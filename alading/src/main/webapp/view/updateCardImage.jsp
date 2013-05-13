<%@ page language="java" contentType="text/html; charset=utf8"
	pageEncoding="utf8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link id="easyuiTheme" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/extend-easyui-validate.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/common.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/PCASClass.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/constant.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.json-2.4.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<style type="text/css">
	fieldset table tr{height: 35px;}
	fieldset{margin-bottom:10px;margin-left:30px;margin-top:10px;}
	.red{color:red;font-size:12px;}
	form{margin:0; padding:0} 
</style>
<script type="text/javascript">
		var baseURL = '<%=request.getContextPath()%>';
	
		
		function show(url,width,height){
			width = (width> 500 ? 500: width);
			height = (height> 700 ? 500: height);
			parent.parent.dialog("预览图片",url,width,height);
		}
		
		$(document).ready(function(){
			$('#oldPic').attr('src', baseURL+'/view/cardImageGet/${param.id}');
		});
		
		function doSubmit(){
			/* var pic = document.getElementById('pic');
			if(pic.value == ''){
				alert("请先添加图片");
				return ;
			} */
			$('#fm').form('submit',{
				success:function(result){
					if(result == 'success'){
						result = '成功';
					} else {
						result = '失败';
					}
					$.messager.show({
						title:'提示信息',
						msg: result,
						timeout:5000,
						showType:'slide'
					});
				}
			}); 
		}
	function check(path,spanId){
		var filepath=path.value;
		filepath=filepath.substring(filepath.lastIndexOf('.')+ 1,filepath.length);
		filepath = filepath.toLocaleLowerCase();
		if(filepath != 'jpg' && filepath != 'gif' && filepath!='jpeg' && filepath !='bmp' && filepath!='png'){
			alert("只能上传JPG, GIF, JPEG, BMP, PNG格式的图片");
			deleteInputFile(path.name, path.id, spanId);
		}
	}
	function openDialog(){
		$('#dd').dialog('center');
		$('#dd').dialog('open');
	}
	function deleteInputFile(name, id, spanId){// 清空input type=file 直接$('#'+imageId).val('');有浏览器不兼容的问题
		$('#'+spanId).html("<input type=file name="+ name +" id="+ id +" accept=image/* onchange=check(this,'"+spanId+"') />");
	}
</script>

</head>
<body>
   	<form action="cardImageUpdate" method="post" id="fm" enctype="multipart/form-data"> 
		<table border="0" style="font-size:13px;">
			<tr>
				<td>
					<fieldset style="font-size: 14px;width:570px;height:auto;">
						<legend style="color: blue;">卡图片修改</legend>
							<table border="0">
								<tr>
									<td><span style="color: red;"></span></td>
									<td>图片：</td>
									<td>
										<input type="hidden" name="id" id="id" value="${param.id }" />
										<img id="oldPic" alt="" src="">
									</td>
								</tr>
								<tr>
									<td><span style="color: red;">&nbsp;</span></td>
									<td>替换图片：</td>
									<td>
									<span id="picSpanId">
										<input type="file" name="pic" id="pic" onchange="check(this,'picSpanId')">
									</span>
									</td>
								</tr>
								<tr>
									<td><span style="color: red;"></span></td>
									<td>描述：</td>
									<td>
										<textarea rows="5" cols="15" name="description">${param.description}</textarea>
									</td>
								</tr>
								<tr>
									<td align="right" colspan="3">
										<a href="javascript:void(0)" onclick="doSubmit()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
									</td>
								</tr>
							</table>
					</fieldset>
				</td>
			</tr>
			
		</table>
	</form>
</body>
</html>