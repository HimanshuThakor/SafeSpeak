const express = require("express");
const router = express.Router();
const {
  firebaseAuth,
  firebaseSignup,
  logIn,
  registerController,
} = require("../controllers/authController");

router.post("/firebaseAuth", firebaseAuth);
router.post("/signup", firebaseSignup);
router.post("/login", logIn);
router.post("/register", registerController);

module.exports = router;
