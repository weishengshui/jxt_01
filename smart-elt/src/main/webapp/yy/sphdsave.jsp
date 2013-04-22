<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ include file="../common/yylogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("4005")==-1)
{
	out.print("你没有操作权限！");
	return;
}

	String strsql="",bt="",hdid="",syxs="",xswz="",ksrq="",jsrq="",sp="",tplj="",spmc="",spid="",sfgg="",hdnr="";
    Connection conn=DbPool.getInstance().getConnection();
	Statement stmt=conn.createStatement();
	Fun fun=new Fun();
	 
    File uploadPath = new File(getServletContext().getRealPath("sphdimg/"));//上传文件目录
    if (!uploadPath.exists()) {
       uploadPath.mkdirs();
    }
    // 临时文件目录
    File tempPathFile = new File(getServletContext().getRealPath("sphdimg/buffer/"));
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
        	
        	if (fi.getFieldName().equals("bt")) bt=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("syxs")) syxs=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("xswz")) xswz=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("ksrq")) ksrq=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("jsrq")) jsrq=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("spid")) spid=fi.getString("UTF-8");
           	
           	if (fi.getFieldName().equals("hdid")) hdid=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("sfgg")) sfgg=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("hdnr")) hdnr=fi.getString("UTF-8");
           	if ( !fun.sqlStrCheck(bt) || !fun.sqlStrCheck(syxs) || !fun.sqlStrCheck(xswz) || !fun.sqlStrCheck(ksrq) || !fun.sqlStrCheck(jsrq) || !fun.sqlStrCheck(spid) || !fun.sqlStrCheck(hdid)|| !fun.sqlStrCheck(sfgg))
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
	           if (fi.getFieldName().equals("tplj"))
	           {tplj="hdtp"+String.valueOf(nowtime.getTimeInMillis())+fileName;
	           fileName=tplj;}
	           
	          
		       fi.write(new File(uploadPath, fileName));
		       fi.delete();
	           }
	       }
       }
       
        if (spid==null || spid.equals("")) spid="0";
        if (tplj!=null && tplj.length()>0) tplj="/sphdimg/"+tplj;
        
		if (hdid!=null && hdid.length()>0)
		{
			
				strsql="update tbl_cxhd set bt=?,xswz=?,ksrq=?,jsrq=?,sp=?,hdnr=?,sfgg=?";
				if (tplj!=null && tplj.length()>0)
					strsql+=",tplj=?";				
				strsql+=" where nid="+hdid;
				PreparedStatement pstmp=conn.prepareStatement(strsql);
				pstmp.setString(1,bt);
				pstmp.setString(2,xswz);
				pstmp.setString(3,ksrq);
				pstmp.setString(4,jsrq);
				pstmp.setString(5,spid);
				pstmp.setString(6,hdnr);
				pstmp.setString(7,sfgg);
				if (tplj!=null && tplj.length()>0)
					pstmp.setString(8,tplj);	
				int res=pstmp.executeUpdate();
				pstmp.close();
			
		}
		else
		{
			strsql="insert into tbl_cxhd (bt,xswz,ksrq,jsrq,sp,hdnr,sfgg,tplj) values(?,?,?,?,?,?,?,?)";
			PreparedStatement pstmp=conn.prepareStatement(strsql);
			pstmp.setString(1,bt);
			pstmp.setString(2,xswz);
			pstmp.setString(3,ksrq);
			pstmp.setString(4,jsrq);
			pstmp.setString(5,spid);
			pstmp.setString(6,hdnr);
			pstmp.setString(7,sfgg);			
			pstmp.setString(8,tplj);	
			int res=pstmp.executeUpdate();
			pstmp.close();
		}
	
	 response.sendRedirect("sphdgl.jsp?pno="+request.getParameter("pno"));
    
    } catch (Exception e) {
       e.printStackTrace();
    }
    finally
{
	if (!conn.isClosed())
		conn.close();
}
%>