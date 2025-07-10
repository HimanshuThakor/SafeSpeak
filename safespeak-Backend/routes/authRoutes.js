const express = require("express");

module.exports = (io) => {
  const router = express.Router();
  const authController = require("../controllers/authController")(io); // inject io

  router.post("/firebaseAuth", authController.firebaseAuth);
  router.post("/signup", authController.firebaseSignup);
  router.post("/login", authController.logIn);
  router.post("/register", authController.registerController);

  return router;
};
