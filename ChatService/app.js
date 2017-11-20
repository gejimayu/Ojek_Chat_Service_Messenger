var express 		= require('express'),
	app 			= express(),
	mongoose 		= require('mongoose'),
	bodyParser 		= require('body-parser'),
	Driver 			= require('./models/driverfindingorder.js'),
	Token 			= require('./models/token.js');
	Chat			= require('./models/chat.js')

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
	console.log(req.body);
	var newChat = new Chat({
		id_sender: req.body.id_sender,
		id_receiver: req.body.id_receiver,
		message: req.body.message
	});
	var recv_token = findToken(newChat.id_receiver);
	sendRequestToFCM(recv_token, newChat.message);
	newChat.save((err, saved) => {
		if (err)
			res.send("error");
		console.log(saved);
	});
	res.send("success");
});

function findToken(id_receiver) {
	Token.find({ id_user: id_receiver }, 'token', function (err, result) {
		if (err) {
			console.log("token not exist");
			return;
		}
		return result.token;
	});
}

function sendRequestToFCM(recv_token, message) {
	var key = 'YOUR-SERVER-KEY';
	var to = 'YOUR-IID-TOKEN';
	var notification = {
	  'title': 'New Message',
	  'body': message,
	  'click_action': 'http://localhost:8085' //gk tau ini apaan
	};

	fetch('https://fcm.googleapis.com/fcm/send', {
	  'method': 'POST',
	  'headers': {
	    'Authorization': 'key=' + key,
	    'Content-Type': 'application/json'
	  },
	  'body': JSON.stringify({
	    'notification': notification,
	    'to': to
	  })
	}).then(function(response) {
	  console.log(response);
	}).catch(function(error) {
	  console.error(error);
	})
}

function post(path, params, method) {
    method = method || "post"; // Set method to post by default if not specified.

    // The rest of this code assumes you are not using a library.
    // It can be made less wordy if you use one.
    var form = document.createElement("form");
    form.setAttribute("method", method);
    form.setAttribute("action", path);

    for(var key in params) {
        if(params.hasOwnProperty(key)) {
            var hiddenField = document.createElement("input");
            hiddenField.setAttribute("type", "hidden");
            hiddenField.setAttribute("name", key);
            hiddenField.setAttribute("value", params[key]);

            form.appendChild(hiddenField);
        }
    }
    document.body.appendChild(form);
    form.submit();
}

app.listen(3000);
