<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.aviyehuda.easyimage.Image"%>
<%@ include file="../common/yylogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("4004")==-1)
{
	out.print("你没有操作权限！");
	return;
}

	String strsql="",mc="",naction="",lmid="",sfxs="1",xswz="",lmtp="";
    Connection conn=DbPool.getInstance().getConnection();
	Statement stmt=conn.createStatement();
	ResultSet rs=null;
	Fun fun=new Fun();
	 
    File uploadPath = new File(getServletContext().getRealPath("lmimg/"));//上传文件目录
    if (!uploadPath.exists()) {
       uploadPath.mkdirs();
    }
    // 临时文件目录
    File tempPathFile = new File(getServletContext().getRealPath("lmimg/buffer/"));
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
           	if (fi.getFieldName().equals("mc")) mc=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("sfxs")) sfxs=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("xswz")) xswz=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("lmid")) lmid=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("naction")) naction=fi.getString("UTF-8");
           	
           	if ( !fun.sqlStrCheck(mc) || !fun.sqlStrCheck(sfxs) || !fun.sqlStrCheck(xswz) || !fun.sqlStrCheck(lmid))
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
		           {lmtp="lmtp"+String.valueOf(nowtime.getTimeInMillis())+fileName;
		           fileName=lmtp;}
		           
		          
			       fi.write(new File(uploadPath, fileName));
			       fi.delete();
			       
			       Image image=new Image(uploadPath+"/"+fileName);
			       if (image.getWidth()>50 || image.getHeight()>50)
			       {
			    	    out.print("<script type='text/javascript'>");
		           		out.print("alert('类目图片尺寸超过规定！');");
		           		out.print("history.back(-1);");
		           		out.print("</script>");
		           		return;
			       }
	           }
	       }
       }
       
       if (naction!=null && naction.equals("save"))
		{
		   strsql="select nid from tbl_splm where mc='"+mc+"'";
		   rs=stmt.executeQuery(strsql);
		   if (rs.next())
		   {
			    rs.close();
				out.print("<script type='text/javascript'>");
				out.print("alert('此类目名称已经存在！ ');");
				out.print("history.back(-1);");
				out.print("</script>");
				return;
		   }
		   rs.close();
		   
		   strsql="select count(nid) as hn from tbl_splm where flm=0 and sfxs=1";
		   rs=stmt.executeQuery(strsql);
		   if (rs.next())
		   {
			    if (rs.getInt("hn")>=8)
			    {
			    rs.close();
				out.print("<script type='text/javascript'>");
				out.print("alert('父类目已经超过8个，将影响显示效果！ ');");
				out.print("history.back(-1);");
				out.print("</script>");
				return;
			    }
		   }
		   rs.close();
		   
    	   
    	   strsql="insert into tbl_splm (mc,sfxs,xswz,flm";
			if (lmtp!=null && lmtp.length()>0)
				strsql+=",lmtp";
			strsql+=") values('"+mc+"',"+sfxs+","+xswz+",0";
			if (lmtp!=null && lmtp.length()>0)
				strsql+=",'/lmimg/"+lmtp+"'";
			strsql=strsql+")";
			
			stmt.executeUpdate(strsql);			
			
		}
		if (naction!=null && naction.equals("sonsave"))
		{
			strsql="select nid from tbl_splm where mc='"+mc+"'";
		   rs=stmt.executeQuery(strsql);
		   if (rs.next())
		   {
			    rs.close();
				out.print("<script type='text/javascript'>");
				out.print("alert('此类目名称已经存在！ ');");
				out.print("history.back(-1);");
				out.print("</script>");
				return;
		   }
		   rs.close();
			   
			strsql="insert into tbl_splm (mc,sfxs,xswz,flm) values('"+mc+"',"+sfxs+","+xswz+","+lmid+")";
			stmt.executeUpdate(strsql);			
			
		}
		if (naction!=null && naction.equals("editsave"))
		{
		   strsql="select nid from tbl_splm where nid!="+lmid+" and mc='"+mc+"'";
		   rs=stmt.executeQuery(strsql);
		   if (rs.next())
		   {
			    rs.close();
				out.print("<script type='text/javascript'>");
				out.print("alert('此类目名称已经存在！ ');");
				out.print("history.back(-1);");
				out.print("</script>");
				return;
		   }
		   rs.close();
		   
		   //判断父类是不是超过8个了
		   if (sfxs!=null && sfxs.equals("1"))
		   {
			   	strsql="select nid from tbl_splm where nid="+lmid+" and flm=0";
			   	rs=stmt.executeQuery(strsql);
			   	if (rs.next())
			   	{
			   		   rs.close();
			   		   strsql="select count(nid) as hn from tbl_splm where flm=0 and sfxs=1";
					   rs=stmt.executeQuery(strsql);
					   if (rs.next())
					   {
						    if (rs.getInt("hn")>8)
						    {
						    rs.close();
							out.print("<script type='text/javascript'>");
							out.print("alert('父类目已经超过8个，将影响显示效果！ ');");
							out.print("history.back(-1);");
							out.print("</script>");
							return;
						    }
					   }
					   rs.close();
			   	}
			   	else
			   		rs.close();
		   }
			strsql="update tbl_splm set mc='"+mc+"',sfxs="+sfxs+",xswz="+xswz;
			if (lmtp!=null && lmtp.length()>0)
				strsql+=",lmtp='/lmimg/"+lmtp+"'";
			strsql+=" where nid="+lmid;
			stmt.executeUpdate(strsql);			
			
		}
	
	 response.sendRedirect("splbgl.jsp");
    
    } catch (Exception e) {
       e.printStackTrace();
    }
    finally
{
	if (!conn.isClosed())
		conn.close();
}
%>