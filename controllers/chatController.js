const Chat = require('../models/Chat');
const Message = require('../models/Message');

const getUserChats = async (req, res) => {
  try {
    const chats = await Chat.find({ participants: req.userId })
      .populate('participants', 'name email')
      .populate('lastMessage')
      .sort({ updatedAt: -1 });

    res.json(chats);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
};

const getChatMessages = async (req, res) => {
  const { chatId } = req.params;

  try {
    const chat = await Chat.findById(chatId)
      .populate({
        path: 'messages',
        populate: { path: 'sender', select: 'name email' },
      });

    if (!chat || !chat.participants.includes(req.userId)) {
      return res.status(403).json({ message: 'Not authorized' });
    }

    res.json(chat.messages);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
};

const sendMessage = async (req, res) => {
  const { chatId, content } = req.body;

  if (!content?.trim()) {
    return res.status(400).json({ message: 'Message content required' });
  }

  try {
    const chat = await Chat.findById(chatId);

    if (!chat || !chat.participants.includes(req.userId)) {
      return res.status(403).json({ message: 'Not authorized' });
    }

    const message = new Message({
      sender: req.userId,
      content,
    });

    await message.save();

    chat.messages.push(message._id);
    chat.lastMessage = message._id;
    chat.updatedAt = Date.now();

    await chat.save();

    const populatedMessage = await Message.findById(message._id)
      .populate('sender', 'name email');

    res.status(201).json(populatedMessage);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
};

const startChat = async (req, res) => {
  const { recipientId } = req.body;

  try {
    let chat = await Chat.findOne({
      participants: { $all: [req.userId, recipientId] },
    });

    if (!chat) {
      chat = new Chat({
        participants: [req.userId, recipientId],
      });
      await chat.save();
    }

    const populatedChat = await Chat.findById(chat._id)
      .populate('participants', 'name email');

    res.json(populatedChat);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
};

module.exports = { getUserChats, getChatMessages, sendMessage, startChat };