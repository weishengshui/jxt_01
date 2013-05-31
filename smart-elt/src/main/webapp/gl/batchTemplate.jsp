<%@page import="org.apache.velocity.Template"%>
<%@page import="org.apache.velocity.VelocityContext"%>
<%@page import="org.apache.velocity.app.Velocity"%>
<%@page import="java.io.StringWriter"%>
<%@page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="jxt.elt.common.ExcelReader"%>
<%@page import="jxt.elt.common.ExcelWriter"%>
<%@page import="jxt.elt.common.SendEmailBean"%>
<%@page import="jxt.elt.common.SecurityUtil"%>
<%@page import="javax.servlet.ServletResponse"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
// 1. Retrieve Data from database tbl_qyyg.
String strsql="select y.nid,y.ygbh,y.ygxm,y.xb,y.bm,y.lxdh,y.email,y.gzxz from tbl_qyyg y where y.qy="+session.getAttribute("qy")+" and xtzt<>3 and zt<>0 order by y.zt desc, y.nid desc";

Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;

rs = stmt.executeQuery(strsql);

ArrayList<String[]> al = new ArrayList<String[]>();

String type = request.getParameter("type");
String flqid = request.getParameter("jfqid");
String flqmc = null;

String fileTemplate = "fjtemplate";
if (null != type && "flq".equals(type)) {
    fileTemplate = "flqtemplate";
	strsql="select mc as flqmc from tbl_jfq where nid=" + flqid;
	rs = stmt.executeQuery(strsql);
	while(rs.next())
	{
	    flqmc = rs.getString("flqmc");
	}
	rs.close();
} else {
    fileTemplate = "jftemplate";
}
strsql="select y.nid,y.ygbh,y.ygxm,y.xb,y.bm,y.lxdh,y.email,y.gzxz from tbl_qyyg y where y.qy="+session.getAttribute("qy")+" and xtzt<>3 and zt<>0 order by y.zt desc, y.nid desc";
rs = stmt.executeQuery(strsql);
while (rs.next())
{
	String[] rowData = null;
	if ("flqtemplate".equals(fileTemplate)) {
	    rowData =  new String[6];
	} else {
	    rowData =  new String[5];
	}
	
	//员工姓名
	rowData[0] = rs.getString("ygxm");
	
	
	//部门
	String bmIDList = rs.getString("bm") == null ? "":rs.getString("bm");
	String bmName = "";
	if (bmIDList != "")
	{
		String[] bmarr=bmIDList.split(",");
		for (int i=0;i<bmarr.length;i++)
  		{		
			if (bmarr[i]!=null && !bmarr[i].equals(""))
			{
				Statement statement=conn.createStatement();
				strsql="select bmmc from tbl_qybm where qy="+session.getAttribute("qy")+" and nid="+bmarr[i];
							
				ResultSet resultSet = statement.executeQuery(strsql);
				while(resultSet.next())
				{
					bmName = bmName + resultSet.getString("bmmc") + ",";
				}				
				resultSet.close();
  			}
  		}
		
		if(!bmName.equals(""))
		{
			bmName = bmName.substring(0, bmName.length()-1); 
		}
	}
	rowData[1]= bmName;
	
	//邮箱
	rowData[2] = rs.getString("email") == null ? "":rs.getString("email");
	
	//工作性质
	rowData[3] = rs.getString("gzxz") == null ? "":rs.getString("gzxz");
	
	//数量
	rowData[4] = "";
	
	if ("flqtemplate".equals(fileTemplate)) {
	    rowData[5] = flqmc;
	}
	
	al.add(rowData);
}

rs.close();

// 2. Export to excel and generate temp file for further download.
ExcelWriter ew=new ExcelWriter(getServletContext().getRealPath("gl/ygdr/"), fileTemplate + ".xls");
String fileName = ew.exportData(al, fileTemplate);

// 3. Populate File donwload dialog.
String filedownload = getServletContext().getRealPath("gl/ygdr/exportbuffer/"+fileName);

String filedisplay = fileName;
filedisplay = URLEncoder.encode(filedisplay,"UTF-8");

response.addHeader("Content-Disposition","attachment;filename=" + filedisplay);
response.setContentType("application/force-download");

ServletOutputStream outp = null;
FileInputStream in = null;
try
{
	outp = response.getOutputStream();
	in = new FileInputStream(filedownload);
		 
	byte[] b = new byte[1024];
	int i = 0;
		 
	while((i = in.read(b)) > 0)
	{
		outp.write(b, 0, i);
	}
		 
	outp.flush();
	out.clear();
	out = pageContext.pushBody();
}
catch(Exception e)
{
	System.out.println("Error!");
	e.printStackTrace();
}
finally
{
	if(in != null)
	{
	  in.close();
	  in = null;
	}
	if(outp != null)
	{
	  outp.close();
	  outp = null;
	}
}

%>
