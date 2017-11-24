var express = require('express'), 
	router = express.Router(), 
	Token = require('../models/token.js');

router.post('/', function(req, res){
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

router.delete('/:id_user', function(req, res){
	var userid = req.params.id_user;
	Token.findOneAndRemove({id_user: userid}, function(err, response) {
		if (err)
			console.log(err);
		else {
			console.log(userid + " deleted");
		}
	});
	res.send("good");
});

module.exports = router;