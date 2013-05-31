<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="org.omg.CORBA.INTERNAL"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>

<%
if (session.getAttribute("glqx").toString().indexOf(",14,")==-1) {
	response.sendRedirect("main.jsp");
}
menun=7;
Connection conn=DbPool.getInstance().getConnection();
conn.setAutoCommit(false);
int conncommit=1;
Statement stmt=conn.createStatement();
ResultSet rs=null;

String action = request.getParameter("action");
String ddhhidden = request.getParameter("ddhhidden");
String ddzjf = request.getParameter("ddzjf");
String actionSql = "";
int qynid = Integer.valueOf(session.getAttribute("qy").toString());
if ("1".equals(action)) {//pay order
	String qyjf = "select jf from tbl_qy where nid=" + qynid;
	rs=stmt.executeQuery(qyjf);
	int jf = 0;
	int zfjf = Integer.valueOf(ddzjf);
	if (rs.next()) {
		jf = rs.getInt("jf");
	}
	if (jf > zfjf) {
	    actionSql = "update tbl_qy set jf="+(jf-zfjf)+" where nid=" + qynid;
	    session.setAttribute("qyjf", jf-zfjf);
	} else {
	%>
	<script type="text/javascript">
	alert("您企业剩余积分不足，支付失败！请充值！");
	</script>
	<%
	}
	rs.close();
} else if ("2".equals(action)) {//confirm order
	actionSql = "update tbl_ygddzb set state=3,shrq=now() where ddh='" + ddhhidden + "'";
} else if ("3".equals(action)) {//cancel order
	actionSql = "update tbl_ygddzb set state=9 where ddh='" + ddhhidden + "'";
}

if (actionSql.length() > 0) {
	stmt.executeUpdate(actionSql);
	if ("1".equals(action)) {//pay order
		actionSql = "update tbl_ygddzb set state=1,jsrq=now() where ddh='" + ddhhidden + "'";
		stmt.executeUpdate(actionSql);
		actionSql = "update tbl_ygddmx set state=1,jssj=now() where ddh='" + ddhhidden + "'";
		stmt.executeUpdate(actionSql);
		//update product quantity
		String sql = "select sp,jfq,sl,spl from tbl_ygddmx where ddh='" + ddhhidden + "'";
		rs=stmt.executeQuery(sql);
		int sp = 0;
		String jfq = null;
		int sl = 0;
		int spl = 0;
		while (rs.next()) {
			sp = rs.getInt("sp");
			jfq = rs.getString("jfq");
			sl = rs.getInt("sl");
			spl = rs.getInt("spl");
			
			Statement stmt2=conn.createStatement();
			String sql2 = null;
			if (jfq == null || "".equals(jfq) || "0".equals(jfq)) {
				sql2 = "update tbl_sp set xsl=xsl+" + sl + ",wcdsl=wcdsl-" + sl + " where nid=" + sp;
			} else {//should not happen
				sql2 = "update tbl_sp set xsl=xsl+" + sl + " where nid=" + sp;
			}
			stmt2.executeUpdate(sql2);
			
			sql2 = "update tbl_spl set ydsl=ydsl+" + sl + " where nid=" + spl;
			stmt2.executeUpdate(sql2);
		}
		rs.close();
	}
}

String ddh = request.getParameter("ddh");
String sj = request.getParameter("cjrq");
String ddstate = request.getParameter("state");
String cjrq = "";
String param = "";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
Calendar cal = Calendar.getInstance();
if (ddh != null && !"".equals(ddh.trim())) {
	param += " and t.ddh like '%" + ddh.trim() + "%'";
}
if (sj != null && !"".equals(sj)) {
	if (!"0".equals(sj)) {
		if ("1".equals(sj)) {
			cal.add(Calendar.DAY_OF_MONTH, -7);
		} else if ("2".equals(sj)) {
			cal.add(Calendar.MONTH, -1);
		} else if ("3".equals(sj)) {
			cal.add(Calendar.MONTH, -3);
		} else if ("4".equals(sj)) {
			cal.add(Calendar.MONTH, -6);
		} else if ("5".equals(sj)) {
			cal.add(Calendar.YEAR, -1);
		}
	    cjrq = sf.format(cal.getTime());
	} else {
		cjrq = "";
	}
} else {
	cal.add(Calendar.MONTH, -3);
	cjrq = sf.format(cal.getTime());
}
if (cjrq.length() > 0) {
	param += " and t.cjrq>='" + cjrq +"'";
}

