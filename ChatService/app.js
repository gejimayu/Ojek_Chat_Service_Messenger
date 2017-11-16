var express = require('express'),
	app = express(),
	mongoose = require('mongoose'),
	bodyParser = require('body-parser');

mongoose.connect('mongodb://localhost/chatojek');

var driverSchema = mongoose.Schema({
	id_driver: Number,
	locations: [String]
});

var Driver = mongoose.model("Driver", driverSchema);

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

app.listen(3000);
