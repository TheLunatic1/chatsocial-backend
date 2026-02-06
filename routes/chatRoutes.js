const express = require('express');
const router = express.Router();
const { getUserChats, getChatMessages, sendMessage, startChat } = require('../controllers/chatController');
const protect = require('../middleware/authMiddleware');

router.use(protect); // all chat routes require auth

router.post('/start', startChat);
router.get('/', getUserChats);
router.get('/:chatId', getChatMessages);
router.post('/:chatId/message', sendMessage);

module.exports = router;