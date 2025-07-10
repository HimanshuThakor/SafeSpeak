const express = require("express");
const router = express.Router();
const { checkToxicity } = require("../controllers/toxicityController");

router.post("/check", checkToxicity);

module.exports = router;
