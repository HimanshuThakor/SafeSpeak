const axios = require("axios");
const dotenv = require("dotenv");
const { responseWrapper } = require("../helper/responseWrapper");

dotenv.config();

exports.checkToxicity = async (req, res) => {
  const { message } = req.body;

  try {
    const response = await axios.post(
      `https://commentanalyzer.googleapis.com/v1alpha1/comments:analyze?key=${process.env.PERSPECTIVE_API_KEY}`,
      {
        comment: { text: message },
        requestedAttributes: { TOXICITY: {} },
      }
    );

    const score = response.data.attributeScores.TOXICITY.summaryScore.value;
    res.json(
      responseWrapper(true, "Response", 200, { toxic: score > 0.7, score })
    );
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json(responseWrapper(true, "Server error", 500, { error: err.message }));
  }
};
