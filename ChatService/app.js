var express = require('express'),
	app = express(),
	mongoose = require('mongoose'),
	bodyParser = require('body-parser');

mongoose.connect('mongodb://localhost/chatojek');

app.use(bodyParser.json()); 
// for parsing application/xwww-form-urlencoded
app.use(bodyParser.urlencoded({ extended: true })); 

app.get('/', function(req, res){
	res.send("hello");
});

app.post('/', function(req, res){
	console.log(req.body);
	res.send("received");
});

app.listen(3000);
