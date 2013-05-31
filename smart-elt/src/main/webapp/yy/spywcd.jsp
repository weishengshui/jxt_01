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
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("5004")==-1)
{
	out.print("你没有操作权限！");
	return;
}
Fun fun=new Fun();
int ln=0;
int pages=1;
int psize=10;
String pno=request.getParameter("pno");
if (pno==null || pno.equals(""))
	pno="1";

String ydh=request.getParameter("ydh");
if (ydh==null) ydh="";

String ddh=request.getParameter("ddh");
if (ddh==null) ddh="";
String scjrq=request.getParameter("scjrq");
if (scjrq==null) scjrq="";
String ecjrq=request.getParameter("ecjrq");
if (ecjrq==null) ecjrq="";

String sjsrq=request.getParameter("sjsrq");
if (sjsrq==null) sjsrq="";
String ejsrq=request.getParameter("ejsrq");
if (ejsrq==null) ejsrq="";

String sfhrq=request.getParameter("sfhrq");
if (sfhrq==null) sfhrq="";
String efhrq=request.getParameter("efhrq");
if (efhrq==null) efhrq="";

String sshrq=request.getParameter("sshrq");
if (sshrq==null) sshrq="";
String eshrq=request.getParameter("eshrq");
if (eshrq==null) eshrq="";

String naction=request.getParameter("naction");

