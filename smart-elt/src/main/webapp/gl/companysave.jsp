<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="com.aviyehuda.easyimage.Image"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (session.getAttribute("glqx").toString().indexOf(",2,")==-1) 
	response.sendRedirect("main.jsp");

	String qymc="",qybh="",qydz="",qh="",dh="",yb="",yyzz="",swdj="",zzjg="",qylog="",bz="",strsql="",lxr="",lxremail="";
    Connection conn=DbPool.getInstance().getConnection();
	Statement stmt=conn.createStatement();
	Fun fun=new Fun();
	 
    File uploadPath = new File(getServletContext().getRealPath("qyimg/"));//上传文件目录
    if (!uploadPath.exists()) {
       uploadPath.mkdirs();
    }
    // 临时文件目录
    File tempPathFile = new File(getServletContext().getRealPath("qyimg/buffer/"));
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
       upload.setSizeMax(5000000); // 设置最大文件尺寸，这里是5000k
       
 
       List<FileItem> items = upload.parseRequest(request);//得到所有的文件
       Iterator<FileItem> i = items.iterator();
       while (i.hasNext()) {
           FileItem fi = (FileItem) i.next();
           
           if (fi.isFormField())
           {
           	if (fi.getFieldName().equals("qymc")) qymc=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("qybh")) qybh=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("qydz")) qydz=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("qh")) qh=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("dh")) dh=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("yb")) yb=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("bz")) bz=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("lxr")) lxr=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("lxremail")) lxremail=fi.getString("UTF-8");
           	
           	if ( !fun.sqlStrCheck(qymc) || !fun.sqlStrCheck(qybh) || !fun.sqlStrCheck(qydz) || !fun.sqlStrCheck(qh) || !fun.sqlStrCheck(dh) || !fun.sqlStrCheck(yb) || !fun.sqlStrCheck(bz) || !fun.sqlStrCheck(lxr) || !fun.sqlStrCheck(lxremail))
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
	           if (fi.getSize()>500000)
	           {
	        	   out.print("<script type='text/javascript'>");
	        	   out.print("alert('上传文件大小超过规定！');");
	        	   out.print("history.back(-1);");
	        	   out.print("</script>");
	        	   return;
	           }
        	   Calendar nowtime=Calendar.getInstance();
	          
	          
	           if (fi.getName() != null && !fi.getName().equals("") ) {	
		           	String fileName=fi.getName();	
		          
		           	fileName=fileName.substring(fileName.lastIndexOf("."));
		           if (fi.getFieldName().equals("yyzz"))
		           {yyzz="yyzz"+String.valueOf(nowtime.getTimeInMillis())+fileName;
		           fileName=yyzz;}
		           if (fi.getFieldName().equals("swdj"))
		           {swdj="swdj"+String.valueOf(nowtime.getTimeInMillis())+fileName;
		           fileName=swdj;
		           }
		           if (fi.getFieldName().equals("zzjg")) 
		           {
		           zzjg="zzjg"+String.valueOf(nowtime.getTimeInMillis())+fileName;
		           fileName=zzjg;}
		           
		           if (fi.getFieldName().equals("qylog"))
		           {qylog="qylog"+String.valueOf(nowtime.getTimeInMillis())+fileName;
		            fileName=qylog;
		           }      
			       fi.write(new File(uploadPath, fileName));
			       fi.delete();
			       
			       if (qylog!=null && qylog.length()>0)
			       {
				       Image image=new Image(uploadPath+"/"+fileName);
				       if (image.getWidth()>200 || image.getHeight()>75)
				       {
				    	    out.print("<script type='text/javascript'>");
			           		out.print("alert('企业Logo图片尺寸超过规定！');");
			           		out.print("history.back(-1);");
			           		out.print("</script>");
			           		return;
				       }
			       }
	           }
	       }
       }
     
     strsql="update tbl_qy set qydz='"+qydz+"',qh='"+qh+"',dh='"+dh+"',yb='"+yb+"',lxr='"+lxr+"',lxremail='"+lxremail+"'";
     if (yyzz!=null && !yyzz.equals(""))
     strsql+=",yyzz='/qyimg/"+yyzz+"'";
     if (swdj!=null && !swdj.equals(""))
     strsql+=",swdj='/qyimg/"+swdj+"'";
     if (zzjg!=null && !zzjg.equals(""))
     strsql+=",zzjg='/qyimg/"+zzjg+"'";
     if (qylog!=null && !qylog.equals(""))
     strsql+=",log='/qyimg/"+qylog+"'";
     strsql=strsql+",bz='"+bz+"' where nid="+session.getAttribute("qy");
   
	 stmt.executeUpdate(strsql);
	 response.sendRedirect("company.jsp");
    
    } catch (Exception e) {
       e.printStackTrace();
    }
    finally
{
	if (!conn.isClosed())
		conn.close();
}
%>