if (ddstate != null && !"".equals(ddstate)) {
	param += " and t.state in (" + ddstate + ")";
}

param += " and t.ddtype=" + qynid;
try{%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>IRewards</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<link type="text/css" rel="stylesheet" href="css/style.css">
		<link type="text/css" rel="stylesheet" href="css/ymPrompt.css">
		<script type="text/javascript" src="js/jquery-1.7.min.js"></script>
		<script type="text/javascript" src="js/common.js"></script>
		<script type="text/javascript" src="js/jquery.page.js"></script>	
		<script type="text/javascript" src="js/ymPrompt.js"></script>			
		<script type="text/javascript">	
			var gopay = function(ddh,zjf){
				if (!confirm("您确定使用积分支付？")) {
					return;
				}
				$("#action").val("1");
				$("#ddhhidden").val(ddh);
				$("#ddzjf").val(zjf);
				document.getElementById("cxform").submit();
			};
			var confirmOrder = function(ddh){
				if (!confirm("您确认已经收到货？")) {
					return;
				}
				$("#action").val("2");
				$("#ddhhidden").val(ddh);
				document.getElementById("cxform").submit();			
			};
			var cancel = function(ddh){
				if (!confirm("您确定取消此订单？")) {
					return;
				}
				$("#action").val("3");
				$("#ddhhidden").val(ddh);
				document.getElementById("cxform").submit();
			};
			var cxdd = function(){
				document.getElementById("cxform").submit();
			};
			var paging = function(p){
				$("#pno").val(p);
				document.getElementById("cxform").submit();
			};
			var showHideOrder = function(id){
				
				$('tr[id="order'+id+'"]').toggle();
				if($("#order"+id).is(":visible")) {
					$("#img"+id).attr("src","images/collapse.png");
				} else {
					$("#img"+id).attr("src","images/expand.png");
				}
				
				
				
				window.parent.ddIframe();
			};
		</script>
	</head>
	<body id="ddlistBody">
	
<div id="main" >
		<div class="main2" id="ddchild">
			<div class="box" style="height:auto;">
				<div class="wrap">
					<div class="wrap-right">
						<div class="list">
							<div class="list-title"><h1>直购福利</h1>
								<div class="l-headsl">
									<span id="dzfText" style="cursor:pointer">待支付 （<strong id="dfk" class="bisque">0</strong>）</span>
									<span id="dqrshText" style="cursor:pointer">待确认收货（<strong id="dqrsh" class="bisque">0</strong>）</span>
								</div>
							</div>
							<div class="listin">
								<form action="ddlist.jsp" id="cxform" name="cxform" method="post">
								<input type="hidden" id="action" name="action" value="" />
								<input type="hidden" id="ddhhidden" name="ddhhidden" value="" />
								<input type="hidden" id="ddzjf" name="ddzjf" value="" />
								<input type="hidden" id="pno" name="pno" value="1" />
								<div class="ordercx">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
									  <tr>
										<td width="70"><label>订单号：</label></td>
										<td width="140"><input id="ddh" name="ddh" type="text" maxlength="40" class="ordercxbox" /></td>
										<td width="50"><label>时间：</label></td>
										<td width="168"><select id="cjrq" name="cjrq" style="width:120px">								
											<option value="0" <%if("0".equals(sj)){out.print("selected=\"selected\"");} %>>-请选择-</option>
											<option value="1" <%if("1".equals(sj)){out.print("selected=\"selected\"");} %>>近七天</option>
											<option value="2" <%if("2".equals(sj)){out.print("selected=\"selected\"");} %>>近一个月</option>
											<option value="3" <%if(sj==null||"3".equals(sj)){out.print("selected=\"selected\"");} %>>近三个月</option>
											<option value="4" <%if("4".equals(sj)){out.print("selected=\"selected\"");} %>>近半年</option>
											<option value="5" <%if("5".equals(sj)){out.print("selected=\"selected\"");} %>>近一年</option>
										</select></td>
										<td><span onclick="cxdd();" class="caxun">查 询</span></td>
									  </tr>
									</table>
								    
								</div>	
								<div class="jftable-t">
									<table width="100%" border="0" cellspacing="0" cellpadding="0" class="orderhead-table">
									  <tr>
										<th width="300">商品信息</th>
										<th width="110">兑换价</th>
										<th width="47">数量</th>
										<th width="170">合计</th>
										<th width="115">
										  <select id="state" name="state" onchange="cxdd();" style="width:100px">
										    <option value="" <%if(ddstate==null||"".equals(ddstate)){out.print("selected=\"selected\"");} %>>交易状态</option>
										    <option value="0" <%if("0".equals(ddstate)){out.print("selected=\"selected\"");} %>>待支付</option>
										    <option value="1,11" <%if("1,11".equals(ddstate)){out.print("selected=\"selected\"");} %>>已支付</option>
										    <option value="2" <%if("2".equals(ddstate)){out.print("selected=\"selected\"");} %>>待收货</option>
										    <option value="3,4" <%if("3,4".equals(ddstate)){out.print("selected=\"selected\"");} %>>已收货</option>
										    <option value="9" <%if("9".equals(ddstate)){out.print("selected=\"selected\"");} %>>已取消</option>
									      </select>
										</th>
										<th>操作</th>
									  </tr>
									</table>
								</div>
								</form>
							</div>							
						</div>
						<table id="ddhidelist" style="display:none">
						</table>
						<div id="ddlist">
					 	</div>
						<%
						int num=0;
						int psize=10;
						int pages=1;
						String sqlCount = "SELECT count(*) as num FROM (SELECT t.nid,t.ddh,t.state,t.cjrq,DATE_FORMAT(t.jsrq,'%Y.%m.%d %H:%i') jsrq,t.ydh,t.shrq,t.fhrq,t.zjf,t.zje,t.jfqsl," +
								" t.fhr,t.yg,t.shdz,t.ddbz FROM tbl_ygddzb t" +
								" WHERE 1=1 "+param+" order by t.jsrq desc) as temp";
						rs=stmt.executeQuery(sqlCount);
						if (rs.next()) {
							num=rs.getInt("num");
						}
						rs.close();
						pages=(num-1)/psize+1;
						
						String pno=request.getParameter("pno");
						if (pno==null || pno.equals("")) {
							pno="1";
						}
						
									  String strsql = "SELECT t.nid,t.ddh,t.state,t.cjrq,DATE_FORMAT(t.jsrq,'%Y.%m.%d %H:%i') jsrq,t.ydh,t.shrq,t.fhrq,t.zjf,t.zje,t.jfqsl," +
												" t.fhr,t.yg,t.shdz,t.ddbz FROM tbl_ygddzb t" +
												" WHERE 1=1 "+param+" order by t.jsrq desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;
									  rs=stmt.executeQuery(strsql);
									  String zjf = "";
									  String zje = "";
									  ddh = "";
									  String nid = "";
									  int state = 0;
									  String jsrq = "";
									  String dds = "";
									  while (rs.next())
									  {
										  zjf = rs.getString("zjf");
										  zje = rs.getString("zje");
										  ddh = rs.getString("ddh");
										  nid = rs.getString("nid");
										  state = rs.getInt("state");
										  jsrq = rs.getString("jsrq");
										  
										  String zffs = "";
										  String cjzt = "";
											 if(jsrq != null && !"".equals(jsrq)){
												 cjzt = "&nbsp;&nbsp;&nbsp;&nbsp;成交时间：" + jsrq;
											 }
										  if(zjf!=null && !"".equals(zjf)){
											 zffs += "<strong class=\"bisque\">"+zjf+"</strong> 积分";
										  }
										  if(zje!=null && !"".equals(zje) && Double.valueOf(zje) > 0){
											 zffs += "<strong class=\"bisque\">"+zje+"</strong> 现金";
										  }
										  
									  String jyzt = "";
									  String cz = "";
											 if(state==0){
												 jyzt = "待支付";
												 cz = "<a class=\"confirm-sh\" onclick=\"gopay(\\'"+ddh+"\\',\\'"+zjf+"\\');\">支付</a><br />"
													 +"<a class=\"confirm-sh\" onclick=\"cancel(\\'"+ddh+"\\');\">取消订单</a>";
											 }
											 if(state==1){
												 jyzt = "已支付";
												// cz = '<a class="confirm-sh" onclick="remind(\''+ddh+'\')">提醒发货</a>';
											 } 
											 if(state==11){
												 jyzt = "已支付";
												// cz = '已提醒发货';
											 } 
											 if(state==2){
												 jyzt = "待收货";
												 cz = "<a class=\"confirm-sh\" onclick=\"confirmOrder(\\'"+ddh+"\\')\">确认收货</a>";
											 }
											 if(state==3){
												 jyzt = "已收货";
											 }
											 if(state==9){
												 jyzt = "已取消";
											 }
										  
										  String hidestr = "<tr id=\"hide"+nid
													+"\"><td width=\"170\" valign=\"top\">"+zffs+"<br /><label class=\"gray\">(含快递 0现金)</label></td>"
													+"<td width=\"115\" valign=\"top\">"+jyzt+"</td><td valign=\"top\">"+cz+"</td></tr>";
										  String str ="<div class=\"orderlist\"><table id=\"tab"+nid+"\" width=\"100%\" border=\"0\" cellspacing=\"1\" cellpadding=\"0\" class=\"orderlist-table\">"
													+"<tr onclick=\"showHideOrder("+nid+")\" style=\"cursor:pointer\"><th colspan=\"4\"><span style=\"float:left;\">订单号："+ddh+cjzt+"</span><img id=\"img"+nid+"\" src=\"images/expand.png\" style=\"height:20px;float:right;margin-right:50px;margin-top:5px;\" /></th></tr></table></div>";
										  dds += nid + ",";
													
									   %>
									   <script type="text/javascript">
										$("#ddlist").append('<%=str %>');
										$("#ddhidelist").append('<%=hidestr %>');
									   </script>
									   <%
									   }
									  rs.close();
									  if (dds.length() > 0) {
										  dds = dds.substring(0, dds.length() - 1);
									  
										  String sql = "SELECT t.sp,t.sl,t.jf,t.je,t.jfq,p.spbh,p.lj,t.dd,t.ddh,t.state,q.mc,p.spmc FROM tbl_ygddmx t" +
													" LEFT JOIN (SELECT m.spbh,m.nid,n.lj,m.spmc FROM  tbl_sp m LEFT JOIN tbl_sptp n ON n.nid = m.zstp) p ON p.nid = t.sp" +
													" LEFT JOIN tbl_jfq q ON q.nid = t.jfq"+
													" LEFT JOIN tbl_ygddzb z ON t.dd = z.nid"+
													" WHERE 1=1 AND z.ddtype = " + qynid +" AND t.dd in (" +dds+") order by t.ddh desc";
										  rs=stmt.executeQuery(sql);
										  int trowspan = 1;
										  int tzdd = 0;
										  int jf = 0;
										  String je = "";
										  String jfq = "";
										  String mc = "";
										  int sl = 0;
										  String spmc = "";
										  int sp = 0;
										  String lj = "";
										  int dd = 0;
										  while(rs.next())
										  {
											  jf = rs.getInt("jf");
											  je = rs.getString("je");
											  jfq = rs.getString("jfq");
											  mc = rs.getString("mc");
											  sl = rs.getInt("sl");
											  spmc = rs.getString("spmc");
											  sp = rs.getInt("sp");
											  lj = rs.getString("lj");
											  dd = rs.getInt("dd");
											  
											    String tdstr = "";
												String mxzffs = "";
												if(jf!=0){
													mxzffs+="<strong class=\"bisque\">"+jf+"</strong> 积分";
												}
												if(je!=null&&!"".equals(je)){
													mxzffs+=" <strong class=\"bisque\">"+je+"</strong> 现金";
												}
												if(jfq!=null&&!"".equals(jfq)){
													mxzffs+=mc+"<strong class=\"bisque\">"+sl+"</strong>张";
												}
												tdstr = "<tr id=\"order"+dd+"\" style=\"display: none\"><td width=\"477\"><div class=\"order-states\"><img src=\""+lj+"60x60.jpg\" /><p class=\"blue\">" +
													 spmc+"</p><span>"+mxzffs+"</span><h2>"+sl+"</h2></div></td></tr>";
												 %>
												   <script type="text/javascript">
												   $("#tab"+<%=dd %>).append('<%=tdstr %>');
												   </script>
												  <%
												
												if(tzdd == 0){
													tzdd = dd;
												}
												else if(tzdd == dd){
													trowspan++;
												}
												else if(tzdd != 0&&tzdd != dd){
												%>
												<script type="text/javascript">
												$("#hide"+<%=tzdd %>+" td").attr("rowspan",'<%=trowspan %>');
												$("#tab"+<%=tzdd %>+" tr").eq(1).append($("#hide"+<%=tzdd %>).html());
												</script>
												<%
													tzdd = dd;
													trowspan = 1;
												}
												if(rs.isLast()){
												%>
												<script type="text/javascript">
												$("#hide"+<%=tzdd %>+" td").attr("rowspan",'<%=trowspan %>');
												$("#tab"+<%=tzdd %>+" tr").eq(1).append($("#hide"+<%=tzdd %>).html());
												</script>
												<%
												}
										  }
										  rs.close();
                                      }
									  
									  String ddcount = "(SELECT COUNT(nid) AS ddcount FROM tbl_ygddzb WHERE state = 0 and ddtype="+qynid+") UNION ALL (SELECT COUNT(nid) AS ddcount FROM tbl_ygddzb WHERE state = 2 and ddtype="+qynid+")";
									  rs=stmt.executeQuery(ddcount);
									  int dzf = 0;
									  int dsh = 0;
									  while(rs.next())
									  {
										  if (rs.isFirst()) {
											  dzf = rs.getInt("ddcount");
										  } else {
											  dsh = rs.getInt("ddcount");
										  }
									  }
									  rs.close();
									  %>
									  <script type="text/javascript">
									  $("#dfk").html('<%=dzf %>');
									  $("#dzfText").click(function(){
										  if ($("#state").val() != "0") {
											$("#state").val("0");
											cxdd();
										  }
									  });
									  $("#dqrsh").html('<%=dsh %>');
									  $("#dqrshText").click(function(){
										  if ($("#state").val() != "2") {
												$("#state").val("2");
												cxdd();
											  }
									  });
									  </script>
					</div>
				</div>
			<div class="pages">
	<div class="pages-l">
	<%
	int page_no=Integer.valueOf(pno);	
	if (page_no>=5 && page_no<=pages-2)
	{
		for (int i=page_no-3;i<=page_no+2;i++)
		{
			if (i==page_no)
				out.print("<a href='javascript:void(0);' class='psel' onclick='paging("+i+")'>"+String.valueOf(i)+"</a>");
			else
				out.print("<a href='javascript:void(0);' onclick='paging("+i+")'>"+String.valueOf(i)+"</a>");
			
		}
		out.print("...");
	}
	else if (page_no<5)
	{
		if (pages>6)
		{
			for (int i=1;i<=6;i++)
			{
				if (i==page_no)
					out.print("<a href='javascript:void(0);' class='psel' onclick='paging("+i+")'>"+String.valueOf(i)+"</a>");
				else
					out.print("<a href='javascript:void(0);' onclick='paging("+i+")'>"+String.valueOf(i)+"</a>");
			}
			out.print("...");
		}
		else
		{
			for (int i=1;i<=pages;i++)
			{
				if (i==page_no)
					out.print("<a href='javascript:void(0);' class='psel' onclick='paging("+i+")'>"+String.valueOf(i)+"</a>");
				else
					out.print("<a href='javascript:void(0);' onclick='paging("+i+")'>"+String.valueOf(i)+"</a>");
			}
		}
	}
	else
	{
		for (int i=pages-5;i<=pages;i++)
		{
			if (i==0) i=1;
			if (i==page_no)
				out.print("<a href='javascript:void(0);' class='psel' onclick='paging("+i+")'>"+String.valueOf(i)+"</a>");
			else
				out.print("<a href='javascript:void(0);' onclick='paging("+i+")'>"+String.valueOf(i)+"</a>");
		}
	}

	%>
	
	</div>
	<div class="pages-r">
	<%if (page_no>1) out.print("<h1><a href='javascript:void(0);' onclick='paging("+(page_no-1)+")'>上一页</a></h1>");%>
	<%if (page_no<pages) out.print("<h2><a href='javascript:void(0);' onclick='paging("+(page_no+1)+")'>下一页</a></h2>");%>					
	</div>
	</div>
			</div>
	</div>
	</div>
<%
}
catch(Exception e)
{			
	e.printStackTrace();
	conn.rollback();
	conncommit=0;
}
finally
{
	if (!conn.isClosed())
	{	
		if (conncommit==1)
			conn.commit();
		conn.close();
	}
}
%>
	</body>
</html>
