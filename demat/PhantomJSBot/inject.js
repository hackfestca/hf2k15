// TODO : Dynamically generate this file based on configuration 

window.Initialize = function (_obj) {
	var obj;
	try {
		obj = JSON.parse(_obj);
	}catch(e) {
		throw new Error("Page cannot be initialized");
	}
	
	window.getFlag = function(_url) {
		try {
			if(_url === undefined || _url === null || typeof _url !== "string" || _url.length === 0) {
				return;
			}
			var xml = new XMLHttpRequest();
			xml.open("GET", obj.getFlagUrl + encodeURIComponent(_url), true);
			xml.send();
		} catch(e) {}
	};	
	
	var proxiedSend = window.XMLHttpRequest.prototype.send;
	window.XMLHttpRequest.prototype.send = function(_data) {
		window.callPhantom({
			secret: obj.secret,
			requestData : _data
			});
		
		return proxiedSend.apply(this, [].slice.call(arguments));
	};
	
	// Disabling dynamic element creation for performance issues
	// TODO : Add an option in the configuration file
	window.document.createElement = function(_name) {
		throw new Error("elment creation has been disabled");		
		return;
	};
	
	// Disabling unwanted functions
	// TODO : Add an option in the configuration file
	window.Worker = undefined;
	window.SharedWorker = undefined;
};