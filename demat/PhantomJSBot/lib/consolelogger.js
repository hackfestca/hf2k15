/**
 * New node file
 */

var fs = require('fs');

function LOGGER (_logfile) {
	this.logfile = _logfile;
}

LOGGER.prototype.log = function(_lvl, _obj) {
	console.log(JSON.stringify(_obj));
};

LOGGER.LVL = {};
LOGGER.LVL.INFO = 0;

exports.LOGGER = LOGGER;