// config/firebase.js
const admin = require("firebase-admin");
const serviceAccount = require("../firebaseServiceAccount.json");

// Initialize Firebase Admin SDK
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: "otpverification-1aab0.appspot.com", // optional if you use storage
});

const auth = admin.auth();
module.exports = auth;

const messaging = admin.messaging();
module.exports = messaging;
