import { Router } from 'express';
import multer from 'multer';
const nodemailer = require('nodemailer');

var storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, './uploads');
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + file.originalname);
  },
});
var upload = multer({ storage: storage });

// send mail

let mailTransporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL,
    pass: process.env.PASSWORD,
  },
});

const sendMail = (body) => {
  let promise = [];
  for(let mail of body) {
  let mailDetails = {
    from: process.env.EMAIL,
    to: mail.email,
    subject: 'Ticket Booked',
    text: `Dear ${mail.name}, \n Your ticket has been booked succesfully. the details is attached below.`,
    attachments: [
      {
        filename: mail.qr_code.split('/uploads/')[1],
        path: process.env.BASE_URL + mail.qr_code,
        cid: mail.qr_code,
      },
    ],
  }
   promise.push(mailTransporter.sendMail(mailDetails))
  }
  Promise.all(promise).then((res) => {
    // console.log(res)
  })
}



const router = Router();

router.get('/', async (req, res) => {
  const messages = await req.context.models.Ticket.find();
  return res.send(messages);
});

router.get('/:messageId', async (req, res) => {
  const message = await req.context.models.Ticket.findById(
    req.params.messageId,
  );
  return res.send(message);
});

router.post('/', async (req, res) => {
  const lastTicket = await req.context.models.Ticket.count();
  const ticket = await req.context.models.Ticket.insertMany(
    req.body.map((tic, idx) => ({
      ...tic,
      ticketId: process.env.TICKET_ID + (lastTicket + idx),
    })),
  );
  sendMail(req.body);
  return res.send(ticket);
});
router.post('/upload', upload.array('files'), async (req, res) => {
  console.log(req.files);
  const files = req.files.map((f) => '/uploads/' + f.filename);
  return res.send(files);
});

router.delete('/:messageId', async (req, res) => {
  const message = await req.context.models.Ticket.findById(
    req.params.messageId,
  );

  let result = null;
  if (message) {
    result = await message.remove();
  }

  return res.send(result);
});

export default router;
