// server.js

// BASE SETUP
// =============================================================================

// call the packages we need
var express    = require('express'),           // call express
    app        = express(),                    // define our app using express
    bodyParser = require('body-parser'),       // lets me get post data from req.body
    mongoose   = require('mongoose'),          // a small fury animal that talks to mongo
    User       = require('./app/models/User'), // the mongoose model/actress
    path       = require('path');              // used by express to serve static file

mongoose.connect('mongodb://localhost:27017'); // command to connect to local mongodb

// bodyParser() will let us get the data from a POST
app.use(bodyParser.urlencoded({
    extended: true
}));
app.use(bodyParser.json());

var port = process.env.PORT || 8080; // set our port
var router = express.Router(); // get an instance of the express Router

// viewed at http://localhost:8080
app.get('/', function(req, res) {
    res.sendFile(path.join(__dirname + '/index.html'));
    console.log("It's happening!");
});

// route to serve static file, this is the main page of the app.
// router.get('/', function(req, res) {
//   res.json({ message: 'hooray! welcome to our api!' });
// });

// middleware to use for all requests
router.use(function(req, res, next) {
    // do logging
    console.log('Something is happening.');
    next(); // make sure we go to the next routes and don't stop here
});






// more routes for our API will happen here

// REGISTER OUR ROUTES -------------------------------
// all of our routes will be prefixed with /api
app.use('/', router);

// START THE SERVER
// =============================================================================
app.listen(port);
console.log('Magic is happening right now at http://localhost:' + port);