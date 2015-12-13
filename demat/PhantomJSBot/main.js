/**
 * New node file
 */

require('./lib/util');
var url = require('./lib/URL').URL;
var fs = require('fs');
var ipv4 = require('./lib/IPv4');
var config = require('./config').load;
var system = require('system');

var LOGGER = require(config.logger.libpath).LOGGER;
var INSECURE_SCHEME = ["http", "ws", "ftp"];

(function loadTeamsData(_filePath) {
	if(system.args.length === 3) {	// Starting in recovery mode
		if (fs.exists(_filePath)) {
			var teamsData = JSON.parse(fs.read(_filePath, {mode : "r"}));
			config.teams = teamsData;
		}
	}
	
	setInterval(function() {
		fs.write(_filePath, JSON.stringify(config.teams), 'w');
	}, 5000);
})(".\\teams.data");

//Monitor Team Directory for new files
function monitorTeamDirectory(_team,_path,_page,_logger) {
	_team.data.fileIndex = _team.data.fileIndex || 2; // A directory always contain .. and . directories 
	
	_path = _path + fs.separator + encodeURIComponent(_team.id);		// Team path
	
	setInterval(function() {
		var list = fs.list(_path);	// List team directory content
		var filename = _path + fs.separator + list[_team.data.fileIndex];
		// If at least a new file exists 
		if(list.length > _team.data.fileIndex &&
				fs.isFile(filename)) {
			_team.data.pageId = list[_team.data.fileIndex];
			_logger.log(LOGGER.LVL.INFO, {"EVTID" : "NEW_FILE",
				"TEAMID" : _team.id,
				"TIMESTAMP" : (new Date()).getTime(),
				"URL" : filename,
				"FILEINDEX" : _team.data.fileIndex - 1,
				"FILENUM " : list.length - 2});
	
			_page.setContent(fs.read(filename), config.contextLocation + encodeURIComponent(_team.id));
			_team.data.fileIndex++;
		}
	}, config.refresh);
}

var strGetFlagUrl;
var strContextLocationDomain;

(function () {
	var parsedContextLocation = url.parse(config.contextLocation);
	parsedContextLocation.port = 65534;
	parsedContextLocation.path = "/GETFLAG";
	
	strGetFlagUrl = parsedContextLocation.toString() + "?url=";
	strContextLocationDomain = parsedContextLocation.hostname;
})();

