    <%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="com.chinarewards.metro.core.common.FileUtil"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.chinarewards.metro.core.common.Constants"%>
<%@ page language="java" pageEncoding="utf-8"%>
    <%@ page import="java.io.*"%>
    <%@ page import="java.net.*"%>
    <%@ page import="java.util.*"%>
    <%@ page import="com.chinarewards.metro.core.common.Uploader" %>
    <%
    	request.setCharacterEncoding("utf-8");
    	response.setCharacterEncoding("utf-8");
    	String url = request.getParameter("upfile");
    	String state = "远程图片抓取成功！";
    	
    	String[] arr = url.split("ue_separate_ue");
    	String[] outSrc = new String[arr.length];
    	for(int i=0;i<arr.length;i++){
        	String tmp = arr[i];
        	if(tmp.endsWith("/")){
        		tmp = tmp.substring(0, tmp.length()-1);
        	}

			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
			String date = dateFormat.format(new Date());
    		//保存文件路径
			String savePath = Constants.UEDITOR_UPLOAD_DIR + date;
    		//格式验证
    		String type = getFileType(tmp);
			if(type.equals("")){
				state = "图片类型不正确！";
				continue;
			}
    		String saveName = Long.toString(new Date().getTime())+type;
    		//大小验证
    		HttpURLConnection.setFollowRedirects(false); 
		    HttpURLConnection   conn   = (HttpURLConnection) new URL(arr[i]).openConnection(); 
		    String contentType = conn.getContentType();
		   	if(null == contentType || contentType.indexOf("image")==-1){
		    	state = "请求地址头不正确";
		    	continue;
		    }  
		    if(conn.getResponseCode() != 200){
		    	state = "请求地址不存在！";
		    	continue;
		    }
            File dir = new File(savePath);
			if (!dir.exists()) {
				dir.mkdirs();
			}
    		File savetoFile = new File(dir,saveName);
    		outSrc[i]=date +"/"+ saveName;
    		try {
    			InputStream is = conn.getInputStream();
    			FileUtils.copyInputStreamToFile(is, savetoFile);
    			// 这里处理 inputStream
    		} catch (Exception e) {
    			e.printStackTrace();
    			System.err.println("页面无法访问");
    		}
    	}
   	String outstr = "";
   	for(int i=0;i<outSrc.length;i++){
   		if(outSrc[i] != null && !outSrc[i].equals("")){
	   		outstr+=outSrc[i]+"/ue_separate_ue";
   		}
   	}
   	if(outstr.length() > 0){
	   	outstr = outstr.substring(0,outstr.lastIndexOf("ue_separate_ue"));
	   	response.getWriter().print("{'url':'" + outstr + "','tip':'"+state+"','srcUrl':'" + url + "'}" );
   	}

    %>
    <%!
    public String getFileType(String fileName){
    	String[] fileType = {".gif" , ".png" , ".jpg" , ".jpeg" , ".bmp"};
    	Iterator<String> type = Arrays.asList(fileType).iterator();
    	while(type.hasNext()){
    		String t = type.next();
    		if(fileName.endsWith(t)){
    			return t;
    		}
    	}
    	return "";
    }
    %>
