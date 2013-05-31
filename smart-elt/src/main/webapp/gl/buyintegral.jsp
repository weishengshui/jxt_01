<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="jxt.elt.common.Fun"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (!isAuth && !isLeader) {
	response.sendRedirect("main.jsp");
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
 <link href="css/style.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/select2css.js"></script>
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/calendar3.js"></script>
<script type="text/javascript">
function buyintegral()
{
	var v=document.getElementById("zzje").value;
	if (v=="")
	{
		alert("请输入支付金额!");
		return false;
	}
	
	
	if (!CheckJinE(v) || !parseFloat(v))
	{
		alert("支付金额 格式不正确！");
		return false;		
	}
	
    if (v.indexOf(".")>-1)
    {
    	if (v.indexOf(".")<v.length-1)
    	{
    		document.getElementById("zzje").value=v.substr(0,v.indexOf(".")+2);
    	}
    }
  
	
	if (document.getElementById("zzjf").value=="")
	{
		alert("请输入要购买的积分!");
		return false;
	}
	
	
	if (!CheckNumber(document.getElementById("zzjf").value))
	{
		alert("购买积分格式不正确！");
		return false;		
	}
	
	if (parseInt(document.getElementById("zzjf").value)==0)
    {
    	alert("购买积分格式不正确！");
		return false;	
    }
	
	
	document.getElementById("buyform").submit();
}

function canclezz(id)
{
	if (confirm("确认要取消此订单"))
	{
		var timeParam = Math.round(new Date().getTime()/1000);
		var url = "getbilist.jsp?zzid="+id+"&time="+timeParam;	
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
			response=response.replace(new RegExp("","g"),"");			
			if (response=="0")
			{
				alert("该订单运营端已确认支付，不能进行取消！");
				return;
			}
			document.getElementById("bilist").innerHTML=response;
		}
		catch(exception){}
	}
}

