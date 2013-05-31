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
<script type="text/javascript" src="js/common.js"></script>
<%@page import="jxt.elt.common.DbPool"%>

<%
// 1. Retrieve Data from database tbl_qyyg.
String strsql="select y.nid,y.ygbh,y.ygxm,y.xb,y.bm,y.lxdh,y.email,y.zt,y.gzxz from tbl_qyyg y where y.qy="+session.getAttribute("qy")+" and xtzt<>3 order by y.zt desc, y.nid desc";

Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;

rs = stmt.executeQuery(strsql);

ArrayList<String[]> al = new ArrayList<String[]>();

while (rs.next())
{
	String[] rowData = new String[8];
	//员工编号
	rowData[0] = rs.getString("ygbh") == null ? "":rs.getString("ygbh");
	
	//员工姓名
	rowData[1] = rs.getString("ygxm");
	
	//性别
	rowData[2] = rs.getInt("xb") == 2 ? "女":"男";
	
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
				ResultSet rs2=null;
				Statement stmt2=conn.createStatement();
				String strsql2="select bmmc from tbl_qybm where qy="+session.getAttribute("qy")+" and nid="+bmarr[i];
							
				rs2 = stmt2.executeQuery(strsql2);
				while(rs2.next())
				{
					bmName = bmName + rs2.getString("bmmc") + ",";
				}				
				rs2.close();
  			}
  		}
		
		if(!bmName.equals(""))
		{
			bmName = bmName.substring(0, bmName.length()-1); 
		}
	}
	rowData[3]= bmName;
	
	//联系电话
	rowData[4] = rs.getString("lxdh") == null ? "":rs.getString("lxdh");
	
	//邮箱
	rowData[5] = rs.getString("email") == null ? "":rs.getString("email");
	
	//工作性质
	rowData[6] = rs.getString("gzxz") == null ? "":rs.getString("gzxz");
	
	//工作状态
	rowData[7] = rs.getInt("zt") == 0 ? "离职":"在职";
	
// 	if (rowData[7]  == "离职")
// 	{
// 		rowData[5] = rowData[5].replace("$", "@");
// 	}
	
	al.add(rowData);
}

rs.close();

// 2. Export to excel and generate temp file for further download.
ExcelWriter ew=new ExcelWriter(getServletContext().getRealPath("gl/ygdr/"));
String fileName = ew.exportData(al);

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
