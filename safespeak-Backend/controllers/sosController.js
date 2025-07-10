const { sendPushNotification } = require("../utils/sendNotification");
const SOS = require("../models/SOS");
const EmergencyContact = require("../models/EmergencyContact");
const User = require("../models/User");

exports.sendSOS = async (req, res) => {
  try {
    const { userId, location, timestamp } = req.body;

    // 1. Save SOS log
    const sos = new SOS({ userId, location, sentAt: timestamp });
    await sos.save();

    // 2. Get user's name
    const user = await User.findById(userId);
    if (!user) {
      return res
        .status(404)
        .json({ success: false, message: "User not found" });
    }

    // 3. Get emergency contacts
    const contacts = await EmergencyContact.find({ userId });

    // 4. Loop over contacts and send push notification
    for (const contact of contacts) {
      if (contact.fcmToken) {
        await sendPushNotification({
          to: contact.fcmToken,
          title: `SOS Alert from ${user.displayName || "a family member"}`,
          body: `Location: ${location}. Immediate help may be needed.`,
          data: {
            type: "sos_alert",
            location,
            userId,
            timestamp,
          },
        });
      }
    }

    res
      .status(200)
      .json({ success: true, message: "SOS sent to emergency contacts" });
  } catch (err) {
    console.error("❌ SOS Error:", err.message);
    res.status(500).json({ error: err.message });
  }
};
