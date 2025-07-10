const express = require("express");
const mongoose = require("mongoose");
const dotenv = require("dotenv");
const cors = require("cors");
const http = require("http");
const { Server } = require("socket.io");

// Import route files
const userRoutes = require("./routes/userRoutes");
const sosRoutes = require("./routes/sosRoutes");
const reportRoutes = require("./routes/reportRoutes");
const toxicityRoutes = require("./routes/toxicityRoutes");
const authRoutes = require("./routes/authRoutes");

dotenv.config();

const app = express();
const server = http.createServer(app);

// Enable CORS
app.use(
  cors({
    origin: "*",
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);
app.use(express.json());

// Setup Socket.IO server
const io = new Server(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
  },
});

io.on("connection", (socket) => {
  console.log("🔌 New client connected:", socket.id);

  // Example: Handle a custom event
  socket.on("send_message", (data) => {
    console.log("📨 Message received:", data);
    // Broadcast to all clients
    io.emit("receive_message", data);
  });

  socket.on("disconnect", () => {
    console.log("❌ Client disconnected:", socket.id);
  });
});

const PORT = process.env.PORT || 5000;
const MONGO_URI = process.env.MONGO_URI;

async function main() {
  try {
    await mongoose.connect(MONGO_URI);
    console.log("✅ MongoDB Connected");

    // Use API routes
    app.use("/api/auth", authRoutes(io));
    app.use("/api/users", userRoutes);
    app.use("/api/sos", sosRoutes);
    app.use("/api/report", reportRoutes);
    app.use("/api/toxicity", toxicityRoutes);

    // Start the server
    server.listen(PORT, "192.168.1.11", () =>
      console.log(`🚀 Server running at http://192.168.1.11:${PORT}`)
    );
  } catch (err) {
    console.error("❌ Failed to connect MongoDB:", err.message);
    process.exit(1);
  }
}
module.exports.io = io;
main();
