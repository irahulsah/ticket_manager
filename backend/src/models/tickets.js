const mongoose = require('mongoose');

const ticketSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
  },
  ticketId: {
    type: String,
    required: true,
  },
  uniqueUUid: {
    type: String,
    required: true,
  },
  qr_code: {
    type: String,
    required: true,
  },
  event: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Event",
    required: true,
  },
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  scanned_by: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
  },
  seatNumber: {
    type: String,
  },
  isActive: {
    type: Boolean,
    required: false,
    default: true
  }
},   {
  timestamps: true
}
);

const Ticket = mongoose.model('Ticket', ticketSchema);

module.exports = Ticket;
