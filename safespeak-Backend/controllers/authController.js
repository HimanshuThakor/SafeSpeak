const User = require("../models/User");
const auth = require("../config/firebase");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");
const { responseWrapper } = require("../helper/responseWrapper");

exports.firebaseAuth = async (req, res) => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({ error: "Unauthorized: No token provided" });
    }

    const token = authHeader.split(" ")[1];
    const decodedToken = await auth.auth().verifyIdToken(token);

    const { uid, email, name: displayName } = decodedToken;

    const user = await User.findOneAndUpdate(
      { uid },
      { uid, email, displayName },
      { new: true, upsert: true }
    );

    res.status(200).json({ success: true, user });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// 👤 Sign up with Firebase email + password via backend
exports.firebaseSignup = async (req, res) => {
  try {
    const { email, password, displayName } = req.body;

    if (!email || !password || !displayName) {
      return res.status(400).json({ error: "Missing fields" });
    }

    // Create user in Firebase Auth
    const firebaseUser = await auth.auth().createUser({
      email,
      password,
      displayName,
    });

    // Save in MongoDB
    const user = await User.findOneAndUpdate(
      { uid: firebaseUser.uid },
      {
        uid: firebaseUser.uid,
        email: firebaseUser.email,
        displayName: firebaseUser.displayName,
      },
      { new: true, upsert: true }
    );

    res.status(201).json({ success: true, user });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.logIn = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json(responseWrapper(404, "User not found"));
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch)
      return res.status(401).json(
        responseWrapper(true, "Passwor Is Invalid", 401, {
          msg: "Please Enter Correct Password",
        })
      );

    const token = jwt.sign(
      { id: user._id, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: "7d" }
    );

    res.status(200).json(
      responseWrapper(true, "Login successful", 200, {
        token,
        user: { id: user._id, name: user.displayName },
      })
    );
  } catch (err) {
    res
      .status(500)
      .json(
        responseWrapper(ttrue, "Server error", 500, { error: err.message })
      );
  }
};

exports.registerController = async (req, res) => {
  try {
    const { name, email, password, phone, fcmToken } = req.body;

    // Validate inputs
    if (!name || !email || !password || !phone) {
      return res.status(400).json({ error: "Missing fields" });
    }

    // Check if user already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({
        error: "Email already registered",
      });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create new user
    const newUser = new User({
      displayName: name,
      email,
      password: hashedPassword,
      phone,
      fcmToken,
    });

    await newUser.save();

    // Generate token
    const token = jwt.sign({ id: newUser._id }, process.env.JWT_SECRET, {
      expiresIn: "7d",
    });

    res.status(201).json({
      success: true,
      message: "User registered successfully",
      data: {
        token,
        user: {
          id: newUser._id,
          name: newUser.displayName,
          email: newUser.email,
          phone: newUser.phone,
        },
      },
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      error: "Registration failed",
      msg: err.message,
    });
  }
};
