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
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("9004")==-1)
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

String bmc=request.getParameter("bmc");
if (bmc!=null)
{
	bmc=fun.unescape(bmc);
	bmc=URLDecoder.decode(bmc,"utf-8");
}
if (bmc==null) bmc="";

String upid=request.getParameter("upid");

String naction=request.getParameter("naction");
String bid=request.getParameter("bid");
if (!fun.sqlStrCheck(bmc) || !fun.sqlStrCheck(pno) || !fun.sqlStrCheck(bid) || !fun.sqlStrCheck(naction)|| !fun.sqlStrCheck(upid))
{	
	response.sendRedirect("helpgl.jsp");
	return;
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards企业员工忠诚度系统</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/adminstyle.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">


function searchit(p)
{
	location.href="helpgl.jsp?bmc="+encodeURI(escape(document.getElementById("bmc").value))+"&upid="+document.getElementById("upid").value+"&pno="+p;
}

function delit(bid)
{
	if (confirm("确认删除此文档吗，删除后无法恢复"))
	{
		location.href="helpgl.jsp?naction=del&bid="+bid+"&bmc="+encodeURI(escape(document.getElementById("bmc").value))+"&upid="+document.getElementById("upid").value+"&pno=<%=pno%>";
	}
}

</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="9004";
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
try{
	
	if (naction!=null && naction.equals("del"))
	{		
		strsql="delete from tbl_bzzx  where nid="+bid;
		stmt.executeUpdate(strsql);
	}
	
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
            <td><div class="local"><span>系统管理&gt; 帮助中心管理</span></div></td>
          </tr>
          <tr>
            <td>
					<div class="caxunbox">
					<div class="caxun">
						<span>标题：</span><input type="text" class="inputbox" style="width: 80px;" name="bmc" id="bmc" value="<%=bmc%>" />
						<span>类别：</span><select name="upid" id="upid">
						<option value="">全部</option>
						<option value="1" <%if (upid!=null && upid.equals("1")) out.print(" selected='selected'"); %>>购物指南</option>
						<option value="2" <%if (upid!=null && upid.equals("2")) out.print(" selected='selected'"); %>>配送方式</option>
						<option value="3" <%if (upid!=null && upid.equals("3")) out.print(" selected='selected'"); %>>支付方式</option>
						<option value="4" <%if (upid!=null && upid.equals("4")) out.print(" selected='selected'"); %>>其他服务</option>
						<option value="5" <%if (upid!=null && upid.equals("5")) out.print(" selected='selected'"); %>>网站信息</option>
						</select>
						<input name="" type="button"  onclick="searchit(1)" class="findbtn"/>
					</div>
					<div class="caxun-r"><a href="helpbianji.jsp" class="daorutxt">增加文档</a></div>
				</div>
			</td>
          </tr>
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">
            <%
            	
            	strsql="select count(nid) as hn from tbl_bzzx where upid>0";
           		if (bmc!=null && bmc.length()>0)
           			strsql+=" and bt like '%"+bmc+"%'";
           		if (upid!=null && upid.length()>0)
           			strsql+=" and upid="+upid;           		
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
                   <th width="25%">标题</th>
                   <th width="10%">所属类别</th>
                   <th width="10%">显示位置</th>
                   <th width="10%">是否显示</th>
                   <th>操作</th>
                 </tr>
                  <%
                  strsql="select nid,bt,upid,xswz,sfxz from tbl_bzzx where upid>0";
            	  if (bmc!=null && bmc.length()>0)
            			strsql+=" and bt like '%"+bmc+"%'";
            	  if (upid!=null && upid.length()>0)
            			strsql+=" and upid="+upid; 
                  strsql+=" order by upid desc,nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;
                  rs=stmt.executeQuery(strsql);
                  while(rs.next())
                  {
                  %>
                  <tr>                  	
                    <td class="textbreak"><%=rs.getString("bt")%></td>
                   <td class="textbreak"><%
                   	if (rs.getInt("upid")==1) out.print("购物指南");
                    if (rs.getInt("upid")==2) out.print("配送方式");
                    if (rs.getInt("upid")==3) out.print("支付方式");
                    if (rs.getInt("upid")==4) out.print("其他服务");
                    if (rs.getInt("upid")==5) out.print("网站信息");
                   	%></td>
                   	<td class="textbreak"><%=rs.getString("xswz")%></td>
                    <td class="textbreak"><%=rs.getInt("sfxz")==0?"否":"是"%></td>                    
                    <td>                   
                    <a href="helpbianji.jsp?bid=<%=rs.getString("nid")%>" class="blue">修改</a>
                    &nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0);" onclick="delit(<%=rs.getInt("nid")%>)" class="blue">删除</a></td>
                 
                    </td>
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