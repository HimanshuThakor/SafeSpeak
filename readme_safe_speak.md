# SafeSpeak - Cyberbullying Detection App

**SafeSpeak** is a cross-platform mobile app built with **Flutter** and a **Node.js/Express** backend. It leverages **AI/NLP APIs** to detect toxic or harmful messages in real time, allows anonymous reporting, SOS alerts, and provides educational content on digital safety.

---

## 🚀 Project Structure

```
SafeSpeak/
├── backend/     # Node.js + Express + MongoDB API
└── frontend/    # Flutter app using Riverpod
```

---

## ⚙️ Requirements

### Common

- Git

### Frontend (Flutter)

- Flutter SDK (3.10+)
- Dart SDK
- Android Studio / VSCode

### Backend (Node.js)

- Node.js (v18+)
- MongoDB Atlas account (or local MongoDB)
- Google Perspective API Key (optional)

---

## 📦 How to Clone the Repository

```bash
git clone https://github.com/your-username/SafeSpeak.git
cd SafeSpeak
```

---

## ▶️ Run the Backend

```bash
cd backend
npm install
```

### 🔐 Create `.env` File

```
PORT=5000
MONGO_URI=your_mongodb_connection_string
PERSPECTIVE_API_KEY=your_google_api_key
```

### ▶️ Start the Server

```bash
npm run dev
```

### 📌 API Base URL

```
http://localhost:5000/api
```

---

## 📱 Run the Flutter Frontend

```bash
cd ../frontend
flutter pub get
```

### 🔐 Create `.env` File or Constants

Inside `lib/core/constants/api_constants.dart`:

```dart
class ApiConstants {
  static const baseUrl = "http://10.0.2.2:5000/api"; // Android emulator
  // Use localhost:5000 for Web or Windows
}
```

### ▶️ Run the App

```bash
flutter run
```

You can also select your device (emulator or physical) in VSCode/Android Studio.

---

## 🧠 Backend Features

- Toxicity Detection API (`/api/toxicity/check`)
- Report Submission API (`/api/report`)
- SOS Alert Logging (`/api/sos`)
- Admin/Guardian notifications (future scope)

---

## 📲 Flutter Features

- Login/Signup with Firebase
- Real-time toxicity detection via backend
- Anonymous report submission
- SOS button with optional GPS/location
- Educational content & emotional support

---

## ✅ Testing

### Backend:

Use Postman to test:

- `POST /api/toxicity/check`
- `POST /api/report`

### Flutter:

Run in emulator or physical device.

---

## 🤝 Contributing

Feel free to fork and submit pull requests!

---

## 📄 License

MIT

---

## 🙌 Credits

- [Perspective API](https://perspectiveapi.com/)
- [Flutter](https://flutter.dev/)
- [MongoDB](https://www.mongodb.com/)
- [Firebase](https://firebase.google.com/)

