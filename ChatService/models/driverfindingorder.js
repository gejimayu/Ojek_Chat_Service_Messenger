var mongoose = require('mongoose');

var driverSchema = mongoose.Schema({
	id_driver: Number,
	locations: [String]
});

module.exports = mongoose.model("Driver", driverSchema);