const express = require("express");
const router = express.Router();
const authMiddleware = require("../middlewares/authMiddleware");
const { sendSOS } = require("../controllers/sosController");

router.post("/send-sos", authMiddleware, sendSOS);

module.exports = router;
