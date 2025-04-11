const express = require('express');
const UserController = require('../../controllers/front/userController');

const router = express.Router();

// Auth routes
router.post('/register', UserController.register);
router.post('/login', UserController.login);

module.exports = router;