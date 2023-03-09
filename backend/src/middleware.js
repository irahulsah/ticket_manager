const jwt = require("jsonwebtoken");

module.exports = function auth(req, res,next) {
  const token = req.header("token");
  if (!token) return res.status(401).send("Access denied. No token provided");
  try {
    req.user = jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
      if (err) {
        res.json({
          status: false,
          message: "Failed to authenticate token.",
        });
      } else {
        req.auth = decoded;
        next();
      }
    });
  } catch (e) {
    res.json({
      status: false,
      message: "Invalid token",
    });
  }
};