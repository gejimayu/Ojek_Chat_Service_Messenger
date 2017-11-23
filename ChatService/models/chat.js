var mongoose = require('mongoose');

var chatSchema = mongoose.Schema({
	id_sender: Number,
	id_receiver: Number,
	message: String
});

module.exports = mongoose.model("Chat", chatSchema);
