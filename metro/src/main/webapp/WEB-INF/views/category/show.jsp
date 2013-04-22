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
<script id="easyuiTheme" type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/common.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>	
<script type="text/javascript">
		var baseURL = '<%=request.getContextPath()%>';

	function saveCategory() {
		if ($.trim($('#id_').val()) == null
				|| $.trim($('#id_').val()) == "") {
			alert("请先选择一个节点");
			return;
		}
			$('#fm').form('submit',{  
				url:'create',
		        onSubmit: function(){  
		        	return $(this).form('validate');  
		        },  
		        success: function(result){ 
		        	if(eval('('+result+')').success){
			        	var oldId = $('#oldParentId').val();
			        	var newId = $('#parentId').val();
	
			        	if(oldId != newId){
			        		//alert("oldId != newId oldId  is "+ oldId);
			        		var oldParent = $('#tt').tree('find', oldId);
			        		//alert("oldId != newId oldParent  is "+ oldId);
			        		$('#tt').tree('reload', oldParent.target);
				        	$('#tt').tree('expandTo', oldParent.target);
			        	}
			        	//refreshTree(newId);
			        	setTimeout("refreshTree(\'"+ newId+ "\')",200);//延时执行，否则树没加载完，newParent就找不到就报错
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
	function refreshTree(newId){
		var newParent = $('#tt').tree('find', newId);
		if(newParent){
			$('#tt').tree('reload', newParent.target);
	    	$('#tt').tree('expandTo', newParent.target);
		}else{//newParent 还没有加载，找不到，从根节点开始一级级加载
			var timeIndex = 0;
			$.ajax({
				url:'get_parents',
				data:'id='+newId,
				async:false,
				success: function(result){
					if(result && result.length > 0){
						for(var i =1, length = result.length; i < length; i++){
							timeIndex += 200*(i);
							setTimeout("reloadChilds(\'"+ result[i].id+ "\')",timeIndex);
						}
					}
				}
			});
			setTimeout("reloadChilds(\'"+ newId+ "\')",timeIndex + 200);
		}
	}
	
	function reloadChilds(id){
		var node = $('#tt').tree('find', id);
		$('#tt').tree('reload', node.target);
    	$('#tt').tree('expandTo', node.target);
	}
	
	function deleteCategory(){
		if ($.trim($('#id_').val()) == null
				|| $.trim($('#id_').val()) == "") {
			alert("请先选择一个节点");
			return;
		}
		if (!$('#fm').form('validate')) {
			return ;
		}
			$('#fm').form('submit',{
				url: 'delete',
		        onSubmit: function(){
		        	if(!confirm("确认删除?")){
		        		return false; 
		        	}
		        	return $(this).form('validate');  
		        },  
		        success: function(result){  
		        	if(eval('(' + result + ')').success){
			        	var oldId = $('#oldParentId').val();
			        	
			        	var oldParent = $('#tt').tree('find', oldId);
		        		$('#tt').tree('reload', oldParent.target);
			        	$('#tt').tree('expandAll', oldParent.target);
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
	function openDialog(){
		
		if ($.trim($('#id_').val()) == null
				|| $.trim($('#id_').val()) == "") {
			alert("修改父节点之前，请先选择一个子节点");
			return;
		}
		
		var root = $('#tt2').tree('getRoot');
		if(root){
			$('#tt2').tree('reload', root.target); 
			$('#tt2').tree('expandAll', root.target);
		}
		$('#dd').dialog('open');
	}
	//选择父节点
	function selectParent(){
		var node = $('#tt2').tree('getSelected');
		if(node){
			var id = $('#id_').val();
			if(node.id == id){
				alert("选择的父节点无效");
				return ;
			}
			var valid = true;
			var parent = $('#tt2').tree('getParent', node.target);
			while(parent){
				if(id==parent.id){
					valid = false;
					break;
				}			
				parent = $('#tt2').tree('getParent', parent.target);
			}
			if(!valid){
				alert("选择的父节点无效");
				return ;
			}
			var hasMerchandise = false;
			$.ajax({
				url:'hasMerchandises',
				data:'id='+node.id,
				type:'post',
				async:false,
				success: function(result){
					if(eval('('+result+')').success){
						hasMerchandise = true;		
					}
				}
			});
			if(hasMerchandise){
				alert("类别\""+node.text+"\"下有商品，不能作为父节点");
				return;
			}
			$('#parentId').val(node.id);
			$('#parentName').val(node.text);
			$('#dd').dialog('close');
		}else{
			alert("请选择一个节点");
		}
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
						<ul id="tt" class="easyui-tree" url="get_tree_nodes" data-options="
							url:'get_tree_nodes',
							onLoadSuccess: function(node, data){
								if(node){
									var root = $('#tt').tree('getRoot');
									if(data && node.id == root.id){
										if(data.length>0){
											var childrens = $(this).tree('getChildren', node.target); 
											$(this).tree('select',childrens[0].target);
										}else{
											$('#name').val('');
											$('#id_').val('');
											$('#displaySort').numberbox('clear');
										}
									}
								}else{//第一次加载“根节点”，node为空
									var root = $(this).tree('getRoot');
									if(root){// 继续加载根节点的子节点
										$('#tt').tree('reload', root.target); 
									}
								}
							},
							onSelect: function(node){
								var root = $(this).tree('getRoot');
								if(root.id == node.id){
									var childrens = $(this).tree('getChildren', root.target);
									if(childrens && childrens.length > 0){
										$(this).tree('select',childrens[0].target);
									}
								}else{
									var par = $(this).tree('getParent', node.target);
									$('#parentId').val(par.id);
									$('#oldParentId').val(par.id);
									$('#parentName').val(par.text);
									$('#name').val(node.text);
									$('#id_').val(node.id);
									var d =(new Function('','return '+node.attributes))();
									$('#displaySort').numberbox('setValue', d.displaySort);
								}
							}"></ul>
						<input type="hidden" id="opt" name="opt"> 
						<input type="hidden" id="id" name="id">
				</fieldset>
			</td>
			<td>
				<fieldset style="font-size: 14px;width:400px;height:800px;">
					<legend style="color: blue;">类别信息</legend>
					<form id="fm" action="create" method="post">
					<table>
						<tr>
							<td colspan="2">请从左边商品类别树选择商品类别</td>
						</tr>
						<tr>
							<td><span style="color: red;">*&nbsp;</span>父节点：</td>
							<td>
								<input type="hidden" name="oldParentId" id="oldParentId">
								<input type="hidden" name="parent.id" id="parentId"> 
								<input id="parentName" name="parentName" type="text" style="width:150px" disabled="disabled"> 
							</td>
							<td>
								<a href="javascript:void(0)" onclick="openDialog()" class="easyui-linkbutton" data-options="iconCls:'icon-edit'">修改</a>
							</td>
						</tr>
						<tr>
							<td><span style="color: red;">*&nbsp;</span>类别名称：</td>
							<td colspan="2">
								<input type="hidden" name='id' id='id_' />
								<input id="name" type='text' name='name' style="width:150px" 
												class="easyui-validatebox" data-options="required:true" maxlength="20"/>
							</td>
						</tr>
						<tr>
							<td><span style="color: red;">*&nbsp;</span>排序编号：</td>
							<td colspan="2">
								<input id="displaySort" type='text' name='displaySort' style="width:150px"  
												class="easyui-numberbox" data-options="min:1,required:true" maxlength="10"/>
							</td>
						</tr>
						<tr>
							<td colspan="4" align="center">
								<a href="javascript:void(0)" onclick="saveCategory()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>&nbsp;&nbsp;<a href="javascript:void(0)" onclick="deleteCategory()" class="easyui-linkbutton" data-options="iconCls:'icon-remove'">删除</a>
							</td>
						</tr>
					</table>
					</form>
				</fieldset>
			</td>
		</tr>
	</table>
	
	<div id="dd" class="easyui-dialog" title="选择父节点" style="width:400px;height:400px;"  
        data-options="resizable:false,modal:true,closed:true">  
        <ul id="tt2" class="easyui-tree" url="get_tree_nodes" style="margin-top:10px;margin-left:20px;"></ul>
        <div style="position: absolute;top: 350px;left:200px;text-align:right;">
        	<a href="javascript:void(0)" onclick="selectParent()" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">确定</a>&nbsp;&nbsp;<a href="javascript:void(0)" onclick="javascript:$('#dd').dialog('close');" class="easyui-linkbutton" data-options="iconCls:'icon-back'">关闭</a>
        </div>
	</div> 

</body>
</html>