<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>

<%
String t=request.getParameter("t");
String xid=request.getParameter("xid");
String qxid=request.getParameter("qxid");
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
Statement stmt2=conn.createStatement();
ResultSet rs2=null;
Fun fun=new Fun();
String strsql="",bmmc="";
int fflx=0,lxbh=0;
try
{
			
%>			
		
		<div class="findyg">
		<span class="findyg-title">查找员工</span>
		<div class="find-top">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="43" height="31">姓名</td>
				<td width="140"><input type="text" class="input7" name="dsygxm" id="dsygxm" style="margin:0; width:95px" /></td>
				<td width="34">部门</td>
				<td width="125" valign="top"><div id="tm2008style" style="margin:0px">
											<select name="dsbm" id="dsbm" style="height: 30px;">
												<option value="">所有</option>
												<%
												strsql="select nid, bmmc from tbl_qybm where qy="+session.getAttribute("qy")+" and fbm=0";
												rs=stmt.executeQuery(strsql);
												while (rs.next())
												{
													out.print("<option value='"+rs.getString("nid")+"'>"+rs.getString("bmmc")+"</option>");
												}
												rs.close();
												%>
											</select>
				</div></td>
				<td width="34">邮箱</td>
				<td width="122"><input type="text" class="input7" name="dsemail" id="dsemail" style="margin:0; width:95px" /></td>
				<td><span onclick="sygagain(1,<%=t%>)" class="caxun2">查 寻</span></td>
			  </tr>
			</table>
		</div>
		<div class="workers" id="dyglist">
			<div class="workers-t">
				<div class="workers1"><%if (t!=null && t.equals("0")) {%><h1><input type="checkbox" name="sygsa" id="sygsa" onclick="allselyg()" /></h1><span>全选</span><%} else out.print("&nbsp;"); %></div>
				<div class="workers2">姓名</div>
				<div class="workers3">部门</div>
				<div class="workers4">邮箱</div>
			</div>
			<ul class="workersin">
				<%
				if (xid!=null && xid.length()>0)
				{
					strsql="select fflx,lxbh from tbl_jfffxx where nid="+xid;
					rs=stmt.executeQuery(strsql);
					if (rs.next())
					{
						fflx=rs.getInt("fflx");
						lxbh=rs.getInt("lxbh");
					}
					rs.close();
				}
				
				if (qxid!=null && qxid.length()>0)
				{
					strsql="select fflx,lxbh from tbl_jfqffxx where nid="+qxid;
					rs=stmt.executeQuery(strsql);
					if (rs.next())
					{
						fflx=rs.getInt("fflx");
						lxbh=rs.getInt("lxbh");
					}
					rs.close();
				}
				
				int ln=0,pages=1;
				
				if (fflx==1)
					strsql="select count(nid) as hn from tbl_qyyg where qy="+session.getAttribute("qy")+" and xtzt<>3 and zt=1 and bm like '%,"+lxbh+",%'";
				
				if (fflx==2)
					strsql="select count(x.nid) as hn from tbl_qyxzmc x inner join tbl_qyyg y on x.yg=y.nid where x.xz="+lxbh+"  and y.xtzt<>3  and y.zt=1";
				if (fflx==0)
					strsql="select count(nid) as hn from tbl_qyyg where qy="+session.getAttribute("qy")+" and xtzt<>3 and zt=1";
				
				rs=stmt.executeQuery(strsql);
				if (rs.next())
				{
					ln=rs.getInt("hn");
				}
				rs.close();
				pages=(ln-1)/10+1;
				
				
				if (fflx==1)
					strsql="select nid,ygxm,email,bm from tbl_qyyg where qy="+session.getAttribute("qy")+" and xtzt<>3  and zt=1 and bm like '%,"+lxbh+",%'  order by nid limit 10";
				
				if (fflx==2)
					strsql="select y.nid,y.ygxm,y.email,y.bm from tbl_qyxzmc x inner join tbl_qyyg y on x.yg=y.nid where x.xz="+lxbh+"  and y.xtzt<>3  and y.zt=1 order by y.nid limit 10";
				if (fflx==0)					
					strsql="select nid,ygxm,email,bm  from tbl_qyyg where qy="+session.getAttribute("qy")+" and xtzt<>3  and zt=1 order by nid desc limit 10";
				rs=stmt.executeQuery(strsql);
				while (rs.next())
				{
				%>
				<li>
					<div class="workersin1">
					<%if (t!=null && t.equals("0")) {%>
					<input type="checkbox" name="yg" id="yg" value="<%=rs.getInt("nid")%>" title="<%=rs.getString("ygxm")%>" />
					<%} %>
					<%if (t!=null && t.equals("1")) {%>
					<input type="radio" name="yg" id="yg" value="<%=rs.getInt("nid")%>" title="<%=rs.getString("ygxm")%>" />
					<%} %>
					</div>
					<div class="workersin2"><%=rs.getString("ygxm") %></div>
					<div class="workersin3">&nbsp;
					<%
					bmmc=rs.getString("bm");
					if (bmmc!=null && bmmc.length()>1)
					{
					strsql="select bmmc from tbl_qybm where nid="+bmmc.substring(1,bmmc.indexOf(",",1));
					rs2=stmt2.executeQuery(strsql);
					if (rs2.next())
					{out.print(rs2.getString("bmmc"));}
					rs2.close();
					}
					%>
					</div>
					<div class="workersin4"><%=rs.getString("email") %></div>
				</li>
				
				<%
				}
				%>
				
			</ul>
			<div class="pages-worker">				
				<div class="pages-l">
				<%for (int i=1;i<=pages;i++) {
				%>
				<a href="javascript:void(0);" <%if (i==1) out.print(" class='psel'"); %> onclick="sygagain(<%=i%>,<%=t%>)"><%=i%></a>
				<%
				if (i>=6) break;
				} %>
				</div>
				<div class="pages-r">
				<%if (pages>1) out.print("<h2><a href='javascript:void(0);' onclick='sygagain(2,"+t+")'>下一页</a></h2>");%>					
				</div>		
			</div>
		</div>
		
		<div class="workersbtn">
			<span class="floatleft" style="padding-right:12px"><span onclick="selectedyg(<%=t%>)" class="caxun2">选择</span></span><span class="floatleft"><span onclick="closeLayer()" class="caxun2">取消关闭</span></span>
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