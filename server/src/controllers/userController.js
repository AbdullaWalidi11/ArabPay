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
    console.log('Incoming headers:', req.headers);
    console.log('Incoming body:', req.body);
    const { requestedAlias, displayName, country } = req.body;

    if (!requestedAlias) {
        return res.status(400).json({ error: `Alias is required. Received body: ${JSON.stringify(req.body)}` });
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
        linkedAccounts: [] // Starts empty!
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
