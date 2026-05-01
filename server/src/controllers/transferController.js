import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { evaluateRoute } from '../services/routingEngine.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const dataPath = path.join(__dirname, '../data/users.json');

const getUsers = () => JSON.parse(fs.readFileSync(dataPath, 'utf-8'));

// ==========================================
// ENDPOINT: POST /api/transfers/evaluate
// Purpose: Stage 2 - Analyzes sender & receiver accounts to suggest options
// ==========================================
export const evaluateTransfer = (req, res) => {
    const { senderUuid, receiverAlias } = req.body;

    if (!senderUuid || !receiverAlias) {
        return res.status(400).json({ error: 'Missing senderUuid or receiverAlias' });
    }

    const users = getUsers();
    const sender = users.find(u => u.uuid === senderUuid);
    
    // Format the alias internally (e.g., 'ihsan' -> 'ihsan@arabpay')
    const searchAlias = receiverAlias.includes('@arabpay') 
        ? receiverAlias.toLowerCase() 
        : `${receiverAlias.toLowerCase()}@arabpay`;

    const receiver = users.find(u => u.alias === searchAlias);

    if (!sender) return res.status(404).json({ error: 'Sender not found' });
    if (!receiver) return res.status(404).json({ error: 'Receiver not found' });

    // Run our Smart Routing Engine!
    const routingResult = evaluateRoute(sender.linkedAccounts, receiver.linkedAccounts);

    if (!routingResult.success) {
        return res.status(400).json({ error: routingResult.error });
    }

    return res.status(200).json({
        message: 'Route evaluated successfully',
        evaluation: routingResult
    });
};

// ==========================================
// ENDPOINT: POST /api/transfers/execute
// Purpose: Stage 4 - Executes the transfer and updates balances
// ==========================================
export const executeTransfer = (req, res) => {
    const { senderUuid, senderAccountId, receiverAlias, receiverAccountId, amount } = req.body;

    if (!senderUuid || !senderAccountId || !receiverAlias || !receiverAccountId || !amount) {
        return res.status(400).json({ error: 'Missing required fields' });
    }

    let users = getUsers();
    const senderIndex = users.findIndex(u => u.uuid === senderUuid);
    
    // Format the alias internally
    const searchAlias = receiverAlias.includes('@arabpay') 
        ? receiverAlias.toLowerCase() 
        : `${receiverAlias.toLowerCase()}@arabpay`;

    const receiverIndex = users.findIndex(u => u.alias === searchAlias);

    if (senderIndex === -1 || receiverIndex === -1) {
        return res.status(404).json({ error: 'Sender or Receiver not found' });
    }

    const senderAcc = users[senderIndex].linkedAccounts.find(a => a.id === senderAccountId);
    const receiverAcc = users[receiverIndex].linkedAccounts.find(a => a.id === receiverAccountId);

    if (!senderAcc || !receiverAcc) {
        return res.status(404).json({ error: 'Account not found' });
    }

    if (senderAcc.balance < amount) {
        return res.status(400).json({ error: 'Insufficient funds in selected account' });
    }

    // Execute!
    senderAcc.balance -= amount;
    
    // Simplistic hackathon FX (e.g. SAR -> TRY = * 8.6)
    let finalAmount = amount;
    if (senderAcc.currency === 'SAR' && receiverAcc.currency === 'TRY') finalAmount = amount * 8.6;
    
    receiverAcc.balance += finalAmount;

    // Log transactions
    const txId = `tx_${crypto.randomUUID().split('-')[0]}`;
    users[senderIndex].transactions.push({
        id: txId,
        type: 'SEND',
        amount: amount,
        currency: senderAcc.currency,
        to: receiverAlias,
        date: new Date().toISOString()
    });

    users[receiverIndex].transactions.push({
        id: txId,
        type: 'RECEIVE',
        amount: finalAmount,
        currency: receiverAcc.currency,
        from: users[senderIndex].alias,
        date: new Date().toISOString()
    });

    saveUsers(users);

    return res.status(200).json({
        message: 'Transfer successful',
        transactionId: txId,
        senderNewBalance: senderAcc.balance
    });
};
