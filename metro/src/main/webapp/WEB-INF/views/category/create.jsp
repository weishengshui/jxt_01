<%@ page language="java" contentType="text/html; charset=utf8"
	pageEncoding="utf8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link id="easyuiTheme" rel="stylesheet" type="text/css"
	href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css"
	href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<style type="text/css">
fieldset table tr {
	height: 35px;
}

fieldset {
	margin-bottom: 10px;
	margin: 10px;
}

select {
	width: 155px;
	height: 20px;
}

.red {
	color: red;
	font-size: 12px;
}
</style>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/common.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery/ajaxfileupload.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<script type="text/javascript">
		var baseURL = '<%=request.getContextPath()%>';
	
		
		$(function(){
			setTimeout("expandRoot()", 200);
		});
		
		function expandRoot(){
			var root = $('#tt').tree('getRoot');
			if(root){
				$('#tt').tree('reload', root.target); 
				$('#tt').tree('expandAll', root.target);
			}
		}
		
	function saveCategory() {
		if ($('#parentName').val() == "") {
			alert("请先选择一个父节点");
			return;
		}
		if ($.trim($('#name').val()) == null
				|| $.trim($('#name').val()) == "") {
			alert("请输入类别名称");
			return;
		}
		if(!$('#fm').form('validate')){
			return;
		}

		$('#fm').form('submit',{  
	        success: function(result){  
	        	var node = $('#tt').tree('getSelected');
	        	if(node){
	        		$('#tt').tree('reload', node.target);
	        		$('#tt').tree('expandTo', node.target);
	        	}
	        	if(eval('(' + result + ')').success){
	        		$('#name').val('');
	        		$('#displaySort').numberbox('clear');
	        	}
	        	//alert(eval('(' + result + ')').msg);
	        	$.messager.show({
					title:'提示信息',
					msg:eval('(' + result + ')').msg,
					timeout:5000,
					showType:'slide'
				});
	        }  
	    });	
	}
	function clearForm(){
		$('#fm').form('clear');
	}
</script>

</head>
<body>
	<table border="0">
		<tr>
			<td>
				<fieldset style="font-size: 14px;width:400px;height:800px;">
					<legend style="color: blue;">商品类别树</legend>
						选择商品类别：
						<ul id="tt" class="easyui-tree" url="get_tree_nodes" data-options='
							url:"get_tree_nodes",
							onClick: function(node){
								var hasMerchandise = false;
								$.ajax({
									url:"hasMerchandises",
									data:"id="+node.id,
									type:"post",
									async:false,
									success: function(result){
										if(eval("("+result+")").success){
											hasMerchandise = true;		
										}
									}
								});
								if(hasMerchandise){
									alert("类别\"" + node.text + "\"下有商品，不能作为父节点");
								}else{
									$("#parentId").val(node.id);
									$("#parentName").val(node.text);
								}
							}'></ul>
				</fieldset>
			</td>
			<td>
				<fieldset style="font-size: 14px;width:300px;height:800px;">
					<legend style="color: blue;">类别信息</legend>
					<form id="fm" action="create" method="post">
					<table>
						<tr>
							<td colspan="2">请从左边商品类别树选择父节点</td>
						</tr>
						<tr>
							<td><span style="color: red;">*&nbsp;</span>父节点：</td>
							<td>
								<input type="hidden" name="parent.id" id="parentId"> 
								<input id="parentName" name="parentName" type="text" style="width:150px" disabled="disabled"> 
							</td>
						</tr>
						<tr>
							<td><span style="color: red;">*&nbsp;</span>类别名称：</td>
							<td>
								<input id="name" type='text' name='name' style="width:150px" 
												class="easyui-validatebox" data-options="required:true" maxlength="20"/>
							</td>
						</tr>
						<tr>
							<td><span style="color: red;">*&nbsp;</span>排序编号：</td>
							<td>
								<input id="displaySort" type='text' name='displaySort' style="width:150px"  
												class="easyui-numberbox" data-options="min:1,required:true" maxlength="10"/>
							</td>
						</tr>
						<tr>
							<td colspan="3" align="center">
								<a href="javascript:void(0)" onclick="saveCategory()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>&nbsp;&nbsp;<a href="javascript:void(0)" onclick="clearForm()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a>
							</td>
						</tr>
					</table>
					</form>
				</fieldset>
			</td>
		</tr>
	</table>

</body>
</html>