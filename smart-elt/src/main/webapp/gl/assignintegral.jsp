<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
request.setCharacterEncoding("UTF-8");
if (session.getAttribute("ffjf")!=null && session.getAttribute("ffjf").equals("1"))
{
	
	out.print("<script type='text/javascript'>");
	out.print("location.href='leaderjf.jsp';");
	out.print("</script>");
	return;
}


if (session.getAttribute("glqx").toString().indexOf(",11,")==-1) 
{
	out.print("<script type='text/javascript'>");
	out.print("location.href='main.jsp';");
	out.print("</script>");
	return;
}

%>
<%SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
 <link href="css/style.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/calendar3.js"></script>
<script type="text/javascript">
	var staffn=0;
	var listn=2;
	var ygbh=0;
	var thisp=1;
	var havejf=0;
	var ifsubmit=1;
	function showmm(id)
	{
		var timeParam = Math.round(new Date().getTime()/1000);
		var url = "selectitem.jsp?mid="+id+"&time="+timeParam;	
		xmlHttp.open("GET", url, true);
		xmlHttp.onreadystatechange=mmshow;
		xmlHttp.send(null);
	}
	function mmshow()
	{
		if (xmlHttp.readyState == 4)
		{
			var response = xmlHttp.responseText;
			try
			{	
				document.getElementById("mm2span").innerHTML="";
				document.getElementById("mm2span").innerHTML=response;
								
			}
			catch(exception){}
		}
	}
	
	function showcc(t,p)
	{
		var timeParam = Math.round(new Date().getTime()/1000);
		if (t==4)
			{
			document.getElementById("xxbchild"+p).innerHTML="";
			document.getElementById("xxchild"+p).innerHTML="";
			document.getElementById("xchild"+p).innerHTML="";			
			document.getElementById("xchild"+p).innerHTML="<h1>发放积分：每人</h1><span class=\"floatleft\">&nbsp;<input type=\"text\" class=\"input7\" name='ojf"+p+"' id='ojf"+p+"' onblur='changetjf("+p+",4)' value='0' />&nbsp;</span> <h1>积分</h1><h2>共 <span class=\"yellowtxt\"  id='tjf"+p+"'>0</span> 积分</h2>";
			}
		if (t==3)
			{				
				document.getElementById("xxbchild"+p).innerHTML="";
				document.getElementById("xxchild"+p).innerHTML="";
				var addDiv = document.createElement("ul");				
				addDiv.setAttribute("id","xxchildc"+p);
				addDiv.setAttribute("className","hjrbox2-l2");
				addDiv.setAttribute("class","hjrbox2-l2");
				document.getElementById("xxchild"+p).appendChild(addDiv);
				var addDiv2=document.createElement("div");
				addDiv2.setAttribute("class","xzxzbox");
				addDiv2.setAttribute("className","xzxzbox");
				addDiv2.innerHTML="<a href=\"javascript:void(0);\" class=\"ygxzbut\" onclick='checkyg("+p+")'></a>";
				document.getElementById("xxchild"+p).appendChild(addDiv2);
				document.getElementById("xchild"+p).innerHTML="";
				thisp=p;
				
				var url = "selectyg.jsp?t=0&time="+timeParam;	
				xmlHttp.open("GET", url, true);
				xmlHttp.onreadystatechange=showcon;
				xmlHttp.send(null);
				
			}
		if (t==1)
			{
				document.getElementById("xxchild"+p).innerHTML="";
				document.getElementById("xxbchild"+p).innerHTML="";
				var addDiv = document.createElement("ul");				
				addDiv.setAttribute("id","xxchildc"+p);
				addDiv.setAttribute("className","hjrbox2-l2");
				addDiv.setAttribute("class","hjrbox2-l2");
				document.getElementById("xxbchild"+p).appendChild(addDiv);
				var addDiv2=document.createElement("div");
				addDiv2.setAttribute("class","xzxzbox");
				addDiv2.setAttribute("className","xzxzbox");
				addDiv2.innerHTML="<a href=\"javascript:void(0);\" onclick='checkbm("+p+")'><img src=\"images/bmxzbut.gif\" /></a><a href=\"department.jsp\" target='_blank' style=\" padding-left:20px;\"><img src=\"images/xzxzbtn.jpg\" /></a>";
				document.getElementById("xxbchild"+p).appendChild(addDiv2);				
				document.getElementById("xchild"+p).innerHTML="";
				thisp=p;
				var url = "selectbms.jsp?time="+timeParam;	
				xmlHttp.open("GET", url, true);
				xmlHttp.onreadystatechange=showcon;
				xmlHttp.send(null);
			}
		if (t==2)
			{
				document.getElementById("xxchild"+p).innerHTML="";
				document.getElementById("xxbchild"+p).innerHTML="<input type='hidden' name='xzid"+p+"' id='xzid"+p+"' />";
				document.getElementById("xchild"+p).innerHTML="";
				thisp=p;
				var url = "selectgroup.jsp?p="+p+"&time="+timeParam;	
				xmlHttp.open("GET", url, true);
				xmlHttp.onreadystatechange=showgroup;
				xmlHttp.send(null);
			}
		
	}
	
	function changeajf()
	{
		var tt=0;
		for (var i=0;i<listn;i++)
		{
			if (document.getElementById("ojf"+i))
			{
				tt=tt+parseInt(document.getElementById("tjf"+i).innerHTML);
				
			}
		}
		document.getElementById("ajf").innerHTML=tt;
		if (tt>havejf)
		{
			document.getElementById("ajfalert").innerHTML="，您的积分余额不足，请 <a href='buyintegral.jsp' class='blue'>购买积分</a> 或者 删除部分发放信息";			
			document.getElementById("aisave").className="tijiao";
			ifsubmit=0;
		}
		else
		{
			document.getElementById("ajfalert").innerHTML="";
			//document.getElementById("aisave").class="submit";
			document.getElementById("aisave").className="submit";
			ifsubmit=1;
		}
			
	}
	
	function checkbm(p)
	{
		thisp=p;
		var timeParam = Math.round(new Date().getTime()/1000);
		var url = "selectbms.jsp?time="+timeParam;	
		xmlHttp.open("GET", url, true);
		xmlHttp.onreadystatechange=showcon;
		xmlHttp.send(null);
	}
	function checkyg(p)
	{
		thisp=p;
		var timeParam = Math.round(new Date().getTime()/1000);
		var url = "selectyg.jsp?t=0&time="+timeParam;	
		xmlHttp.open("GET", url, true);
		xmlHttp.onreadystatechange=showcon;
		xmlHttp.send(null);
	}
	
	function changetjf(p,t)
	{
		if (!CheckNumber(document.getElementById("ojf"+p).value))
		{
			alert("积分数格式不对！");
			return;
		}
		if (document.getElementById("ojf"+p).value=="")
		{
			document.getElementById("ojf"+p).value="0";
		}
		if (t==4)
			document.getElementById("tjf"+p).innerHTML=parseInt(staffn)*parseInt(document.getElementById("ojf"+p).value);
		if (t==3)
			{
			var n=document.getElementsByName("ygid"+p).length;	
			document.getElementById("tjf"+p).innerHTML=parseInt(n)*parseInt(document.getElementById("ojf"+p).value);
			}
		if (t==1)
			{
			var n=document.getElementsByName("bmid"+p).length;	
			document.getElementById("tjf"+p).innerHTML=parseInt(n)*parseInt(document.getElementById("ojf"+p).value);
			}
		if (t==2)
			{
			var n=document.getElementsByName("xz"+p).length;
			var sn=0;
			var xzstr="";
			for (i=0;i<n;i++)
			{
				if (document.getElementsByName("xz"+p)[i].checked)
				{
					xzstr=xzstr+document.getElementsByName("xz"+p)[i].value+",";
					sn++;}
			}
			
			document.getElementById("xzid"+p).value=xzstr;
			document.getElementById("tjf"+p).innerHTML=parseInt(sn)*parseInt(document.getElementById("ojf"+p).value);
			}
		changeajf();
			
	}
	
	function showcon()
	{
		if (xmlHttp.readyState == 4)
		{
			var response = xmlHttp.responseText;
			try
			{
				openLayer(response);
			}
			catch(exception){}
		}
	}
	
	function showgroup()
	{
		if (xmlHttp.readyState == 4)
		{
			var response = xmlHttp.responseText;
			try
			{
				document.getElementById("xxbchild"+thisp).innerHTML=document.getElementById("xxbchild"+thisp).innerHTML+response+"<div class=\"xzxzbox\"><a href=\"group.jsp\" target='_blank'><img src=\"images/tjxmzbtn.jpg\" /></a></div>";
				document.getElementById("xchild"+thisp).innerHTML="<h1>发放积分：每小组</h1><span class=\"floatleft\">&nbsp;<input type=\"text\" class=\"input7\" name='ojf"+thisp+"' id='ojf"+thisp+"' onblur='changetjf("+thisp+",2)' value='0' />&nbsp;</span> <h1>积分</h1><h2>共 <span class=\"yellowtxt\"  id='tjf"+thisp+"'>0</span> 积分</h2>";
		
			}
			catch(exception){}
		}
	}
	
	function selectedbm()
	{
		var n=document.getElementsByName("bm").length;	
		var nowcon=document.getElementById("xxchildc"+thisp).innerHTML;
		var isadd=1;
		for (i=0;i<n;i++)
		{
			isadd=1;
			if (document.getElementsByName("bm")[i].checked)
			{
				for (j=0;j<document.getElementsByName("bmid"+thisp).length;j++)
				{
					if (document.getElementsByName("bmid"+thisp)[j].value==document.getElementsByName("bm")[i].value)
					{
						isadd=0;
						break;
					}
				}				
				if (isadd==1)
				{
				var addDiv = document.createElement("li");				
				addDiv.setAttribute("id","bm"+ygbh);
				addDiv.innerHTML="<input type='hidden' name='bmid"+thisp+"' id='bmid"+thisp+"' value='"+document.getElementsByName("bm")[i].value+"' />"+document.getElementsByName("bm")[i].title+"<span onclick=\"delbm("+ygbh+","+thisp+")\">&times;</span>";
				document.getElementById("xxchildc"+thisp).appendChild(addDiv);
				ygbh++;	
				}				
			}
		}
		closeLayer();
		if (document.getElementById("xchild"+thisp).innerHTML!="")
			changetjf(thisp,1);
		else
		document.getElementById("xchild"+thisp).innerHTML="<h1>发放积分：每部门</h1><span class=\"floatleft\">&nbsp;<input type=\"text\" class=\"input7\" name='ojf"+thisp+"' id='ojf"+thisp+"' onblur='changetjf("+thisp+",1)' value='0' />&nbsp;</span> <h1>积分</h1><h2>共 <span class=\"yellowtxt\"  id='tjf"+thisp+"'>0</span> 积分</h2>";
			
	}
	
	function selectedyg(t)
	{
		var n=document.getElementsByName("yg").length;
		var nowcon=document.getElementById("xxchildc"+thisp).innerHTML;
		var isadd=1;
		for (i=0;i<n;i++)
		{
			isadd=1;
			if (document.getElementsByName("yg")[i].checked)
			{
				
				for (j=0;j<document.getElementsByName("ygid"+thisp).length;j++)
				{
					if (document.getElementsByName("ygid"+thisp)[j].value==document.getElementsByName("yg")[i].value)
					{
						isadd=0;
						break;
					}
				}				
				if (isadd==1)
				{
					var addDiv = document.createElement("li");		
					addDiv.setAttribute("id","yg"+ygbh);
					addDiv.innerHTML="<input type='hidden' name='ygid"+thisp+"' id='ygid"+thisp+"' value='"+document.getElementsByName("yg")[i].value+"' />"+document.getElementsByName("yg")[i].title+"<span onclick=\"delyg("+ygbh+","+thisp+")\">&times;</span>";
					document.getElementById("xxchildc"+thisp).appendChild(addDiv);
					ygbh++;	
				}
			}
		}
		closeLayer();
		
		if (document.getElementById("xchild"+thisp).innerHTML!="")
			changetjf(thisp,3);
		else
			document.getElementById("xchild"+thisp).innerHTML="<h1>发放积分：每人</h1><span class=\"floatleft\">&nbsp;<input type=\"text\" class=\"input7\" name='ojf"+thisp+"' id='ojf"+thisp+"' onblur='changetjf("+thisp+",3)' value='0' />&nbsp;</span> <h1>积分</h1><h2>共 <span class=\"yellowtxt\"  id='tjf"+thisp+"'>0</span> 积分</h2>";
			
	}
	
	function delbm(tp,p)
	{
		var removeLi=document.getElementById("bm"+tp);		
		document.getElementById("xxchildc"+p).removeChild(removeLi);
		var n=document.getElementsByName("bmid"+p).length;	
		document.getElementById("tjf"+p).innerHTML=parseInt(n)*parseInt(document.getElementById("ojf"+p).value);
		changeajf();
	}
	function delyg(tp,p)
	{
		var removeLi=document.getElementById("yg"+tp);		
		document.getElementById("xxchildc"+p).removeChild(removeLi);
		var n=document.getElementsByName("ygid"+p).length;	
		document.getElementById("tjf"+p).innerHTML=parseInt(n)*parseInt(document.getElementById("ojf"+p).value);
		changeajf();
	}
	function additem()
	{
		var addDiv = document.createElement("div");
		addDiv.setAttribute("id","xlist"+listn);		
		addDiv.innerHTML="<div class=\"hjrwrap\"><div class=\"hjrbox\"><div class=\"hjrbox1\">发放对象：[可选择全体员工或个别指定的员工进行积分发放]</div><div class=\"hjrbox2\"><h1><input type=\"radio\" name=\"fflx"+listn+"\" id=\"fflx"+listn+"\" value=\"4\"  onclick=\"showcc(4,"+listn+")\"/></h1><h2>全体员工</h2><h1><input type=\"radio\" name=\"fflx"+listn+"\" id=\"fflx"+listn+"\" value=\"3\" onclick=\"showcc(3,"+listn+")\"/></h1><h2>个别员工</h2></div><div class=\"hjrbox3\"  id=\"xxchild"+listn+"\"></div></div><div class=\"hjrbox\"><div class=\"hjrbox1\">发放授权：[用于发放给部门或项目组，由其对内部成员进行积分发放]</div><div class=\"hjrbox2\"><h1><input type=\"radio\" name=\"fflx"+listn+"\" id=\"fflx"+listn+"\" value=\"1\" onclick=\"showcc(1,"+listn+")\" /></h1><h2>部门</h2><h1><input type=\"radio\" name=\"fflx"+listn+"\" id=\"fflx"+listn+"\" value=\"2\"  onclick=\"showcc(2,"+listn+")\" /></h1><h2>项目组</h2></div><div class=\"hjrbox3\"  id=\"xxbchild"+listn+"\"></div></div><div class=\"hjrbox4\" id=\"xchild"+listn+"\"></div></div><a href=\"javascript:void(0);\" class=\"deltxt\" onclick=\"delitem("+listn+")\">&times;删除</a><div class=\"clear\"></div>";
		document.getElementById("xxlist").appendChild(addDiv);
		listn++;
	}
	function delitem(id)
	{
		var removeLi=document.getElementById("xlist"+id);		
		document.getElementById("xxlist").removeChild(removeLi);
		changeajf();
	}
	function saveit()
	{
		if (ifsubmit==1)
		{
			if (document.getElementById("mm1").value=="")
			{
				alert("请选择发放名目！");
				return;
			}
			if (document.getElementById("mm2"))
			{
				if (document.getElementById("mm2").value=="")
				{
					alert("请选择子名目！");
					return;
				}
			}
			if (document.getElementById("ajf").innerHTML=="0")
			{
				alert("请设置发放积分！");
				return;
			}
			if (document.getElementById("bz").value=="您可以在这里输入发放的备注内容,比如[ELT项目最佳完成奖]")
				document.getElementById("bz").value="";
			
			for (var i=0;i<listn;i++)
			{
				if (document.getElementById("xzid"+i))
				{
					if (document.getElementById("xzid"+i).value=="")
					{
						alert("请选择要发放积分的项目组！");
						return;
					}					
				}
			}			
			
			for (var i=0;i<listn;i++)
			{
				if (document.getElementById("ojf"+i))
				{
					if (parseInt(document.getElementById("tjf"+i).innerHTML)==0)
					{
						alert("发放积分不能为零！");
						return;
					}					
				}
			}
			
			
			var nffsj=document.getElementById("ffsj").value.replace("-","/");
			var nsj="<%=sf.format(Calendar.getInstance().getTime())%>";
			nsj=nsj.replace("-","/");
			if (Date.parse(nffsj)<Date.parse(nsj))
			{
				alert("发放日期不能小于当前日期！");
				return;
			}
			document.getElementById("listn").value=listn;
			document.getElementById("aiform").submit();
		}
	}
	
	function showlist()
	{
		if (xmlHttp.readyState == 4)
		{
			var response = xmlHttp.responseText;
			try
			{			
				document.getElementById("ailist").innerHTML=response;
			}
			catch(exception){}
		}
	}

	function showailist(p)
	{
		var timeParam = Math.round(new Date().getTime()/1000);
		var url = "getailist.jsp?pno="+p+"&ffzt="+document.getElementById("ffzt").value+"&sffsj="+document.getElementById("sffsj").value+"&effsj="+document.getElementById("effsj").value+"&ssrsj="+document.getElementById("ssrsj").value+"&esrsj="+document.getElementById("esrsj").value+"&time="+timeParam;	
		
		xmlHttp.open("GET", url, true);
		xmlHttp.onreadystatechange=showlist;
		xmlHttp.send(null);
	}
	
	function Cancleff(id)
	{
		if (confirm("确认要取消此发放"))
		{
			var timeParam = Math.round(new Date().getTime()/1000);
			var url = "getailist.jsp?ffid="+id+"&time="+timeParam;		
			xmlHttp.open("GET", url, true);
			xmlHttp.onreadystatechange=showlist;
			xmlHttp.send(null);
		}
	}
	
	
	function sygagain(p,t)
	{
		var timeParam = Math.round(new Date().getTime()/1000);
		var url = "getyglist.jsp?t="+t+"&pno="+p+"&dsygxm="+encodeURI(escape(document.getElementById("dsygxm").value))+"&dsbm="+document.getElementById("dsbm").value+"&dsemail="+encodeURI(escape(document.getElementById("dsemail").value))+"&time="+timeParam;		
		
		xmlHttp.open("GET", url, true);
		xmlHttp.onreadystatechange=showyglist;
		xmlHttp.send(null);
	}
	
	function showyglist()
	{
		if (xmlHttp.readyState == 4)
		{
			var response = xmlHttp.responseText;
			try
			{			
				document.getElementById("dyglist").innerHTML=response;
			}
			catch(exception){}
		}
	}
	
	function allselyg()
	{
		var n=document.getElementsByName("yg").length;
		
		if (document.getElementById("sygsa").checked)
		{
			for (var i=0;i<n;i++)
			{
				if (!document.getElementsByName("yg")[i].checked)
					document.getElementsByName("yg")[i].checked=true;
			}
		}
		else
		{
			for (var i=0;i<n;i++)
			{
				if (document.getElementsByName("yg")[i].checked)
					document.getElementsByName("yg")[i].checked=false;
			}
		}
	}
	
	function addmm()
	{
		if (document.getElementById("mmmcadd").value=="")
		{
			alert("请填写要自定义的名目!");
			return;
		}
		var timeParam = Math.round(new Date().getTime()/1000);
		var url = "itemsave.jsp?mmmc="+encodeURI(escape(document.getElementById("mmmcadd").value))+"&time="+timeParam;
		
		xmlHttp.open("GET", url, true);
		xmlHttp.onreadystatechange=newmm;
		xmlHttp.send(null);
	}
	
	function newmm()
	{
		if (xmlHttp.readyState == 4)
		{
			var response = xmlHttp.responseText;
			try
			{
				response=response.replace(new RegExp("","g"),"");			    
				if (response=="")
				{				
					alert("添加出错！");
					return;
				}
				
				if (response=="0")
				{
					alert("此名目已经存在，请不要重复添加！");
					return;
				}
				document.getElementById("mm1span").innerHTML=response;
				document.getElementById("mm2span").innerHTML="";
				document.getElementById("mmmcadd").value="";
			}
			catch(exception){}
		}
	}
	
	function fiton(obj)
  {
     if (obj!=null){
			var subName=obj.id.substr(3);
			document.getElementById('D'+subName).style.display='';   
			obj.style.display='none';
			//document.getElementById('simg'+subName).style.display='none';
			document.getElementById('on'+subName).style.display='';
			//document.getElementById('oimg'+subName).style.display='';
	 }
  }
