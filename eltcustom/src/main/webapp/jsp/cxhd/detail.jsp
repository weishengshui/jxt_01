<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>IRewards</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">		
		<script type="text/javascript" src="common/js/jquery-1.7.min.js"></script>
		<script type="text/javascript">			
			var cxhd = function(){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("cxhdj!hdnr.do?time="+timeParam,{param:'<s:property value="hdid" />'}, function(data){
					if(data.rows==null) return false;
					$("#hdbody").html(data.rows.hdnr);
				});
			};
			$(function(){
				cxhd();
			})
		</script>
	<link rel="shortcut icon" href="<%=request.getContextPath() %>/common/images/favicon.ico" type="image/x-icon" /></head>
	<body id="hdbody">
		
	</body>
</html>
