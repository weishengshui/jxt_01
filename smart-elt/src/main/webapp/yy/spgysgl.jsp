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
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("4006")==-1)
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

String gysmc=request.getParameter("gysmc");
if (gysmc!=null)
{
	gysmc=fun.unescape(gysmc);
	gysmc=URLDecoder.decode(gysmc,"utf-8");
}
if (gysmc==null) gysmc="";

String lxr=request.getParameter("lxr");
if (lxr!=null)
{
	lxr=fun.unescape(lxr);
	lxr=URLDecoder.decode(lxr,"utf-8");
}
if (lxr==null) lxr="";


String naction=request.getParameter("naction");
String gysid=request.getParameter("gysid");
if ( !fun.sqlStrCheck(pno) || !fun.sqlStrCheck(gysid))
{	
	response.sendRedirect("spgysgl.jsp");
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
	location.href="spgysgl.jsp?pno="+p+"&gysmc="+encodeURI(escape(document.getElementById("gysmc").value))+"&lxr="+encodeURI(escape(document.getElementById("lxr").value));
}
function delit(lid)
{
	if (confirm("确认删除此供应商，删除后无法恢复"))
	{
		location.href="spgysgl.jsp?naction=del&gysid="+lid+"&pno=<%=pno%>&gysmc="+encodeURI(escape(document.getElementById("gysmc").value))+"&lxr="+encodeURI(escape(document.getElementById("lxr").value));
	}
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="4006";
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
try{
	if (naction!=null && naction.equals("del"))
	{
		strsql="delete from tbl_spgys where nid="+gysid;
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
            <td><div class="local"><span>商品管理&gt; 供应商管理</span></div></td>
          </tr>
          <tr>
            <td>
					<div class="caxunbox">
					<div class="caxun">
						<span>供应商名称：</span><input type="text" class="inputbox" style="width: 80px;" name="gysmc" id="gysmc" value="<%=gysmc%>" />
						<span>联系人：</span><input type="text" class="inputbox" style="width: 80px;" name="lxr" id="lxr" value="<%=lxr%>" />
						
						<input name="" type="button"  onclick="searchit(1)" class="findbtn"/>
					</div>
					<div class="caxun-r"><a href="spgysbianji.jsp" class="daorutxt">增加供应商</a></div>
				</div>
			</td>
          </tr>
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">
            <%
            	
            	strsql="select count(nid) as hn from tbl_spgys where 1=1"; 
            	if (gysmc!=null && gysmc.length()>0)
            		strsql+=" and gysmc like '%"+gysmc+"%'";
            	if (lxr!=null && lxr.length()>0)
            		strsql+=" and lxr like '%"+lxr+"%'";
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
                   <th width="20%">供应商</th>
                   <th width="30%">地址</th>
                   <th width="10%">联系人</th>
                   <th width="10%">联系人电话</th>                
                   <th width="10%">类型</th>
                   <th>操作</th>
                 </tr>
                  <%
                  strsql="select nid,gysmc,dz,lxr,lxrdh,gtype from tbl_spgys where 1=1";
                  if (gysmc!=null && gysmc.length()>0)
              		strsql+=" and gysmc like '%"+gysmc+"%'";
              	 if (lxr!=null && lxr.length()>0)
              		strsql+=" and lxr like '%"+lxr+"%'";
                  strsql+=" order by nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;
                  rs=stmt.executeQuery(strsql);
                  while(rs.next())
                  {
                  %>
                  <tr>                  	
                    <td class="textbreak"><%=rs.getString("gysmc")==null?"":rs.getString("gysmc")%></td>
                    <td class="textbreak"><%=rs.getString("dz")==null?"":rs.getString("dz")%></td>
                    <td><%=rs.getString("lxr")==null?"":rs.getString("lxr")%></td>
                    <td><%=rs.getString("lxrdh")==null?"":rs.getString("lxrdh")%></td>
                    <td><%=rs.getInt("gtype")==1?"供货商":"物流商"%></td>                      
                    <td><a href="spgysbianji.jsp?gysid=<%=rs.getString("nid")%>&pno=${param.pno}" class="blue">修改</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" class="blue" onclick="delit(<%=rs.getString("nid")%>)">删除</a></td>
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