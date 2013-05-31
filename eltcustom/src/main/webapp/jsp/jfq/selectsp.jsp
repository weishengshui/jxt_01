<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.ssh.util.SecurityUtil"%>
<%@page import="com.ssh.util.DbPool"%>

<script type="text/javascript" src="common/js/common.js"></script>

<%
String t=request.getParameter("t");
String ids=request.getParameter("ids");
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="",bmmc="";
try
{
			
%>			
		<div class="findyg">
		<div class="workers" id="dspllist">
			<div class="workers-t">
				<div class="workers1">&nbsp;</div>
				<div class="workers4">商品名称</div>
				<div class="workers1">类目1</div>
				<div class="workers1">类目2</div>				
				<div class="workers1">库存</div>
				<div class="workers1">积分</div>
			</div>
			<ul class="workersin">
				<%
				int ln=0,pages=1;
				strsql="select count(nid) as hn from tbl_sp where zt>=0 and nid in ("+ids+")";
				if (t!=null && t.equals("more"))
					strsql+=" and wcdsl>=kcyj";
				if (t!=null && t.equals("more2"))
					strsql+=" and wcdsl>0";
				rs=stmt.executeQuery(strsql);
				if (rs.next())
				{
					ln=rs.getInt("hn");
				}
				rs.close();
				pages=(ln-1)/10+1;
				
				strsql="select s.nid,l.mc as lmc,s.spmc as spmc,m1.mc as lmmc1,m2.mc as lmmc2,m3.mc as lmmc3,s.wcdsl,s.qbjf,s.cxjf from tbl_sp s left join tbl_spl l on s.spl=l.nid left join tbl_splm m1 on l.lb1=m1.nid left join tbl_splm m2 on l.lb2=m2.nid left join tbl_splm m3 on l.lb3=m3.nid where s.zt>=0 and s.nid in ("+ids+")";
				if (t!=null && t.equals("more"))
					strsql+=" and wcdsl>=kcyj";
				if (t!=null && t.equals("more2"))
					strsql+=" and wcdsl>0";
				strsql+=" order by s.nid desc limit 10";
				rs=stmt.executeQuery(strsql);
				while (rs.next())
				{
				%>
				<li>
					<div class="workersin1">					
					<%if (t!=null && t.equals("more")) {%>
					<input type="checkbox" name="sspid" id="sspid" value="<%=rs.getInt("nid")%>,<%=rs.getInt("wcdsl")%>" title="<%=rs.getString("spmc")%>" />	
					<% }else {%>				
					<input type="radio" name="sspid" id="sspid" value="<%=rs.getInt("nid")%>" title="<%=rs.getString("spmc")%>" />	
					<%} %>									
					</div>
					<div class="workersin4" style="overflow: hidden;white-space: nowrap;"><%=rs.getString("spmc") %></div>
					<div class="workersin1" style="overflow: hidden;white-space: nowrap;"><%=rs.getString("lmmc1")==null?"":rs.getString("lmmc1") %></div>
					<div class="workersin1" style="overflow: hidden;white-space: nowrap;"><%=rs.getString("lmmc2")==null?"":rs.getString("lmmc2")  %></div>					
					<div class="workersin1"><%=rs.getString("wcdsl")%></div>
					<%
					String spjf = rs.getString("qbjf");
					String cxjf = rs.getString("cxjf");
					if (cxjf != null && !"".equals(cxjf) && !"0".equals(cxjf)) {
						spjf = cxjf;
					}
					%>
					<div class="workersin1"><%=spjf%></div>
				</li>
				
				<%
				}
				%>
				
			</ul>
			<div class="pages-worker">				
				<div class="pages-l">
				<%for (int i=1;i<=pages;i++) {
				%>
				<a href="javascript:void(0);" <%if (i==1) out.print(" class='psel'"); %> onclick="sspagain(<%=i%>)"><%=i%></a>
				<%
				if (i>=6) break;
				} %>
				</div>
				<div class="pages-r">
				<%if (pages>1) out.print("<h2><a href='javascript:void(0);' onclick='sspagain(2)'>下一页</a></h2>");%>					
				</div>		
			</div>
		</div>
		
		<div class="workerbtn">
			<span class="floatleft" style="padding-right:12px"><span onclick="getsp()" class="xzsp">选择</span></span><span class="floatleft"><span onclick="closeLayer()" class="xzsp">取消关闭</span></span>
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