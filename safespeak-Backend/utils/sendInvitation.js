const sendMail = require("./sendMail");
const path = require("path");

const sendInvitation = async ({ name, email }) => {
  const appLink = "https://we.tl/t-C48T8iPC1G"; // update with real link
  const htmlContent = `
    <h2>📲 You're Invited to Join SafeSpeak!</h2>
    <p>Hi ${name || "there"},</p>
    <p>You've been added as an emergency contact on <strong>SafeSpeak</strong> – a platform to ensure your safety and awareness in critical situations.</p>
    
    <p>Download our app and stay connected. You can also find the app attached to this email.</p>

    <p>
      <a href="${appLink}" target="_blank" style="font-size:16px; color: #ffffff; background-color: #007bff; padding: 10px 15px; border-radius: 5px; text-decoration: none;">
        🔽 Download SafeSpeak App
      </a>
    </p>

    <p>If you weren’t expecting this, you can ignore the email.</p>
    <p>Thanks,<br/>The SafeSpeak Team 🔐</p>
  `;

  await sendMail(email, "📩 You're Invited to Join SafeSpeak!", htmlContent);
};

module.exports = sendInvitation;
