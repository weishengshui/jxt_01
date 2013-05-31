<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
int menun=0;
if (session.getAttribute("ygid")==null || session.getAttribute("ygid").equals(""))
{
response.sendRedirect("../index.jsp");
return;
}
boolean isAuth = false;
boolean isLeader = false;
Object glqxObj = session.getAttribute("glqx");
if (glqxObj==null || glqxObj.toString().indexOf(",10,")==-1) {
	isAuth = false;
} else {
	isAuth = true;
}
if (session.getAttribute("ffjf")!=null && session.getAttribute("ffjf").equals("1")) {
	isLeader = true;
} else {
	isLeader = false;
}
%>