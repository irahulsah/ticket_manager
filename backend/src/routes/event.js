const { Router } = require("express");

const router = Router();

router.get("/", async (req, res) => {
  const events = await req.context.models.Event.find({user: req.auth._id});
  return res.status(200).send(events);
});

router.post("/", async (req, res) => {
  const events = await req.context.models.Event.create({
    ...req.body,
    user: req.auth._id,
  });
  return res.send(events);
});

module.exports = router;
