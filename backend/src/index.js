const cors = require('cors');
const express = require('express');
require('dotenv/config');

const   {connectDb}  = require('./models');
const  {models} = require('./models');
const  routes = require('./routes');
const  middleareAuth = require('./middleware');

const app = express();

// * Application-Level Middleware * //

// Third-Party Middleware

app.use(cors());

// Built-In Middleware

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static("public"));
app.use('/uploads', express.static('uploads'));
// Custom Middleware
  
app.use(async (req, res, next) => {
  req.context = {
    models,
  };
  next();
});

// * Routes * //

app.use('/session',middleareAuth, routes.session);
app.use('/users',routes.auth);
app.use('/tickets',middleareAuth, routes.tickets);
app.use('/events',middleareAuth, routes.events);

// * Start * //

const eraseDatabaseOnSync = true;

connectDb().then(async () => {
  app.listen(process.env.PORT, () =>
    console.log(`app listening on port ${process.env.PORT}!`),
  );
});

// * Database Seeding * //


