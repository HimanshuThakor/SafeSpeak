const express = require("express");
const router = express.Router();
const { submitReport ,getUsersWithReports} = require("../controllers/reportController");

router.post("/", submitReport);
router.get("/get-users-with-reports", getUsersWithReports);

module.exports = router;
