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

app.use('/drivers', require('./controllers/drivers.js'));
app.use('/chats', require('./controllers/chats.js'));
app.use('/tokens', require('./controllers/tokens.js'));

app.listen(3000);
