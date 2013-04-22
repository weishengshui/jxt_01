<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.sql.ResultSet"%>
<%@ include file="../common/yylogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("3002")==-1)
{
	out.print("你没有操作权限！");
	return;
}

	String hdmc="",hdtp="",kssj="",jssj="",zxjf="",lm="",tj="",hdid="",strsql="",hdtp2="";
    Connection conn=DbPool.getInstance().getConnection();
	Statement stmt=conn.createStatement();
	ResultSet rs=null;
	Fun fun=new Fun();
	 
    File uploadPath = new File(getServletContext().getRealPath("hdimg/"));//上传文件目录
    if (!uploadPath.exists()) {
       uploadPath.mkdirs();
    }
    // 临时文件目录
    File tempPathFile = new File(getServletContext().getRealPath("hdimg/buffer/"));
    if (!tempPathFile.exists()) {
       tempPathFile.mkdirs();
    }
    try {
       // Create a factory for disk-based file items
       DiskFileItemFactory factory = new DiskFileItemFactory();
 
       // Set factory constraints
       factory.setSizeThreshold(409600); // 设置缓冲区大小，这里是40kb
       factory.setRepository(tempPathFile);//设置缓冲区目录
 
       // Create a new file upload handler
       ServletFileUpload upload = new ServletFileUpload(factory);
 
       // Set overall request size constraint
       upload.setSizeMax(4194304); // 设置最大文件尺寸，这里是4MB
 
       List<FileItem> items = upload.parseRequest(request);//得到所有的文件
       Iterator<FileItem> i = items.iterator();
       while (i.hasNext()) {
           FileItem fi = (FileItem) i.next();
           
           if (fi.isFormField())
           {
           	if (fi.getFieldName().equals("hdmc")) hdmc=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("kssj")) kssj=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("jssj")) jssj=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("zxjf")) zxjf=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("tj")) tj=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("lm")) lm=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("hdid")) hdid=fi.getString("UTF-8");
           	
           	if ( !fun.sqlStrCheck(hdmc) || !fun.sqlStrCheck(kssj) || !fun.sqlStrCheck(jssj) || !fun.sqlStrCheck(zxjf) || !fun.sqlStrCheck(tj) || !fun.sqlStrCheck(lm))
           	{
           		out.print("<script type='text/javascript'>");
           		out.print("alert('提交的内容中有敏感字符！');");
           		out.print("history.back(-1);");
           		out.print("</script>");
           		return;
           	}
           	
           }
           else
           {
	           Calendar nowtime=Calendar.getInstance();
	          
	          
	           if (fi.getName() != null && !fi.getName().equals("") ) 
	           {	
	           	String fileName=fi.getName();	
	          
	           	fileName=fileName.substring(fileName.lastIndexOf("."));
	           if (fi.getFieldName().equals("hdtp"))
	           {hdtp="hdtp"+String.valueOf(nowtime.getTimeInMillis())+fileName;
	           fileName=hdtp;}
	           
	           if (fi.getFieldName().equals("hdtp2"))
	           {hdtp2="hdtp2"+String.valueOf(nowtime.getTimeInMillis())+fileName;
	           fileName=hdtp2;}
	           
		       fi.write(new File(uploadPath, fileName));
		       fi.delete();
	           }
	       }
       }
     if (hdid!=null && hdid.length()>0)
     {
    	  strsql="select nid from tbl_jfqhd where hdmc='"+hdmc+"' and nid<>"+hdid;
		   rs=stmt.executeQuery(strsql);
		   if (rs.next())
		   {
			    rs.close();
				out.print("<script type='text/javascript'>");
				out.print("alert('此活动名称已经存在！ ');");
				out.print("history.back(-1);");
				out.print("</script>");
				return;
		   }
		   rs.close();
    	 
    	strsql="update tbl_jfqhd set hdmc='"+hdmc+"',kssj='"+kssj+"',jssj='"+jssj+"',lm="+lm+",tj="+tj;    
	    if (hdtp!=null && !hdtp.equals(""))
	    	strsql+=",hdtp='"+hdtp+"'";
	    if (hdtp2!=null && !hdtp2.equals(""))
	    	strsql+=",hdtp2='"+hdtp2+"'";
     	strsql=strsql+" where nid="+hdid;
     }
     else
     {
    	 strsql="select nid from tbl_jfqhd where hdmc='"+hdmc+"'";
		   rs=stmt.executeQuery(strsql);
		   if (rs.next())
		   {
			    rs.close();
				out.print("<script type='text/javascript'>");
				out.print("alert('此活动名称已经存在！ ');");
				out.print("history.back(-1);");
				out.print("</script>");
				return;
		   }
		   rs.close();
		   
    	 strsql="insert into tbl_jfqhd (hdmc,lm,kssj,jssj,zxjf,tj,srsj";
    	 if (hdtp!=null && !hdtp.equals(""))
 	    	strsql+=",hdtp";
 	     if (hdtp2!=null && !hdtp2.equals(""))
 	    	strsql+=",hdtp2";
    	 strsql+=") values('"+hdmc+"',"+lm+",'"+kssj+"','"+jssj+"',0,"+tj+",now()";
    	 if (hdtp!=null && !hdtp.equals(""))
  	    	strsql+=",'"+hdtp+"'";
  	     if (hdtp2!=null && !hdtp2.equals(""))
  	    	strsql+=",'"+hdtp2+"'";
    	 strsql+=")";
     }
     
	 stmt.executeUpdate(strsql);
	 response.sendRedirect("jifenjuanhuodong.jsp");
    
    } catch (Exception e) {
       e.printStackTrace();
    }
    finally
{
	if (!conn.isClosed())
		conn.close();
}
%>