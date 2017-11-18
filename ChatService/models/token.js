var mongoose = require('mongoose');

var tokenSchema = mongoose.Schema({
	id_user: Number,
	token: String
});

module.exports = mongoose.model("Token", tokenSchema);
