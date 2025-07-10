const express = require("express");
const router = express.Router();
const authMiddleware = require("../middlewares/authMiddleware");
const {
  addEmergencyContact,
  getEmergencyContacts,
  deleteEmergencyContact,
  updateEmergencyContact,
} = require("../controllers/userController");

router.post(
  "/add-emergency-contacts/:userId",
  authMiddleware,
  addEmergencyContact
);
router.get(
  "/get-emergency-contacts/:userId",
  authMiddleware,
  getEmergencyContacts
);
router.post(
  "/update-emergency-contacts/:contactId",
  authMiddleware,
  updateEmergencyContact
);
router.post(
  "/:userId/delete-emergency-contacts/:contactId",
  authMiddleware,
  deleteEmergencyContact
);

module.exports = router;
