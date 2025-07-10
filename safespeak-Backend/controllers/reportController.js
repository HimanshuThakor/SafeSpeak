const Report = require("../models/Report");

exports.submitReport = async (req, res) => {
  try {
    const { reportType, message, userId } = req.body;
    const report = new Report({ reportType, message, userId });
    await report.save();
    res.status(200).json({ success: true, message: "Report submitted" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getUsersWithReports = async (req, res) => {
  try {
    const users = await Report.aggregate([
      {
        $match: {
          userId: { $ne: null },
        },
      },
      {
        $group: {
          _id: "$userId", // group by userId (email or uid)
        },
      },
      {
        $lookup: {
          from: "users",
          localField: "_id",
          foreignField: "email", // match userId to email field in User
          as: "user",
        },
      },
      {
        $unwind: "$user",
      },
      {
        $project: {
          _id: "$user._id",
          displayName: "$user.displayName",
          email: "$user.email",
          phone: "$user.phone",
        },
      },
    ]);

    res.status(200).json({
      success: true,
      count: users.length,
      users,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
