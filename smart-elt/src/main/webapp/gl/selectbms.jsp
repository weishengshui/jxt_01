<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>

<%

Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
Statement stmt2=conn.createStatement();
Statement stmt3=conn.createStatement();
Statement stmt4=conn.createStatement();
Statement stmt5=conn.createStatement();
Statement stmtt=conn.createStatement();
ResultSet rs=null;
ResultSet rs2=null;
ResultSet rs3=null;
ResultSet rs4=null;
ResultSet rs5=null;
ResultSet rst=null;
Fun fun=new Fun();
String strsql="";
try
{
		%>
		<div class="findyg">
		<span class="findyg-title">选择部门</span>
		<div class="findbm-right"><div style="float: left;">没有期望奖励的部门？赶紧去&nbsp;</div><div style="float: left;"><a href="department.jsp" target='_blank'><img src="images/xzxzbtn.jpg" /></a></div></div>
		<div class="workers" id="dyglist">
			<div class="workers-t">							
				<div class="workers3">　选择</div>
			</div>
			<div class="workersin">
			
			<%
  		String sLine="0",sLine2="0",sLine3="0",sLine4="0",sLine5="0";
  	
  		int haves=0;
  		int j=1;
  		strsql="select b.nid,b.bmmc from tbl_qybm b  where b.qy="+session.getAttribute("qy")+" and b.fbm=0";
  		rs=stmt.executeQuery(strsql);
  		
  		while (rs.next())
  		{	  		  	   
  			if (rs.isFirst())
  			out.print("<div id='D0' style='display:block;'>");
  			out.print("<table class='selbmtbl' width='100%'  border='0' height=18 cellspacing=0 cellpadding=0><tr><td width=16> </td>");
	  		for (j=1;j<sLine.length();j++)
	  		{
	  			if (sLine.substring(j,j+1).equals("1"))
	  				out.print("<td width=16><img border=0 src='images/_1.gif' style='display:block;'></td>");
	  			else
	  				out.print("<td width=16> </td>");
	  		}
	  		
	  		strsql="select nid from tbl_qybm where fbm="+rs.getString("nid");
		    rst=stmtt.executeQuery(strsql);
		    if (rst.next())
		    	haves=1;
		    else
		    	haves=0;
		    rst.close();
		    
	  	    if (rs.isLast())
	  	    {
	  	    	sLine2=sLine +"0";	  	    	
	  	    	if (haves==1)
	  	    		out.print("<td width=16><span style='cursor:hand' id='off"+rs.getString("nid")+"' onclick='fiton(this)'><img border=0 src='images/_4.gif'></span><span style='display:none;cursor:hand' id='on"+rs.getString("nid")+"' onclick='fitoff(this)'><img border=0 src='images/_41.gif'></span></td>");
	  	    	else
	  	    		out.print("<td width=16><img border=0 src='images/_2.gif'></td>");
	  	    	
	  	    }
	  	    else
	  	    {
	  	    	sLine2=sLine +"1";
	  	    	if (haves==1)
	  	    		out.print("<td width=16><span style='cursor:hand' id='off"+rs.getString("nid")+"' onclick='fiton(this)'><img border=0 src='images/_5.gif'></span><span style='display:none;cursor:hand' id='on"+rs.getString("nid")+"' onclick='fitoff(this)'><img border=0 src='images/_51.gif'></span></td>");
	  	    	else
	  	    		out.print("<td width=16><img border=0 src='images/_3.gif'></td>");  	    	
	  	    }
			
	  	    if (haves==1)
	  	    {
	  	    	out.print("<td id='m"+rs.getString("nid")+"' ><input type=\"checkbox\" name=\"bm\" id=\"bm\" value=\""+rs.getInt("nid")+"\" title=\""+rs.getString("bmmc")+"\"/> "+rs.getString("bmmc")+"</font></td>");
				out.print("</tr></table>\n");
	  	    	
	  	    	strsql="select b.nid,b.bmmc from tbl_qybm b  where b.qy="+session.getAttribute("qy")+" and b.fbm="+rs.getString("nid");
	  	  		rs2=stmt2.executeQuery(strsql);
	  	  		
	  	  		while (rs2.next())
	  	  		{	  		  	   
	  	  		if (rs2.isFirst())
	  	  			out.print("<div id='D"+rs.getString("nid")+"' style='display:none;'>");
	  	  	out.print("<table class='selbmtbl' width='100%'  border='0' height=18 cellspacing=0 cellpadding=0><tr><td width=16> </td>");
	  		  		for (j=1;j<sLine2.length();j++)
	  		  		{
	  		  			if (sLine2.substring(j,j+1).equals("1"))
	  		  				out.print("<td width=16><img border=0 src='images/_1.gif' style='display:block;'></td>");
	  		  			else
	  		  				out.print("<td width=16> </td>");
	  		  		}
	  		  		
	  		  		strsql="select nid from tbl_qybm where fbm="+rs2.getString("nid");
	  			    rst=stmtt.executeQuery(strsql);
	  			    if (rst.next())
	  			    	haves=1;
	  			    else
	  			    	haves=0;
	  			    rst.close();
	  			    
	  		  	    if (rs2.isLast())
	  		  	    {
	  		  	    	sLine3=sLine2 +"0";	  	    	
	  		  	    	if (haves==1)
	  		  	    		out.print("<td width=16><span style='cursor:hand' id='off"+rs2.getString("nid")+"' onclick='fiton(this)'><img border=0 src='images/_4.gif'></span><span style='display:none;cursor:hand' id='on"+rs2.getString("nid")+"' onclick='fitoff(this)'><img border=0 src='images/_41.gif'></span></td>");
	  		  	    	else
	  		  	    		out.print("<td width=16><img border=0 src='images/_2.gif'></td>");
	  		  	    	
	  		  	    }
	  		  	    else
	  		  	    {
	  		  	    	sLine3=sLine2 +"1";
	  		  	    	if (haves==1)
	  		  	    		out.print("<td width=16><span style='cursor:hand' id='off"+rs2.getString("nid")+"' onclick='fiton(this)'><img border=0 src='images/_5.gif'></span><span style='display:none;cursor:hand' id='on"+rs2.getString("nid")+"' onclick='fitoff(this)'><img border=0 src='images/_51.gif'></span></td>");
	  		  	    	else
	  		  	    		out.print("<td width=16><img border=0 src='images/_3.gif'></td>");  	    	
	  		  	    }
	  				
	  		  	    if (haves==1)
	  		  	    {
	  		  	    	out.print("<td id='m"+rs2.getString("nid")+"' ><input type=\"checkbox\" name=\"bm\" id=\"bm\" value=\""+rs2.getInt("nid")+"\" title=\""+rs2.getString("bmmc")+"\"/> "+rs2.getString("bmmc")+"</font></td>\n");
		  		  	    
			  	    	out.print("</tr></table>\n");
	  		  	    	
		  		  	    strsql="select b.nid,b.bmmc from tbl_qybm b  where b.qy="+session.getAttribute("qy")+" and b.fbm="+rs2.getString("nid");
			  	  		rs3=stmt3.executeQuery(strsql);
			  	  		
			  	  		while (rs3.next())
			  	  		{	  		  	   
			  	  		if (rs3.isFirst())
			  	  			out.print("<div id='D"+rs2.getString("nid")+"' style='display:none;'>");
			  	  	out.print("<table class='selbmtbl' width='100%'  border='0' height=18 cellspacing=0 cellpadding=0><tr><td width=16> </td>");
			  		  		for (j=1;j<sLine3.length();j++)
			  		  		{
			  		  			if (sLine3.substring(j,j+1).equals("1"))
			  		  				out.print("<td width=16><img border=0 src='images/_1.gif' style='display:block;'></td>");
			  		  			else
			  		  				out.print("<td width=16> </td>");
			  		  		}
			  		  		
			  		  		strsql="select nid from tbl_qybm where fbm="+rs3.getString("nid");
			  			    rst=stmtt.executeQuery(strsql);
			  			    if (rst.next())
			  			    	haves=1;
			  			    else
			  			    	haves=0;
			  			    rst.close();
			  			    
			  		  	    if (rs3.isLast())
			  		  	    {
			  		  	    	sLine4=sLine3 +"0";	  	    	
			  		  	    	if (haves==1)
			  		  	    		out.print("<td width=16><span style='cursor:hand' id='off"+rs3.getString("nid")+"' onclick='fiton(this)'><img border=0 src='images/_4.gif'></span><span style='display:none;cursor:hand' id='on"+rs3.getString("nid")+"' onclick='fitoff(this)'><img border=0 src='images/_41.gif'></span></td>");
			  		  	    	else
			  		  	    		out.print("<td width=16><img border=0 src='images/_2.gif'></td>");
			  		  	    	
			  		  	    }
			  		  	    else
			  		  	    {
			  		  	    	sLine4=sLine3 +"1";
			  		  	    	if (haves==1)
			  		  	    		out.print("<td width=16><span style='cursor:hand' id='off"+rs3.getString("nid")+"' onclick='fiton(this)'><img border=0 src='images/_5.gif'></span><span style='display:none;cursor:hand' id='on"+rs3.getString("nid")+"' onclick='fitoff(this)'><img border=0 src='images/_51.gif'></span></td>");
			  		  	    	else
			  		  	    		out.print("<td width=16><img border=0 src='images/_3.gif'></td>");  	    	
			  		  	    }
			  				
			  		  	    if (haves==1)
			  		  	    {
			  		  	    	out.print("<td width=16>en.gif'></td><td id='m"+rs3.getString("nid")+"' ><input type=\"checkbox\" name=\"bm\" id=\"bm\" value=\""+rs3.getInt("nid")+"\" title=\""+rs3.getString("bmmc")+"\"/> "+rs3.getString("bmmc")+"</font></td>");
				  		  	    
					  	    	out.print("</tr></table>\n");
			  		  	    	
			  		  	    	
				  		  	    strsql="select b.nid,b.bmmc from tbl_qybm b where b.qy="+session.getAttribute("qy")+" and b.fbm="+rs3.getString("nid");
					  	  		rs4=stmt4.executeQuery(strsql);
					  	  		
					  	  		while (rs4.next())
					  	  		{	  		  	   
					  	  			if (rs4.isFirst())
					  	  			out.print("<div id='D"+rs3.getString("nid")+"' style='display:none;'>");
					  	  		out.print("<table class='selbmtbl' width='100%'  border='0' height=18 cellspacing=0 cellpadding=0><tr><td width=16> </td>");
					  		  		for (j=1;j<sLine4.length();j++)
					  		  		{
					  		  			if (sLine4.substring(j,j+1).equals("1"))
					  		  				out.print("<td width=16><img border=0 src='images/_1.gif' style='display:block;'></td>");
					  		  			else
					  		  				out.print("<td width=16> </td>");
					  		  		}
					  		  		
					  		  		strsql="select nid from tbl_qybm where fbm="+rs4.getString("nid");
					  			    rst=stmtt.executeQuery(strsql);
					  			    if (rst.next())
					  			    	haves=1;
					  			    else
					  			    	haves=0;
					  			    rst.close();
					  			    
					  		  	    if (rs4.isLast())
					  		  	    {
					  		  	    	sLine5=sLine4 +"0";	  	    	
					  		  	    	if (haves==1)
					  		  	    		out.print("<td width=16><span style='cursor:hand' id='off"+rs4.getString("nid")+"' onclick='fiton(this)'><img border=0 src='images/_4.gif'></span><span style='display:none;cursor:hand' id='on"+rs4.getString("nid")+"' onclick='fitoff(this)'><img border=0 src='images/_41.gif'></span></td>");
					  		  	    	else
					  		  	    		out.print("<td width=16><img border=0 src='images/_2.gif'></td>");
					  		  	    	
					  		  	    }
					  		  	    else
					  		  	    {
					  		  	    	sLine5=sLine4 +"1";
					  		  	    	if (haves==1)
					  		  	    		out.print("<td width=16><span style='cursor:hand' id='off"+rs4.getString("nid")+"' onclick='fiton(this)'><img border=0 src='images/_5.gif'></span><span style='display:none;cursor:hand' id='on"+rs4.getString("nid")+"' onclick='fitoff(this)'><img border=0 src='images/_51.gif'></span></td>");
					  		  	    	else
					  		  	    		out.print("<td width=16><img border=0 src='images/_3.gif'></td>");  	    	
					  		  	    }
					  				
					  		  	    if (haves==1)
					  		  	    {
					  		  	    	out.print("<td id='m"+rs4.getString("nid")+"' ><input type=\"checkbox\" name=\"bm\" id=\"bm\" value=\""+rs4.getInt("nid")+"\" title=\""+rs4.getString("bmmc")+"\"/> "+rs4.getString("bmmc")+"</font></td>");
						  		  	    
							  	    	out.print("</tr></table>\n");
						  		  	    strsql="select b.nid,b.bmmc from tbl_qybm b  where b.qy="+session.getAttribute("qy")+" and b.fbm="+rs4.getString("nid");
							  	  		rs5=stmt5.executeQuery(strsql);
							  	  		
							  	  		while (rs5.next())
							  	  		{	  		  	   
							  	  			if (rs5.isFirst())
							  	  			out.print("<div id='D"+rs4.getString("nid")+"' style='display:none;'>");
							  	  		out.print("<table class='selbmtbl' width='100%'  border='0' height=18 cellspacing=0 cellpadding=0><tr><td width=16> </td>");
							  		  		for (j=1;j<sLine5.length();j++)
							  		  		{
							  		  			if (sLine5.substring(j,j+1).equals("1"))
							  		  				out.print("<td width=16><img border=0 src='images/_1.gif' style='display:block;'></td>");
							  		  			else
							  		  				out.print("<td width=16> </td>");
							  		  		}
							  			    haves=0;							  			    
							  		  	    if (rs5.isLast())
							  		  	    {
							  		  	    	out.print("<td width=16><img border=0 src='images/_2.gif'></td>");							  		  	    	
							  		  	    }
							  		  	    else
							  		  	    {							  		  	    	
							  		  	    	out.print("<td width=16><img border=0 src='images/_3.gif'></td>");  	    	
							  		  	    }							  				
							  		  	    
							  		  	    out.print("<td height=20 id=\"td"+rs5.getString("nid")+"\" style='cursor:hand;padding-top:2px;'><input type=\"checkbox\" name=\"bm\" id=\"bm\" value=\""+rs5.getInt("nid")+"\" title=\""+rs5.getString("bmmc")+"\"/> "+rs5.getString("bmmc")+"</td>");
								  		  	
								  	    	out.print("</tr></table>\n");	    	  	    
							  		  }
							  	  	  rs5.close();
							  	  	  out.print("</div>");
					  		  	    	
					  		  	    }
					  		  	    else
					  		  	    {
					  		  	    	out.print("<td height=20 id=\"td"+rs4.getString("nid")+"\" style='cursor:hand;padding-top:2px;'><input type=\"checkbox\" name=\"bm\" id=\"bm\" value=\""+rs4.getInt("nid")+"\" title=\""+rs4.getString("bmmc")+"\"/> "+rs4.getString("bmmc")+"</td>");
						  		  	    
							  	    	out.print("</tr></table>\n");
					  		  	    }	  	    
					  		  }
					  	  	  rs4.close();
					  	  	  out.print("</div>");
				  	  	  
				  	  	  
			  		  	    }
			  		  	    else
			  		  	    {
			  		  	    	out.print("<td height=20 id=\"td"+rs3.getString("nid")+"\" style='cursor:hand;padding-top:2px;'><input type=\"checkbox\" name=\"bm\" id=\"bm\" value=\""+rs3.getInt("nid")+"\" title=\""+rs3.getString("bmmc")+"\"/> "+rs3.getString("bmmc")+"</td>");
			  		  	    
				  	    	out.print("</tr></table>\n");
			  		  	    }	  	    
			  		  }
			  	  	  rs3.close();
			  	  	  out.print("</div>");
	  		  	    }
	  		  	    else
	  		  	    {
	  		  	    	out.print("<td height=20 id=\"td"+rs2.getString("nid")+"\"  style='cursor:hand;padding-top:2px;'><input type=\"checkbox\" name=\"bm\" id=\"bm\" value=\""+rs2.getInt("nid")+"\" title=\""+rs2.getString("bmmc")+"\"/> "+rs2.getString("bmmc")+"</td>");
		  		  	    
			  	    	out.print("</tr></table>\n");
	  		  	    }	  	    
	  		  }
	  	  	  rs2.close();
	  	  	  out.print("</div>");
	  	    }
	  	    else
	  	    {
	  	    	out.print("<td height=20 id=\"td"+rs.getString("nid")+"\" style='cursor:hand;padding-top:2px;'><input type=\"checkbox\" name=\"bm\" id=\"bm\" value=\""+rs.getInt("nid")+"\" title=\""+rs.getString("bmmc")+"\"/> "+rs.getString("bmmc")+"</td>");
	  	    	
	  	    	out.print("</tr></table>\n");
	  	    }	  	    
	  }
  	  rs.close();
  	  out.print("</div>");
  	  
		   
  	
	
			%>
			</ul>
			</div>
		
		<div class="workersbtn">
			<span class="floatleft" style="padding-right:12px; margin-top: 10px;"><span onclick="selectedbm()" class="caxun">选择部门</span></span><span class="floatleft" style="padding-right:12px; margin-top: 10px;"><span onclick="closeLayer()" class="caxun">取消关闭</span></span>
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