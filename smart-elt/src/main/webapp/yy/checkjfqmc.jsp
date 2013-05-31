<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%><%@page import="java.sql.Connection"%><%@page import="java.sql.Statement"%><%@page import="java.sql.ResultSet"%><%@page import="jxt.elt.common.Fun"%><%-- <%@ include file="../common/yylogcheck.jsp" %> --%><%@page import="jxt.elt.common.DbPool"%><%request.setCharacterEncoding("UTF-8");
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
conn.setAutoCommit(false);
int conncommit=1;
Statement stmt=conn.createStatement();
ResultSet rs=null;
String jfqmc = request.getParameter("jfqmc");
if (jfqmc == null) {
    jfqmc = "";
}
String jfjid = request.getParameter("jfjid");
if (null == jfjid) {
    jfjid = "";
}
jfqmc = new String(jfqmc.getBytes("ISO8859-1"), "UTF-8");
if (fun.sqlStrCheck(jfqmc) && fun.sqlStrCheck(jfjid)){
    if (!jfjid.isEmpty()) {
		String strsql = "select count(*) as hn from tbl_jfq where nid = "+ jfjid +" and mc = '" + jfqmc + "'";
		rs = stmt.executeQuery(strsql);
		if (rs.next()) {
		    int hn = rs.getInt("hn");
		    if (hn != 0) {
		        out.print(1);
		        return;
		    } 
		}
		rs.close();
    }
	String strsql = "select count(*) as hn from tbl_jfq where mc = '" + jfqmc + "'";
	rs = stmt.executeQuery(strsql);
	if (rs.next()) {
	    int hn = rs.getInt("hn");
	    if (hn == 0) {
	        out.print(1);
	    } else {
	        out.print(0);
	    }
	}
} else {
    out.print(-1);
}
%>