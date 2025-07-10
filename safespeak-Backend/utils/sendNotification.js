const admin = require("firebase-admin");
const axios = require("axios");

exports.sendPushNotification = async ({ to, title, body, data }) => {
  try {
    const serverKey = process.env.FCM_SERVER_KEY;
    await axios.post(
      "https://fcm.googleapis.com/fcm/send",
      {
        to,
        notification: {
          title,
          body,
        },
        data,
      },
      {
        headers: {
          "Content-Type": "application/json",
          Authorization: `key=${serverKey}`,
        },
      }
    );
  } catch (err) {
    console.error("❌ Failed to send push notification:", err.message);
  }
};
