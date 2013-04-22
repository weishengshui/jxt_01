<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%

if (session.getAttribute("xtyh")==null || session.getAttribute("xtyh").equals(""))
{
response.sendRedirect("index.jsp");
return;
}
%>