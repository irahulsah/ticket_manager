const { Router } = require("express");

const multer = require("multer");
const nodemailer = require("nodemailer");

var storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "./uploads");
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + file.originalname);
  },
});
var upload = multer({ storage: storage });

// send mail

let mailTransporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL,
    pass: process.env.PASSWORD,
  },
});

const sendMail = (body) => {
  let promise = [];
  for (let mail of body) {
    let mailDetails = {
      from: process.env.EMAIL,
      to: mail.email,
      subject: "Ticket Booked",
      text: `Dear ${mail.name}, \n Your ticket has been booked succesfully. the details is attached below.`,
      attachments: [
        {
          filename: mail.qr_code.split("/uploads/")[1],
          path: process.env.BASE_URL + mail.qr_code,
          cid: mail.qr_code,
        },
      ],
    };
    promise.push(mailTransporter.sendMail(mailDetails));
  }
  Promise.all(promise).then((res) => {
    // console.log(res)
  });
};

const router = Router();

router.get("/", async (req, res) => {
  const messages = await req.context.models.Ticket.find({isActive: false}).populate('event');
  return res.send(messages);
});

router.get("/:messageId", async (req, res) => {
  const message = await req.context.models.Ticket.findById(
    req.params.messageId
  );
  return res.send(message);
});

router.post("/", async (req, res) => {
  const lastTicket = await req.context.models.Ticket.countDocuments();
  const ticket = await req.context.models.Ticket.insertMany(
    req.body.map((tic, idx) => ({
      ...tic,
      ticketId: process.env.TICKET_ID + (lastTicket + idx),
    }))
  );
  sendMail(req.body);
  return res.send(ticket);
});
router.post("/upload", upload.array("files"), async (req, res) => {
  const files = req.files.map((f) => "/uploads/" + f.filename);
  return res.send(files);
});

router.put("/:uuid", async (req, res) => {
  const ticket = await req.context.models.Ticket.findOne(
    { uniqueUUid: req.params.uuid });
  if(ticket.isActive === false) {
    return res.status(400).send({message: "Ticket is expired"});
  }
  const result = await req.context.models.Ticket.findOneAndUpdate(
    { uniqueUUid: req.params.uuid },
    { isActive: false }
  );
  return res.send(result);
});

module.exports = router;
