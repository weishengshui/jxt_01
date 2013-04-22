<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.DbPool"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="jxt.elt.common.SecurityUtil"%>

<%request.setCharacterEncoding("UTF-8"); %>
<%
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;


try
{
	SecurityUtil su=new SecurityUtil();
	
	StringBuffer ygidstr=new StringBuffer();
	StringBuffer dlmmstr=new StringBuffer();
	String strsql="select nid,dlmm from tbl_qyyg where IFNULL(dlmm,'')<>''";
	rs=stmt.executeQuery(strsql);
	while (rs.next())
	{
		ygidstr.append(rs.getString(1)+",");
		dlmmstr.append(rs.getString(2)+",");
	}
	rs.close();
	
	
	String[] ygidarr=ygidstr.toString().split(",");
	String[] dlmmarr=dlmmstr.toString().split(",");
	for (int i=0;i<ygidarr.length;i++)
	{
		if (dlmmarr[i]!=null && dlmmarr[i].length()>0)
		{
			strsql="update tbl_qyyg set dlmm='"+su.md5(dlmmarr[i])+"' where nid="+ygidarr[i];
			stmt.executeUpdate(strsql);
		}
	}
	
	StringBuffer xtidstr=new StringBuffer();
	StringBuffer xtmmstr=new StringBuffer();
	StringBuffer xtffmmstr=new StringBuffer();
	StringBuffer xtqymmstr=new StringBuffer();
	strsql="select nid,dlmm,ffmm,syffmm from tbl_xtyh";
	rs=stmt.executeQuery(strsql);
	while (rs.next())
	{
		xtidstr.append(rs.getString(1)+",");
		xtmmstr.append(rs.getString(2)==null?"":rs.getString(2)+",");
		xtffmmstr.append(rs.getString(3)==null?"":rs.getString(3)+",");
		xtqymmstr.append(rs.getString(4)==null?"":rs.getString(4)+",");
	}
	rs.close();
	
	
	String[] xtidarr=xtidstr.toString().split(",");
	String[] xtmmarr=xtmmstr.toString().split(",");
	String[] xtffmmarr=xtffmmstr.toString().split(",");
	String[] xtqymmarr=xtqymmstr.toString().split(",");
	for (int i=0;i<xtidarr.length;i++)
	{
		if (xtmmarr[i]!=null && xtmmarr[i].length()>0)
		{
			strsql="update tbl_xtyh set dlmm='"+su.md5(xtmmarr[i])+"' where nid="+xtidarr[i];
			stmt.executeUpdate(strsql);
		}
		if (xtffmmarr[i]!=null && xtffmmarr[i].length()>0)
		{
			strsql="update tbl_xtyh set ffmm='"+su.md5(xtffmmarr[i])+"' where nid="+xtidarr[i];
			stmt.executeUpdate(strsql);
		}
		if (xtqymmarr[i]!=null && xtqymmarr[i].length()>0)
		{
			
			strsql="update tbl_xtyh set syffmm='"+su.md5(xtqymmarr[i])+"' where nid="+xtidarr[i];			
			stmt.executeUpdate(strsql);
		}
	}
	
	
	
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
