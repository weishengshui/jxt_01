<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="jxt.elt.common.SendEmailBean"%>
<%@ include file="../common/yylogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("9006")==-1)
{
	out.print("你没有操作权限！");
	return;
}
Fun fun=new Fun();
int ln=0;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/adminstyle.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="../gl/js/calendar3.js"></script>
<script type="text/javascript">


function searchit(p)
{
	location.href="spywcd.jsp?ydh="+document.getElementById("ydh").value+"&ddh="+document.getElementById("ddh").value+"&scjrq="+document.getElementById("scjrq").value+"&ecjrq="+document.getElementById("ecjrq").value+"&sjsrq="+document.getElementById("sjsrq").value+"&ejsrq="+document.getElementById("ejsrq").value+"&sfhrq="+document.getElementById("sfhrq").value+"&efhrq="+document.getElementById("efhrq").value+"&sshrq="+document.getElementById("sshrq").value+"&eshrq="+document.getElementById("eshrq").value+"&pno="+p;
}



</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="9006";
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
Statement stmttemp=conn.createStatement();
ResultSet rstemp = null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");

String sskhjl = request.getParameter("khjl");
String ssqymc = request.getParameter("qymc");
String condition = "";

if (null != sskhjl && !sskhjl.isEmpty() && fun.sqlStrCheck(sskhjl)) {
	sskhjl = new String(sskhjl.getBytes("ISO8859-1"), "UTF-8");
    condition = condition + " and khjl like '%" + sskhjl + "%'";
}

if (null != ssqymc && !ssqymc.isEmpty() && fun.sqlStrCheck(ssqymc)) {
	ssqymc = new String(ssqymc.getBytes("ISO8859-1"), "UTF-8");
    condition = condition + " and qymc like '%" + ssqymc + "%'";
}

