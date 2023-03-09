const mongoose = require('mongoose');
const {omit} = require('lodash');
const jwt = require('jsonwebtoken');


const userSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true,
    unique: true
  },
  firstName: {
    type: String,
    required: true,
  },
  lastName: {
    type: String,
    required: true,
  },
  gender: {
    type: String,
    // required: true,
  },
  password: {
    type: String,
    required: true,
  },
});

userSchema.methods.generateToken = function () {
  return jwt.sign(
    omit(this.toJSON(), ["password", "__v", "fullName"]),
    process.env.JWT_SECRET
  );
}

const User = mongoose.model('User', userSchema);

module.exports = User;
