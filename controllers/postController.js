const Post = require('../models/Post');

const getPosts = async (req, res) => {
  try {
    const posts = await Post.find()
      .populate('author', 'name email')
      .sort({ createdAt: -1 });

    res.json(posts);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
};

const createPost = async (req, res) => {
  const { content } = req.body;

  if (!content?.trim()) {
    return res.status(400).json({ message: 'Content is required' });
  }

  try {
    const post = new Post({
      content,
      author: req.userId,
    });

    await post.save();

    const populated = await Post.findById(post._id).populate('author', 'name email');

    res.status(201).json(populated);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
};

module.exports = { getPosts, createPost };