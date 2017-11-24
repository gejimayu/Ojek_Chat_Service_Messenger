var express = require('express'), 
	router = express.Router(), 
	request	= require('request');
	Chat = require('../models/chat.js'),
	Token = require('../models/token.js');

router.post('/', function(req, res){
	var newChat = new Chat({
		id_sender: req.body.id_sender,
		id_receiver: req.body.id_receiver,
		message: req.body.message
	});
	console.log(newChat);
	console.log("hello : " + req.body.issave);
	Token.findOne({ id_user: newChat.id_receiver }, function (err, result) {
		if (err) {
			console.log("token not exist");
			return null;
		}
		else {
			if (result != null) {
				var key = 'AAAA_GmMXNo:APA91bHPCn5TqamLyqh8Fpw0mjP78qrDQpOw1HE0jNCLP8SV7PXHzJYb_0cX4xRWAF8jHQsoF0rNMQS0LHK-De1kkx9YsC_ifYj62iVQ9tcew9S9In3jXSHI118sifj1uJAHJVHQjHvb';
			
				var sendme = {
					'notification': {'title': 'New Message', 'body': newChat.message},
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
				            console.log(req.body.issave);
				            if (req.body.issave == 1) {
				            	newChat.save((err, saved) => {
									if (err)
										res.send("error");
									console.log("inidia : " + saved);
								});
				            }
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

router.get('/', function(req, res){
	console.log(req.query);
	Chat.find({$or : [
						{$and : [{id_sender: req.query.id_sender}, {id_receiver: req.query.id_receiver}]},
						{$and : [{id_sender: req.query.id_receiver}, {id_receiver: req.query.id_sender}]}
					]}, 
		function(err, response){
			if (err)
				console.log(err);
			else {
				res.send(response);
		}
	});
})

module.exports = router;