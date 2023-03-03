import mongoose from 'mongoose';

import User from './user';
import Ticket from './tickets';

const connectDb = () => {
  return mongoose.connect(process.env.DATABASE_URL, {useNewUrlParser: true});
};

const models = { User, Ticket };

export { connectDb };

export default models;
