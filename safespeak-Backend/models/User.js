const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true },
  displayName: { type: String },
  password: { type: String, required: true }, // should be hashed
  phone: { type: String },
  imageUrl: { type: String, default: "" },
  fcmToken: { type: String },
  isAutoCreated: { type: Boolean, default: false }, // flag for invited users
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model("User", userSchema);
