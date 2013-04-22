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
		<link type="text/css" rel="stylesheet" href="common/css/style.css">
		<link type="text/css" rel="stylesheet" href="common/css/ymPrompt.css">
		<script type="text/javascript" src="common/js/jquery-1.7.min.js"></script>	
		<script type="text/javascript" src="common/js/jquery.validate.js"></script>
		<script type="text/javascript" src="common/js/ymPrompt.js"></script>	
		<script type="text/javascript" src="common/js/common.js"></script>
		<script type="text/javascript">
			var ymclose = function(){ymPrompt.close();};
			$(function() {
				if('<s:property value="rs"/>'=='2'){
					ymPrompt.win({message:'<div class=\'popbox\'>密码修改成功，下次登录请使用新密码。</div>',width:355,height:55,titleBar:false});
					var timeClose = setTimeout(ymclose, 2500);
				}
				if('<s:property value="rs"/>'=='1'){
					ymPrompt.win({message:'<div class=\'popbox\'>原始密码输入有误。</div>',width:355,height:55,titleBar:false});
					var timeClose = setTimeout(ymclose, 2500);
				}
				$("#form1").validate({
        			rules:{
						"oldpassword":{required:true,rangelength:[5,16]},
						"password":{required:true,rangelength:[5,16]},
						"repassword":{equalTo:"#password"}
					},
					messages:{						
						"oldpassword":{required:"旧密码为必输项。",rangelength:"5-16个字符。"},
						"password":{required:"旧密码为必输项。",rangelength:"5-16个字符。"},
						"repassword":{equalTo:"两次输入的密码必须相同。"}
					}
				});
			});
		</script>
	<link rel="shortcut icon" href="<%=request.getContextPath() %>/common/images/favicon.ico" type="image/x-icon" /></head>

	<body>
	<%@ include file="/jsp/base/head.jsp" %>
	<div id="main">
	  <div class="main2">
	    <div class="box">
	      <div class="wrap">
	        <div class="wrap-left">	         
			<%@ include file="/jsp/base/leftlist.jsp" %>
			<script type="text/javascript">menusel(11);</script>
	        </div>
	        <div class="wrap-right">
	          	<div class="list">
	            	<div class="list-title"><h1>密码修改</h1></div>
	            	<form action="user!chgpwd.do" id="form1" name="form1" method="post">
					<div class="states">
						<s:hidden name="user.nid" />
						<div class="states-right" style="padding-left:0px; border:none">
							<p><label class="label"><span class="bisque">*</span>旧密码</label><input name="oldpassword" type="password" value="" class="nameinputbox" /></p>
							<p><label class="label"><span class="bisque">*</span>新密码</label><input name="password" id="password" type="password" class="nameinputbox" /></p>
							<p><label class="label"><span class="bisque">*</span>重复密码</label><input name="repassword" type="password" class="nameinputbox" /></p>
						</div>
						<input value="" type="submit" class="savebtn" style="margin:20px 0 0 100px; display:inline" />
					</div>
					</form>
				</div>
	        </div>
	      </div>
			<%@ include file="/jsp/base/bottomnav.jsp" %>
		</div>
	  </div>
	</div>
	<%@ include file="/jsp/base/footer.jsp" %>
	</body>
</html>
