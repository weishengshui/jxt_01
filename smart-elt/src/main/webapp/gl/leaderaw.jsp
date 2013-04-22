<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="jxt.elt.common.Fun"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>

<%
request.setCharacterEncoding("UTF-8");
String xid=request.getParameter("xid");
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd"); %>
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
			//document.getElementById("xxbchild"+p).innerHTML="";
			document.getElementById("xxchild"+p).innerHTML="";
			document.getElementById("xchild"+p).innerHTML="";			
			document.getElementById("xchild"+p).innerHTML="<h1>发放福利：每人</h1><span class=\"floatleft\">&nbsp;<input type=\"text\" class=\"input7\" name='ojf"+p+"' id='ojf"+p+"' onblur='changetjf("+p+",4)' value='0' />&nbsp;</span> <h1>张</h1><h2>共 <span class=\"yellowtxt\"  id='tjf"+p+"'>0</span> 张</h2>";
			}
		if (t==3)
			{				
				//document.getElementById("xxbchild"+p).innerHTML="";	
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
				var url = "selectyg.jsp?t=0&qxid=<%=xid%>&time="+timeParam;	
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
		document.getElementById("ajfalert").innerHTML="，还差 <span class=\"yellowtxt\">"+(tt-havejf)+"</span>张，请  <a href=\"buywelfare.jsp\" class=\"blue\">购买福利</a> 或者 删除部分发放信息";
		document.getElementById("aisave").className="tijiao";
		ifsubmit=0;
		}
		else
		{
			document.getElementById("ajfalert").innerHTML="";
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
		var url = "selectyg.jsp?t=0&qxid=<%=xid%>&time="+timeParam;	
		xmlHttp.open("GET", url, true);
		xmlHttp.onreadystatechange=showcon;
		xmlHttp.send(null);
	}
	
	function changetjf(p,t)
	{
		if (!CheckNumber(document.getElementById("ojf"+p).value))
		{
			alert("福利数格式不对！");
			return;
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
				document.getElementById("xchild"+thisp).innerHTML="<h1>发放福利：每小组</h1><span class=\"floatleft\">&nbsp;<input type=\"text\" class=\"input7\" name='ojf"+thisp+"' id='ojf"+thisp+"' onblur='changetjf("+thisp+",2)' value='0' />&nbsp;</span> <h1>张</h1><h2>共 <span class=\"yellowtxt\"  id='tjf"+thisp+"'>0</span> 张</h2>";
		
			}
			catch(exception){}
		}
	}
	
	function selectedbm()
	{
		var n=document.getElementsByName("bm").length;
		var nowcon=document.getElementById("xxchildc"+thisp).innerHTML;
		for (i=0;i<n;i++)
		{
			if (document.getElementsByName("bm")[i].checked)
			{
				if (nowcon.indexOf("\""+document.getElementsByName("bm")[i].value+"\"")==-1)
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
		document.getElementById("xchild"+thisp).innerHTML="<h1>发放福利：每部门</h1><span class=\"floatleft\">&nbsp;<input type=\"text\" class=\"input7\" name='ojf"+thisp+"' id='ojf"+thisp+"' onblur='changetjf("+thisp+",1)' value='0' />&nbsp;</span> <h1>张</h1><h2>共 <span class=\"yellowtxt\"  id='tjf"+thisp+"'>0</span> 张</h2>";
			
	}
	
	function selectedyg(t)
	{
		var n=document.getElementsByName("yg").length;
		var nowcon=document.getElementById("xxchildc"+thisp).innerHTML;
		for (i=0;i<n;i++)
		{
			if (document.getElementsByName("yg")[i].checked)
			{
				if (nowcon.indexOf("\""+document.getElementsByName("yg")[i].value+"\"")==-1)
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
		document.getElementById("xchild"+thisp).innerHTML="<h1>发放福利：每人</h1><span class=\"floatleft\">&nbsp;<input type=\"text\" class=\"input7\" name='ojf"+thisp+"' id='ojf"+thisp+"' onblur='changetjf("+thisp+",3)' value='0' />&nbsp;</span> <h1>张</h1><h2>共 <span class=\"yellowtxt\"  id='tjf"+thisp+"'>0</span> 张</h2>";
			
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
		addDiv.innerHTML="<div class=\"hjrwrap\"><div class=\"hjrbox\"><div class=\"hjrbox1\">发放对象：[可选择全体员工或个别指定的员工进行积分发放]</div><div class=\"hjrbox2\"><h1><input type=\"radio\" name=\"fflx"+listn+"\" id=\"fflx"+listn+"\" value=\"4\"  onclick=\"showcc(4,"+listn+")\"/></h1><h2>全体员工</h2><h1><input type=\"radio\" name=\"fflx"+listn+"\" id=\"fflx"+listn+"\" value=\"3\" onclick=\"showcc(3,"+listn+")\"/></h1><h2>个别员工</h2></div><div class=\"hjrbox3\"  id=\"xxchild"+listn+"\"></div></div><div class=\"hjrbox4\" id=\"xchild"+listn+"\"></div></div><a href=\"javascript:void(0);\" class=\"deltxt\" onclick=\"delitem("+listn+")\">&times;删除</a><div class=\"clear\"></div>";
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
				alert("请设置发放福利！");
				return;
			}
			if (document.getElementById("bz").value=="您可以在这里输入发放的备注内容,比如[ELT项目最佳完成奖]")
				document.getElementById("bz").value="";
			
			var nffsj=document.getElementById("ffsj").value.replace("-","/");
			var nsj="<%=sf.format(Calendar.getInstance().getTime())%>";
			nsj=nsj.replace("-","/");
			if (Date.parse(nffsj)<Date.parse(nsj))
			{
				alert("发放日期不能小于当前日期！");
				return;
			}
			document.getElementById("listn").value=listn;
			document.getElementById("awform").submit();
		}
	}
	
	function showlist()
	{
		if (xmlHttp.readyState == 4)
		{
			var response = xmlHttp.responseText;
			try
			{			
				document.getElementById("awlist").innerHTML=response;
			}
			catch(exception){}
		}
	}

	function showawlist(p)
	{
		var timeParam = Math.round(new Date().getTime()/1000);
		var url = "getawlist.jsp?pno="+p+"&ffzt="+document.getElementById("ffzt").value+"&sffsj="+document.getElementById("sffsj").value+"&effsj="+document.getElementById("effsj").value+"&ssrsj="+document.getElementById("ssrsj").value+"&esrsj="+document.getElementById("esrsj").value+"&time="+timeParam;	
		
		xmlHttp.open("GET", url, true);
		xmlHttp.onreadystatechange=showlist;
		xmlHttp.send(null);
	}
	
	function Cancleff(id)
	{
		if (confirm("确认要取消此发放"))
		{
			var timeParam = Math.round(new Date().getTime()/1000);
			var url = "getawlist.jsp?ffid="+id+"&time="+timeParam;		
			xmlHttp.open("GET", url, true);
			xmlHttp.onreadystatechange=showlist;
			xmlHttp.send(null);
		}
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
	
	function sygagain(p,t)
	{
		var timeParam = Math.round(new Date().getTime()/1000);
		var url = "getyglist.jsp?t="+t+"&pno="+p+"&dsygxm="+encodeURI(escape(document.getElementById("dsygxm").value))+"&dsbm="+document.getElementById("dsbm").value+"&dsemail="+encodeURI(escape(document.getElementById("dsemail").value))+"&time="+timeParam;		
		
		xmlHttp.open("GET", url, true);
		xmlHttp.onreadystatechange=showyglist;
		xmlHttp.send(null);
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
			{	response=response.replace(new RegExp("","g"),"");
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
menun=5;
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
int staffn=0;

Fun fun=new Fun();
int haven=0;
String qid=request.getParameter("qid");
if (qid==null || qid.equals("") || !fun.sqlStrCheck(qid))
{
	response.sendRedirect("mywelfare.jsp");
	return;
}


String mm1=request.getParameter("mm1");
String mm2=request.getParameter("mm2");
String ffsj=request.getParameter("ffsj");
String bz=request.getParameter("bz");
String sendfflx=request.getParameter("sendfflx");
String sendojfs=request.getParameter("sendojfs");
String sendvalue=request.getParameter("sendvalue");
String jfq=request.getParameter("jfq");
int ygbh=0;
int tjf=0;
int listn=0;


String lxbh="0",mc1="",mc2="";
int fflx=0,ffjf=0;
try
{
	strsql="select x.nid,f.ffsj,m1.mmmc as mc1,m2.mmmc as mc2,x.jf,x.fflx,x.lxbh,f.mm1,f.mm2,x.yffjf from tbl_jfqffxx x inner join tbl_jfqff f on x.jfqff=f.nid left join tbl_jfmm m1 on f.mm1=m1.nid left join tbl_jfmm m2 on f.mm2=m2.nid where x.nid="+xid;
	
	rs=stmt.executeQuery(strsql);
	if (rs.next())
	{
		fflx=rs.getInt("fflx");
		lxbh=rs.getString("lxbh");
		mc1=rs.getString("mc1");
		mc2=rs.getString("mc2");
		//如果返回修改则不取原来的
		if (mm1==null || mm1.equals(""))
		{
			mm1=rs.getString("mm1");
			mm2=rs.getString("mm2");
		}
		ffjf=rs.getInt("jf")-rs.getInt("yffjf");
		haven=ffjf;
	}
	rs.close();
	
	
	
	
	
	//这里取的总数不能包含自己
	if (fflx==1)
	{
		strsql="select count(nid) as hn from tbl_qyyg where qy="+session.getAttribute("qy")+" and xtzt<>3  and zt=1 and bm like '%,"+lxbh+",%'";
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			staffn=rs.getInt("hn");
		}
		rs.close();
	}
	//小组
	if (fflx==2)
	{
		strsql="select count(nid) as hn from tbl_qyxzmc where xz="+lxbh;
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			staffn=rs.getInt("hn");
		}
		rs.close();
	}
	
	
 %>
	<%@ include file="head.jsp" %>
	<div id="main">
	  	<div class="main2">
  		  <div class="box">
				<ul class="local2">
					<li class="local2-ico1"><h1>选择积分券</h1><h2><%=sf.format(Calendar.getInstance().getTime())%></h2></li>
					<li class="local2-ico2"><h1 class="current-local">选择发放对象</h1><h2><%=sf.format(Calendar.getInstance().getTime())%></h2></li>
					<li class="local2-ico3"><h1>确认发放信息</h1></li>
					<li><h1>确认发放</h1></li>
				</ul>
				<%
				strsql="select q.nid,q.mc,q.sm,q.jf,q.sp,h.hdmc,h.hdtp,h.nid as hid from tbl_jfq q inner join tbl_jfqhd h on q.hd=h.nid where q.nid="+qid;
				rs=stmt.executeQuery(strsql);
				if (rs.next())
				{
				%>
				<div class="confirm-t">您选择的积分券</div>
				<div class="confirm-states">
					<h1><a href="hddetail.jsp?hid=<%=rs.getString("hid")%>" target="_blank"><img src="../hdimg/<%=rs.getString("hdtp")%>" width="121" height="88" /></a></h1>
					<dl>
						<dt><a href="hddetail.jsp?hid=<%=rs.getString("hid")%>" target="_blank" style="color:#279cd9"><%=rs.getString("hdmc")%></a></dt>
						<dd><%=rs.getString("mc")%></dd>
					</dl>
					<div class="c-s-r">
						<div class="c-s-r1">您拥有 <%=haven%> 张</div>
						<div class="c-s-r2">
							
						</div>
						<div class="c-s-r3"></div>
					</div>
				</div>
				<%}
				rs.close();
				%>
				<form action="awconfirm.jsp" name="awform" id="awform" method="post">
				<input type="hidden" name="jfq" id="jfq" value="<%=qid%>"  />
				<input type="hidden" name="listn" id="listn"/>
				<input type="hidden" name="xid" id="xid" value="<%=xid%>"/>
				<div class="hjr-ffmm" style="border-bottom:1px #cccccc dashed; padding-bottom:8px">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="90" height="30" class="tdtitle"><span class="star">*</span> 发放名目</td>
							<td width="300"><span id="mm1span">
								<select name="mm1" id="mm1" onchange="showmm(this.value)" style="height: 30px;">
									<%
									strsql="select nid,mmmc from tbl_jfmm where nid="+mm1;
									rs=stmt.executeQuery(strsql);
									if (rs.next())
									{
										out.print("<option value='"+rs.getString("nid")+"' selected='selected'>"+rs.getString("mmmc")+"</option>");
									}
									rs.close();
									//strsql="select nid,mmmc from tbl_jfmm where (qy="+session.getAttribute("qy")+" or qy=0) and fmm=0";
							  		//rs=stmt.executeQuery(strsql);
							  		//while (rs.next())
							  		//{
							  		//	if (mm1!=null && mm1.equals(rs.getString("nid")))
							  		//		out.print("<option value='"+rs.getString("nid")+"' selected='selected'>"+rs.getString("mmmc")+"</option>");
							  		//	else
							  		//		out.print("<option value='"+rs.getString("nid")+"'>"+rs.getString("mmmc")+"</option>");
							  		//}
							  		//rs.close();
									%>
								</select></span><span id="mm2span">
								<%
								if (mm2!=null && !mm2.equals("0") && !mm2.equals(""))
								{
									//out.print("<select name=\"mm2\" id=\"mm2\" style=\"height: 30px;\"><option value=\"\">请选择</option>");
									//strsql="select nid,mmmc from tbl_jfmm where (qy="+session.getAttribute("qy")+" or qy=0) and fmm="+mm1;
							  		//rs=stmt.executeQuery(strsql);
							  		//while (rs.next())
							  		//{
							  		//	if (mm2!=null && mm2.equals(rs.getString("nid")))
							  		//	else
							  		//		out.print("<option value='"+rs.getString("nid")+"'>"+rs.getString("mmmc")+"</option>");
							  		//}
							  		//rs.close();
							  		//out.print("</select>");
									strsql="select nid,mmmc from tbl_jfmm where nid="+mm2;
									rs=stmt.executeQuery(strsql);
									if (rs.next())
									{
										out.print("<select name=\"mm2\" id=\"mm2\" style=\"height: 30px;\">");
										out.print("<option value='"+rs.getString("nid")+"' selected='selected'>"+rs.getString("mmmc")+"</option>");
										out.print("</select>");
									}
									rs.close();
								}
								%>
								</span></td>
							<td width="163"></td>
							<td width="114"></td>
							<td>&nbsp;</td>
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
					String[] fflxa=sendfflx.split(";");
					String[] ojfs=sendojfs.split(";");
					String[] lxvalue=sendvalue.split(";");
					
					String jfffxx="";
					int ldbh=0;
					
					
					for (int i=0;i<fflxa.length;i++)
					{
					
						if (fflxa[i].equals("1"))
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
						
						if (fflxa[i].equals("2"))
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
							out.print("<input type='hidden' name='xzid"+i+"' id='xzid"+i+"' />");
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
						
						if (fflxa[i].equals("3"))
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
						if (fflxa[i].equals("4"))
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
							
							
							<div class="hjrbox4" id="xchild1"></div>										
						</div>
						<a href="javascript:void(0);" class="deltxt" onclick="delitem(1)">&times;删除</a>
						<div class="clear"></div>
					</div>
				<%} %>
				</div>
				
				
				<div class="hjr-tishi">您选择发放积分券共 <span class="yellowtxt" id="ajf"><%=tjf%></span> 张 ，您拥有该积分券 <span class="yellowtxt"><%=haven%></span> 张<span  style="font-size:14px;" id="ajfalert"></span></div>			
				<div class="hjr-box1" style="border-bottom:1px #cccccc dashed; padding-bottom:8px">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td width="20" height="30"><span class="star">*</span></td>
						<td width="70" class="tdtitle">发放日期</td>
						<td width="100"><input type="text" class="input7" name="ffsj" id="ffsj" value="<%=sf.format(Calendar.getInstance().getTime())%>"   readonly="readonly" /></td>
						<td class="grey">&nbsp;</td>
					  </tr>
					</table>
				</div>
				<div class="hjr-box1">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td width="20" height="30"></td>
						<td width="70" valign="top" class="tdtitle">备注信息</td>
						<td><textarea cols="" rows="" class="inputarea1" name="bz" id="bz" onFocus="javascript:if(this.value=='您可以在这里输入发放的备注内容,比如[ELT项目最佳完成奖]') this.value='';" onBlur="javascript:if(this.value=='') this.value='您可以在这里输入发放的备注内容,比如[ELT项目最佳完成奖]';"><%if (bz!=null && bz.length()>0) out.print(bz); else out.print("您可以在这里输入发放的备注内容,比如[ELT项目最佳完成奖]"); %></textarea></td>
					  </tr>
					</table>
				</div>
				<div class="hjr-box1">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td width="20" height="30"></td>
						<td width="70" valign="top"></td>
						<td><a  id="aisave" href="javascript:void(0);"  class="submit" onclick="saveit()" /></a><a href="leaderaw.jsp?xid=<%=xid%>&qid=<%=qid%>" class="reset"></a></td>
					  </tr>
					</table>
				</div>
				</form>				
				<%out.print("<script type='text/javascript'>staffn="+staffn+";havejf="+haven+";");
				if (ffsj!=null && ffsj.length()>0)
				{					
					out.print("listn="+listn+";");
					out.print("ygbh="+ygbh+";");					
				}
				out.print("</script>"); %>
				<div class="hjr-box2">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td width="125" height="30" align="center"><strong>积分券发放记录</strong></td>
						<td width="86" align="center">设置日期：</td>
						<td width="90"><input type="text" class="input7" style="margin-top:0" name="ssrsj" id="ssrsj" onclick="new Calendar().show(this);" readonly="readonly" /></td>
						<td width="20" height="30" align="center">-</td>
						<td width="90" valign="top"><input type="text" class="input7" style="margin-top:0" name="esrsj" id="esrsj" onclick="new Calendar().show(this);" readonly="readonly" /></td>
						<td width="90" align="right">发放日期：</td>
						<td width="90"><input type="text" class="input7" style="margin-top:0" name="sffsj" id="sffsj" onclick="new Calendar().show(this);" readonly="readonly" /></td>
						<td width="20" align="center">-</td>
						<td width="90"><input type="text" class="input7" style="margin-top:0" name="effsj" id="effsj" onclick="new Calendar().show(this);" readonly="readonly" /></td>
						<td width="60" align="right">状态：</td>
						<td width="90" valign="top"><div id="tm2008style">
								<select name="ffzt" id="ffzt">
									<option value="">所有</option>
									<option value="1" >已发放</option>
									<option value="0" >未发放</option>
									<option value="-1" >已取消</option>
								</select>
						</div></td>
						<td align="right"><span class="caxun" style="margin-right:10px; margin-top:0" onclick="showawlist(1)">查询</span></td>
					  </tr>
					</table>
				</div>
				
		  </div>
	  	</div>
	</div>
	
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
