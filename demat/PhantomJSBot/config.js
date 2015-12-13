/**
 * New node file
 */
var fs = require('fs');
var ipv4 = require('./lib/IPv4');
var system = require('system');
var url = require('./lib/URL').URL;

exports.load = (function () {
	var config;
	try{
		if(system.args.length >= 2) {
			config = JSON.parse(fs.read(system.args[1], {mode : "r"}));
		} else {
			config = JSON.parse(fs.read(fs.workingDirectory + fs.separator + "config.json", {mode : "r"}));
		}
	}catch(e) {}
		
	config = config || {};
	
	config.teams = config.teams || [];
	
	// Default logger
	config.logger = config.logger || {};
	config.logger.libpath = config.logger.libpath || "./lib/consolelogger";
	
	// Default refresh time is 30 seconds
	config.refresh = config.refresh || 30000;
	
	// Default allowedTarget is an empty array
	config.allowedTargets = config.allowedTargets || [];
	if(!(config.allowedTargets instanceof Array)) {
		config.allowedTargets = [];
	}
	
	// Parse the IPv4 ranges of the allowed targets
	config.allowedTargets = config.allowedTargets.map(function (e) {
			var parsedIPRange;
			try {
				parsedIPRange = ipv4.Range.parse(e);
				
				return ipv4.Range.parse(e);
			}catch(error) {
				if(typeof e !== "string") {
					e = "";
				}
				return e.toString().toLowerCase();
			}
	});
	
	config.simultaneousRequest = config.simultaneousRequest || 500;
	
	// Default services is an empty array
	config.services = config.services || [];
	config.servicesUrlList = config.services.map(function (e) {
			return url.parse(e.url);
	});

	config.cookies = config.cookies || [];
	config.cookies.forEach(function (e) {
		phantom.addCookie(e);
	});
	
	config.contextLocation = config.contextLocation || "https://127.0.0.1/";
	config.contextLocation += config.contextLocation.lastIndexOf("/") !== config.contextLocation.length - 1 ? "/" : "";
	return config;
})();