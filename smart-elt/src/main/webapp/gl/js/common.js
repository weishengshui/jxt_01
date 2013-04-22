
function CheckNumber(v)
{
	if (v.match(/^\d*$/))
		return true;
	else
		return false;
}

function CheckJinE(str)
{
	var checkstr="0123456789.";
	for (var i=0;i<str.length;i++)
	{
		if (checkstr.indexOf(str.substr(i,1))==-1)
		{
			return false;
		}
	}
	if (str.substr(0,1)==".")
		return false;
	return true;
}

function EmailCheck(v)
{
	if (v.match(/^[\w]{1}[\w\.\-_]*@[\w]{1}[\w\-_\.]*\.[\w]{2,4}$/))
		return true;
	else
		return false;
}


function MobileCheck(v)
{
	if (v.match(/^\d{11}$/)==null)
		return false;
		
	var start=v.substring(0,3);
	if (start=="130" || start=="131" || start=="132" || start=="133" || start=="134" || start=="135" || start=="136" || start=="137" || start=="138" || start=="139" || start=="150" || start=="151" || start=="152" || start=="153" || start=="155" || start=="156" || start=="157" || start=="158" || start=="159" || start=="180" || start=="185" || start=="186" || start=="187" || start=="188" || start=="189")
	{
		return true;
	}
	else
		return false;
}

function DnsCheck(v)
{
	
	//if (v.match(/^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$/)==null)
	if (v.match(/^([a-zA-Z0-9][a-zA-Z0-9\-]{2,13}[a-zA-Z0-9])$/)==null)
		return false;
	
}

function UrlCheck(v)
{
	if (v.length<11)
	return false;
	var start=v.substring(0,7);
	if (start.toUpperCase()!="HTTP://")
	return false;
	
}



//判断字符串的长度，汉字长度为2
function checkStrLen(str){
 //var str;
 var Num = 0;
 for (var i=0;i<str.length;i++){
  //str = value.substring(i,i+1);
  //if (str<="~")  //判断是否双字节
  if (str.charCodeAt(i)<=255)
   Num+=1;
  else
   Num+=2;
 }
 return Num;
}


function checkChinese(str)
{
 for (var i=0;i<str.length;i++)
 {  
  
  if (str.charCodeAt(i)<=255)
   {   	
   	return false;
   }
 }
 return true;
}

function YHMCheck(str)
{
	var checkstr="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
	for (var i=0;i<str.length;i++)
	{
		if (checkstr.indexOf(str.substr(i,1))==-1)
		{
			return false;
		}
	}
	return true;
}

function readCookie(name){
	var cookieValue = "";
	var s_search = name + "=";
	if(document.cookie.length > 0){
		offset = document.cookie.indexOf(s_search);
		if (offset != -1){
			offset += s_search.length;
			end = document.cookie.indexOf(";", offset);
			if (end == -1) end = document.cookie.length;
			cookieValue = unescape(document.cookie.substring(offset, end))
		}
	}
	return cookieValue;
}

function writeCookie(name, value, hours){
  var expire = "";
  if(hours != null)  {
    expire = new Date((new Date()).getTime() + hours * 3600000);
    expire = "; expires=" + expire.toGMTString();
  }
  document.cookie = name + "=" + escape(value) + expire ;
}

function sethyday()
{
var y=document.getElementById("hyyear").value;
var m=document.getElementById("hymonth").value;
var d=document.getElementById("hyday").value;
var rd=0;
if (m==1 || m==3 || m==5 || m==7 || m==8 || m==10 || m==12)
rd=31;
if (m==4 || m==6 || m==9 || m==11)
rd=30;
if (m==2)
	if (y % 4==0)
	rd=29;
	else
	rd=28;


	var dlen=document.getElementById("hyday").options.length;
	
	if (dlen!=rd)
	{
		if (dlen<rd)
			for (var i=dlen+1;i<=rd;i++)
			{
				document.getElementById("hyday").add(new Option(i+"日",i));
			}
		else
			for (var i=dlen;i>rd;i--)
			{
				
				document.getElementById("hyday").removeChild(document.getElementById("hyday").options[i-1]);
			}		
	}
}

