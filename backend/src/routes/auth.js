const { Router } = require("express");
const bcrypt  = require("bcrypt");
const {omit}  = require("lodash");

const router = Router();

router.post("/login", async (req, res) => {
  const { email, password } = req.body;
  if (!email) return res.status(400).send("Email is required.");
  if (!password) return res.status(400).send("Password is required.");
  let user = await req.context.models.User.findOne({ email }).select(
    "+password"
  );
  if (!user) return res.status(400).send("not valid email or password");

  const validPassword = await bcrypt.compare(password, user.password);
  if (!validPassword) return res.status(400).send("Invalid email or password");
  const token = user.generateToken();
  return res.send({accessToken: token});
});

router.post("/signup", async (req, res) => {
  const { email, password ,firstName,lastName} = req.body;
  if (!email) return res.status(400).send("Email is required.");
  if (!password) return res.status(400).send("Password is required.");
  if (!firstName) return res.status(400).send("firstName is required.");
  if (!lastName) return res.status(400).send("lastName is required.");

  let user = await req.context.models.User.findOne({ email });
  if (user) return res.status(400).send("Email already registered");

  const salt = await bcrypt.genSalt(10);
  const hashedPassword = await bcrypt.hash(password, salt);

  user = new req.context.models.User({
    ...req.body,
    password: hashedPassword,
  });
  await user.save();

  response =  omit(user.toJSON(), ["__v", "password"])
  
  res.status(200).send(response);
});

// const validPassword = await bcrypt.compare(password, user.password);
// if (!validPassword) return res.status(400).send("Invalid email or password");
// const token = user.generateToken();
// user = {
//   ...omit(user.toJSON(), ["password", "__v"]),
//   token: token,
// };

// res.cookie("jwt", token, {
//   maxAge: 24 * 60 * 60 * 1000,
//   httpOnly: true,
//   secure: process.env.NODE_ENV === "production" ? true : false,
// });

// res.cookie("user", JSON.stringify(user), {
//   maxAge: 24 * 60 * 60 * 1000,
//   httpOnly: true,
//   secure: process.env.NODE_ENV === "production" ? true : false,
// });

// res.send(user);
// };

// exports.logout = async (req, res) => {
//   res.cookie("jwt", "", { expires: new Date(0) });
//   res.send("logout Success");
// };

module.exports = router;
