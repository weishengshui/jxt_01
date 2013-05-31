<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="org.omg.CORBA.INTERNAL"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="jxt.elt.common.Fun"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/style.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/select2css.js"></script>
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/calendar3.js"></script>
	<script type="text/javascript" src="js/jquery-1.9.1.min.js"></script>


<style   type= "text/css ">
.presp   {
height:   2px;
width:   992px;
margin:   0   auto;
background-color:  black;
}

</style> 
<script type="text/javascript">

function cancleit(id)
{
	if (confirm("确认要取消此订单！ "))
	{
		var timeParam = Math.round(new Date().getTime()/1000);
		var url = "getwolist.jsp?did="+id+"&time="+timeParam;			
		xmlHttp.open("GET", url, true);
		xmlHttp.onreadystatechange=showlist;
		xmlHttp.send(null);
	}
}
function showlist()
{
	if (xmlHttp.readyState == 4)
	{
		var response = xmlHttp.responseText;
		try
		{			
			document.getElementById("wolist").innerHTML=response;
		}
		catch(exception){}
	}
}

function showwolist(p)
{
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "getwolist.jsp?pno="+p+"&sddsj="+document.getElementById("sddsj").value+"&eddsj="+document.getElementById("eddsj").value+"&ddzt="+document.getElementById("ddzt").value+"&time="+timeParam;	
	xmlHttp.open("GET", url, true);
	xmlHttp.onreadystatechange=showlist;
	xmlHttp.send(null);
}

$(function(){  
 $("#orderIframe").load(function(){
	// $(this).height(0); 
	//var mainheight = $(this).contents().find("#orderchild").height();
	//$(this).height(mainheight);
  }); 
 $("#ddIframe").load(function(){
	 $(this).height(0); 
	var mainheight = $(this).contents().find("#ddchild").height();
	$(this).height(mainheight);
  }); 
 
});

function ddIframe(){
	$("#ddIframe").height(0); 
	var mainheight = $("#ddIframe").contents().find("#ddchild").height();
	$("#ddIframe").height(mainheight);
	window.location.hash = "#ddIframe"; 
}

</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" />
</head>
<body>
<%
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
Fun fun=new Fun();
ResultSet rs=null;
String strsql="";

try{
	boolean isGly=(session.getAttribute("glqx").toString().indexOf(",12,")!=-1);
%>
	<%@ include file="head.jsp" %>
	<div id="main">
		<div class="main2">
		    <%if (isGly){ %>
			<div class="jifeng-t"><span class="floatleft txtsize14">尊敬的<%=session.getAttribute("qymc")%>，您目前公司账户积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("qyjf")%></em><%if (session.getAttribute("djjf")!=null && !session.getAttribute("djjf").equals("0")) {%>，冻结积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("djjf")%></em><%} %>&nbsp;&nbsp;&nbsp;&nbsp;<a href="buyintegral.jsp">立即充值&gt;&gt;</a></span><span class="jifeng-t-r"></span></div>
			<%} %>
			
			<iframe id="orderIframe" 
			name="contentIframe"
			width="992px"
			frameborder="0"
			marginheight="0"
			marginwidth="0"
			style="margin: 0px; padding: 0px;"
			scrolling="no" 
			src="welfareorderchild.jsp"
		    height="497px"
			>
		</iframe>
	   </div>
	   <div   class= "presp ">  </div> 
	   <div class="main2">
			<iframe id="ddIframe" 
			name="contentIframe"
			width="992px"
			frameborder="0"
			marginheight="0"
			marginwidth="0"
			style="margin: 0px; padding: 0px"
			scrolling="no" 
			src="ddlist.jsp"
		 
			>
		</iframe>
	   </div>
		
	</div>
	<%@ include file="footer.jsp" %>
	<%
	}
	catch(Exception e)
{			
	e.printStackTrace();
}
finally
{
	if (!conn.isClosed())
		conn.close();
}
	 %>
	 
	 
	 
</body>
</html>