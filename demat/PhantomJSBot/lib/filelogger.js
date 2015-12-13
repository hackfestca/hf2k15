/**
 * New node file
 */

var fs = require('fs');

function writeLogs() {
	
	var queueSize = this.queue.length;
	if(queueSize === 0){
		return;
	}
	
	if (!fs.exists(this.logfile) || (this.maxsize !== -1 && fs.size(this.logfile) > this.maxsize)) {
		fs.write(this.logfile, JSON.stringify(this.queue.shift()), 'w');
		queueSize--;
	}
	
	for(var i=queueSize;i>=1;i--) {
		fs.write(this.logfile, "\n" + JSON.stringify(this.queue.shift()), 'a');
	}
}

function LOGGER (_options) {
	this.logfile = _options.filepath;
	this.maxsize =  _options.maxsize || -1;
	this.queue = [];
	
	var obj = this;
	setInterval(function () {writeLogs.call(obj);},5000);
}

LOGGER.prototype.log = function(_lvl, _obj) {
	this.queue.push(_obj);
};

LOGGER.LVL = {};
LOGGER.LVL.INFO = 7;

exports.LOGGER = LOGGER;