import express from 'express';
import { createAlias } from '../controllers/userController.js';

const router = express.Router();

// Route: POST /api/users/create
// Purpose: Claims a new ArabPay alias and generates a UUID
router.post('/users/create', createAlias);

export default router;
