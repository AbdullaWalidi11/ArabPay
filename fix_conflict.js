const fs = require('fs');
const path = require('path');

const filePath = path.join(__dirname, 'server/src/data/users.json');
let content = fs.readFileSync(filePath, 'utf8');

// Extract the HEAD part (which has our new schema for Faisal)
const headMatch = content.match(/<<<<<<< HEAD\r?\n([\s\S]*?)=======\r?\n/);
const headContent = headMatch ? headMatch[1] : '';

// Extract the incoming part (which has all the new dummy users)
const incomingMatch = content.match(/=======\r?\n([\s\S]*?)>>>>>>> [a-f0-9]+\r?\n/);
let incomingContent = incomingMatch ? incomingMatch[1] : '';

// The incoming content has empty linkedAccounts but is missing contacts and transactions.
// Let's use regex to add "contacts": [], and "transactions": [] to each dummy user in incomingContent.
incomingContent = incomingContent.replace(/"linkedAccounts": \[\]\s*\}/g, '"contacts": [],\n    "linkedAccounts": [],\n    "transactions": []\n  }');

// Replace the whole conflict block with our fixed merged content
content = content.replace(/<<<<<<< HEAD\r?\n[\s\S]*?>>>>>>> [a-f0-9]+\r?\n/, headContent + incomingContent);

fs.writeFileSync(filePath, content);
console.log('Fixed merge conflict in users.json!');
