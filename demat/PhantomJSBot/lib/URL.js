function URL() {}

URL.prototype.toString = function() {
	var strUrl = "";
	strUrl += this.scheme ? this.scheme + ":" : "";
	strUrl += this.hostname ? "//" + this.hostname : "";
	strUrl += this.port ? ":" + this.port : "";
	strUrl += this.path;
  var query = this.query;
	strUrl += this.query ? "?" + Object.keys(this.query).map(function (k) {
				return query[k] !== undefined ? k + "=" + encodeURIComponent(query[k]) : k;
			}).join("&") : "";
	strUrl += this.fragment ? "#" + this.fragment : "";
		
	return strUrl;
};

URL.prototype.isSubUri = function(url) {
	if(this.scheme && url.scheme && this.scheme !== url.scheme) {
		return false;
	}
	
	if(this.hostname && url.hostname && this.hostname !== url.hostname) {
		return false;
	}
	
	if(this.port && url.port && this.port !== url.port) {
		return false;
	}
	
	if(this.path && url.path && this.path.indexOf(url.path) !== 0) {
		return false;
	}
	
	if(url.query){
		var keys = Object.keys(url.query);
		for(var i=0;i<keys.length;i++) {
			if(!(keys[i] in this.query) || url.query[keys[i]] !== this.query[keys[i]]) {
				return false;
			}
		}
	}
	
	return true;
};

URL.parse = function(_strUrl) {
	var url = new URL();
	
	var greedyMatch = function(_regex) {
		var match = _strUrl.match(_regex);
		if(match !== null && match.length === 1) {
			if(match[0].length <= _strUrl.length) {
				_strUrl = _strUrl.substring(match[0].length);
			}
			return match[0];
		}
		
		return undefined;
	};

	// Match scheme
	url.scheme = greedyMatch(/^[^:/?#]+:/g);
	if(url.scheme) {
		url.scheme = url.scheme.substring(0,url.scheme.length-1);
	}
	
	// Match hostname
	url.hostname = greedyMatch(/^\/\/([^:/?#]*)/g);
	if(url.hostname) {
		url.hostname = url.hostname.substring(2);
	}
	
	// Match port
	url.port  = greedyMatch(/^:[0-9]*/g);
	if(url.port) {
		url.port = url.port.substring(1);
	}
	
	// Match path
	url.path = greedyMatch(/^([^?#]*)/g);
	if(!url.path) {
		throw new Error("Invalid Url");
	}
	
	// Match query
	url.query = greedyMatch(/^(\?([^#]*))/g);
	if(url.query) {
		url.query = url.query.substring(1,url.query.length);
		url.query = url.query.split("&").reduce(function (p,c) {
			var arr = c.split("=");
			p[arr[0]] = arr[1] !== undefined ? decodeURIComponent(arr[1]) : undefined;
			return p;}, {});
	}
	
	// Match fragment
	url.fragment = greedyMatch(/^(#(.*))/g);
	if(url.fragment) {
		url.fragment = url.fragment.substring(1);
	}
	
	if(_strUrl.length > 0) {
		throw new Error("Invalid Url");
	}
	
	return url;
};

exports.URL = URL;