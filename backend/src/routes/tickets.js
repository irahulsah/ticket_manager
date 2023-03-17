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
      text: `Dear ${mail.name}, \n Your ticket has been booked succesfully. the details is attached below.\n Seat Number: ${mail.seatNumber}        `,
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
  let body = { isActive: false, user: req.auth._id };
  if (req.query.event && req.query.event !== "null") {
    body["event"] = req.query.event;
  }
  const tickets = await req.context.models.Ticket.find(body)
    .populate("event", "name")
    .populate("scanned_by", "firstName lastName");
  return res.send(tickets);
});

router.get("/scanned-ticket-count", async (req, res) => {
  let body = { isActive: false, user: req.auth._id };
  const ticketsCount = await req.context.models.Ticket.countDocuments(body);
  return res.send(ticketsCount.toString());
});

router.get("/scanned-ticket-percentage", async (req, res) => {
  let body = { user: req.auth._id };
  const ticketsCount = [
    req.context.models.Ticket.countDocuments({ ...body, isActive: false }),
    req.context.models.Ticket.countDocuments({ ...body }),
  ];
  const resp = await Promise.all(ticketsCount);
  console.log(resp);
  return res.send(((resp[0] / resp[1]) * 100).toString());
});

router.post("/", async (req, res) => {
  const lastTicket = await req.context.models.Ticket.countDocuments();
  const ticket = await req.context.models.Ticket.insertMany(
    req.body.map((tic, idx) => ({
      ...tic,
      ticketId: process.env.TICKET_ID + (lastTicket + idx),
      user: req.auth._id,
    }))
  );
  sendMail(req.body);
  return res.send(ticket);
});
router.post("/upload", upload.array("files"), async (req, res) => {
  const files = req.files.map((f) => "/uploads/" + f.filename);
  return res.send(files);
});

router.put("/scan/:uuid", async (req, res) => {
  const ticket = await req.context.models.Ticket.findOne({
    uniqueUUid: req.params.uuid,
  });
  if (ticket.isActive === false) {
    return res.status(400).send({ message: "Ticket is expired" });
  }
  const result = await req.context.models.Ticket.findOneAndUpdate(
    { uniqueUUid: req.params.uuid },
    { isActive: false, scanned_by: req.auth._id }
  );
  return res.send(result);
});

module.exports = router;
