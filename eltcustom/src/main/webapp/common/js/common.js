
String.prototype.trim = function() { 
	return this.replace(/(^\s*)|(\s*$)/g, ""); 
} 

Date.prototype.toformat = function(split){
	if(split == undefined)split="-"
	var d = this.getDate();
	var m = this.getMonth()+1;
	var y = this.getYear();
	var datestr = y+split+(m<10?("0"+m):m)+split+(d<10?("0"+d):d);
	return datestr;
}

Number.prototype.toFixed = function( fractionDigits )
{
	var add = 0,s;
	var s1 = this + "";
	var start = s1.indexOf(".");
	if(start == -1) 
	{
		return s1 + "." + FillWithZero(fractionDigits);
	}
	var length = s1.length - start -1;
	if( length <= fractionDigits){
		return s1 + FillWithZero(fractionDigits-length);
	}
	if(s1.substr(start+fractionDigits+1,1)>=5){
		add = 1;
	}
	var temp = Math.pow(10, fractionDigits);
	s = Math.floor(this*temp) + add;
	return (s/temp).toFixed(2);
}

Array.prototype.unique = function() {
	var ret = [], record = {}, it, tmp;
	var type = {
		"number" : function(n) {
			return "_num" + n;
		},
		"string" : function(n) {
			return n;
		},
		"boolean" : function(n) {
			return "_boolean" + n;
		},
		"object" : function(n) {
			return n === null ? "_null" : $.data(n);
		},
		"undefined" : function(n) {
			return "_undefined";
		}
	};
	for ( var i = 0, length = this.length; i < length; i++) {
		it = tmp = this[i];
		tmp = type[typeof it](it);
		if (!record[tmp]) {
			ret.push(it);
			record[tmp] = true;
		}
	}
	return ret;
};
var getParams = function(classname){
	var str = "";
	var order = "";
	var or = "";
	var $searchs = $("."+classname+" :input").not(":button,:submit,:checkbox,:radio");
	$searchs = $searchs.add("."+classname+" :checked");
	for ( var i = 0; i < $searchs.length; i++) {
		var tmpvalue = $.trim($searchs.eq(i).get(0).value);
		tmpvalue = tmpvalue.replace(/'/g,"''");
		var rule = $searchs.eq(i).attr("rule");
		if (tmpvalue != "") {
			if (rule == "like") {
				str += " and " + $searchs.eq(i).attr("id")
						+ " like '%" + tmpvalue + "%'";
			}
			if (rule == "lk") {
				str += " and " + $searchs.eq(i).attr("id")
						+ " like '" + tmpvalue.replace(/\*/gi,"%").replace(/\?/gi,"_") + "'";
			}
			if (rule == "eq") {
				str += " and " + $searchs.eq(i).attr("id")
						+ " = '" + tmpvalue + "'";
			}
			if (rule == "le") {
				str += " and " + $searchs.eq(i).attr("id").replace(/start_|end_/gi,"")
						+ " <= '" + tmpvalue + "'";
			}
			if (rule == "dtle") {
				str += " and " + $searchs.eq(i).attr("id").replace(/start_|end_/gi,"")
						+ " <= '" + tmpvalue + " 23:59:59'";
			}
			if (rule == "ge") {
				str += " and " + $searchs.eq(i).attr("id").replace(/start_|end_/gi,"")
						+ " >= '" + tmpvalue + "'";
			}	
			if (rule == "in") {
				str += " and " + $searchs.eq(i).attr("id").replace(/start_|end_/gi,"")
						+ " in (" + tmpvalue + ") ";
			}
			if (rule == "daylimit") {
				var now = new Date();
				var dlimit = new Date(now.getTime()-parseInt(tmpvalue)*24*3600*1000).toformat();
				str += " and " + $searchs.eq(i).attr("id").replace(/start_|end_/gi,"")
						+ " >= '" + dlimit + "'";
			}			
			if (rule == "or") {
				or += " or " + $searchs.eq(i).attr("id").replace(/start_|end_/gi,"")
				+ " = '" + tmpvalue + "'";
			}
			if (rule == "order") {
				order += " order by " + tmpvalue;
			}
		}
	}
	if(or!=''){
		or = ' and ('+or.substr(or.indexOf('or')+2)+')';
	}
	return str+or+order;
}


function FixWidth(selectObj)
{
	if(!$.browser.msie) return true;
    var newSelectObj = document.createElement("select");
    newSelectObj = selectObj.cloneNode(true);
    newSelectObj.selectedIndex = selectObj.selectedIndex;
    newSelectObj.onmouseover = null;
    
    var e = selectObj;
    var absTop = e.offsetTop;
    var absLeft = e.offsetLeft;
    while(e = e.offsetParent)
    {
        absTop += e.offsetTop;
        absLeft += e.offsetLeft;
    }
    with (newSelectObj.style)
    {
        position = "absolute";
        top = absTop + "px";
        left = absLeft + "px";
        width = "auto";
    }
    
    var rollback = function(){ RollbackWidth(selectObj, newSelectObj); };
    if(window.addEventListener)
    {
        newSelectObj.addEventListener("blur", rollback, false);
        newSelectObj.addEventListener("change", rollback, false);
    }
    else
    {
        newSelectObj.attachEvent("onblur", rollback);
        newSelectObj.attachEvent("onchange", rollback);
    }
    
    selectObj.style.visibility = "hidden";
    document.body.appendChild(newSelectObj);
    var w=selectObj.offsetWidth;
    var wnew=newSelectObj.offsetWidth;
    if(wnew<w){
    	with (newSelectObj.style)
        {
            width = w+"px";
        }
    }
    newSelectObj.focus();
}

function RollbackWidth(selectObj, newSelectObj)
{
    selectObj.selectedIndex = newSelectObj.selectedIndex;
    selectObj.style.visibility = "visible";
    document.body.removeChild(newSelectObj);
    if(typeof(isselectchange)!="undefined"){
    	selectchange();
    }
}

function FillWithZero(length){
	var result = "";
	for(var i = 0; i < length; i++){
		result = result + "0";
	}
	return result;
}

function getCookie(objName){
    var arrStr = document.cookie.split("; ");
    for(var i = 0;i < arrStr.length;i ++){
        var temp = arrStr[i].split("=");
        if(temp[0] == objName) return unescape(temp[1]);
    }
    return "";
} 
function setCookie(objName,objValue,objHours){      
    var str = objName + "=" + escape(objValue);
    if(objHours > 0){                            
        var date = new Date();
        var ms = objHours*3600*1000;
        date.setTime(date.getTime() + ms);
        str += "; expires=" + date.toGMTString();
    }
    document.cookie = str;
}

function getCookieReg(name){
     var arr = document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"));
     if(arr != null) return unescape(arr[2]); 
	 return "";
}

function delCookie(name){
    var exp = new Date();
    exp.setTime(exp.getTime() - 1);
    var cval=getCookie(name);
    if(cval!=null) document.cookie= name + "="+cval+";expires="+exp.toGMTString();
}

var addShopCar = function(sp,spcount,dhfs){
	var spstr = getCookie("sp");
	var dhfsstr = getCookie("dhfs");
	var spcountstr = getCookie("spcount");
	if(spstr==""){
		spstr = sp;
		dhfsstr = dhfs;
		spcountstr = spcount;
	}
	else if(spstr.indexOf(",")==-1){
		if(spstr==sp){
			spcountstr = parseInt(spcountstr)+parseInt(spcount);
		}
		else {
			spstr += ','+sp;
			dhfsstr += ','+dhfs;
			spcountstr += ','+spcount;			
		}
	}
	else{
		var sparr = spstr.split(",");
		var dhfsarr = dhfsstr.split(",");
		var spcountarr = spcountstr.split(",");
		var exist = 0;
		for(var i=0;i<sparr.length;i++){
			if(sparr[i]==sp){
				spcountarr[i] = parseInt(spcountarr[i])+parseInt(spcount);
				exist = 1;
			}
		}
		if(exist == 0){
			sparr.push(sp);
			dhfsarr.push(dhfs);
			spcountarr.push(spcount);
		}
		spstr = sparr.toString();
		dhfsstr = dhfsarr.toString();
		spcountstr = spcountarr.toString();
	}
	setCookie("sp",spstr,10);
	setCookie("dhfs",dhfsstr,10);
	setCookie("spcount",spcountstr,10);
	refreshHeadDhlCount();
}

var delShopCar = function(sp){
	var spstr = getCookie("sp");
	var dhfsstr = getCookie("dhfs");
	var spcountstr = getCookie("spcount");
	if(spstr==""){
		return false;
	}
	else if(spstr.indexOf(",")==-1){
		if(sp==spstr){
			delCookie("sp");
			delCookie("dhfs");
			delCookie("spcount");
		}
	}
	else{
		var sparr = spstr.split(",");
		var dhfsarr = dhfsstr.split(",");
		var spcountarr = spcountstr.split(",");
		var tsparr = new Array();
		var tdhfsarr = new Array();
		var tspcountarr = new Array();
		for(var i=0;i<sparr.length;i++){
			if(sparr[i]!=sp){
				tsparr.push(sparr[i]);
				tdhfsarr.push(dhfsarr[i]);
				tspcountarr.push(spcountarr[i]);
			}
		}
		spstr = tsparr.toString();
		dhfsstr = tdhfsarr.toString();
		spcountstr = tspcountarr.toString();
		setCookie("sp",spstr,10);
		setCookie("dhfs",dhfsstr,10);
		setCookie("spcount",spcountstr,10);
	}
	refreshHeadDhlCount();
}

var getShopCarCount = function(){
	var count = 0;
	var spcountstr = getCookie("spcount");
	if(spcountstr==""){
		return count;
	}
	else if(spcountstr.indexOf(",")==-1){
		return parseInt(spcountstr);
	}
	else{
		var spcountarr = spcountstr.split(",");
		for(var i=0;i<spcountarr.length;i++){
			count += parseInt(spcountarr[i]);
		}
		return count;
	}
}
var getShopCarTpyeCount = function(){
	var count = 0;
	var spcountstr = getCookie("spcount");
	if(spcountstr==""){
		return count;
	}
	else if(spcountstr.indexOf(",")==-1){
		return 1;
	}
	else{
		var spcountarr = spcountstr.split(",");
		return spcountarr.length;
	}
}
var removeShopCar = function(){
	delCookie("sp");
	delCookie("dhfs");
	delCookie("spcount");
	refreshHeadDhlCount();
}

function Objsp(sp,sl,dh){
	this.sp=sp;
	this.sl=sl;
	this.dh=dh;
}

var getShopCarSplist = function(){
	var sparr = new Array();
	var spstr = getCookie("sp");
	var countstr = getCookie("spcount");
	var dhstr = getCookie("dhfs");
	if(spstr==""){
		return sparr;
	}
	else if(spstr.indexOf(",")==-1){
		var so = new Objsp(spstr,countstr,dhstr)
		sparr.push(so);
	}
	else{
		tsp = spstr.split(",");
		tcount = countstr.split(",");
		tdh = dhstr.split(",");
		for(var i= 0;i<tsp.length;i++){
			var so = new Objsp(tsp[i],tcount[i],tdh[i]);
			sparr.push(so);
		}
	}
	return sparr;
}
var refreshHeadDhlCount = function(){
	$("#headhdltotal").html(getShopCarTpyeCount());
}

function U2A(val) { 		
	var result = "";
	var code = val.match(/&#(\d+);/g); 
	if (code == null) { 
		return val; 
	}  
	for (var i=0; i<code.length; i++) {
		result += String.fromCharCode(code[i].replace(/[&#;]/g, '')); 
	}
	return result; 
} 
