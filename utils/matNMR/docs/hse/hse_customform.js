/* JavaScript library for HSE to be used for custom input forms. Written by Robert Allerstorfer. Last modified on 2002 10 06 */

var iev = navigator.appVersion;
'0'.search(/(0)/);
iev = iev.search(/MSIE (\d\.[\d]{1,2})/);
iev = RegExp.$1;

function DecodeURIComponent(u8enc) {
	var plaintxt = "";
	if (iev < 5.5) {
		var u8txt = "";
		var i=0;
		while ((i = u8enc.search(/%([\dA-F]{2})/i)) >= 0) {
			u8txt += u8enc.substring(0, i);
			u8txt += String.fromCharCode('0x' + RegExp.$1);
			u8enc = u8enc.substring(i + 3, u8enc.length);
		}
		u8txt += u8enc;
		i=0;
		while(i < u8txt.length) {
			var c = u8txt.charCodeAt(i);
			if (c<128) {
				plaintxt += String.fromCharCode(c);
				i++;
			} else if ((c>191) && (c<224)) {
				var c2 = u8txt.charCodeAt(i+1);
				plaintxt += String.fromCharCode(((c&31)<<6) | (c2&63));
				i+=2;
			} else {
				var c2 = u8txt.charCodeAt(i+1);
				var c3 = u8txt.charCodeAt(i+2);
				plaintxt += String.fromCharCode(((c&15)<<12) | ((c2&63)<<6) | (c3&63));
				i+=3;
			}
		}
	} else {
		plaintxt = decodeURIComponent(u8enc);
	}
	return plaintxt;
}

function fill_form() {
	var names = "+";
	for (var i = 0; i < self.document.hse_form1.elements.length; i++) {
		names = names + self.document.hse_form1.elements[i].name + "+";
	}
	var url = self.document.URL;
	if (url.indexOf("?") > -1) {
		var query = (url.split("?"))[1];
		if (query.indexOf("#") > -1) {
			query = (query.split("#"))[0];
		}
		query = query.replace(/\&/g, ";");
		if (query.indexOf("terms=") > -1 && names.indexOf("+terms+") > -1) {
			var terms;
			if (query.indexOf("enc=") > -1) {
				terms = DecodeURIComponent((((query.split("enc="))[1]).split(";"))[0]);
			} else {
				terms = unescape((((((query.split("terms="))[1]).split(";"))[0]).split("+")).join(" "));
			}
			self.document.hse_form1.terms.value = terms;
		}
	}
	if (query.indexOf("geturl=") > -1 && query.indexOf("geturl=highlightmatches+gotofirstmatch") == -1 && names.indexOf("+geturl+") > -1) {
		self.document.hse_form1.geturl.value = "off";
	}
	if (query.indexOf("matchcase=") > -1 && query.indexOf("matchcase=off") == -1 && names.indexOf("+matchcase+") > -1) {
		self.document.hse_form1.matchcase.value = "on";
	}
	if (query.indexOf("noparts=") > -1 && query.indexOf("noparts=off") == -1 && names.indexOf("+noparts+") > -1) {
		self.document.hse_form1.noparts.value = "on";
	}
}

function checkinput() {
	if (self.document.hse_form1.terms.value == "") {
		var message = "Please enter a search string (one or more terms, separated by blanks).\n";
		message += "Phrases must stand under double-quotes (\").\n";
		message += "You can also use the asterik (*) as wildcard.\n";
		alert(message);
		self.document.hse_form1.terms.focus();
		return false;
	} else {
		return true;			
	}
}

function help_terms() {
	var message = "Enter one or more terms (separated by blanks).\n";
	message += "Phrases must stand under double-quotes (\").\n";
	message += "You can also use the asterik (*) as wildcard.\n";
	alert(message);
	self.document.hse_form1.terms.focus();
	return false;
}