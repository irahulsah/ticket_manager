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

module.exports = {upload, sendMail}