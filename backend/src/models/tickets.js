import mongoose from 'mongoose';

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

export default Ticket;