try{
%>
<form action="entreport.jsp" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <%@ include file="head.jsp" %>
  <tr>
    <td bgcolor="#f4f4f4"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="200" height="100%" valign="top"style="background:url(images/left-bottom.jpg) bottom">
			<%@ include file="leftmenu.jsp" %>
		  </td>
         <td width="10">&nbsp;</td>
        <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><div class="local"><span>系统管理&gt; 报表</span></div></td>
          </tr>
          <tr>
            <td>
					<div class="caxunbox">
					<div class="caxun">
						<span>企业名称：</span><input type="text" class="inputbox" style="width: 80px;" name="qymc" id="qymc" value="<%if(null != ssqymc) out.print(ssqymc);%>" />
						<span>客户经理：</span><input type="text" class="inputbox"  style="width: 50px;" name="khjl" id="khjl" value="<%if(null != sskhjl) out.print(sskhjl);%>" />						
						<input value="" type="submit" class="findbtn"/>
					</div>
					<div class="caxun-r"></div>
				</div>
			</td>
          </tr>
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">
            <%
            	
           	 	strsql= "select count(nid) as hn from tbl_qy where (zt=2 or zt=4)";
            	rs=stmt.executeQuery(strsql);
            	if(rs.next())
            	{
            		ln=rs.getInt("hn");
            	}
            	rs.close();
            	
            %>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td height="30">一共 <span class="red"><%=ln%></span> 条信息 </td>
              </tr>
              <tr>
                <td><table width="100%" border="0" cellspacing="1" cellpadding="1" class="maintable">
                  <tr>
                   <th width="11%">企业名称</th>
                   <th width="6%">当前规模（人数）</th>
                   <th width="8%">客户经理</th>
                   <th width="8%">购买实际金额(￥)</th>
                   <th width="6%">购买次数</th>
                   <th width="10%">最近购买时间</th>
                   <th width="8%">实际到账积分</th>
                   <th width="8%">已使用积分</th>
                   <th width="7%">积分发放量</th>          
                   <th width="7%">积分兑换量</th>
                   <th width="7%">福利购买量</th>
                   <th width="7%">已领取福利</th>
                   <th width="7%">未领取福利</th>
                 </tr>
                 <%
            	strsql= "select nid, qymc, khjl, jf as qyjf from tbl_qy where (zt=2 or zt=4) " + condition;
             	rs=stmt.executeQuery(strsql);
             	float zzjezj = 0l;
             	int dzjfzj = 0;
             	int ffjfzj = 0;
             	int jfdhlzj = 0;
             	int gmjfqzj = 0;
             	int syjfzj = 0;
             	int jfqfflqzj = 0;
             	int jfqwlqzj = 0;
             	while (rs.next())
             	{
             		int qynid = rs.getInt("nid");
             		String qymc = rs.getString("qymc");
             		String khjl = rs.getString("khjl");
             		if (null == khjl) {
             		    khjl = "";
             		}
             		int qyjf = rs.getInt("qyjf");
             		
             		strsql = "select count(*) as hn from tbl_qyyg where qy = " + qynid + " and zt in (1, 2)";
             		rstemp = stmttemp.executeQuery(strsql);
             		int gm = 0;
             		if (rstemp.next()) {
	             		gm = rstemp.getInt("hn");
             		}
             		rstemp.close();
             		
             		strsql = "select count(*) as hn, sum(zzje) as zzje, sum(dzjf) as dzjf, max(zzsj) as zjgm from tbl_jfzz where qy = " + qynid + " and zzzt = 3";
             		rstemp = stmttemp.executeQuery(strsql);
             		float zzje = 0;
             		int gmcs = 0;
             		int dzjf = 0;
             		String zjgm = "";
             		if (rstemp.next()) {
             		    //购买次数
             		   gmcs = rstemp.getInt("hn");
             		    //购买金额
             		   zzje = rstemp.getFloat("zzje");
             		    //到帐金额
             		   dzjf = rstemp.getInt("dzjf");
             		   Date zjgmDate = rstemp.getDate("zjgm");
             		   if (zjgmDate != null) {
             		       //最近一次时间
	             		   zjgm = sf.format(zjgmDate);
             		   }
             		}
             		rstemp.close();
             		//剩余积分
             		int syjf = dzjf - qyjf;
             		
             		strsql = "select sum(ffjf) as ffjf from tbl_jfff where ffxx = 0 and ffzt=1 and qy = " + qynid;
             		rstemp = stmttemp.executeQuery(strsql);
             		int ffjf = 0;
             		if (rstemp.next()) {
             		    //发放积分
             		   ffjf = rstemp.getInt("ffjf");
             		}
             		rstemp.close();
             		
             		strsql = "SELECT sum(a.jf) as jfdhl FROM tbl_ygddmx a where a.state >= 1 and a.state <> 9 and a.yg in (select b.nid from tbl_qyyg b where qy = "+ qynid + ")";
             		rstemp = stmttemp.executeQuery(strsql);
             		//TODO: REFINE
             		int jfdhl = 0;
             		if (rstemp.next()) {
             		   //兑换的积分
             		   jfdhl = rstemp.getInt("jfdhl");
             		} 
	             	rstemp.close();
             		
             		strsql = "select sum(ddsl) as gmjfq, sum(ddjf) as jfqgml from tbl_jfqdd where zt = 1 and qy = " + qynid;
             		rstemp = stmttemp.executeQuery(strsql);
             		int gmjfq = 0;
             		int jfqgml = 0;
             		if (rstemp.next()) {
             		   gmjfq = rstemp.getInt("gmjfq");
             		   jfqgml = rstemp.getInt("jfqgml");
             		}
             		rstemp.close();
             		
//              		strsql = "SELECT sum(a.sl) as jfqdhl FROM tbl_ygddmx a where a.state >= 1 and a.state<>9 and jfq is not null and a.yg in (select b.nid from tbl_qyyg b where qy = " + qynid + ")";
//              		rstemp = stmttemp.executeQuery(strsql);
//              		int jfqfflq = 0;
//              		if (rstemp.next()) {
//              		   jfqfflq = rstemp.getInt("jfqdhl");
//              		}
//              		rstemp.close();
             		
             		strsql = "SELECT sum(c.jf*t.sl) as jfqdhl FROM tbl_ygddmx t inner join tbl_jfq c on t.jfq = c.nid where t.jfq is not null and t.yg in (select b.nid from tbl_qyyg b where b.qy=" + qynid + ") and state >=1 and state <> 9";
             		rstemp = stmttemp.executeQuery(strsql);
             		int jfqdhl = 0;
             		if (rstemp.next()) {
             		   jfqdhl = rstemp.getInt("jfqdhl");
             		}
             		rstemp.close();
             		
             		int jfqwlq = jfqgml - jfqdhl;
             		
             		zzjezj += zzje;
             		dzjfzj += dzjf;
             		syjfzj += syjf;
             		ffjfzj += ffjf;
             		jfdhlzj += jfdhl;
             		gmjfqzj += jfqgml;
             		jfqfflqzj += jfqdhl;
             		jfqwlqzj += jfqwlq;
             	%>
                 <tr>
                  	<td><a class="blue" href="detailreport.jsp?qy=<%=qynid%>"><%=qymc%></a></td>
                  	<td><%=gm%></td>
                  	<td><%=khjl%></td>
                  	<td><%=zzje%></td>
                  	<td><%=gmcs%></td>
                    <td><%=zjgm%></td>
                    <td><%=dzjf%></td>
                    <td><%=syjf%></td>
                    <td><%=ffjf%></td>
                    <td><%=jfdhl%></td>
                    <td><%=jfqgml%></td>
                    <td><%=jfqdhl%></td>
                    <td><%=jfqwlq%></td>
                  </tr>
             	<%
             	}
             	rs.close();
                 %>
                 <tr>
                  	<td>总计</td>
                  	<td></td>
                  	<td></td>
                  	<td><%=zzjezj%></td>
                  	<td></td>
                    <td></td>
                    <td><%=dzjfzj%></td>
                    <td><%=syjfzj%></td>
                    <td><%=ffjfzj%></td>
                    <td><%=jfdhlzj%></td>
                    <td><%=gmjfqzj%></td>
                    <td><%=jfqfflqzj%></td>
                    <td><%=jfqwlqzj%></td>
                  </tr>
                </table>
				</td>
              </tr>
            </table></td>
          </tr>
        </table></td>
        <td width="20">&nbsp;</td>
      </tr>
    </table></td>
  </tr>
  <%@ include file="bottom.jsp" %>
</table>
</form>
<%}
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