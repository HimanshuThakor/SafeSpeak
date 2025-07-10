const mongoose = require("mongoose");

const reportSchema = new mongoose.Schema({
  userId: { type: String, required: false }, // optional for anonymous
  reportType: { type: String, required: true }, // e.g., "Harassment", "Threats"
  message: { type: String },
  submittedAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model("Report", reportSchema);
