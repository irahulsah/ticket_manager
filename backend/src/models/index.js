const { Module } = require("module");
const mongoose = require("mongoose");
const User = require("./user");
const Event = require("./event");
const Ticket = require("./tickets");

const connectDb = () => {
  return mongoose.connect(process.env.DATABASE_URL, { useNewUrlParser: true });
};

const models = { User, Ticket, Event };

module.exports = { connectDb, models };
