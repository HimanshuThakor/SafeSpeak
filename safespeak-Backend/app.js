const express = require("express");
const mongoose = require("mongoose");
const dotenv = require("dotenv");
const cors = require("cors");

// Import route files
const userRoutes = require("./routes/userRoutes");
const sosRoutes = require("./routes/sosRoutes");
const reportRoutes = require("./routes/reportRoutes");
const toxicityRoutes = require("./routes/toxicityRoutes");
const authRoutes = require("./routes/authRoutes");
const https = require("https");
const { google } = require("googleapis");

dotenv.config();

const app = express();
app.use(
  cors({
    origin: "*",
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);
app.use(express.json());

const PORT = process.env.PORT || 5000;
const MONGO_URI = process.env.MONGO_URI;

async function main() {
  try {
    await mongoose.connect(MONGO_URI);
    console.log("✅ MongoDB Connected");

    app.use("/api/auth", authRoutes);
    app.use("/api/users", userRoutes);
    app.use("/api/sos", sosRoutes);
    app.use("/api/report", reportRoutes);
    app.use("/api/toxicity", toxicityRoutes);

    app.listen(PORT, () =>
      console.log(`🚀 Server running at http://:${PORT}`)
    );
  } catch (err) {
    console.error("❌ Failed to connect MongoDB:", err.message);
    process.exit(1);
  }
}

main();
