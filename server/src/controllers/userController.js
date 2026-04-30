import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import crypto from 'crypto';

// Setup file paths for ES Modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Path to your mock database
const dbPath = path.join(__dirname, '../data/users.json');

// Helper function to read the database
const getUsers = () => JSON.parse(fs.readFileSync(dbPath, 'utf8'));

// Helper function to save to the database (so it survives server restarts!)
const saveUsers = (usersArray) => fs.writeFileSync(dbPath, JSON.stringify(usersArray, null, 2));


// ==========================================
// ENDPOINT: POST /api/users/create
// ==========================================
export const createAlias = (req, res) => {
    // Flutter will send this in the body
    const { requestedAlias, displayName, country } = req.body;

    if (!requestedAlias) {
        return res.status(400).json({ error: 'Alias is required' });
    }

    let users = getUsers();

    // 1. Format the alias internally
    const formattedAlias = requestedAlias.includes('@arabpay') 
        ? requestedAlias.toLowerCase() 
        : `${requestedAlias.toLowerCase()}@arabpay`;

    // Extract the "blabla" part for the default display name (removes @ and @arabpay)
    const rawUsername = requestedAlias.toLowerCase().replace('@arabpay', '').replace('@', '');
    // Capitalize the first letter so 'khalid' becomes 'Khalid'
    const autoDisplayName = rawUsername.charAt(0).toUpperCase() + rawUsername.slice(1);

    // 2. Check Availability
    const isTaken = users.find(u => u.alias === formattedAlias);
    if (isTaken) {
        return res.status(409).json({ error: 'Alias is already taken', available: false });
    }

    // 3. Generate Institutional Grade Security ID (UUID)
    const newUuid = `usr_${crypto.randomUUID().replace(/-/g, '').substring(0, 8)}`;

    // 4. Build the new user profile
    const newUser = {
        uuid: newUuid,
        alias: formattedAlias,
        // Uses the provided name, OR falls back to our newly generated autoDisplayName
        displayName: displayName || autoDisplayName, 
        country: country || "Unknown",
        verified: true, // Auto-verified for the hackathon sandbox
        routingRules: {
            localTransfers: { enabled: true } // Default rule
        },
        contacts: [], // Saved recipients
        linkedAccounts: [], // Starts empty!
        transactions: [] // Empty transaction history
    };

    // 5. Save them to the "Database"
    users.push(newUser);
    saveUsers(users);

    // 6. Return the secret UUID to the Flutter app
    return res.status(201).json({
        message: 'Payment Identity Claimed',
        user: {
            alias: formattedAlias,
            displayName: newUser.displayName,
            uuid: newUuid // FLUTTER SHOULD SAVE THIS LOCALLY
        }
    });
};

// ==========================================
// ENDPOINT: GET /api/users/resolve/:alias
// Purpose: Resolves an alias securely for the sender
// ==========================================
export const resolveAlias = (req, res) => {
    const { alias } = req.params;

    if (!alias) {
        return res.status(400).json({ error: 'Alias parameter is required' });
    }

    let users = getUsers();

    // 1. Format the search alias (in case they just typed 'ali')
    const searchAlias = alias.includes('@arabpay') 
        ? alias.toLowerCase() 
        : `${alias.toLowerCase()}@arabpay`;

    // 2. Find the user in the database
    const foundUser = users.find(u => u.alias === searchAlias);

    // 3. Handle Not Found
    if (!foundUser) {
        return res.status(404).json({ error: 'User not found' });
    }

    // 4. SECURITY FILTER: Strip private data before sending to Flutter!
    const safePublicProfile = {
        alias: foundUser.alias,
        displayName: foundUser.displayName,
        country: foundUser.country,
        verified: foundUser.verified
        // Notice we do NOT include: uuid, balance, linkedAccounts, or routingRules!
    };

    // 5. Return safe profile
    return res.status(200).json({
        message: 'User found',
        user: safePublicProfile
    });
};

// ==========================================
// ENDPOINT: POST /api/users/link-account
// Purpose: Adds a new bank or wallet to the user's profile
// ==========================================
export const linkAccount = (req, res) => {
    const { uuid, type, provider, country, currency, isPreferred } = req.body;

    if (!uuid || !type || !provider || !currency || !country) {
        return res.status(400).json({ error: 'Missing required fields (uuid, type, provider, country, currency)' });
    }

    let users = getUsers();
    const userIndex = users.findIndex(u => u.uuid === uuid);

    if (userIndex === -1) {
        return res.status(404).json({ error: 'User not found (Invalid UUID)' });
    }

    // Generate a simple account ID
    const newAccountId = `acc_${crypto.randomUUID().split('-')[0]}`;

    const newAccount = {
        id: newAccountId,
        type, // 'bank' or 'wallet'
        provider, // e.g., 'STC Pay', 'Al Rajhi'
        country,
        currency,
        balance: 10000, // Give them some mock money to test with!
        isPreferred: isPreferred || false
    };

    // If this is preferred, we should un-prefer others
    if (newAccount.isPreferred) {
        users[userIndex].linkedAccounts.forEach(acc => acc.isPreferred = false);
    } 
    // If it's their very first account, make it preferred automatically!
    else if (users[userIndex].linkedAccounts.length === 0) {
        newAccount.isPreferred = true;
    }

    // Save to database
    users[userIndex].linkedAccounts.push(newAccount);
    saveUsers(users);

    return res.status(200).json({
        message: 'Account linked successfully',
        account: newAccount
    });
};

// ==========================================
// ENDPOINT: POST /api/users/save-contact
// Purpose: Saves a custom name for an alias
// ==========================================
export const saveContact = (req, res) => {
    const { uuid, targetAlias, customName } = req.body;

    if (!uuid || !targetAlias || !customName) {
        return res.status(400).json({ error: 'Missing required fields' });
    }

    let users = getUsers();
    const userIndex = users.findIndex(u => u.uuid === uuid);

    if (userIndex === -1) {
        return res.status(404).json({ error: 'User not found' });
    }

    const newContact = {
        alias: targetAlias,
        customName: customName
    };

    // Replace if exists, else push
    const existingIndex = users[userIndex].contacts.findIndex(c => c.alias === targetAlias);
    if (existingIndex !== -1) {
        users[userIndex].contacts[existingIndex] = newContact;
    } else {
        users[userIndex].contacts.push(newContact);
    }
    
    saveUsers(users);

    return res.status(200).json({
        message: 'Contact saved successfully',
        contacts: users[userIndex].contacts
    });
};
