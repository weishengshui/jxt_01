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
<%@page import="java.text.NumberFormat"%>
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

String qynidparameter = request.getParameter("qy");

if (null == qynidparameter && qynidparameter.isEmpty()) {
    response.sendRedirect("entreport.jsp");
    return;
}

try{
%>
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
            <td><div class="local"><span>系统管理&gt; 报表&gt; 详细报表</span>
            <a class="back" href="entreport.jsp">返回上一页</a></div></td>
          </tr>
          <%
            String qymc = "";
            String qyjl = "";
	      	strsql= "select qymc, khjl as qyjf from tbl_qy where (zt=2 or zt=4) and nid = " + qynidparameter;
	        rs=stmt.executeQuery(strsql);
	      	if(rs.next())
	      	{
	      	    qymc=rs.getString("qymc");
	      	    qyjl=rs.getString("qyjf");
	      	}
	      	if (qymc == null) {
	      	   qymc = "";
	      	}
	      	if (qyjl == null) {
	      	  	qyjl = "";
		    }
	      	rs.close();
	      	
     		strsql = "select count(*) as hn from tbl_qyyg where qy = " + qynidparameter + " and zt in (1, 2)";
     		rs = stmt.executeQuery(strsql);
     		
     		int gm = 0;
     		if (rs.next()) {
         		gm = rs.getInt("hn");
     		}
     		rs.close();
          %>
          <tr>
            <td>
            <span>企业名称: <%=qymc%></span>
            <span style="margin-left: 7%;">当前规模: <%=gm%></span>
            <span style="margin-left: 7%;">客户经理: <%=qyjl%></span>
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
              <tr height="20px">
				<td>积分购买信息</td>
              </tr>
              <tr>
                <td><table width="100%" border="0" cellspacing="1" cellpadding="1" class="maintable">
                  <tr>
                   <th width="11%">购买时间</th>
                   <th width="6%">购买实际金额（￥）</th>
                   <th width="8%">实际到账积分</th>
                 </tr>
                 <%
            	strsql= "SELECT zzsj, zzje, dzjf  FROM tbl_jfzz where qy = " + qynidparameter +" and zzzt = 3";
             	rs=stmt.executeQuery(strsql);
             	float zzjezj = 0l;
             	int dzjfzj = 0;
             	while (rs.next())
             	{
             		String gmsj = "";
             		Date zzsj = rs.getDate("zzsj");
             		if (null != zzsj) {
             		   gmsj = sf.format(zzsj);
             		}
             		float zzje = rs.getFloat("zzje");
             		int dzjf = rs.getInt("dzjf");
             		
             		zzjezj += zzje;
             		dzjfzj += dzjf;
             	%>
                 <tr>
                  	<td><%=gmsj%></td>
                  	<td><%=zzje%></td>
                  	<td><%=dzjf%></td>
                  </tr>
             	<%
             	}
             	rs.close();
                 %>
                 <tr>
                  	<td>总计</td>
                  	<td><%=zzjezj%></td>
                  	<td><%=dzjfzj%></td>
                  </tr>
                </table>
				</td>
              </tr>
              <tr height="20px"></tr>
              <%
            strsql = "select sum(ddjf) as jfqgml from tbl_jfqdd where zt = 1 and qy = " + qynidparameter;
       		rs = stmt.executeQuery(strsql);
       		int jfqgml = 0;
       		if (rs.next()) {
       		   jfqgml = rs.getInt("jfqgml");
       		}
       		rs.close();
       		
       		strsql = "SELECT sum(c.jf*t.sl) as jfqdhl FROM tbl_ygddmx t inner join tbl_jfq c on t.jfq = c.nid where t.jfq is not null and t.yg in (select b.nid from tbl_qyyg b where b.qy=" + qynidparameter + ") and state >=1 and state <> 9";
       		rs = stmt.executeQuery(strsql);
       		int jfqdhl = 0;
       		if (rs.next()) {
       		   jfqdhl = rs.getInt("jfqdhl");
       		}
       		rs.close();
       		
       		int jfqwlq = jfqgml - jfqdhl;
              %>
              <tr>
				<td>
				<span>福利信息统计</span>
            	<span style="margin-left: 7%;">已领取福利: <%=jfqdhl%></span>
            	<span style="margin-left: 7%;">未领取福利: <%=jfqwlq%></span></td>
              </tr>
              <tr>
              <td><table width="100%" border="0" cellspacing="1" cellpadding="1" class="maintable">
                  <tr>
                   <th width="11%">购买时间</th>
                   <th width="6%">福利名称</th>
                   <th width="8%">单价</th>
                   <th width="8%">数量</th>
                   <th width="6%">小计</th>
                   <th width="10%">已领取福利(张)</th>
                   <th width="8%">未使用福利(张)</th>
                   <th width="8%">逾期未使用(张)</th>
                 </tr>
                 <%
                strsql= "SELECT c.ddsj, b.mc, b.jf, c.ddsl, c.ddjf, a.jfqdd FROM tbl_jfqmc a inner join tbl_jfq b on a.jfq=b.nid inner join tbl_jfqdd c on a.jfqdd=c.nid where a.qy = "+qynidparameter+" and c.zt=1 group by a.jfq, a.jfqdd";
             	rs=stmt.executeQuery(strsql);
             	int jlqslzj = 0;
             	int jfqxjzh = 0;
             	int jfqlqslzh = 0;
             	int jfqwsyslzh = 0;
             	int jfqgqwsyslzh = 0;
             	while (rs.next())
             	{
             		String gmsj = "";
             		Date ddsj = rs.getDate("ddsj");
             		if (null != ddsj) {
             		   gmsj = sf.format(ddsj);
             		}
             		String mc = rs.getString("mc");
             		int jlqdj = rs.getInt("jf");
             		int sl = rs.getInt("ddsl");
             		int xj = rs.getInt("ddjf");
             		int jfqddnid = rs.getInt("jfqdd");
             		
             		jlqslzj += sl;
             		jfqxjzh += xj;
             		
             		int jfqlqsl = 0;
             		strsql = "SELECT count(*) as jfqlqsl FROM tbl_jfqmc t where jfqdd="+jfqddnid+" and zt>=1 and zt<>7";
             		rstemp = stmttemp.executeQuery(strsql);
             		if (rstemp.next()) {
             		   jfqlqsl = rstemp.getInt("jfqlqsl");
             		}
             		jfqlqslzh += jfqlqsl;
             		rstemp.close();
             		
             		int jfqwsysl = 0;
             		strsql = "SELECT count(*) as jfqwsysl FROM tbl_jfqmc t where jfqdd="+jfqddnid+" and zt=0 and yxq > now()";
             		rstemp = stmttemp.executeQuery(strsql);
             		if (rstemp.next()) {
             		   jfqwsysl = rstemp.getInt("jfqwsysl");
             		}
             		jfqwsyslzh += jfqwsysl;
             		rstemp.close();
             		
             		int jfqgqwsysl = 0;
             		strsql = "SELECT count(*) as hn FROM tbl_jfqmc where jfqdd = " + jfqddnid + " and ((zt = 0 and yxq < now()) or zt = 7 )";
             		rstemp = stmttemp.executeQuery(strsql);
             		if (rstemp.next()) {
             		   jfqgqwsysl = rstemp.getInt("hn");
             		}
             		jfqgqwsyslzh += jfqgqwsysl;
             		rstemp.close();
             	%>
             	<tr>
                  	<td><%=gmsj%></td>
                  	<td><%=mc%></td>
                  	<td><%=jlqdj%></td>
                  	<td><%=sl%></td>
                  	<td><%=xj%></td>
                    <td><%=jfqlqsl%></td>
                    <td><%=jfqwsysl%></td>
                    <td><%=jfqgqwsysl%></td>
                  </tr>
             	<%
             	}
             	rs.close();
                 %>
                 <tr>
                  	<td>总计</td>
                  	<td></td>
                  	<td></td>
                  	<td><%=jlqslzj%></td>
                  	<td><%=jfqxjzh%></td>
                    <td><%=jfqlqslzh%></td>
                    <td><%=jfqwsyslzh%></td>
                    <td><%=jfqgqwsyslzh%></td>
                  </tr>
                </table>
				</td>
              </tr>
              <tr height="20px"></tr>
              <tr>
				<td>积分发放信息</td>
              </tr>
              <tr>
              <td><table width="100%" border="0" cellspacing="1" cellpadding="1" class="maintable">
                  <tr>
                   <th width="11%">发放时间</th>
                   <th width="6%">发放名目</th>
                   <th width="8%">发放金额</th>
                   <th width="8%">数量</th>
                   <th width="6%">小计</th>
                 </tr>
                 <%
                 
                strsql= "SELECT b.ffsj, c.mmmc, a.jf, a.rs, jf*rs as xj FROM tbl_jfffxx a, tbl_jfff b, tbl_jfmm c where a.jfff = b.nid and b.mm1 = c.nid and b.ffxx = 0 and b.ffzt = 1 and a.qy = " + qynidparameter;
             	rs=stmt.executeQuery(strsql);
             	int ffjfzj = 0;
             	while (rs.next())
             	{
             		String ffjfsj = "";
             		Date ffsj = rs.getDate("ffsj");
             		if (null != ffsj) {
             		   ffjfsj = sf.format(ffsj);
             		}
             		String mmmc = rs.getString("mmmc");
             		
             		int ffjfsl = rs.getInt("rs");
             		int ffjf = rs.getInt("jf");
             		int ffjfxj = rs.getInt("xj");
             		ffjfzj += ffjfxj;
             	%>
             	<tr>
                  	<td><%=ffjfsj%></td>
                  	<td><%=mmmc%></td>
                  	<td><%=ffjf%></td>
                  	<td><%=ffjfsl%></td>
                  	<td><%=ffjfxj%></td>
                  </tr>
             	<%
             	}
             	rs.close();
                 %>
                 <tr>
                  	<td>总计</td>
                  	<td></td>
                  	<td></td>
                  	<td></td>
                  	<td><%=ffjfzj%></td>
                  </tr>
                </table>
				</td>
              </tr>
              <tr height="20px"></tr>
              <tr>
				<td>积分兑换信息</td>
              </tr>
              <tr>
              <td><table width="100%" border="0" cellspacing="1" cellpadding="1" class="maintable">
                  <tr>
                   <th width="11%">积分兑换人次</th>
                   <th width="11%">积分兑换量</th>
                 </tr>
                 <%
                 strsql= "SELECT count(*) as hn, sum(a.jf) as ffjfzh FROM tbl_ygddmx a where a.state >= 1 and  a.state <> 9 and a.jf is not null and a.yg in (select b.nid from tbl_qyyg b where qy = " + qynidparameter +")";
              	 rs=stmt.executeQuery(strsql);
              	if (rs.next())
             	{
              	    int dhrc = rs.getInt("hn");
              	    int ffjfzh = rs.getInt("ffjfzh");
                 %>
                  <tr>
                  	<td><%=dhrc%></td>
                  	<td><%=ffjfzh%></td>
                  </tr>
                 <%
             	}
              	rs.close();
                 %>
                </table>
				</td>
              </tr>
              <tr height="20px"></tr>
              <tr>
				<td>兑换商品信息</td>
              </tr>
              <tr>
              <td><table width="100%" border="0" cellspacing="1" cellpadding="1" class="maintable">
                  <tr>
                   <th width="11%">商品类目</th>
                   <th width="11%">兑换量(个)</th>
                   <th width="11%">百分比</th>
                 </tr>
                 <%
                 strsql= "SELECT d.mc as lmmc, count(a.sl) as sl FROM tbl_ygddmx a, tbl_sp b, tbl_spl c, tbl_splm d where a.sp=b.nid and b.spl=c.nid and c.lb1 = d.nid and a.state<>0 and a.state<>9 and a.yg in (select e.nid from tbl_qyyg e where e.qy=" + qynidparameter +") group by d.nid";
              	 rs=stmt.executeQuery(strsql);
              	 int slzj=0;
              	List<String[]> items = new ArrayList<String[]>();
              	while (rs.next())
             	{
              	    String lmmc = rs.getString("lmmc");
              	    String ffjfzh = rs.getString("sl");
              	    String[] item = {lmmc, ffjfzh};
              	    items.add(item);
              	    slzj += Integer.valueOf(ffjfzh);
             	}
                NumberFormat nf = NumberFormat.getNumberInstance();
                nf.setMaximumFractionDigits(2);
              	for (String[] item : items) {
              	    
                 %>
                  <tr>
                  	<td><%=item[0]%></td>
                  	<td><%=item[1]%></td>
                  	<td><%=nf.format(Double.valueOf(item[1])/slzj * 100)%>%</td>
                  </tr>
                 <%}%>
                </table>
				</td>
              </tr>
            </table>
          </tr>
        </table></td>
        <td width="20">&nbsp;</td>
      </tr>
    </table></td>
  </tr>
  <%@ include file="bottom.jsp" %>
</table>
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