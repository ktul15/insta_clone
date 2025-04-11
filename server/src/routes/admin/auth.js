const express = require('express');
const UserController = require('../../controllers/admin/userController');

const router = express.Router();

// Auth routes
router.post('/login', UserController.login);

module.exports = router;