if (!fun.sqlStrCheck(ydh) || !fun.sqlStrCheck(ddh) || !fun.sqlStrCheck(pno) || !fun.sqlStrCheck(scjrq) || !fun.sqlStrCheck(naction) || !fun.sqlStrCheck(ecjrq) || !fun.sqlStrCheck(sfhrq) || !fun.sqlStrCheck(efhrq) || !fun.sqlStrCheck(sshrq) || !fun.sqlStrCheck(eshrq) )
{	
	response.sendRedirect("spywcd.jsp");
	return;
}
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
String  menun="5004";
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
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
            <td><div class="local"><span>订单管理&gt; 已完成订单</span></div></td>
          </tr>
          <tr>
            <td>
					<div class="caxunbox">
					<div class="caxun">
						<span>运单号：</span><input type="text" class="inputbox" style="width: 80px;" name="ydh" id="ydh" value="<%=ydh%>" />
						<span>订单号：</span><input type="text" class="inputbox" style="width: 80px;" name="ddh" id="ddh" value="<%=ddh%>" />
						<span>订单生成日期：</span><input type="text" class="inputbox"  style="width: 80px;" name="scjrq" id="scjrq" value="<%=scjrq%>"  onclick="new Calendar().show(this);" readonly="readonly" />--<input type="text" class="inputbox"  style="width: 80px;" name="ecjrq" id="ecjrq" value="<%=ecjrq%>"  onclick="new Calendar().show(this);" readonly="readonly" />					
						<br/>
						<span>订单付款日期：</span><input type="text" class="inputbox"  style="width: 80px;" name="sjsrq" id="sjsrq" value="<%=sjsrq%>"  onclick="new Calendar().show(this);" readonly="readonly" />--<input type="text" class="inputbox"  style="width: 80px;" name="ejsrq" id="ejsrq" value="<%=ejsrq%>"  onclick="new Calendar().show(this);" readonly="readonly" />
						<span>订单发货日期：</span><input type="text" class="inputbox"  style="width: 80px;" name="sfhrq" id="sfhrq" value="<%=sfhrq%>"  onclick="new Calendar().show(this);" readonly="readonly" />--<input type="text" class="inputbox"  style="width: 80px;" name="efhrq" id="efhrq" value="<%=efhrq%>"  onclick="new Calendar().show(this);" readonly="readonly" />
						<span>订单签收日期：</span><input type="text" class="inputbox"  style="width: 80px;" name="sshrq" id="sshrq" value="<%=sshrq%>"  onclick="new Calendar().show(this);" readonly="readonly" />--<input type="text" class="inputbox"  style="width: 80px;" name="eshrq" id="eshrq" value="<%=eshrq%>"  onclick="new Calendar().show(this);" readonly="readonly" />
						<input name="" type="button"  onclick="searchit(1)" class="findbtn"/>
					</div>
					<div class="caxun-r"></div>
				</div>
			</td>
          </tr>
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">
            <%
            	
            	strsql="select count(nid) as hn from tbl_ygddzb where state in (3,4,5)";
           	 	if (ydh!=null && ydh.length()>0)
           			strsql+=" and ydh like '%"+ydh+"%'";
           	 	
            	if (ddh!=null && ddh.length()>0)
               		strsql+=" and ddh like '%"+ddh+"%'";
           		if (scjrq!=null && scjrq.length()>0)
           			strsql+=" and cjrq>='"+scjrq+"'";
        		if (ecjrq!=null && ecjrq.length()>0)
            		strsql+=" and cjrq<'"+ecjrq+" 23:59:59'";
        		
        		if (sjsrq!=null && sjsrq.length()>0)
           			strsql+=" and jsrq>='"+sjsrq+"'";
        		if (ejsrq!=null && ejsrq.length()>0)
            		strsql+=" and jsrq<'"+ejsrq+" 23:59:59'";
        		
        		if (sfhrq!=null && sfhrq.length()>0)
           			strsql+=" and fhrq>='"+sfhrq+"'";
        		if (efhrq!=null && efhrq.length()>0)
            		strsql+=" and fhrq<'"+efhrq+" 23:59:59'";
        		
        		if (sshrq!=null && sshrq.length()>0)
           			strsql+=" and (shrq>='"+sshrq+"' or qsrq>='"+sshrq+"')";
        		if (eshrq!=null && eshrq.length()>0)
            		strsql+=" and (shrq<'"+eshrq+" 23:59:59' or qsrq<'"+eshrq+" 23:59:59')";	
            	rs=stmt.executeQuery(strsql);
            	if(rs.next())
            	{
            		ln=rs.getInt("hn");
            	}
            	rs.close();
            	pages=(ln-1)/psize+1;
            	
            	
            %>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td height="30">一共 <span class="red"><%=ln%></span> 条信息 </td>
              </tr>
              <tr>
                <td><table width="100%" border="0" cellspacing="1" cellpadding="1" class="maintable">
                  <tr>                   
                   <th width="10%">运单号</th>
                   <th width="12%">订单生成日期</th>
                   <th width="12%">订单付款日期</th>
                   <th width="12%">订单发货日期</th>
                   <th width="12%">订单签收日期</th>
                   <th width="7%">订单号</th>
                   <th width="7%">使用积分</th>
                   <th width="7%">使用金额</th>
                   <th width="10%">使用福利券(张)</th>          
                   <th width="6%">签收</th>
                 </tr>
                  <%
                  strsql="select nid, cjrq,ddh,zjf,zje,jfqsl,jsrq,fhrq,ydh,shrq,qsrq from tbl_ygddzb where state in (3,4,5)";
                  if (ydh!=null && ydh.length()>0)
             			strsql+=" and ydh like '%"+ydh+"%'";
                  
                  if (ddh!=null && ddh.length()>0)
                 		strsql+=" and ddh like '%"+ddh+"%'";
             	  if (scjrq!=null && scjrq.length()>0)
             			strsql+=" and cjrq>='"+scjrq+"'";
             			
	          		if (ecjrq!=null && ecjrq.length()>0)
	              		strsql+=" and cjrq<'"+ecjrq+" 23:59:59'";
	          		
	          		if (sjsrq!=null && sjsrq.length()>0)
	             			strsql+=" and jsrq>='"+sjsrq+"'";
	          		if (ejsrq!=null && ejsrq.length()>0)
	              		strsql+=" and jsrq<'"+ejsrq+" 23:59:59'";
	          		
	          		if (sfhrq!=null && sfhrq.length()>0)
	           			strsql+=" and fhrq>='"+sfhrq+"'";
	        		if (efhrq!=null && efhrq.length()>0)
	            		strsql+=" and fhrq<'"+efhrq+" 23:59:59'";
	        		
	        		if (sshrq!=null && sshrq.length()>0)
	           			strsql+=" and (shrq>='"+sshrq+"' or qsrq>='"+sshrq+"')";
	        		if (eshrq!=null && eshrq.length()>0)
	            		strsql+=" and (shrq<'"+eshrq+" 23:59:59' or qsrq<'"+eshrq+" 23:59:59')";	
                  strsql+=" order by nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;
                  rs=stmt.executeQuery(strsql);
                  while(rs.next())
                  {
                  %>
                  <tr>
                  	 <td><%=rs.getString("ydh")%></td>
                  	<td><%if (rs.getString("cjrq")!=null) out.print(sf.format(rs.getTimestamp("cjrq")));%></td>  
                  	<td><%if (rs.getString("jsrq")!=null)  out.print(sf.format(rs.getTimestamp("jsrq")));%></td>
                  	<td><%if (rs.getString("fhrq")!=null)  out.print(sf.format(rs.getTimestamp("fhrq")));%></td>
                  	<td><%if (rs.getString("qsrq")!=null)  out.print(sf.format(rs.getTimestamp("qsrq"))); else if (rs.getString("shrq")!=null) out.print(sf.format(rs.getTimestamp("shrq")));%></td>        	
                    <td><a href="spddmx.jsp?did=<%=rs.getString("nid")%>" target="_blank" class="blue"><%=rs.getString("ddh")%></a></td>
                    <td><%=rs.getString("zjf")%></td>
                    <td><%=rs.getString("zje")%></td>
                    <td><%=rs.getString("jfqsl")%></td>
                    <td><%=rs.getString("qsrq")==null?"客户":"运营"%></td>
                  </tr>
                 <%}
                  rs.close();
                  %>
                
                </table>
				</td>
              </tr>
            </table></td>
          </tr>
          <tr>
            <td style="padding:15px 0"><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>                
                <td width="450">
                <%
					int page_no=Integer.valueOf(pno);	
					if (page_no>=5 && page_no<=pages-2)
					{
						for (int i=page_no-3;i<=page_no+2;i++)
						{
							if (i==page_no)
								out.print("<a href='javascript:void(0);' class='nums' onclick='searchit("+i+")'>"+String.valueOf(i)+"</a>");
							else
								out.print("<a href='javascript:void(0);' class='num'  onclick='searchit("+i+")'>"+String.valueOf(i)+"</a>");
							
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
									out.print("<a href='javascript:void(0);' class='nums' onclick='searchit("+i+")'>"+String.valueOf(i)+"</a>");
								else
									out.print("<a href='javascript:void(0);'  class='num' onclick='searchit("+i+")'>"+String.valueOf(i)+"</a>");
							}
							out.print("...");
						}
						else
						{
							for (int i=1;i<=pages;i++)
							{
								if (i==page_no)
									out.print("<a href='javascript:void(0);' class='nums' onclick='searchit("+i+")'>"+String.valueOf(i)+"</a>");
								else
									out.print("<a href='javascript:void(0);' class='num' onclick='searchit("+i+")'>"+String.valueOf(i)+"</a>");
							}
						}
					}
					else
					{
						for (int i=pages-5;i<=pages;i++)
						{
							if (i==0) i=1;
							if (i==page_no)
								out.print("<a href='javascript:void(0);' class='nums' onclick='searchit("+i+")'>"+String.valueOf(i)+"</a>");
							else
								out.print("<a href='javascript:void(0);' class='num' onclick='searchit("+i+")'>"+String.valueOf(i)+"</a>");
						}
					}
				
					%>
                </td>
                <td align="right">
                <%if (page_no>1) out.print("<a href='javascript:void(0);' class='up' onclick='searchit("+(page_no-1)+")'>上一页</a>");%>
				<%if (page_no<pages) out.print("<a href='javascript:void(0);' class='up' onclick='searchit("+(page_no+1)+")'>下一页</a>");%>
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