const messaging = require("../config/firebase");
const EmergencyContact = require("../models/EmergencyContact");
const { responseWrapper } = require("../helper/responseWrapper");
const { sendSMSorEmail } = require("../utils/sendInvite");
const User = require("../models/User"); // ✅ Ensure this line exists

// ✅ Create/Add Emergency Contact
exports.addEmergencyContact = async (req, res) => {
  try {
    const { userId } = req.params;
    const { name, email, phone, relationship } = req.body;

    const creator = await User.findById(userId);
    if (!creator) {
      return res.status(404).json({ error: "Creator user not found" });
    }

    // Step 1: Check if a user already exists with this email or phone
    let existingUser = await User.findOne({ $or: [{ email }, { phone }] });

    // Step 2: If not, create a user for them
    if (!existingUser) {
      existingUser = await User.create({
        displayName: name,
        email,
        phone,
        password: creator.password,
        isAutoCreated: true, // Optional flag
      });

      // Optional: send SMS/email invite
      await sendSMSorEmail({ name, email, phone });
    }

    // Step 3: Save emergency contact
    const contact = await EmergencyContact.create({
      userId,
      name,
      email,
      phone,
      relationship,
      linkedUserId: existingUser._id,
    });

    // Step 4: Send FCM Notification to the main user (creator)
    // Send FCM Notification to the main user (creator)
    if (creator.fcmToken) {
      const message = {
        notification: {
          title: "Congratulation",
          body: "You Added Succesfully A New Emergency Contact:-${name}${relationship}${phone}${email}",
          sound: "default",
        },
        token: creator.fcmToken,
      };

      messaging
        .send(message)
        .then((response) => {
          console.log("✅ Successfully sent message:", response);
        })
        .catch((error) => {
          console.log("❌ Error sending message:", error);
        });
    }

    res.status(201).json({
      success: true,
      message: "Emergency contact added & user created (if new)",
      data: contact,
    });
  } catch (err) {
    console.error("❌ Add Emergency Contact Error:", err.message);
    res.status(500).json({ error: err.message });
  }
};

// ✅ Get All Emergency Contacts by User ID
exports.getEmergencyContacts = async (req, res) => {
  try {
    const { userId } = req.params;
    const contacts = await EmergencyContact.find({ userId });

    res.status(200).json(
      responseWrapper(true, "Fetched Successfully", 200, {
        emergencyContact: contacts,
      })
    );
  } catch (err) {
    res
      .status(500)
      .json(
        responseWrapper(false, "Server error", 500, { error: err.message })
      );
  }
};

// ✅ Update Emergency Contact by contactId
exports.updateEmergencyContact = async (req, res) => {
  try {
    const { contactId } = req.params;
    const updated = await EmergencyContact.findByIdAndUpdate(
      contactId,
      req.body,
      { new: true }
    );

    if (!updated)
      return res
        .status(404)
        .json(responseWrapper(false, "Contact not found", 404));

    res
      .status(200)
      .json(responseWrapper(true, "Updated Successfully", 200, updated));
  } catch (err) {
    res
      .status(500)
      .json(
        responseWrapper(false, "Server error", 500, { error: err.message })
      );
  }
};

// ✅ Delete Emergency Contact by contactId
exports.deleteEmergencyContact = async (req, res) => {
  try {
    const { contactId } = req.params;
    const deleted = await EmergencyContact.findByIdAndDelete(contactId);

    if (!deleted)
      return res
        .status(404)
        .json(responseWrapper(false, "Contact not found", 404));

    res
      .status(200)
      .json(responseWrapper(true, "Deleted Successfully", 200, deleted));
  } catch (err) {
    res
      .status(500)
      .json(
        responseWrapper(false, "Server error", 500, { error: err.message })
      );
  }
};
