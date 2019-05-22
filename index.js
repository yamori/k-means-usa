const WEB_PORT = 8080;

var express = require('express');
var app = express();

// set the view engine to ejs
app.set('view engine', 'ejs');

// index page 
app.get('/', function(req, res) {
    res.render('pages/index');
});

app.listen(WEB_PORT);
console.log(WEB_PORT + ' is the magic port');
