import express from 'express';
import { createAlias, resolveAlias, linkAccount, saveContact } from '../controllers/userController.js';
import { evaluateTransfer, executeTransfer } from '../controllers/transferController.js';

const router = express.Router();

// Route: POST /api/users/create
// Purpose: Claims a new ArabPay alias and generates a UUID
router.post('/users/create', createAlias);

// Route: GET /api/users/resolve/:alias
// Purpose: Securely searches for a user to send money to
router.get('/users/resolve/:alias', resolveAlias);

// Route: POST /api/users/link-account
// Purpose: Adds a new bank or wallet to the user's profile
router.post('/users/link-account', linkAccount);

// Route: POST /api/users/save-contact
// Purpose: Saves a custom name for a specific alias
router.post('/users/save-contact', saveContact);

// ==========================================
// TRANSFER ROUTES
// ==========================================

// Route: POST /api/transfers/evaluate
// Purpose: Evaluates the Smart Route before final execution
router.post('/transfers/evaluate', evaluateTransfer);

// Route: POST /api/transfers/execute
// Purpose: Actually moves the money between the accounts!
router.post('/transfers/execute', executeTransfer);

export default router;
