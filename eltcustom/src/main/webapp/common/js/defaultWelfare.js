var defaultWelfare = {

	defaultFL: {
		"rows":[
	        {"sflq":0,"mc":"默认福利4","ffsj":"03.09","nid":5,"zt":0,"yxq":new Date().toformat(""),"ffly":"系统发放","ffyy":"试用帐号体验"},
	        {"sflq":0,"mc":"默认福利3","ffsj":"03.08","nid":4,"zt":0,"yxq":new Date().toformat(""),"ffly":"系统发放","ffyy":"试用帐号体验"},
	        {"sflq":0,"mc":"默认福利2","ffsj":"03.01","nid":3,"zt":0,"yxq":new Date().toformat(""),"ffly":"系统发放","ffyy":"试用帐号体验"},
	        {"sflq":0,"mc":"默认福利1","ffsj":"02.01","nid":1,"zt":0,"yxq":"20100209","ffly":"系统发放","ffyy":"试用帐号体验"}
	      ]
	},
	
	listWelfare: function(userName) {
		var str = this._getCookie(userName); // 已经领取的福利id: "1|2|5"
		var fls = this.defaultFL.rows;
		var tmpArr = fls.slice(0);
		if (str) {
			var ss = str.split("|");
			var ssLen = ss.length;
			var len = tmpArr.length;
			for (var i=0; i<len; i++) {
				for (var j=0; j<ssLen; j++) {
					if (tmpArr[i].nid == ss[j]) {
						tmpArr[i].sflq = 1;
					}
				}
			}
		}
		return {"rows": tmpArr};
	},
	
	getWelfare: function(flId) {
		var fls = this.defaultFL.rows;
		var len = fls.length;
		var row = [];
		for (var i=0; i<len; i++) {
			if (fls[i].nid == flId) {
				row.push(fls[i]);
			}
		}
		return {"rows": row};
	},
	
	lqWelfare: function(userName, flId) {
		var str = this._getCookie(userName);
		if (str) {
			str += "|" + flId;
		} else {
			str = flId;
		}
		this._writeCookie(userName, str, 14 * 24); //有效期为14天
	},
	
	ylqWelfare: function(user) {
		var fls = this.defaultFL.rows;
		var len = fls.length;
		var rows = new Array();
		var str = this._getCookie(user);
		if (str) {
			var ss = str.split("|");
			var ssLen = ss.length;
			for (var i=0; i<len; i++) {
				for (var j=0; j<ssLen; j++) {
					//已领取
					if (ss[j] == fls[i].nid)
						rows.push(fls[i]);
				}
			}
		}
		return rows.length;
	},
	
	wlqWelfare: function(user) {
		var fls = this.defaultFL.rows;
		var len = fls.length;
		var ylqLen = this.ylqWelfare(user);
		var rows = new Array();
		//已过期
		for (var i=0; i<len; i++) {
			if (fls[i].yxq < new Date().toformat("")) {
				rows.push(fls[i]);
			}
		}
		return (len - ylqLen - rows.length);
	},
	
	pagelyFl: function(user, rp, page) {
		var fls = this.listWelfare(user).rows;
		var len = fls.length;
		return {"total": len, "page": page, "rows": fls};
	},
	
	_getCookie: function(objKey) {
		var arrStr = document.cookie.split("; ");
	    for(var i = 0;i < arrStr.length;i ++){
	        var temp = arrStr[i].split("=");
	        if(temp[0] == objKey) {
	        	return unescape(temp[1]);
	        }
	    }
	    return "";
	},
	
	_writeCookie: function(objKey, objValue, objHours) {
		var str = objKey + "=" + escape(objValue);
	    if(objHours > 0) {
	        var date = new Date();
	        var ms = objHours*3600*1000;
	        date.setTime(date.getTime() + ms);
	        str += "; expires=" + date.toGMTString();
	    }
	    document.cookie = str;
	}
};

