function Address(_value) {
   this.value = _value;
}

function Range() {}

Address.prototype.isInRange = function(_range) {
  if(!(_range instanceof Range)) {
    throw new Error("Invalid parameter");
  }
  
  return _range.base.value <= this.value && this.value <= _range.max.value;
};

Address.parse = function(_strAddress) {
	var addr = new Address();
	
	var match = _strAddress.match(/^(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])$/);
	if(match === null) {
		throw new Error("Invalid address");
	}
	
	match.shift();
	addr.value = match.reduce(function (p,c) {
		return parseInt(c,10)+p*256;
	},0);
	
	return addr;
};

exports.Address = Address;

Range.parse = function(_strRange) {
	var rg = new Range();
	var arr = _strRange.split("/");
	if(arr.length !== 2) {
		throw new Error("Invalid range");
	}
	
	try {
		rg.base = Address.parse(arr[0]);
	}catch(e) {
		throw new Error("Invalid range");
	}
	
	var mask = parseInt(arr[1],10);
	var max = Math.ceil(Math.exp((32-mask)*Math.log(2)));
	if(isNaN(mask) || mask > 32 || max + rg.base > 4294967296) {
		throw new Error("Invalid range");
	}
	
	rg.max = new Address(max + rg.base.value);
	
	return rg;
};

exports.Range = Range;