// Create a WebPage for each team
config.teams.forEach(function (t){
	var page = require('webpage').create();
	
	var logger = new LOGGER({filepath : config.logger.options.filepath + "team" + encodeURIComponent(t.id) + ".log", maxsize : config.logger.options.maxsize});
	
	if(typeof t.subnet === "string") {
		t.subnet = ipv4.Range.parse(t.subnet);
	}
		
	t.data = t.data || {};
	
	t.data.services = t.data.services || new Array(config.services.length);
	
	var objTeamContext = {	secret : config.secret,
							teamid : t.id,
							getFlagUrl : strGetFlagUrl};
	var ressourceRequestPending = 0;
	
	page.onInitialized = function() {
		page.injectJs("./inject.js");
		page.evaluate(function(_obj) {
			window.Initialize(_obj);
		}, JSON.stringify(objTeamContext));
	};
	
	page.onCallback = function(data) {
		if(data.secret === config.secret){
			t.data.requestData = data.requestData;
			}
		};
		
	page.onResourceReceived = function(response) {
		ressourceRequestPending--;
		};
		
	page.onResourceTimeout = function(request) {
		ressourceRequestPending--;
	};
	
	page.onResourceError = function(resourceError) {
		ressourceRequestPending--;
		logger.log(LOGGER.LVL.INFO, {"EVTID" : "RESOURCE_ERROR",
			"TEAMID" : t.id,
			"PAGEID" : t.data.pageId,
			"TIMESTAMP" : (new Date()).getTime(),
			"URL" : resourceError.url,
			"MSG" : resourceError.errorString});
			
			// Manually dispatch error events to elements
			page.evaluate(function (_url) {
				var event = new Event('error', {
					'view': window,
					'bubbles': true,
					'cancelable': true
				  });
				
				// TODO : Handle the cases where the URL is not in src attribute
				var elems = document.querySelectorAll("[src='" + _url + "']");
				
				if(elems.length === 0) {
					window.dispatchEvent(event);
					return;
				}
				
				Array.prototype.slice.call(elems).forEach(function (e) { e.dispatchEvent(event);});
			},resourceError.url);
		};
		
	page.onError = function(msg) {
		logger.log(LOGGER.LVL.INFO, {"EVTID" : "PAGE_ERROR",
			"TEAMID" : t.id,
			"PAGEID" : t.data.pageId,
			"TIMESTAMP" : (new Date()).getTime(),
			"MSG" : msg});
		};
	
	page.onResourceRequested = function(requestData, networkRequest) {
		ressourceRequestPending++;
		if(ressourceRequestPending > config.simultaneousRequest) {
			logger.log(LOGGER.LVL.INFO, {"EVTID" : "REQUEST_DROPPED",
				"TEAMID" : t.id,
				"PAGEID" : t.data.pageId,
				"TIMESTAMP" : (new Date()).getTime(),
				"MSG" : "Too many simultaneous requests",
				"URL" : requestData.url});
			networkRequest.abort();
			return;
		}
		
		var servicesIndex;
		// Check if it is a call to getflag
		if(requestData.url.indexOf(strGetFlagUrl) === 0) {
			var serviceUrl = url.parse(decodeURIComponent(requestData.url.substring(strGetFlagUrl.length)));
			servicesIndex = config.servicesUrlList.findIndex(function (e) {
				return serviceUrl.isSubUri(e);
			});
			// Validates if its a legitimate getflag call
			if(servicesIndex !== -1 && t.data.services[servicesIndex].found) {
				// Deliver the FLAG as a cookie
				phantom.addCookie({
					'name'     : 'FLAG',   /* required property */
					'value'    : config.services[servicesIndex].flag,  /* required property */
					'domain'   : strContextLocationDomain,
					'path'     : '/' + encodeURIComponent(t.id),                /* required property */
					'httponly' : false,
					'secure'   : false
					});
				
				logger.log(LOGGER.LVL.INFO, {"EVTID" : "GETFLAG_SUCCESS",
					"TEAMID" : t.id,
					"PAGEID" : t.data.pageId,
					"TIMESTAMP" : (new Date()).getTime(),
					"URL" : serviceUrl,
					"SERVICEID" : config.services[servicesIndex].id});
			} else { // Trying to retrieve flag before finding the service, kill the page
				page.setContent("", config.contextLocation + encodeURIComponent(t.id));
				
				logger.log(LOGGER.LVL.INFO, {"EVTID" : "GETFLAG_ERROR",
					"TEAMID" : t.id,
					"PAGEID" : t.data.pageId,
					"TIMESTAMP" : (new Date()).getTime(),
					"URL" : serviceUrl});
			}
			
			networkRequest.abort();
			return;
		}
		
		var parsedURL = url.parse(requestData.url);
		
		// Check if the requested resource if one of the valid services
		servicesIndex = config.servicesUrlList.findIndex(function (e) {
			return parsedURL.isSubUri(e);
		});
		if(servicesIndex !== -1 && config.services[servicesIndex].method === requestData.method &&
				(config.services[servicesIndex].method !== "POST" || config.services[servicesIndex].data === undefined ||
				(requestData.postData !== undefined && (new Function('return ' + config.services[servicesIndex].data)).call(requestData.postData)) ||
				(t.data.requestData !== undefined && (new Function('return ' + config.services[servicesIndex].data)).call(t.data.requestData)) ) )
		{
				
			t.data.services[servicesIndex] = t.data.services[servicesIndex] || {};
			t.data.services[servicesIndex].found = true;
			
			logger.log(LOGGER.LVL.INFO, {"EVTID" : "SERVICE_FOUND",
				"TEAMID" : t.id,
				"PAGEID" : t.data.pageId,
				"TIMESTAMP" : (new Date()).getTime(),
				"URL" : requestData.url,
				"SERVICEID" : config.services[servicesIndex].id});
			
			return;
		}
		
		var targetIp;
		try {
			// Try to parse the hostname for an IPv4 address
			targetIp = ipv4.Address.parse(parsedURL.hostname);
			
			// If the requested IP is included in the allowedTargets
			if(targetIp &&
					config.allowedTargets.findIndex(function (e) {
							return e instanceof ipv4.Range && targetIp.isInRange(e);
						}) !== -1) {

			logger.log(LOGGER.LVL.INFO, {"EVTID" : "ALLOWED_REQUEST",
					"TEAMID" : t.id,
					"PAGEID" : t.data.pageId,
					"TIMESTAMP" : (new Date()).getTime(),
					"URL" : requestData.url});
				
				return;
			}
		} catch(e) {
			// Check if it's a domain name
			if(config.allowedTargets.findIndex(function (e) {
							return typeof e === "string" && parsedURL.hostname === e;
						}) !== -1) {
				
				logger.log(LOGGER.LVL.INFO, {"EVTID" : "ALLOWED_REQUEST",
					"TEAMID" : t.id,
					"PAGEID" : t.data.pageId,
					"TIMESTAMP" : (new Date()).getTime(),
					"URL" : requestData.url});
				
				return;
			}
		}
				
		// If the requested resource is outside allowedTarget and the scheme is insecure 
		if(config.INSECURE_SCHEME.indexOf(parsedURL.scheme) !== -1){
			logger.log(LOGGER.LVL.INFO, {"EVTID" : "NOTSECURE_REQUEST",
				"TEAMID" : t.id,
				"PAGEID" : t.data.pageId,
				"TIMESTAMP" : (new Date()).getTime(),
				"URL" : requestData.url});
		}
		
		// If the request resource is inside the team subnet
		if(targetIp && targetIp.isInRange(t.subnet)) {
			// Return a free flag
			if(["http","https","ws","wss"].indexOf(parsedURL.scheme) !== -1) {
				parsedURL.query = parsedURL.query || {};
				parsedURL.query.FLAG = config.flag;
				networkRequest.changeUrl(parsedURL.toString());
			}
			
			logger.log(LOGGER.LVL.INFO, {"EVTID" : "CALL_HOME",
				"TEAMID" : t.id,
				"PAGEID" : t.data.pageId,
				"TIMESTAMP" : (new Date()).getTime(),
				"URL" : parsedURL.toString()});
			return;
		}
		
		logger.log(LOGGER.LVL.INFO, {"EVTID" : "NOTALLOWED_REQUEST",
			"TEAMID" : t.id,
			"PAGEID" : t.data.pageId,
			"TIMESTAMP" : (new Date()).getTime(),
			"URL" : requestData.url});
		
		// Otherwise abort request
		networkRequest.abort();
	};
	
	monitorTeamDirectory(t, config.share,page,logger);
});