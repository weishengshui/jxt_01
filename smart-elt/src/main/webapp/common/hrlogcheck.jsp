<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
int menun=0;
if (session.getAttribute("ygid")==null || session.getAttribute("ygid").equals(""))
{
response.sendRedirect("../index.jsp");
return;
}
%>