function showbilist(p)
{
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "getbilist.jsp?pno="+p+"&zzzt="+document.getElementById("zzzt").value+"&szzsj="+document.getElementById("szzsj").value+"&ezzsj="+document.getElementById("ezzsj").value+"&time="+timeParam;		
	//window.open(url);
	//return;
	xmlHttp.open("GET", url, true);
	xmlHttp.onreadystatechange=showlist;
	xmlHttp.send(null);
}
function reset()
{
	document.getElementById("zzjf").value="";
	document.getElementById("zzje").value="";
	document.getElementById("bz").value="";	
}
function jfjs(v)
{	
    
	if (!CheckJinE(v) || !parseFloat(v))
	{
		alert("支付金额 格式不正确！");
		return false;		
	}
	
    if (v.indexOf(".")>-1)
    {
    	if (v.indexOf(".")<v.length-1)
    	{
    		document.getElementById("zzje").value=v.substr(0,v.indexOf(".")+2);
    	}
    }
    document.getElementById("zzjf").value=parseInt(parseFloat(v)*10);
    if (parseInt(document.getElementById("zzjf").value==0))
    {
    	alert("支付金额 格式不正确！");
		return false;	
    }
	
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%

menun=2;
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
String ygdh="";
boolean isgly = false;
int ln=0;


try
{
	SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
	strsql="select lxdh, gly from tbl_qyyg where nid="+session.getAttribute("ygid");
	rs=stmt.executeQuery(strsql);
	if (rs.next())
	{
		ygdh=rs.getString("lxdh");
		if (ygdh==null) ygdh="";
		isgly=rs.getBoolean("gly");
	}
	rs.close();
 %>
	<%@ include file="head.jsp" %>
	<div id="main">
	  	<div class="main2">
	  		<div class="box">
				<ul class="local">
					<li class="local-ico2">
						<div class="local3-1"><h1>确认购买积分数</h1><h2><%=sf.format(Calendar.getInstance().getTime())%></h2></div>
					</li>
					<li class="local-ico3">
						<div class="local3-2"><h1>选择支付方式</h1></div>
					</li>
					<li>
						<div class="local3-3"><h1>订单成功</h1></div>
					</li>
				</ul>
				<form name="buyform" id="buyform" action="biconfirm.jsp" method="post">
				<%if (isAuth) {%>
				<div class="gsjf-states">尊敬的<%=session.getAttribute("qymc")%>，您目前公司账户积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("qyjf")%></em><%if (session.getAttribute("djjf")!=null && !session.getAttribute("djjf").equals("0")) {%>，冻结积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("djjf")%></em><%} %></div>
				<%} %>
				<ul class="buyscores">
					<li>
						<dl>
							<dt>企业名称：</dt>
							<dd class="grey"><%=session.getAttribute("qymc")%></dd>
						</dl>
						<dl>
							<dt>企业账户：</dt>
							<dd class="grey"><%=session.getAttribute("email")%></dd>
						</dl>
					</li>
					<li>
						<dl style="width:900px">
							<dt><span class="star">*</span> 支付金额：</dt>
							<dd><span class="floatleft"><input type="text" class="input1" name="zzje" id="zzje" onblur="jfjs(this.value)" /></span>　￥<span class="yellow2">1.00</span>元 = <span class="yellow2">10</span>个积分</dd>
						</dl>
					</li>
					<li>
						<dl style="width:900px">
							<dt><span class="star">*</span> 购买积分：</dt>
							<dd><span class="floatleft"><input type="text" class="input3" name="zzjf" id="zzjf" value="" <%if (!isgly) {%>readonly="readonly"<%} %> /></span></dd>
						</dl>
					</li>
					
					
					<li>
						<dl>
							<dt>操 作 人：</dt>
							<dd><input type="text" name="zzr" id="zzr" readonly="readonly"  class="input2" value="<%=session.getAttribute("ygxm")%>" /></dd>
						</dl>
					</li>
					<li>
						<dl>
							<dt>联系电话：</dt>
							<dd><input type="text" name="lxdh" id="lxdh" readonly="readonly" class="input2" value="<%=ygdh%>" /></dd>
						</dl>
					</li>
					<li>
						<dl style="width:900px">
							<dt>备　　注：</dt>
							<dd><textarea name="bz" id="bz" cols="" rows="" class="input4"></textarea></dd>
						</dl>
					</li>
					<li>
						<dl class="margintop-5">
							<dt></dt>
							<dd><a href="javascript:void(0);" class="submit" onclick="buyintegral()"></a><a href="javascript:void(0);" class="reset" onclick="reset()"></a></dd>
						</dl>
					</li>
				</ul>
				</form>
				<div class="jfcaxun">
					<span class="jfcaxun-t">积分购买记录</span>
									
					<div class="jfcaxun-r">
						<span>购买时间段：</span>
						<div class="floatleft"><input type="text" class="input6" name="szzsj" id="szzsj" onclick="new Calendar().show(this);" readonly="readonly" /></div>
						<span>&nbsp;-&nbsp;</span>
						<div class="floatleft"><input type="text" class="input6" name="ezzsj" id="ezzsj"  onclick="new Calendar().show(this);" readonly="readonly"  /></div>
						<span class="marginleft18">状态：</span>
						<div class="floatleft" style="margin-top: 5px;">
							<div id="tm2008style">
								<select name="zzzt" id="zzzt">
									<option value="">所有</option>
									<option value="0" >未付款</option>
									<option value="1" >完成支付</option>
									<option value="2" >线下支付</option>
									<option value="3" >交易成功</option>
									<option value="-1" >取消</option>
								</select>
							</div>
						</div>
						<div class="floatleft"><a href="javascript:void(0);" class="caxun" onclick="showbilist(1)">查 询</a></div>
					</div>					
				</div>
				<div class="scoresjilu" id="bilist">
					<div class="scoresjilu-t">
						<div class="scoresjilu1">购买日期</div>
						<div class="scoresjilu2">订单号</div>
						<div class="scoresjilu3">购买积分(分)</div>
						<div class="scoresjilu4">支付金额(元)</div>				
						
						<div class="scoresjilu6">到账积分(分)</div>					
						<div class="scoresjilu7">状态</div>
						<div class="scoresjilu8">操作</div>
					</div>
					<ul class="scoresjiluin">
						<%
						String ffbm = session.getAttribute("ffbm").toString();
					    if ("''".equals(ffbm)) {
					    	ffbm = "-1";
					    }
					    String ffxz = session.getAttribute("ffxz").toString();
					    if ("''".equals(ffxz)) {
					    	ffxz = "-1";
					    }
						if (isAuth) {
							strsql="select count(nid) as hn from tbl_jfzz where qy="+session.getAttribute("qy")+" and zztype=0";
						} else if (isLeader) {
							strsql="select count(nid) as hn from tbl_jfzz where zztype>0 and ((zztype=1 and bmxz in ("+ffbm+")) or (zztype=2 and bmxz in ("+ffxz+")) or (zztype=3 and zzr="+session.getAttribute("ygid")+"))";
						}
						rs=stmt.executeQuery(strsql);
						if (rs.next())
						{ln=rs.getInt("hn");}
						rs.close();
						int pages=(ln-1)/10+1;
						
						if (isAuth) {
							strsql="select nid,zzsj,zzbh,zzjf,zzje,dzjf, zzzt from tbl_jfzz where qy="+session.getAttribute("qy")+" and zztype=0 order by nid desc limit 10";
						} else if (isLeader) {
							strsql="select nid,zzsj,zzbh,zzjf,zzje,dzjf, zzzt from tbl_jfzz where zztype>0 and ((zztype=1 and bmxz in ("+ffbm+")) or (zztype=2 and bmxz in ("+ffxz+")) or (zztype=3 and zzr="+session.getAttribute("ygid")+")) order by nid desc limit 10";
						}
						rs=stmt.executeQuery(strsql);
						while (rs.next())
						{
						 %>
						<li>
							<div class="scoresjiluin1"><%=sf.format(rs.getDate("zzsj"))%></div>
							<div class="scoresjiluin2"><a href="bidetail.jsp?zzid=<%=rs.getString("nid")%>"><%=rs.getString("zzbh")%> </a></div>
							<div class="scoresjiluin3"><%=rs.getInt("zzjf")%> </div>
							<div class="scoresjiluin4"><%=rs.getString("zzje")%></div>							
							<div class="scoresjiluin6"><%=rs.getString("dzjf")%></div>
							
							<div class="scoresjiluin7"><%
							if (rs.getInt("zzzt")==0)
								out.print("未付款");
							if (rs.getInt("zzzt")==1)
								out.print("完成支付");
							if (rs.getInt("zzzt")==2)
								out.print("线下支付");
							if (rs.getInt("zzzt")==3)
								out.print("交易成功");
							if (rs.getInt("zzzt")==-1 || rs.getInt("zzzt")==-2)
								out.print("已取消");	
							 %></div>
							<div class="scoresjiluin8"><%if (rs.getInt("zzzt")==0) {%><span class="floatleft"><a href="bipay.jsp?zzid=<%=rs.getString("nid")%>" class="gopay"></a></span><%} if (rs.getInt("zzzt")==0 || rs.getInt("zzzt")==2 ) { %><span class="cancletxt"><a href="javascript:void(0);" onclick="canclezz(<%=rs.getString("nid")%>)">取消</a></span><%} %></div>
						</li>
						
						<%}
						rs.close();
						 %>
					</ul>
					<div class="pages">
					<div class="pages-l">
					<%for (int i=1;i<=pages;i++) {
					%>
					<a href="javascript:void(0);" <%if (i==1) out.print(" class='psel'"); %> onclick="showbilist(<%=i%>)"><%=i%></a>
					<%
					if (i>=6) break;
					} %>
					</div>
					<div class="pages-r">
					<%if (pages>1) out.print("<h2><a href='javascript:void(0);' onclick='showbilist(2)'>下一页</a></h2>");%>					
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
