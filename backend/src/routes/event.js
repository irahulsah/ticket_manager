const { Router } = require("express");

const router = Router();

router.get("/", async (req, res) => {
  const events = await req.context.models.Event.find();
  return res.status(200).send(events);
});


router.post("/", async (req, res) => {
    console.log(req.body)
  const events = await req.context.models.Event.create(
    req.body
  );
  return res.send(events);
});

module.exports = router;
