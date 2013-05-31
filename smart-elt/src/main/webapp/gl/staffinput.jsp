<%@page import="org.apache.velocity.Template"%>
<%@page import="org.apache.velocity.VelocityContext"%>
<%@page import="org.apache.velocity.app.Velocity"%>
<%@page import="jxt.elt.common.EmailTemplate"%>
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
<%@page import="jxt.elt.common.ExcelReader"%>
<%@page import="jxt.elt.common.SendEmailBean"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="jxt.elt.common.SecurityUtil"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>

<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
    String strsql="",yginfo="";
	String ygbh="",ygxm="",xb="",bm="",zw="",zsld="",lxdh="",email="",csrj="",zt="",rzsj="",bm1="",bm2="",bm3="",bm4="",bm5="", gzxz="", emailUpdate="";
    Connection conn=DbPool.getInstance().getConnection();
	Statement stmt=conn.createStatement();
	ResultSet rs=null;
	Fun fun=new Fun();
	int errrows=0,truerows=0,updatetruerows=0,updateerrrows=0;
	StringBuilder errorMessage = new StringBuilder();
    String errorMessageFormat = "员工: %s 信息有误, 字段: %s\\n";
	SimpleDateFormat sf2=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
    File uploadPath = new File(getServletContext().getRealPath("gl/ygdr/"));//上传文件目录
    if (!uploadPath.exists()) {
       uploadPath.mkdirs();
    }
    // 临时文件目录
    File tempPathFile = new File(getServletContext().getRealPath("gl/ygdr/buffer/"));
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
           String fileName="";
           if (!fi.isFormField())
           {
          
	           Calendar nowtime=Calendar.getInstance();
	              
	           if (fi.getName() != null && !fi.getName().equals("") ) {	
	           	fileName=fi.getName();	
	          
	           	fileName=fileName.substring(fileName.lastIndexOf("."));
	           if (fi.getFieldName().equals("yginfo"))
	           {yginfo=String.valueOf(nowtime.getTimeInMillis())+fileName;
	           fileName=yginfo;}
	               
		       fi.write(new File(uploadPath, fileName));		       
		       fi.delete();
	           }
	           ExcelReader er=new ExcelReader(uploadPath+"/"+fileName);
	           List<String[]> dlist=er.getAllData(0);
	           
	           //SendEmailBean sendemail=new SendEmailBean();
	           for (int j=1;j<dlist.size();j++)
	           {
	        	   	 ygbh=dlist.get(j)[0];
	       			 ygxm=dlist.get(j)[1];
	       			 xb=dlist.get(j)[2];
	       			 bm=dlist.get(j)[3];
	       			 lxdh=dlist.get(j)[4];
	       			 email=dlist.get(j)[5];
	       			 gzxz=dlist.get(j)[6];
	       			 zt=dlist.get(j)[7];
	       			 	
	       		     // Validate email
			       	 if (email == null || email == "")
			       	 {
			     		errorMessage.append(String.format(errorMessageFormat, ygxm, "邮箱")); 
			       		errrows++;
			       		continue;
			       	 }
			       	 else
			       	 {
			       	    String emailPattern="^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$";		       		 			       		 
			       		Pattern mailPattern = Pattern.compile(emailPattern);
				       	Matcher mailMatcher = mailPattern.matcher(email);
				       	if (!mailMatcher.matches())
				       	{
				   			errorMessage.append(String.format(errorMessageFormat, ygxm, "邮箱")); 
			    			errrows++;
	     	       			continue;
			       		}
		       		 }
	       		     
	       		     // Check to insert or udpate.
			       	 boolean isUpdate=false;
	       			 strsql="select nid from tbl_qyyg where email='"+email.trim()+"'";
					 rs=stmt.executeQuery(strsql);
					 if (rs.next())
					 {
					     isUpdate = true;
					 }
					 rs.close();
					 
					 // process logic for dismissed employee.
			         if(zt.equals("离职"))
				     {
			             emailUpdate = email.replace("@", "$");
				     } else {
				         emailUpdate = email;
				     }
	       		
	       			 // Validates employee name.
	       			 if (ygxm == null || ygxm == "")
					 {
	       				if(isUpdate)
	       				{
	       					updateerrrows++;
	       				}
	       				else
	       				{ 
	       					errrows++;
	       				}
		       			continue;
					 }
	       			
	       			 // Validates sex.
	       			 if (xb!=null && xb.equals("男"))
	       				 xb="1";
	       			 else if (xb!=null && xb.equals("女"))
	       				 xb="2";
	       			 else
	       			 {
	       				errorMessage.append(String.format(errorMessageFormat, ygxm, "性别"));
	       				if(isUpdate)
	       				{
	       					updateerrrows++;
	       				}
	       				else
	       				{ 
	       					errrows++;
	       				}
	       				continue;
	       			 }
	       			 
	       			 // Validates department.
	       			 String bmid=",";
	       			 boolean containbm=false;
	       			 if (bm!=null && bm.length()>0)
	       			 {
	       				 // 1. Validates bm list.	   
	       				boolean bmExisted = false;
	       				String tempFbmID = "0";
	       				String[] bmarr=bm.split(",");
	       				for (int bmcounter=0;bmcounter<bmarr.length;bmcounter++)
	       		  		{
	       				   bmExisted=false;
	       				   if (bmcounter == 0)
	       				   {
		       				   strsql = "select nid from tbl_qybm where qy="+session.getAttribute("qy")+" and bmmc ='"+bmarr[bmcounter]+"'";
		       				   rs=stmt.executeQuery(strsql);
		       				   while(rs.next())
		       				   {
		       					  tempFbmID = rs.getString("nid");
		       					  bmExisted= true;	                                
		       				   }
		       				   
		       				   if(!bmExisted)
		       				   {
				       			  break;
		       				   }
	       				   }
	       				   else
	       				   {		       			  
	       					   strsql= "select nid from tbl_qybm where qy="+session.getAttribute("qy")+" and bmmc ='"+bmarr[bmcounter]+"' and fbm="+tempFbmID;
	       					   rs=stmt.executeQuery(strsql);
		       				   while(rs.next())
		       				   {
		       					  tempFbmID = rs.getString("nid");
		       					  bmExisted= true;
		       				   }
	       				   }		   
	       		  		}
	       				
	       				if(!bmExisted)
	       				{
	       					errorMessage.append(String.format(errorMessageFormat, ygxm, "部门"));  	
	       					if(isUpdate)
		       				{
		       					updateerrrows++;
		       				}
		       				else
		       				{ 
		       					errrows++;
		       				}
			       			continue;
	       				}
	       				 	       			       				 	       	   				 
	       				 // 2. Retrieve bm id list.
	       				 bm=bm.replace(",","','");
	       				 bm="'"+bm+"'";
	       				 strsql="select nid from tbl_qybm where qy="+session.getAttribute("qy")+" and bmmc in ("+bm+")";
	       				 rs=stmt.executeQuery(strsql);
	       				 while(rs.next())
	       				 {
	       					 containbm = true;
	       					 bmid=bmid+rs.getString("nid")+",";
	       				 }
	       				 rs.close();
	       			 }
	       			 else
	       			 {
                         // 当导入数据中部门为空，使用组织架构中排名最靠前部门。
	       				 //strsql="select nid from tbl_qybm where qy="+session.getAttribute("qy")+" order by nid asc limit 1";
	       				 //rs=stmt.executeQuery(strsql);
	       				 //while(rs.next())
	       				 //{
	       					//containbm = true;
	       					//bmid=bmid+rs.getString("nid")+",";
	       				 //}
	       				 //rs.close();
	       			 }
	       			 
	       			 if(!containbm)
	       			 {
	       				 bmid="";
	       			 }
         		
	       			// 判断手机准确性
	       			if (lxdh.length() > 0 && lxdh != null)
	       			{
			       	    Pattern phonePattern = Pattern.compile("^1[0-9]{10}$");
			       		Matcher phoneMatcher = phonePattern.matcher(lxdh);
			       		if (!phoneMatcher.matches())
			       		{
			       			errorMessage.append(String.format(errorMessageFormat, ygxm, "手机")); 
			       			if(isUpdate)
		       				{
		       					updateerrrows++;
		       				}
		       				else
		       				{ 
		       					errrows++;
		       				}
			       			continue;
			       		}
	       			}

	       			// 员工工作性质
					if (gzxz == null || gzxz == "" || gzxz.equals(""))
					{
						gzxz = "全职";
					}
					
					// 员工工作状态
					if (zt == null || zt == "")
					{
						zt = "1";
					}
					else if (zt.equals("离职"))
					{
						zt = "0";		
					}
					else if (zt.equals("在职"))
					{
						zt = "1";		
					}
					else
					{
						errorMessage.append(String.format(errorMessageFormat, ygxm, "工作状态")); 
						if(isUpdate)
	       				{
	       					updateerrrows++;
	       				}
	       				else
	       				{ 
	       					errrows++;
	       				}
	       				continue;
					}
										
					SecurityUtil su=new SecurityUtil();
					Random rand=new Random();
					int dlmm=rand.nextInt(999999);
					if (dlmm<100000) dlmm=100000+dlmm;
					
					if(isUpdate)
					{
						strsql="update tbl_qyyg set ygbh='"+ygbh+"',ygxm='"+ygxm+"',xb='"+xb+"',bm='"+bmid+"',lxdh='"+lxdh+"',zt='"+zt+"',gzxz='"+gzxz+"', email='"+emailUpdate+"' where qy='"+session.getAttribute("qy")+"' and email='"+email.trim()+"'";

					}
					else
					{
						strsql="insert into tbl_qyyg (qy,ygbh,ygxm,xb,bm,lxdh,email,zt,dlmm,gzxz) values("+session.getAttribute("qy")+",'"+ygbh+"','"+ygxm+"',"+xb+",'"+bmid+"','"+lxdh+"','"+emailUpdate+"','"+zt+"','"+su.md5(String.valueOf(dlmm))+"','"+gzxz+"')";		           		
					}

			 		stmt.executeUpdate(strsql);
			 		
			 		if(isUpdate)
			 		{
			 			updatetruerows++;
			 		}
			 		else
			 		{
			 			truerows++;
			 		}
			 					          		
	           	    //strsql="update tbl_qy set qydz='"+qydz+"',qh='"+qh+"',dh='"+dh+"',yb='"+yb+"',lxr='"+lxr+"',lxremail='"+lxremail+"'";
					
	           	    //发送初始密码							
					/* instead of velocity 
					StringBuffer mailc=new StringBuffer();
					mailc.append("尊敬的"+ygxm+"：<br/> ");
					mailc.append("    您的公司"+session.getAttribute("qymc")+"重新设置ELT（Employee Loyalty Tools）平台登陆密码，您可使用初始化密码登录，登陆后请尽快更改初始密码。<br/><br/>");
					mailc.append("登录账号和新密码如下<br/>");
					mailc.append("    登录账号："+email+"<br/>");
					mailc.append("    初始化登录密码："+String.valueOf(dlmm)+"<br/><br/>");
					mailc.append("若您有相关需求和意向，可联系我们，联系邮箱：xiao.ling@china-rewards.com，在2-3个工作日内由我们的顾问与您取得联系<br/>");
					mailc.append("若您对该体验有任何建议，可联系我们，联系邮箱：zhen.liang@china-rewards.com<br/>");
					*/
					
					if(!isUpdate)
					{					
						VelocityContext context = new VelocityContext();
						context.put("name", ygxm);
						context.put("loginAccount", email);
						context.put("loginPassword", dlmm);
						
// 						Template template = Velocity.getTemplate("templates/mail/staffregisterpwd.vm");
						Template template = EmailTemplate.getTemplate("staffregisterpwd.vm");
						StringWriter sw = new StringWriter();
						template.merge(context, sw);
						String mailContent = sw.toString();
						System.out.println("mail content: "+mailContent);
						
						//sendemail.sendHtmlEmail(email,mailc.toString(),"ELT重置密码获取");	           		
						strsql="insert into tbl_yjdf (qy,yg,jsyx,bt,nr,srsj,fslx,ljfs,fsdj) values(?,?,?,?,?,?,?,?,?)";									
						PreparedStatement pstm=conn.prepareStatement(strsql);
						pstm.setString(1,session.getAttribute("qy").toString());
						pstm.setString(2,session.getAttribute("ygid").toString());
						pstm.setString(3,email);
						pstm.setString(4,"IRewards登录账号");
						pstm.setString(5,mailContent);
						pstm.setString(6,sf2.format(Calendar.getInstance().getTime()));
						pstm.setString(7,"6");
						pstm.setString(8,"1");
						pstm.setString(9,"50");
						pstm.executeUpdate();
						pstm.close();
					}
	           }        
           }
       }
         
     	out.print("<script type='text/javascript'>");
     	
     	String displayMessage="alert('成功导入"+truerows+"条员工信息,"+errrows+"条失败!\\n成功更新"+updatetruerows+"条员工信息,"+updateerrrows+"条失败!";
     	if(errorMessage.length()>0)
     	{
     		displayMessage += "\\n\\n失败信息如下:\\n"+ errorMessage +"');";
     	}	
     	else
     	{
     		displayMessage +="');";
     	}
     	
     	out.print(displayMessage);   	
     	out.print("window.opener.location.reload();");
		out.print("window.close();");
		out.print("</script>");
    
    } catch (Exception e) {
   
       out.print("<script type='text/javascript'>");
       out.print("alert('导入模板格式不正确，请检查！');");
       out.print("window.opener.location.reload();");
	   out.print("window.close();");
	   out.print("</script>");
	   
	   e.printStackTrace();
    }
    finally
{
	if (!conn.isClosed())
		conn.close();
}
%>