function fitoff(obj)
  {
     if (obj!=null){
			var subName=obj.id.substr(2);
			document.getElementById('D'+subName).style.display='none';   
			obj.style.display='none';
			//document.getElementById('oimg'+subName).style.display='none'
			document.getElementById('off'+subName).style.display='';
			//document.getElementById('simg'+subName).style.display='';
     }
  }

function fitm(obj)
   {
      if (obj!=null){
			var subName=obj.id.substr(1);
			if (document.getElementById('D'+subName).style.display=='none')
			   {
			    document.getElementById('D'+subName).style.display='block';
			    document.getElementById('on'+subName).style.display='block';
			    //document.getElementById('oimg'+subName).style.display='block'
			    document.getElementById('off'+subName).style.display='none';
			    //document.getElementById('simg'+subName).style.display='none'	   
			    }
			else
			   {
			    //document.getElementById('oimg'+subName).style.display='none';
			    document.getElementById('D'+subName).style.display='none';
			    document.getElementById('off'+subName).style.display='block';
			    document.getElementById('on'+subName).style.display='none';
			    //document.getElementById('simg'+subName).style.display='block'
			    }
		}
   }
	
</script> 
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>

<body>
<div id="bodybackdiv" style="display:none"></div>
<div id="logdiv" style="display:none"></div>
<%
menun=3;
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
int staffn=0;

