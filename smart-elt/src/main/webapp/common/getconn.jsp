<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="javax.naming.Context"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%
Context initCtx = new InitialContext(); 
Context ctx = (Context) initCtx.lookup("java:comp/env");
DataSource ds = (DataSource) ctx.lookup("jdbc/elt"); 
%>