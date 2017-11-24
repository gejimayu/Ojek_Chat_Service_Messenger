var express = require('express'), 
	router = express.Router(), 
	Driver = require('../models/driverfindingorder.js');

router.post('/', function(req, res){
	console.log(req.body);
	var newDriver = new Driver({
		id_driver: req.body.id_driver,
		locations: req.body.locations,
		name: req.body.name
	});
	newDriver.save((err, saved) => {
		if (err)
			res.send("error");
		console.log(saved);
	});
	res.send("received");
});

router.get('/pref', function(req, res){
	var to = req.query.destination;
	var drivername = req.query.name;
	Driver.findOne({ $and : [{name: drivername}, {locations: to}] }, function(err, response){
		if (err)
			console.log(err);
		else {
			res.send(response);
		}
	});
});

router.get('/', function(req, res){
	var to = req.query.destination;
	Driver.find({locations: to}, function(err, response){
		if (err)
			console.log(err);
		else {
			res.send(response);
		}
	});
});

router.delete('/:id_user', function(req, res){
	var userid = req.params.id_user;
	Driver.findOneAndRemove({id_driver: userid}, function(err, response) {
		if (err)
			console.log(err);
		else {
			console.log(userid + " deleted");
		}
	});
	res.send("good");
});

module.exports = router;