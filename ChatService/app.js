var express 		= require('express'),
	app 			= express(),
	mongoose 		= require('mongoose'),
	bodyParser 		= require('body-parser'),
	Driver 			= require('./models/driverfindingorder.js'),
	Token 			= require('./models/token.js'),
	Chat			= require('./models/chat.js'),
	request			= require('request');

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

app.post('/selectprefdriver', function(req, res){
	var to = req.body.destination;
	var drivername = req.body.name;
	Driver.findOne({ $and : [{name: drivername}, {locations: to}] }, function(err, response){
		if (err)
			console.log(err);
		else {
			res.send(response);
		}
	});
})

app.post('/selectdriver', function(req, res){
	var to = req.body.destination;
	Driver.find({locations: to}, function(err, response){
		if (err)
			console.log(err);
		else {
			res.send(response);
		}
	});
})

app.post('/deletetoken', function(req, res){
	var userid = req.body.id_user;
	Token.findOneAndRemove({id_user: userid}, function(err, response) {
		if (err)
			console.log(err);
		else {
			console.log(userid + " deleted");
		}
	});
	res.send("good");
});

app.post('/deletefindingdriver', function(req, res){
	var userid = req.body.id_user;
	Driver.findOneAndRemove({id_driver: userid}, function(err, response) {
		if (err)
			console.log(err);
		else {
			console.log(userid + " deleted");
		}
	});
	res.send("good");
});


app.post('/sendchat', function(req, res){
	var newChat = new Chat({
		id_sender: req.body.id_sender,
		id_receiver: req.body.id_receiver,
		message: req.body.message
	});
	console.log(newChat);

	Token.findOne({ id_user: newChat.id_receiver }, function (err, result) {
		if (err) {
			console.log("token not exist");
			return null;
		}
		else {
			if (result != null) {
				var key = 'AAAA_GmMXNo:APA91bHPCn5TqamLyqh8Fpw0mjP78qrDQpOw1HE0jNCLP8SV7PXHzJYb_0cX4xRWAF8jHQsoF0rNMQS0LHK-De1kkx9YsC_ifYj62iVQ9tcew9S9In3jXSHI118sifj1uJAHJVHQjHvb';
			
				var sendme = {
					'notification': {
						'title': 'New Message',
						'body': newChat.message,
						"icon": "firebase-logo.png"
					},
					'to': result.token
				};
				var options = {
					url: 'https://fcm.googleapis.com/fcm/send',
					headers: {
						'Content-Type': 'application/json',
						'Authorization': 'key=' + key
					},
					body: JSON.stringify(sendme)
				};

				console.log(options);

				request.post(options, 
				    function (error, response, body) {
				        if (!error && response.statusCode == 200) {
				            console.log("successfully sent");
				            newChat.save((err, saved) => {
								if (err)
									res.send("error");
								console.log("inidia : " + saved);
							});
				        }
				        else {
				        	console.log(response.statusCode);
				        }
				    }
				);
				res.send("succeded");
			}
			else
				res.send("failed");
		}
	});
});

app.listen(3000);
