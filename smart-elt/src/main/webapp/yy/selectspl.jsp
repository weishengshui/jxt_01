<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@ include file="../common/yylogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>

<%
String t=request.getParameter("t");
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
Statement stmt2=conn.createStatement();
ResultSet rs2=null;
Fun fun=new Fun();
String strsql="",bmmc="";
try
{
			
%>			
		
		<div class="findyg">
		<span class="findyg-title">查找商品系列</span>
		<div class="find-top">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="43" height="31">系列名</td>
				<td width="140"><input type="text" class="input7" name="ssplmc" id="ssplmc" style="margin:0; width:95px" /></td>
				<td width="34">类目</td>
				<td width="300"><span id='lblist1'>
											<select name="lb1" id="lb1" onchange='lbshow(this.value,1)'>
											<option value="">全部</option>
											<%
											strsql="select nid,mc from tbl_splm where flm=0 order by xswz desc";
											rs=stmt.executeQuery(strsql);
											while (rs.next())
											{
												out.print("<option value='"+rs.getString("nid")+"'>"+rs.getString("mc")+"</option>");
											}
											rs.close();
											%>
											</select>
				</span><span id='lblist2'></span></td>				
				
				<td><span onclick="ssplagain(1)" class="caxun2">查找</span></td>
			  </tr>
			</table>
		</div>
		<div class="workers" id="dspllist">
			<div class="workers-t">
				<div class="workers1">&nbsp;</div>
				<div class="workers4">系列名</div>
				<div class="workers1">类目1</div>
				<div class="workers1">类目2</div>
				<div class="workers1">类目3</div>
			</div>
			<ul class="workersin">
				<%
				int ln=0,pages=1;
				strsql="select count(nid) as hn from tbl_spl where zt>=0";
				rs=stmt.executeQuery(strsql);
				if (rs.next())
				{
					ln=rs.getInt("hn");
				}
				rs.close();
				pages=(ln-1)/10+1;
				
				strsql="select l.nid,l.mc as lmc,l.zt,s.spmc as spmc,m1.mc as lmmc1,m2.mc as lmmc2,m3.mc as lmmc3 from tbl_spl l left join tbl_sp s on l.sp=s.nid left join tbl_splm m1 on l.lb1=m1.nid left join tbl_splm m2 on l.lb2=m2.nid left join tbl_splm m3 on l.lb3=m3.nid where l.zt>=0 order by l.nid desc limit 10";
				rs=stmt.executeQuery(strsql);
				while (rs.next())
				{
				%>
				<li>
					<div class="workersin1">					
					<input type="radio" name="splid" id="splid" value="<%=rs.getInt("nid")%>" title="<%=rs.getString("lmc")%>" />					
					</div>
					<div class="workersin4"><%=rs.getString("lmc") %></div>
					<div class="workersin1" style="overflow: hidden;white-space: nowrap;"><%=rs.getString("lmmc1")==null?"":rs.getString("lmmc1") %></div>
					<div class="workersin1" style="overflow: hidden;white-space: nowrap;"><%=rs.getString("lmmc2")==null?"":rs.getString("lmmc2") %></div>
					<div class="workersin1" style="overflow: hidden;white-space: nowrap;"><%=rs.getString("lmmc3")==null?"":rs.getString("lmmc3") %></div>
				</li>
				
				<%
				}
				%>
				
			</ul>
			<div class="pages-worker">				
				<div class="pages-l">
				<%for (int i=1;i<=pages;i++) {
				%>
				<a href="javascript:void(0);" <%if (i==1) out.print(" class='psel'"); %> onclick="ssplagain(<%=i%>)"><%=i%></a>
				<%
				if (i>=6) break;
				} %>
				</div>
				<div class="pages-r">
				<%if (pages>1) out.print("<h2><a href='javascript:void(0);' onclick='ssplagain(2)'>下一页</a></h2>");%>					
				</div>		
			</div>
		</div>
		
		<div class="workerbtn">
			<span class="floatleft" style="padding-right:12px"><span onclick="getspl()" class="caxun2">选择</span></span><span class="floatleft"><span onclick="closeLayer()" class="caxun2">取消关闭</span></span>
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