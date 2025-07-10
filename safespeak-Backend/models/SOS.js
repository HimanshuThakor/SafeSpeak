const mongoose = require("mongoose");

const sosSchema = new mongoose.Schema({
  userId: { type: String, required: true },
  location: { type: String }, // "lat,lng" or city if available
  sentAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model("SOS", sosSchema);
