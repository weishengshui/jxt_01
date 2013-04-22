

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
		document.getElementById("logdiv").style.top = arrayPageScroll[1] + (arrayPageSize[3] - document.getElementById("logdiv").offsetHeight) / 2-50 + 'px';
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
     
   