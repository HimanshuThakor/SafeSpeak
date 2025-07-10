// utils/sendInvite.js

// Dummy SMS function
const sendSMS = async (phone, message) => {
  console.log(`📲 Sending SMS to ${phone}: ${message}`);
};

// Dummy email function
const sendEmail = async (email, subject, message) => {
  console.log(
    `📧 Sending Email to ${email} | Subject: ${subject} | Message: ${message}`
  );
};

exports.sendSMSorEmail = async ({ name, email, phone }) => {
  const appLink = "https://your-app.com/download";

  const message = `Hi ${name}, you've been added as an emergency contact. Download the app and log in with your phone/email. App: ${appLink}`;

  if (phone) {
    await sendSMS(phone, message); // ✅ Now defined
  } else if (email) {
    await sendEmail(email, "You're an emergency contact", message);
  }
};
