<%@ page language="java" contentType="text/html; charset=utf8"
	pageEncoding="utf8"%>
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
<% response.setHeader("Cache-Control","no-store");%>
<script type="text/javascript">
		var baseURL = '<%=request.getContextPath()%>';
	
		
		$(document).ready(function(){
			var pointRate = '${unit.pointRate}';
			if( pointRate == ''){
				$('#pointRate').numberbox('setValue', 1);
			} else {
				$('#pointRate').numberbox('setValue', pointRate);
			}
		});
		
		function doSubmit(){
			var pointRate = $('#pointRate').numberbox('getValue');
			if(pointRate){
				if(pointRate < 1){
					alert("积分比不能小于1");
					return; 
				}
			}else {
				alert("请输入积分比");
				return ;
			}
			var pointName = $('#pointName').val();
			if(pointName){
				if(pointName.trim() == ''){
					alert("单位名称不能为空或全是空格");
					return ;
				}
			} else {
				alert("请输入单位名称");
				return; 
			}
			$('#fm').form('submit',{
				success:function(result){
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
</script>

</head>
<body>
   	<form action="unitShow" method="post" id="fm"> 
		<table border="0" style="font-size:13px;">
			<tr>
				<td>
					<fieldset style="font-size: 14px;width:570px;height:auto;">
						<legend style="color: blue;">积分单位维护</legend>
							<table border="0">
								<tr>
									<td><span style="color: red;">*&nbsp;</span></td>
									<td>单位名称：</td>
									<td>
										<input type="hidden" name="pointId" id="pointId" value="${unit.pointId}">
										<input type="text" name="pointName" id="pointName" value='<c:out value="${unit.pointName }"></c:out>' maxlength="20"> 
									</td>
								</tr>
								<tr>
									<td><span style="color: red;">*&nbsp;</span></td>
									<td>积分比：</td>
									<td>
									    <input type="text" name="pointRate" id="pointRate" class="easyui-numberbox" data-options="min:1,precision:0"></input>  
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