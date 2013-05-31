<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@ include file="../common/yylogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>

<%
String t=request.getParameter("t");
String gtype=request.getParameter("gtype");
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
Fun fun=new Fun();
String strsql="",bmmc="";

if (!fun.sqlStrCheck(gtype))
	return;
try
{
			
%>			
		
		<div class="findyg">
		<span class="findyg-title">查找供应商</span>
		<div class="find-top">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="70">供应商名称</td>
				<td width="115"><input type="text" class="input7" name="sgysmc" id="sgysmc" style="margin:0; width:95px" /></td>
				<td width="50">联系人</td>
				<td width="115"><input type="text" class="input7" name="slxr" id="slxr" style="margin:0; width:95px" /></td>
				<td><span onclick="sgysagain(1)" class="caxun2">查找</span></td>
			  </tr>
			</table>
		</div>
		<div class="workers" id="dspllist">
			<div class="workers-t">
				<div class="workers1">&nbsp;</div>
				<div class="workers4">供应商名称</div>
				<div class="workers1">联系人</div>
				<div class="workers1">联系电话</div>
			</div>
			<ul class="workersin">
				<%
				int ln=0,pages=1;
				strsql="select count(nid) as hn from tbl_spgys where 1=1";
				if (gtype!=null && gtype.length()>0)
					strsql=strsql+" and gtype="+gtype;
				rs=stmt.executeQuery(strsql);
				if (rs.next())
				{
					ln=rs.getInt("hn");
				}
				rs.close();
				pages=(ln-1)/10+1;
				
				strsql="select nid,gysmc,dz,lxr,lxrdh from tbl_spgys where 1=1";
				if (gtype!=null && gtype.length()>0)
					strsql=strsql+" and gtype="+gtype;
				strsql+=" order by nid desc limit 10";
				rs=stmt.executeQuery(strsql);
				while (rs.next())
				{
				%>
				<li>
					<div class="workersin1">					
					<input type="radio" name="sgysid" id="sgysid" value="<%=rs.getInt("nid")%>" title="<%=rs.getString("gysmc")%>" />					
					</div>
					<div class="workersin4"><%=rs.getString("gysmc") %></div>
					<div class="workersin1"><%=rs.getString("lxr") %></div>
					<div class="workersin1"><%=rs.getString("lxrdh") %></div>
				</li>
				
				<%
				}
				%>
				
			</ul>
			<div class="pages-worker">				
				<div class="pages-l">
				<%for (int i=1;i<=pages;i++) {
				%>
				<a href="javascript:void(0);" <%if (i==1) out.print(" class='psel'"); %> onclick="sgysagain(<%=i%>)"><%=i%></a>
				<%
				if (i>=6) break;
				} %>
				</div>
				<div class="pages-r">
				<%if (pages>1) out.print("<h2><a href='javascript:void(0);' onclick='sgysagain(2)'>下一页</a></h2>");%>					
				</div>		
			</div>
		</div>
		
		<div class="workerbtn">
			<span class="floatleft" style="padding-right:12px"><span onclick="getgys()" class="caxun2">选择</span></span><span class="floatleft"><span onclick="closeLayer()" class="caxun2">取消关闭</span></span>
		</div>
	</div>
	
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