int listn=0;
int ygbh=0;
int tjf=0;
String mm1=request.getParameter("mm1");
String mm2=request.getParameter("mm2");
String ffsj=request.getParameter("ffsj");
String bz=request.getParameter("bz");
String sendfflx=request.getParameter("sendfflx");
String sendojfs=request.getParameter("sendojfs");
String sendvalue=request.getParameter("sendvalue");

try
{
	strsql="select count(nid) as hn from tbl_qyyg where qy="+session.getAttribute("qy")+" and xtzt<>3  and zt=1";
	rs=stmt.executeQuery(strsql);
	if (rs.next())
		{
			staffn=rs.getInt("hn");
		}
	rs.close();
 %>
	<%@ include file="head.jsp" %>
	<div id="main">
	  	<div class="main2">
  		  <div class="box">
				<ul class="local">
					<li class="local-ico2">
						<div class="local3-1"><h1>填写发放积分信息</h1><h2><%=sf.format(Calendar.getInstance().getTime())%></h2></div>
					</li>
					<li class="local-ico3">
						<div class="local3-2"><h1>确认发放信息</h1></div>
					</li>
					<li>
						<div class="local3-3"><h1>确认发放 </h1></div>
					</li>
				</ul>
				<div class="gsjf-states">尊敬的<%=session.getAttribute("qymc")%>，您目前公司账户积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("qyjf")%></em><%if (session.getAttribute("djjf")!=null && !session.getAttribute("djjf").equals("0")) {%>，冻结积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("djjf")%></em><%} %></div>
				<form action="aiconfirm.jsp" name="aiform" id="aiform" method="post">
				<input type="hidden" name="listn" id="listn"/>
				<div class="hjr-ffmm" style="border-bottom:1px #cccccc dashed; padding-bottom:8px">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="90" height="30" class="tdtitle"><span class="star">*</span> 发放名目</td>
							<td width="350"><span id="mm1span">
								<select name="mm1" id="mm1" onchange="showmm(this.value)" style="height: 30px;"><option value="">请选择</option>
									<%
									strsql="select nid,mmmc from tbl_jfmm where (qy="+session.getAttribute("qy")+" or qy=0) and fmm=0";
							  		rs=stmt.executeQuery(strsql);
							  		while (rs.next())
							  		{
							  			if (mm1!=null && mm1.equals(rs.getString("nid")))
							  				out.print("<option value='"+rs.getString("nid")+"' selected='selected'>"+rs.getString("mmmc")+"</option>");
							  			else
							  				out.print("<option value='"+rs.getString("nid")+"'>"+rs.getString("mmmc")+"</option>");
							  		}
							  		rs.close();
									%>
								</select>&nbsp;<span style="font-size: 20px;" title="可在”账户设置“栏目中的”发放名目管理“项进行设置">？</span></span><span id="mm2span">
								<%
								if (mm2!=null && !mm2.equals("0") && !mm2.equals(""))
								{
									out.print("<select name=\"mm2\" id=\"mm2\" style=\"height: 30px;\"><option value=\"\">请选择</option>");
									strsql="select nid,mmmc from tbl_jfmm where (qy="+session.getAttribute("qy")+" or qy=0) and fmm="+mm1;
							  		rs=stmt.executeQuery(strsql);
							  		while (rs.next())
							  		{
							  			if (mm2!=null && mm2.equals(rs.getString("nid")))
							  				out.print("<option value='"+rs.getString("nid")+"' selected='selected'>"+rs.getString("mmmc")+"</option>");
							  			else
							  				out.print("<option value='"+rs.getString("nid")+"'>"+rs.getString("mmmc")+"</option>");
							  		}
							  		rs.close();
							  		out.print("</select>");
								}
								%>
								</span></td>
							<td width="163">没有适合的名目?新增</td>
							<td width="114"><span class="floatleft">
							  <input name="mmmcadd" id="mmmcadd" type="text" class="input7"  maxlength="25" style="margin-top:0; width:90px"/>
							</span></td>
							<td><div class="floatleft"><span onclick="addmm()" class="caxun" style="margin:3px;">保 存</span></div></td>
					  </tr>
					</table>
				</div>
				<div class="hjr-ffxx-t">
					<div class="hjr-ffxx-tl"><span class="star">*</span> 发放信息</div>
					<span><a href="javascript:void(0);" class="addffxx" onclick="additem()"></a></span>					
				</div>
				<div id="xxlist">	
				<%
				if (ffsj!=null && ffsj.length()>0)
				{
					String[] fflx=sendfflx.split(";");
					String[] ojfs=sendojfs.split(";");
					String[] lxvalue=sendvalue.split(";");
					
					String jfffxx="";
					int ldbh=0;
					
					
					for (int i=0;i<fflx.length;i++)
					{
					
						if (fflx[i].equals("1"))
						{
							
							String[] bmarr=lxvalue[i].split(",");									
							out.print("<div class=\"delbox\" id=\"xlist"+i+"\">");
							out.print("<div class=\"hjrwrap\">");
							out.print("<div class=\"hjrbox\">");
							out.print("<div class=\"hjrbox1\">发放对象：[可选择全体员工或个别指定的员工进行积分发放]</div>");
							out.print("<div class=\"hjrbox2\"><h1><input type=\"radio\" name=\"fflx"+i+"\" id=\"fflx"+i+"\" value=\"4\"  onclick=\"showcc(4,"+i+")\"/></h1><h2>全体员工</h2><h1><input type=\"radio\" name=\"fflx"+i+"\" id=\"fflx"+i+"\" value=\"3\" onclick=\"showcc(3,"+i+")\"/></h1><h2>个别员工</h2></div>");
							out.print("<div class=\"hjrbox3\"  id=\"xxchild"+i+"\"></div>");
							out.print("</div>");
							out.print("<div class=\"hjrbox\">");
							out.print("<div class=\"hjrbox1\">发放授权：[用于发放给部门或项目组，由其对内部成员进行积分发放]</div>");
							out.print("<div class=\"hjrbox2\"><h1><input type=\"radio\" name=\"fflx"+i+"\" id=\"fflx"+i+"\" value=\"1\" onclick=\"showcc(1,"+i+")\" checked='checked' /></h1><h2>部门</h2><h1><input type=\"radio\" name=\"fflx"+i+"\" id=\"fflx"+i+"\" value=\"2\"  onclick=\"showcc(2,"+i+")\" /></h1><h2>项目组</h2></div>");
							out.print("<div class=\"hjrbox3\"  id=\"xxbchild"+i+"\">");
							
							out.print("<ul id=\"xxchildc"+i+"\" class=\"hjrbox2-l2\">");
							strsql="select nid,bmmc from tbl_qybm where nid in ("+lxvalue[i]+")";
							rs=stmt.executeQuery(strsql);
							while(rs.next())
							{
								out.print("<li id=\"bm"+ygbh+"\"><input type='hidden' name='bmid"+i+"' id='bmid"+i+"' value='"+rs.getString("nid")+"' />"+rs.getString("bmmc")+"<span onclick=\"delbm("+ygbh+","+i+")\">&times;</span></li>");									
								ygbh++;
							}
							rs.close();
							out.print("</ul>");
							out.print("<div class=\"xzxzbox\"><a href=\"javascript:void(0);\" onclick='checkbm("+i+")'><img src=\"images/bmxzbut.gif\" /></a><a href=\"department.jsp\" target='_blank' style=\" padding-left:20px;\"><img src=\"images/xzxzbtn.jpg\" /></a></div>");
							
							
							out.print("</div>	");						
							out.print("</div>");
							out.print("<div class=\"hjrbox4\" id=\"xchild"+i+"\">");
							out.print("<h1>发放积分：每部门</h1><span class=\"floatleft\">&nbsp;<input type=\"text\" class=\"input7\" name='ojf"+i+"' id='ojf"+i+"' onblur='changetjf("+i+",1)' value='"+ojfs[i]+"' />&nbsp;</span> <h1>积分</h1><h2>共 <span class=\"yellowtxt\"  id='tjf"+i+"'>"+String.valueOf(Integer.valueOf(ojfs[i])*bmarr.length)+"</span> 积分</h2>");
							out.print("</div>");										
							out.print("</div>");
							out.print("<a href=\"javascript:void(0);\" class=\"deltxt\" onclick=\"delitem("+i+")\">&times;删除</a>");
							out.print("<div class=\"clear\"></div>");
							out.print("</div>");	
							
							tjf=tjf+Integer.valueOf(ojfs[i])*bmarr.length;
						}
						
						if (fflx[i].equals("2"))
						{
							String[] xzarr=lxvalue[i].split(",");
							out.print("<div class=\"delbox\" id=\"xlist"+i+"\">");
							out.print("<div class=\"hjrwrap\">");
							out.print("<div class=\"hjrbox\">");
							out.print("<div class=\"hjrbox1\">发放对象：[可选择全体员工或个别指定的员工进行积分发放]</div>");
							out.print("<div class=\"hjrbox2\"><h1><input type=\"radio\" name=\"fflx"+i+"\" id=\"fflx"+i+"\" value=\"4\"  onclick=\"showcc(4,"+i+")\"/></h1><h2>全体员工</h2><h1><input type=\"radio\" name=\"fflx"+i+"\" id=\"fflx"+i+"\" value=\"3\" onclick=\"showcc(3,"+i+")\"/></h1><h2>个别员工</h2></div>");
							out.print("<div class=\"hjrbox3\"  id=\"xxchild"+i+"\"></div>");
							out.print("</div>");
							out.print("<div class=\"hjrbox\">");
							out.print("<div class=\"hjrbox1\">发放授权：[用于发放给部门或项目组，由其对内部成员进行积分发放]</div>");
							out.print("<div class=\"hjrbox2\"><h1><input type=\"radio\" name=\"fflx"+i+"\" id=\"fflx"+i+"\" value=\"1\" onclick=\"showcc(1,"+i+")\" /></h1><h2>部门</h2><h1><input type=\"radio\" name=\"fflx"+i+"\" id=\"fflx"+i+"\" value=\"2\"  onclick=\"showcc(2,"+i+")\"  checked='checked' /></h1><h2>项目组</h2></div>");
							out.print("<div class=\"hjrbox3\"  id=\"xxbchild"+i+"\">");								
							out.print("<input type='hidden' name='xzid"+i+"' id='xzid"+i+"' value='"+lxvalue[i]+",' />");
							out.print("<ul class='hjrbox2-l'>");
							strsql="select nid,xzmc from tbl_qyxz where qy="+session.getAttribute("qy");
							rs=stmt.executeQuery(strsql);
							while (rs.next())
							{
								out.print("<li><h1><input type=\"checkbox\" name=\"xz"+i+"\" id=\"xz"+i+"\" onclick=\"changetjf("+i+",2)\" value=\""+rs.getInt("nid")+"\" title=\""+rs.getString("xzmc")+"\"" );
								if ((","+lxvalue[i]+",").indexOf(","+rs.getString("nid")+",")>-1)
									out.print(" checked='checked' ");
								out.print(" /></h1><h2>"+rs.getString("xzmc")+"</h2></li>");
							}								
							rs.close();								
							out.print("</ul>");
							out.print("<div class=\"xzxzbox\"><a href=\"group.jsp\" target='_blank'><img src=\"images/tjxmzbtn.jpg\" /></a></div>");								
							
							out.print("</div>	");						
							out.print("</div>");
							out.print("<div class=\"hjrbox4\" id=\"xchild"+i+"\">");
							out.print("<h1>发放积分：每小组</h1><span class=\"floatleft\">&nbsp;<input type=\"text\" class=\"input7\" name='ojf"+i+"' id='ojf"+i+"' onblur='changetjf("+i+",2)' value='"+ojfs[i]+"' />&nbsp;</span> <h1>积分</h1><h2>共 <span class=\"yellowtxt\"  id='tjf"+i+"'>"+String.valueOf(Integer.valueOf(ojfs[i])*xzarr.length)+"</span> 积分</h2>");						
							out.print("</div>");										
							out.print("</div>");
							out.print("<a href=\"javascript:void(0);\" class=\"deltxt\" onclick=\"delitem("+i+")\">&times;删除</a>");
							out.print("<div class=\"clear\"></div>");
							out.print("</div>");	
													
							tjf=tjf+Integer.valueOf(ojfs[i])*xzarr.length;
						}
						
						if (fflx[i].equals("3"))
						{
							String[] ygarr=lxvalue[i].split(",");
							out.print("<div class=\"delbox\" id=\"xlist"+i+"\">");
							out.print("<div class=\"hjrwrap\">");
							out.print("<div class=\"hjrbox\">");
							out.print("<div class=\"hjrbox1\">发放对象：[可选择全体员工或个别指定的员工进行积分发放]</div>");
							out.print("<div class=\"hjrbox2\"><h1><input type=\"radio\" name=\"fflx"+i+"\" id=\"fflx"+i+"\" value=\"4\"  onclick=\"showcc(4,"+i+")\"/></h1><h2>全体员工</h2><h1><input type=\"radio\" name=\"fflx"+i+"\" id=\"fflx"+i+"\" value=\"3\" onclick=\"showcc(3,"+i+")\"  checked='checked' /></h1><h2>个别员工</h2></div>");
							out.print("<div class=\"hjrbox3\"  id=\"xxchild"+i+"\">");								

							out.print("<ul id=\"xxchildc"+i+"\" class=\"hjrbox2-l2\">");
							strsql="select nid,ygxm from tbl_qyyg where nid in ("+lxvalue[i]+")";
							rs=stmt.executeQuery(strsql);
							while(rs.next())
							{
								out.print("<li id=\"yg"+ygbh+"\"><input type='hidden' name='ygid"+i+"' id='ygid"+i+"' value='"+rs.getString("nid")+"' />"+rs.getString("ygxm")+"<span onclick=\"delyg("+ygbh+","+i+")\">&times;</span></li>");									
								ygbh++;
							}
							rs.close();
							out.print("</ul>");
							out.print("<div class=\"xzxzbox\"><a href=\"javascript:void(0);\" class=\"ygxzbut\" onclick='checkyg("+i+")'></a></div>");
							
							out.print("</div>");
							out.print("</div>");
							out.print("<div class=\"hjrbox\">");
							out.print("<div class=\"hjrbox1\">发放授权：[用于发放给部门或项目组，由其对内部成员进行积分发放]</div>");
							out.print("<div class=\"hjrbox2\"><h1><input type=\"radio\" name=\"fflx"+i+"\" id=\"fflx"+i+"\" value=\"1\" onclick=\"showcc(1,"+i+")\" /></h1><h2>部门</h2><h1><input type=\"radio\" name=\"fflx"+i+"\" id=\"fflx"+i+"\" value=\"2\"  onclick=\"showcc(2,"+i+")\" /></h1><h2>项目组</h2></div>");
							out.print("<div class=\"hjrbox3\"  id=\"xxbchild"+i+"\">");								
							out.print("</div>	");						
							out.print("</div>");
							out.print("<div class=\"hjrbox4\" id=\"xchild"+i+"\">");								
							out.print("<h1>发放积分：每人</h1><span class=\"floatleft\">&nbsp;<input type=\"text\" class=\"input7\" name='ojf"+i+"' id='ojf"+i+"' onblur='changetjf("+i+",3)' value='"+ojfs[i]+"' />&nbsp;</span> <h1>积分</h1><h2>共 <span class=\"yellowtxt\"  id='tjf"+i+"'>"+String.valueOf(Integer.valueOf(ojfs[i])*ygarr.length)+"</span> 积分</h2>");
							out.print("</div>");										
							out.print("</div>");
							out.print("<a href=\"javascript:void(0);\" class=\"deltxt\" onclick=\"delitem("+i+")\">&times;删除</a>");
							out.print("<div class=\"clear\"></div>");
							out.print("</div>");								
							tjf=tjf+Integer.valueOf(ojfs[i])*ygarr.length;
						}
						if (fflx[i].equals("4"))
						{
							out.print("<div class=\"delbox\" id=\"xlist"+i+"\">");
							out.print("<div class=\"hjrwrap\">");
							out.print("<div class=\"hjrbox\">");
							out.print("<div class=\"hjrbox1\">发放对象：[可选择全体员工或个别指定的员工进行积分发放]</div>");
							out.print("<div class=\"hjrbox2\"><h1><input type=\"radio\" name=\"fflx"+i+"\" id=\"fflx"+i+"\" value=\"4\"  onclick=\"showcc(4,"+i+")\"  checked='checked' /></h1><h2>全体员工</h2><h1><input type=\"radio\" name=\"fflx"+i+"\" id=\"fflx"+i+"\" value=\"3\" onclick=\"showcc(3,"+i+")\"/></h1><h2>个别员工</h2></div>");
							out.print("<div class=\"hjrbox3\"  id=\"xxchild"+i+"\">");								

							out.print("</div>");
							out.print("</div>");
							out.print("<div class=\"hjrbox\">");
							out.print("<div class=\"hjrbox1\">发放授权：[用于发放给部门或项目组，由其对内部成员进行积分发放]</div>");
							out.print("<div class=\"hjrbox2\"><h1><input type=\"radio\" name=\"fflx"+i+"\" id=\"fflx"+i+"\" value=\"1\" onclick=\"showcc(1,"+i+")\" /></h1><h2>部门</h2><h1><input type=\"radio\" name=\"fflx"+i+"\" id=\"fflx"+i+"\" value=\"2\"  onclick=\"showcc(2,"+i+")\" /></h1><h2>项目组</h2></div>");
							out.print("<div class=\"hjrbox3\"  id=\"xxbchild"+i+"\">");								
							out.print("</div>	");						
							out.print("</div>");
							out.print("<div class=\"hjrbox4\" id=\"xchild"+i+"\">");								
							out.print("<h1>发放积分：每人</h1><span class=\"floatleft\">&nbsp;<input type=\"text\" class=\"input7\" name='ojf"+i+"' id='ojf"+i+"' onblur='changetjf("+i+",4)' value='"+ojfs[i]+"' />&nbsp;</span> <h1>积分</h1><h2>共 <span class=\"yellowtxt\"  id='tjf"+i+"'>"+String.valueOf(Integer.valueOf(ojfs[i])*staffn)+"</span> 积分</h2>");								
							out.print("</div>");										
							out.print("</div>");
							out.print("<a href=\"javascript:void(0);\" class=\"deltxt\" onclick=\"delitem("+i+")\">&times;删除</a>");
							out.print("<div class=\"clear\"></div>");
							out.print("</div>");	
							
							tjf=tjf+Integer.valueOf(ojfs[i])*staffn;
						}
						listn=i+1;						
					}
				}
				else
				{
				%>
								
					<div class="delbox" id="xlist1">
						<div class="hjrwrap">
							<div class="hjrbox">
								<div class="hjrbox1">发放对象：[可选择全体员工或个别指定的员工进行积分发放]</div>
						  		<div class="hjrbox2"><h1><input type="radio" name="fflx1" id="fflx1" value="4"  onclick="showcc(4,1)"/></h1><h2>全体员工</h2><h1><input type="radio" name="fflx1" id="fflx1" value="3" onclick="showcc(3,1)"/></h1><h2>个别员工</h2></div>
								<div class="hjrbox3"  id="xxchild1"></div>
							</div>
							
							<div class="hjrbox">
								<div class="hjrbox1">发放授权：[用于发放给部门或项目组，由其对内部成员进行积分发放]</div>
						  		<div class="hjrbox2"><h1><input type="radio" name="fflx1" id="fflx1" value="1" onclick="showcc(1,1)" /></h1><h2>部门</h2><h1><input type="radio" name="fflx1" id="fflx1" value="2"  onclick="showcc(2,1)" /></h1><h2>项目组</h2></div>
								<div class="hjrbox3"  id="xxbchild1">
								</div>							
							</div>
							<div class="hjrbox4" id="xchild1"></div>										
						</div>
						<a href="javascript:void(0);" class="deltxt" onclick="delitem(1)">&times;删除</a>
						<div class="clear"></div>
					</div>
				<%} %>
				</div>
				
				
				
				<div class="hjr-tishi" style="border-bottom:1px #cccccc dashed; padding-bottom:8px;">您选择发放积分总额  <span class="yellowtxt" id="ajf"><%=tjf%></span> 积分<span style="font-size:14px;" id="ajfalert"></span></div>
				<div class="hjr-box1" style="border-bottom:1px #cccccc dashed; padding-bottom:8px">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td width="20" height="30"><span class="star">*</span></td>
						<td width="70" class="tdtitle">发放日期</td>
						<td width="100"><input type="text" class="input7" name="ffsj" id="ffsj" value="<%=ffsj==null?sf.format(Calendar.getInstance().getTime()):ffsj%>"  onclick="new Calendar().show(this);" readonly="readonly"  /></td>
						<td class="grey2">发放的时间也可自行设置，系统会根据您设置的时间将积分发放到指定账户中,该时间前积分暂时处于冻结状态</td>
					  </tr>
					</table>
				</div>
				<div class="hjr-box1">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td width="20" height="30"></td>
						<td width="70" valign="top" class="tdtitle">备注信息</td>
						<td><textarea cols="" rows="" class="inputarea1" name="bz" id="bz"  onFocus="javascript:if(this.value=='您可以在这里输入发放的备注内容,比如[ELT项目最佳完成奖]') this.value='';" onBlur="javascript:if(this.value=='') this.value='您可以在这里输入发放的备注内容,比如[ELT项目最佳完成奖]';"><%if (bz!=null && bz.length()>0) out.print(bz); else out.print("您可以在这里输入发放的备注内容,比如[ELT项目最佳完成奖]"); %></textarea></td>
					  </tr>
					</table>
				</div>
				<div class="hjr-box1">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td width="20" height="30"></td>
						<td width="70" valign="top"></td>
						<td><a id="aisave" href="javascript:void(0);" class="submit" onclick="saveit()" /></a><a href="assignintegral.jsp" class="reset"></a></td>
					  </tr>
					</table>
				</div>
				</form>
				<%out.print("<script type='text/javascript'>staffn="+staffn+";havejf="+session.getAttribute("qyjf")+";");
				if (ffsj!=null && ffsj.length()>0)
				{					
					out.print("listn="+listn+";");
					out.print("ygbh="+ygbh+";");					
				}
				out.print("</script>"); %>
				<div class="hjr-box2">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td width="125" height="30" align="center"><strong>积分发放记录</strong></td>
						<td width="100" align="center">根据设置日期：</td>
						<td width="90"><input type="text" class="input7" style="margin-top:0" name="ssrsj" id="ssrsj"  onclick="new Calendar().show(this);" readonly="readonly" /></td>
						<td width="20" height="30" align="center">-</td>
						<td width="90" valign="top"><input type="text" class="input7" style="margin-top:0" name="esrsj" id="esrsj"  onclick="new Calendar().show(this);" readonly="readonly" /></td>
						<td width="110" align="right">根据发放日期：</td>
						<td width="90"><input type="text" class="input7" style="margin-top:0" name="sffsj" id="sffsj"  onclick="new Calendar().show(this);" readonly="readonly" /></td>
						<td width="20" align="center">-</td>
						<td width="90"><input type="text" class="input7" style="margin-top:0" name="effsj" id="effsj"  onclick="new Calendar().show(this);" readonly="readonly" /></td>
						<td width="60" align="right">状态：</td>
						<td width="90" valign="top"><div id="tm2008style">
								<select name="ffzt" id="ffzt" style="height: 30px;">
									<option value="">所有</option>
									<option value="1" >已发放</option>
									<option value="0" >未发放</option>
									<option value="-1" >已取消</option>
								</select>
						</div></td>
						<td align="right"><span class="caxun" style="margin-right:10px; margin-top:0;" onclick="showailist(1)">查询</span></td>
					  </tr>
					</table>
				</div>
				<div class="jfqffjl" id="ailist">
					<div class="jfqffjl-t">
						<div class="jfqffjl1">设置日期</div>
						<div class="jfqffjl2">发放名目</div>
						<div class="jfqffjl3">发放对象</div>
						<div class="jfqffjl4">积分</div>
						<div class="jfqffjl5">状态</div>
						<div class="jfqffjl6">发放日期</div>
						<div class="jfqffjl7"></div>
					</div>
					<ul class="jfqffjlin">
					<%
					int ln=0,pages=1;
					strsql="select count(nid) as hn from tbl_jfff where qy="+session.getAttribute("qy")+" and ffxx=0";
					rs=stmt.executeQuery(strsql);
					if (rs.next())
					{
						ln=rs.getInt("hn");
					}
					rs.close();
					pages=(ln-1)/10+1;
					
					strsql="select f.nid,f.ffsj,m1.mmmc as mc1,m2.mmmc as mc2,f.hjr,ffjf,ffzt,f.srsj from tbl_jfff f left join tbl_jfmm m1 on f.mm1=m1.nid left join tbl_jfmm m2 on f.mm2=m2.nid where f.qy="+session.getAttribute("qy")+" and ffxx=0 order by f.nid desc limit 10";
					rs=stmt.executeQuery(strsql);
					while (rs.next())
					{
					%>
						<li>
							<div class="jfqffjlin1"><%=sf.format(rs.getDate("srsj"))%></div>
							<div class="jfqffjlin2"><a href="aiorder.jsp?ffid=<%=rs.getString("nid")%>"><%if (rs.getString("mc2")!=null && rs.getString("mc2").length()>0) out.print(rs.getString("mc2")); else out.print(rs.getString("mc1")); %></a></div>
							<div class="jfqffjlin3"><%if (rs.getString("hjr")!=null && rs.getString("hjr").length()>20) out.print(rs.getString("hjr").substring(0,20)+"..."); else out.print(rs.getString("hjr"));%></div>
							<div class="jfqffjlin4"><%=rs.getString("ffjf")%><%if (rs.getInt("ffzt")==0) out.print("冻结"); %></div>
							<div class="jfqffjlin5"><%
								if (rs.getInt("ffzt")==-1)
									out.print("已取消");
								if (rs.getInt("ffzt")==0)
									out.print("未发放");
								if (rs.getInt("ffzt")==1)
									out.print("已发放");
								%></div>
							<div class="jfqffjlin6"><%=sf.format(rs.getDate("ffsj"))%></div>
							<div class="jfqffjlin7"><%if (rs.getInt("ffzt")==0) {%><span class="cancletxt"><a href="javascript:void(0);" onclick="Cancleff(<%=rs.getString("nid")%>)">取消发放</a></span><%} %></div>
						</li>
					<%}
					rs.close();
					%>	
					</ul>
					<div class="pages">
					<div class="pages-l">
					<%for (int i=1;i<=pages;i++) {
					%>
					<a href="javascript:void(0);" <%if (i==1) out.print(" class='psel'"); %> onclick="showailist(<%=i%>)"><%=i%></a>
					<%
					if (i>=6) break;
					} %>
					</div>
					<div class="pages-r">
					<%if (pages>1) out.print("<h2><a href='javascript:void(0);' onclick='showailist(2)'>下一页</a></h2>");%>					
					</div>		
				</div>
				</div>
				
		  </div>
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
