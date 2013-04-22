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
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("4005")==-1)
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


String naction=request.getParameter("naction");
String hdid=request.getParameter("hdid");
if ( !fun.sqlStrCheck(pno) || !fun.sqlStrCheck(hdid))
{	
	response.sendRedirect("sphdgl.jsp");
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
	location.href="sphdgl.jsp?pno="+p;;
}
function delit(lid)
{
	if (confirm("确认删除此活动，删除后无法恢复"))
	{
		location.href="sphdgl.jsp?naction=del&hdid="+lid+"&pno=<%=pno%>";
	}
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="4005";
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
try{
	if (naction!=null && naction.equals("del"))
	{		
		strsql="delete from tbl_cxhd  where nid="+hdid;
		stmt.executeUpdate(strsql);
	}
	if (naction!=null && naction.equals("xiajia"))
	{		
		strsql="update tbl_cxhd set syxs=0 where nid="+hdid;
		stmt.executeUpdate(strsql);
	}
	if (naction!=null && naction.equals("shangjia"))
	{		
		strsql="update tbl_cxhd set syxs=1 where nid="+hdid;
		stmt.executeUpdate(strsql);
	}
	if (naction!=null && naction.equals("gg"))
	{		
		strsql="update tbl_cxhd set sfgg=1 where nid="+hdid;
		stmt.executeUpdate(strsql);
	}
	if (naction!=null && naction.equals("nogg"))
	{		
		strsql="update tbl_cxhd set sfgg=0 where nid="+hdid;
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
            <td><div class="local"><span>商品管理&gt; 活动管理</span></div></td>
          </tr>
          <tr>
            <td>
					<div class="caxunbox">
					
					<div class="caxun-r"><a href="sphdbianji.jsp" class="daorutxt">增加活动</a></div>
				</div>
			</td>
          </tr>
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">
            <%
            	
            	strsql="select count(nid) as hn from tbl_cxhd";           		
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
                   <th width="40%">标题</th>
                   <th width="10%">开始时间</th>
                   <th width="10%">结束时间</th>
                   <th width="10%">显示位置</th>
                   <th width="10%">广告栏</th>                 
                   <th>操作</th>
                 </tr>
                  <%
                  strsql="select nid,bt,ksrq,jsrq,xswz,syxs,sfgg from tbl_cxhd";                  
                  strsql+=" order by nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;
                  rs=stmt.executeQuery(strsql);
                  while(rs.next())
                  {
                  %>
                  <tr>                  	
                    <td class="textbreak"><%=rs.getString("bt")==null?"":rs.getString("bt")%></td>
                    <td><%=sf.format(rs.getDate("ksrq"))%></td>
                    <td><%=sf.format(rs.getDate("jsrq"))%></td>
                    <td><%=rs.getString("xswz")==null?"":rs.getString("xswz")%></td>
                    <td> <%if (rs.getInt("sfgg")==0) out.print("<a href='sphdgl.jsp?naction=gg&hdid="+rs.getString("nid")+"'>否</a>"); else out.print("<a href='sphdgl.jsp?naction=nogg&hdid="+rs.getString("nid")+"'>是</a>"); %></td>
                    <td><a href="sphdbianji.jsp?hdid=<%=rs.getString("nid")%>&pno=${param.pno}" class="blue">修改</a>
                    &nbsp;&nbsp;&nbsp;&nbsp;<%if (rs.getInt("syxs")==1) out.print("<a href='sphdgl.jsp?naction=xiajia&pno="+(request.getParameter("pno")==null?"1":request.getParameter("pno"))+"&hdid="+rs.getString("nid")+"' class='blue'>下架</a>"); else out.print("<a href='sphdgl.jsp?naction=shangjia&pno="+(request.getParameter("pno")==null?"1":request.getParameter("pno"))+"&hdid="+rs.getString("nid")+"' class='blue'>上架</a>"); %>&nbsp;&nbsp;&nbsp;&nbsp;<%if (rs.getInt("syxs")==0) out.print("<a href='javascript:void(0);' class='blue' onclick='delit("+rs.getString("nid")+")'>删除</a>"); %></td>
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