var xmlHttp;
try
{
	xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
}
catch(e)
{
	try
	{
		xmlHttp= new ActiveXObject("Microsoft.XMLHTTP");
	}
	catch(e)
	{
		try
		{
			xmlHttp = new XMLHttpRequest();
		}
		catch(e) {}
	}
}




 function openLayer(showc)
	 {
		var arrayPageSize   = getPageSize();//调用getPageSize()函数
		var arrayPageScroll = getPageScroll();//调用getPageScroll()函数
		document.getElementById("logdiv").innerHTML=showc;
		document.getElementById("logdiv").style.position = "absolute";
		//document.getElementById("logdiv").style.border = "1px solid #ccc";
		//document.getElementById("logdiv").style.background = "#fff";
		document.getElementById("logdiv").style.zIndex = 99;
		
		document.getElementById("bodybackdiv").style.position = "absolute";
		document.getElementById("bodybackdiv").style.width = "100%";
		document.getElementById("bodybackdiv").style.height = (arrayPageSize[1] + 35 + 'px');
		document.getElementById("bodybackdiv").style.zIndex = 98;
		document.getElementById("bodybackdiv").style.top = 0;
		document.getElementById("bodybackdiv").style.left = 0;
		document.getElementById("bodybackdiv").style.filter = "alpha(opacity=50)";
		document.getElementById("bodybackdiv").style.opacity = 0.5;
		document.getElementById("bodybackdiv").style.background = "#CCCCCC";
		document.getElementById("bodybackdiv").style.display = "";
		document.getElementById("logdiv").style.display = "";
		document.getElementById("logdiv").style.top = arrayPageScroll[1] + (arrayPageSize[3] - document.getElementById("logdiv").offsetHeight) / 2 + 'px';
		document.getElementById("logdiv").style.left = (arrayPageSize[0] - document.getElementById("logdiv").offsetWidth) / 2 -30 + 'px';
	}
	
     //获取滚动条的高度
     function getPageScroll()
	 {
      var yScroll;
      if (self.pageYOffset)
	  {
       yScroll = self.pageYOffset;
      }
	  else if (document.documentElement && document.documentElement.scrollTop)
	  {
       yScroll = document.documentElement.scrollTop;
      }
	   else if (document.body)
	  {
       yScroll = document.body.scrollTop;
      }

      arrayPageScroll = new Array('',yScroll);
      return arrayPageScroll;
     }

     //获取页面实际大小

     function getPageSize()
	 {
      var xScroll,yScroll;
      if (window.innerHeight && window.scrollMaxY)
	  {
       xScroll = document.body.scrollWidth;
       yScroll = window.innerHeight + window.scrollMaxY;
      }
	  else if (document.body.scrollHeight > document.body.offsetHeight)
	  {
       xScroll = document.body.scrollWidth;
       yScroll = document.body.scrollHeight;
      }
	  else
	  {
       xScroll = document.body.offsetWidth;
       yScroll = document.body.offsetHeight;
      }

      var windowWidth,windowHeight;
      //var pageHeight,pageWidth;
      if (self.innerHeight)
	  {
       windowWidth = self.innerWidth;
       windowHeight = self.innerHeight;
      }
	  else if (document.documentElement && document.documentElement.clientHeight)
	  {
       windowWidth = document.documentElement.clientWidth;
       windowHeight = document.documentElement.clientHeight;
      }
	  else if (document.body)
	  {
       windowWidth = document.body.clientWidth;
       windowHeight = document.body.clientHeight;
      }

      var pageWidth,pageHeight;
      if(yScroll < windowHeight)
	  {
       pageHeight = windowHeight;
      }
	  else
	  {
       pageHeight = yScroll;
      }
      if(xScroll < windowWidth)
	  {
       pageWidth = windowWidth;
      }
	  else
	  {
	   pageWidth = xScroll;
      }
      arrayPageSize = new Array(pageWidth,pageHeight,windowWidth,windowHeight);
      return arrayPageSize;
     }

     //关闭弹出层
     function closeLayer()
	 {
      document.getElementById("bodybackdiv").style.display = "none";
      document.getElementById("logdiv").style.display = "none";
	  document.getElementById("logdiv").innerHTML="";
	  globalgourl="";
      return false;
     }
     
     function showjfqcar()
     {
    	 var carstr=readCookie("bwcarp");
    	 if (carstr!=null && carstr.length>0)
    	{
    		 document.getElementById("jfqcar").innerHTML="("+(carstr.split(",").length-1)+")";
    	}
     }
	
function checkimg(v)
{
	v=v.toLowerCase();
	if(v.substring(v.lastIndexOf("."))!=".jpg" && v.substring(v.lastIndexOf("."))!=".gif" )
		return false;
	else
		return true;
}