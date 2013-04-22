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
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("4007")==-1)
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

String gys=request.getParameter("gys");
if (gys!=null)
{
	gys=fun.unescape(gys);
	gys=URLDecoder.decode(gys,"utf-8");
}
if (gys==null) gys="";

String sp=request.getParameter("sp");
if (sp!=null)
{
	sp=fun.unescape(sp);
	sp=URLDecoder.decode(sp,"utf-8");
}
if (sp==null) sp="";


String naction=request.getParameter("naction");
String jhid=request.getParameter("jhid");
if ( !fun.sqlStrCheck(pno) || !fun.sqlStrCheck(jhid))
{	
	response.sendRedirect("spjhgl.jsp");
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
	location.href="spjhgl.jsp?pno="+p+"&gys="+encodeURI(escape(document.getElementById("gys").value))+"&sp="+encodeURI(escape(document.getElementById("sp").value));
}
function delit(lid)
{
	if (confirm("确认删除此进货数据，删除后无法恢复,也不更新库存量"))
	{
		location.href="spjhgl.jsp?pno=${param.pno}&naction=del&jhid="+lid+"&pno=<%=pno%>&gys="+encodeURI(escape(document.getElementById("gys").value))+"&sp="+encodeURI(escape(document.getElementById("sp").value));
	}
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="4007";
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
try{
	if (naction!=null && naction.equals("del"))
	{
		strsql="update tbl_spjh set zt=-1 where nid="+jhid;
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
            <td><div class="local"><span>商品管理&gt; 进货管理</span></div></td>
          </tr>
          <tr>
            <td>
					<div class="caxunbox">
					<div class="caxun">
						<span>供应名称：</span><input type="text" class="inputbox" style="width: 80px;" name="gys" id="gys" value="<%=gys%>" />
						<span>商品名称：</span><input type="text" class="inputbox" style="width: 80px;" name="sp" id="sp" value="<%=sp%>" />
						
						<input name="" type="button"  onclick="searchit(1)" class="findbtn"/>
					</div>
					<div class="caxun-r"><a href="spjhbianji.jsp" class="daorutxt">增加进货</a></div>
				</div>
			</td>
          </tr>
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">
            <%
            	
            	strsql="select count(j.nid) as hn from tbl_spjh j left join tbl_spgys g on j.gys=g.nid left join tbl_sp s on j.sp=s.nid where j.zt>=0"; 
            	if (gys!=null && gys.length()>0)
            		strsql+=" and g.gysmc like '%"+gys+"%'";
            	if (sp!=null && sp.length()>0)
            		strsql+=" and s.spmc like '%"+sp+"%'";
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
                   <th width="10%">进货日期</th>
                   <th width="10%">进货编号</th> 
                   <th width="25%">商品名称</th>
                   <th width="25%">供应商</th>
                   <th width="10%">数量</th>
                   <th width="10%">虚拟</th>                
                   <th>操作</th>
                 </tr>
                  <%
                  strsql="select j.nid,j.jhbh,j.jhsj,j.sfxn,s.spmc,g.gysmc,j.sl from tbl_spjh j left join tbl_spgys g on j.gys=g.nid left join tbl_sp s on j.sp=s.nid where  j.zt>=0"; 
                  if (gys!=null && gys.length()>0)
              		strsql+=" and g.gysmc like '%"+gys+"%'";
              	  if (sp!=null && sp.length()>0)
              		strsql+=" and s.spmc like '%"+sp+"%'";
                  strsql+=" order by j.nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;
                  rs=stmt.executeQuery(strsql);
                  while(rs.next())
                  {
                  %>
                  <tr>                  	
                    <td><%=sf.format(rs.getDate("jhsj"))%></td>
                    <td><%=rs.getString("jhbh")%></td>
                    <td><%=rs.getString("spmc")%></td>
                    <td><%=rs.getString("gysmc")%></td>
                    <td><%=rs.getString("sl")%></td>
                    <td><%=rs.getInt("sfxn")==1?"是":"否"%></td>                   
                    <td><a href="#" class="blue" onclick="delit(<%=rs.getString("nid")%>)">删除</a></td>
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