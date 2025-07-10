const mongoose = require("mongoose");

const educationSchema = new mongoose.Schema({
  title: { type: String, required: true },
  content: { type: String, required: true }, // Markdown/HTML/plaintext
  videoUrl: { type: String }, // optional
  tags: [String],
});

module.exports = mongoose.model("Education", educationSchema);
