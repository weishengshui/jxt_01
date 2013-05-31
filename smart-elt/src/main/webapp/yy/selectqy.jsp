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
String qymc = request.getParameter("qymc");
String jlmc = request.getParameter("jlmc");
String condition = "";
    
if (null == qymc || qymc.isEmpty()) {
    qymc = "";
} else {
	qymc = new String(qymc.getBytes("ISO8859-1"), "UTF-8");
	if (fun.sqlStrCheck(qymc)) {
		condition += " and qymc like '%" + qymc + "%' ";
	} else {
	    qymc = "";
	}
}

if (null == jlmc || jlmc.isEmpty()) {
    jlmc = "";
} else {
	jlmc = new String(jlmc.getBytes("ISO8859-1"), "UTF-8");
	if (fun.sqlStrCheck(jlmc)) {
		condition += " and khjl like '%" + jlmc + "%' ";
	} else {
	    jlmc = "";
	}
}
try
{
%>
		<div class="findyg">
		<span class="findyg-title">查找企业</span>
		<div class="find-top">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="43" height="31">企业名</td>
				<td width="140"><input type="text" class="input7" name="qymc" id="qymc" style="margin:0; width:95px" value="<%=qymc%>"/></td>
				<td width="57" height="31">客户经理</td>
				<td width="140"><input type="text" class="input7" name="jlmc" id="jlmc" style="margin:0; width:95px" value="<%=jlmc%>"/></td>			
				<td><span onclick="searchQyList()" class="caxun2">查找</span></td>
			  </tr>
			</table>
		</div>
		<div class="workers" id="dspllist">
			
			
				<%
				int index = 1;
				int ln=0,pages=1;
// 				strsql="select count(nid) as hn from tbl_qy";
				strsql="select count(nid) as hn from tbl_qy where (zt=2 or zt=4)" + condition;
				rs=stmt.executeQuery(strsql);
				if (rs.next())
				{
					ln=rs.getInt("hn");
				}
				rs.close();
				pages=(ln-1)/10+1;
				
// 				strsql="select nid, qymc, khjl from tbl_qy";
				strsql="select nid, qymc, khjl from tbl_qy where (zt=2 or zt=4)" + condition;
				rs=stmt.executeQuery(strsql);
				while (rs.next())
				{
				    int indexNum = index/10;
				    if (index % 10 == 1) {
				        %>
				        <div class="workers-t" name="qyfyTitle" id="qyfyTitle<%=indexNum%>" <%if (indexNum != 0) {out.print("style=\"display:none\"");}%>>
							<div class="workers1"><h1><input type="checkbox" onclick="selectAllqy(this)"></h1><span>全选</span></div>
							<div class="workers4">企业名</div>
							<div class="workers4">客户经理</div>
						</div>
				        <ul class="workersin" name="qyfy" id="qyfy<%=indexNum%>" <%if (indexNum != 0) {out.print("style=\"display:none\"");}%>>
				        <%
				    }
				%>
				<li>
					<div class="workersin1">					
					<input type="checkbox" name="qyid" id="qyid<%=index-1%>" value="<%=rs.getInt("nid")%>" title="<%=rs.getString("qymc")%>" />
					</div>
					<div class="workersin4"><%=rs.getString("qymc") %></div>
					<div class="workersin4"><%=rs.getString("khjl") == null ? "" : rs.getString("khjl")%></div>
				</li>
				
				<%
				 if (index % 10 == 0) {
				     %>
				        </ul>
				     <%
				    }
				index++;
				}
				 if (index % 10 != 0) {
				     %>
				        </ul>
				     <%
				    }
				%>
			
		</div>
		
			<div class="pages-worker">				
				<div class="pages-l">
				<%for (int i=1;i<=pages;i++) {
				%>
				<a href="javascript:void(0);" name="fytag" id="fytag<%=i-1%>" <%if (i==1) out.print(" class='psel'"); %> onclick="selectqyfy(<%=i%>)"><%=i%></a>
				<%
				if (i>=6) break;
				} %>
				</div>
				<div class="pages-r">
				<input type="hidden" id="pagesNum" value="<%=pages%>">
				<input type="hidden" id="currentPage" value="1">
				<%if (pages>1) out.print("<h2><a href='javascript:void(0);' onclick='nextqyfy()'>下一页</a></h2>");%>					
				</div>		
			</div>
		
		<div class="workerbtn">
			<span class="floatleft" style="padding-right:12px"><span onclick="getQyList()" class="caxun2">选择</span></span><span class="floatleft"><span onclick="closeLayer()" class="caxun2">取消关闭</span></span>
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