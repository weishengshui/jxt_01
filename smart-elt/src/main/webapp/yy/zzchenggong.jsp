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
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("2004")==-1)
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

String qymc=request.getParameter("qymc");
if (qymc!=null)
{
	qymc=fun.unescape(qymc);
	qymc=URLDecoder.decode(qymc,"utf-8");
}
if (qymc==null) qymc="";

String zzbh=request.getParameter("zzbh");
if (zzbh==null) zzbh="";
String naction=request.getParameter("naction");
String zzid=request.getParameter("zzid");
if (!fun.sqlStrCheck(qymc) || !fun.sqlStrCheck(pno) || !fun.sqlStrCheck(zzid) || !fun.sqlStrCheck(zzbh))
{	
	response.sendRedirect("zzchenggong.jsp");
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
<script type="text/javascript">


function searchit(p)
{
	location.href="zzchenggong.jsp?qymc="+encodeURI(escape(document.getElementById("qymc").value))+"&zzbh="+encodeURI(escape(document.getElementById("zzbh").value))+"&pno="+p;
}
function ddzz(zid)
{
	if (confirm("确认充值积分？"))
	{
		location.href="zzchenggong.jsp?naction=audit&zzid="+zid+"&qymc="+encodeURI(escape(document.getElementById("qymc").value))+"&zzbh="+encodeURI(escape(document.getElementById("zzbh").value))+"&pno=<%=pno%>";
	}
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="2004";
Connection conn=DbPool.getInstance().getConnection();;
Statement stmt=conn.createStatement();
ResultSet rs=null;
Statement stmt2=conn.createStatement();
ResultSet rs2=null;
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
            <td><div class="local"><span>积分管理&gt; 交易成功充值单</span></div></td>
          </tr>
          <tr>
            <td>
					<div class="caxunbox">
					<div class="caxun">
						<span>企业名称：</span><input type="text" class="inputbox" style="width: 80px;" name="qymc" id="qymc" value="<%=qymc%>" />
						<span>订单号：</span><input type="text" class="inputbox"  style="width: 80px;" name="zzbh" id="zzbh" value="<%=zzbh%>" />											
						<input name="" type="button"  onclick="searchit(1)" class="findbtn"/>
					</div>
					<div class="caxun-r"></div>
				</div>
			</td>
          </tr>
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">
            <%
            	
            	strsql="select count(z.nid) as hn from tbl_jfzz z left join tbl_qy q on z.qy=q.nid  where z.zzzt=3";
           		if (qymc!=null && qymc.length()>0)
           			strsql+=" and q.qymc like '%"+qymc+"%'";
           		if (zzbh!=null && zzbh.length()>0)
           			strsql+=" and z.zzbh like '%"+zzbh+"%'";
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
                   <th width="6%">折扣订单</th>
                   <th width="12%">确认付款日期</th>
                   <th width="12%">最近充值日期</th>         
                   <th width="12%">企业名称</th>
                   <th width="6%">订单号</th>
                   <th width="6%">支付金额</th>
                   <th width="6%">购买积分</th>
                   <th width="6%">到账积分</th>
                   <th width="5%">操作人</th>
                   <th width="10%">备注</th>
                   <th width="8%">客户经理</th>
                   <th>操作</th>
                 </tr>
                  <%
                  strsql="select z.nid, z.zzsj,q.qymc,z.zzbh,z.zzje,z.zzjf,z.zzbz,z.zzzt,z.dzjf,z.fksj,y.ygxm,q.khjl from tbl_jfzz z left join tbl_qy q on z.qy=q.nid left join tbl_qyyg y on z.zzr=y.nid  where z.zzzt=3";
             		if (qymc!=null && qymc.length()>0)
             			strsql+=" and q.qymc like '%"+qymc+"%'";
             		if (zzbh!=null && zzbh.length()>0)
             			strsql+=" and z.zzbh like '%"+zzbh+"%'";
                  strsql+=" order by z.zzzt ,z.nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;
                  rs=stmt.executeQuery(strsql);
                  while(rs.next())
                  {
                  %>
                  <tr>
                  	<td><%if (rs.getInt("zzjf")>rs.getDouble("zzje")*10) out.print("<font color='red'>是</font>"); else out.print("否");%></td>
                  	<td><%=sf.format(rs.getTimestamp("fksj"))%></td>
                  	<td>
                  	<%
                  	strsql="select zjsj from tbl_jfzj where zz="+rs.getString("nid")+" order by nid desc limit 1";
                  	rs2=stmt2.executeQuery(strsql);
                  	if (rs2.next())
                  		out.print(sf.format(rs2.getTimestamp("zjsj")));
                  	else
                  		out.print("");
                  	rs2.close();
                  	%>
                  	</td>           	
                    <td class="textbreak"><%=rs.getString("qymc")==null?"":rs.getString("qymc")%></td>
                    <td><%=rs.getString("zzbh")==null?"":rs.getString("zzbh")%></td>
                    <td><%=rs.getString("zzje")==null?"":rs.getString("zzje")%></td>
                    <td><%=rs.getString("zzjf")==null?"":rs.getString("zzjf")%></td>
                    <td><%=rs.getString("dzjf")==null?"":rs.getString("dzjf")%></td>
                    <td><%=rs.getString("ygxm")==null?"":rs.getString("ygxm")%></td>
                    <td><%=rs.getString("zzbz")==null?"":rs.getString("zzbz")%></td>
                    <td><%=rs.getString("khjl")==null?"":rs.getString("khjl")%></td>
                    <td><a href="zzjifenzhuijia.jsp?zzid=<%=rs.getString("nid")%>" class="blue">追加积分</a></td>
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