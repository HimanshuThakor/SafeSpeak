const https = require("https");

https
  .get("https://www.googleapis.com/oauth2/v4/token", (res) => {
    console.log(`✅ HTTPS test success - Status Code: ${res.statusCode}`);
  })
  .on("error", (e) => {
    console.error("❌ HTTPS test failed:", e.message);
  });
