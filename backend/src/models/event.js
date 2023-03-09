const mongoose = require('mongoose');

const eventSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
},   {
  timestamps: true
}
);

const Event = mongoose.model('Event', eventSchema);

module.exports = Event;
