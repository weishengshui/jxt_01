<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></meta>
		<title>IRewards</title>
		<meta http-equiv="pragma" content="no-cache"></meta>
		<meta http-equiv="cache-control" content="no-cache"></meta>
		<meta http-equiv="expires" content="0"></meta>
		<link type="text/css" rel="stylesheet" href="common/css/style.css"></link>
		<link type="text/css" rel="stylesheet" href="common/css/ymPrompt.css" />
		<script type="text/javascript" src="common/js/jquery-1.7.min.js"></script>	
		<script type="text/javascript" src="common/js/jquery.validate.js"></script>	
		<script type="text/javascript" src="common/js/datepicker/WdatePicker.js"></script>	
		<script type="text/javascript" src="common/js/ymPrompt.js"></script>	
		<script type="text/javascript" src="common/js/common.js"></script>
		<script type="text/javascript">
			var ymclose = function(){ymPrompt.close();};
			
			function ssss(){
				$("#ygphoto").attr("src",'<%=request.getContextPath() %>/common/images/default_headPortrait.png');
			}
			
			$(function() {
				if('<s:property value="rs"/>'=='2'){
					ymPrompt.win({message:'<div class=\'popbox\'>保存成功</div>',width:135,height:55,titleBar:false});
					var timeClose = setTimeout(ymclose, 2500);
				}
				var timeParam = Math.round(new Date().getTime()/1000);
				$("#ygphoto").attr("src","photo/"+'<s:property value="user.nid" />'+"/normal.jpg?time="+timeParam);
				/*$.ajax({
					url: '<%=request.getContextPath() %>/' + 'photo/' + '<s:property value="user.nid" />' + '/normal.jpg',
					data: {'time':timeParam}, 
					type: 'post',
					dataType: 'json',
					success:function(data){
						alert("modify is "+data);
						$("#ygphoto").attr("src","photo/"+'<s:property value="user.nid" />'+"/normal.jpg?time="+timeParam);		
					},
					error:function(data){
						alert("modify error is "+data);
						$("#ygphoto").attr("src",'<%=request.getContextPath() %>/common/images/default_headPortrait.png?time='+timeParam);
					}
				});*/ 	
				
				$("#form1").validate({
        			rules:{
						"user.nc":{required:true,mingchen:true,minlength:2},
						"user.csrj":{required:true},
						"user.lxdh":{mobile:true},
						"upload":{img:true}
					},
					messages:{						
						"user.nc":{required:"昵称为必输项。",mingchen:"2-30个字符，支持中英文、数字、“_”。",minlength:"2-30个字符，支持中英文、数字、“_”。！"},
						"user.csrj":{required:"出生日期为必输项。"},
						"user.lxdh":{mobile:"请输入正确的电话号码,例如13012345678。"},						
						"upload":{img:"请选择正确的图片格式，jpg,jpeg,或者png"}
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
		<script type="text/javascript">menusel(10);</script>
        </div>
        <div class="wrap-right">
          	<div class="list">
            	<div class="list-title"><h1>基本信息</h1></div>
				<div class="states">
					<form action="user!modify.do" id="form1" name="form1" method="post"
						enctype="multipart/form-data">
					<div class="states-left"><img id="ygphoto" src="" onerror="ssss()"/></div>
					<div class="states-right">
						<s:hidden name="user.nid" />
						<p><label class="label"><span class="bisque">*</span>昵称</label><s:textfield maxlength="30"  name="user.nc"  cssClass="nameinputbox" /></p>
						<p><label class="label">姓名</label><s:property value="user.ygxm" /> </p>
						<p><label class="label"><span class="bisque">*</span>性别</label><s:radio cssClass="ygxbcls" name="user.xb" list="#{'1':'男', '2':'女'}"/></p>
						<p><label class="label"><span class="bisque">*</span>生日</label><input  name="user.csrj" class="nameinputbox" onclick="WdatePicker({readOnly:true})" value='<s:date name="user.csrj" format="yyyy-MM-dd" />' /></p>
						<p><label class="label">手机号码</label><s:textfield  name="user.lxdh"  cssClass="nameinputbox" /></p>
						<p><label class="label">电子邮件</label><s:property value="user.email"/></p>
						<p><label class="label">上传头像</label><input name="upload" id="upload" type="file" />&nbsp;&nbsp;选择大小为116px×116px的图片效果最佳</p>
					</div>
					<input type="submit" class="savebtn"  value="" style="margin:20px 0 0 250px; display:inline" />
					</form>
				</div>
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
