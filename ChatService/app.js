var express 		= require('express'),
	app 			= express(),
	mongoose 		= require('mongoose'),
	bodyParser 		= require('body-parser'),
	Driver 			= require('./models/driverfindingorder.js'),
	Token 			= require('./models/token.js');

mongoose.connect('mongodb://localhost/chatojek');

app.use(bodyParser.json()); 
// for parsing application/xwww-form-urlencoded
app.use(bodyParser.urlencoded({ extended: true })); 

app.get('/', function(req, res){
	res.send("hello");
});

app.post('/storedriver', function(req, res){
	console.log(req.body);
	var newDriver = new Driver({
		id_driver: req.body.id_driver,
		locations: req.body.locations
	});
	newDriver.save((err, saved) => {
		if (err)
			res.send("error");
		console.log(saved);
	});
	res.send("received");
});

app.post('/storetoken', function(req, res){
	console.log(req.body);
	var newToken = new Token({
		id_user: req.body.id_user,
		token: req.body.token
	});
	newToken.save((err, saved) => {
		if (err)
			res.send("error");
		console.log(saved);
	});
	res.send("received");
});

app.listen(3000);
