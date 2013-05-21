<%@ page language="java" contentType="text/html; charset=utf8" pageEncoding="utf8"%>
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
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<style type="text/css">
	.select{width:140px;height:22px;margin-right:20px;}
	form{margin:0; padding:0} 
</style>
<% response.setHeader("Cache-Control","no-store");%>
<script type="text/javascript">
	var baseURL = '<%=request.getContextPath()%>';
	
	$(document).ready(function(){
		$('#tt').datagrid({
			onDblClickRow: function(rowIndex,rowData){
					var titile = '维护卡信息';
					parent.addTab(titile,'showCard.do?id='+ rowData.id+'&temp='+new Date().getTime());			
			}
		});	  
	});
	function formatterdate(val, row) {
        var date = new Date(val);
        var m = (date.getMonth() + 1) < 10 ? "0" + (date.getMonth() + 1) : (date.getMonth() + 1);
        var d = date.getDate() < 10 ? "0" + date.getDate() : date.getDate();
        return date.getFullYear() + '-' + m + '-' + d;
	}

	function doSearch(){  
		if($('#defaultCard').combobox('getValue') == ''){
		    $('#tt').datagrid('load',{  
		    	cardName:$('#cardName').val()
		    });  
		} else {
		    $('#tt').datagrid('load',{  
		    	cardName:$('#cardName').val(),
		    	defaultCard: $('#defaultCard').combobox('getValue')
		    });  
		}
	}
	function del(){
		var row = $('#tt').datagrid('getSelected');
		if(row == null){
			alert("请选择要删除的卡");
			return;
		}
		if(row.defaultCard){
			alert("默认卡不能删除");
			return ;
		}
		var id = row.id;
		if(!confirm("确认删除？")){
			return;
		}
		$.ajax({
			url:'deleteCard.do',
			type:'post',
			cache: false,
			data: {id: id},
			success: function(data){
				var res = "删除失败";
				if(data.type == 3){
					res = "删除成功";
				}				
				$.messager.show({
					title:'提示信息',
					msg:res,
					timeout:5000,
					showType:'slide'
				});
				doSearch();
			}
		}); 
	}
	
	function update(v, r, i){
		var name = r.name.replaceAll("'" , "&#39;");
		 name = encodeURIComponent(name);
		return '<a href="javascript:void(0)" onclick="edit(\''+r.id+'\',\''+name+'\')">修改</a>';
	}
	
	/* function edit(id,name){
		name = decodeURIComponent(name);
		parent.addTab('维护'+name+'的信息','brand/edit?id='+id);
	} */
	function edit(){
		var row = $('#tt').datagrid('getSelected');
		if(row == null){
			alert("请选择要修改的卡");
			return;
		}
		var titile = '维护卡信息';
		parent.addTab(titile,'showCard.do?id='+ row.id+'&temp='+new Date().getTime());
	}
	function clearForm(){
		$('#cardName').val('');
		$('#defaultCard').combobox('select', '');
	}
	function previewImage(v, r, i){
		var url = baseURL + "/view/showImage.do?id="+r.imageId;
		return '<a href=javascript:show(\''+url+'\',\''+500+'\',\''+300+'\')>预览</a>';
	}
	
	function show(url,width,height){
        width = (width> 500 ? 500: width);
        width = (width < 100 ? 100: width);
        height = (height> 700 ? 500: height);
        height = (height < 100 ? 100: height);
        parent.parent.dialog("预览图片",url,width,height);
	}
	function formatterCardId(v, r, i){
		if(r.card){
			return r.card.id;
		}
	}
	function formatterCardName(v, r, i){
		if(r.card){
			return r.card.cardName;
		}
	}
</script>

</head>
	<body>
		<form action="" id="fm" style="width:1100px;">
			<table border="0" style="font-size: 14px;">
				<tr>
					<td>卡名称：</td>
					<td>
						<input id="cardName" name="cardName" type="text" style="width:150px"/> 
					</td>
					<td>是否默认：</td>
					<td>
						<input id="defaultCard" name="defaultCard" class="easyui-combobox" style="width:150px" data-options="
						valueField: 'value',
						textField: 'label',
						data: [{
							label: '所有',
							value: '',
							selected:true 
						},{
							label: '否',
							value: 'false'
						},{
							label: '是',
							value: 'true'
						}]" /> 
					</td>
					<td>
						<a href="javascript:void(0)" onclick="doSearch()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>&nbsp;&nbsp;<a href="javascript:void(0)" onclick="clearForm()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a>
					</td>
				</tr>
			</table>
		</form>
		<div id="toolbar">  
	       <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="edit()">修改</a>  
	       <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="del()">删除</a>  
	   </div>
	   <!-- 显示列表Table -->
		<table id="tt" class="easyui-datagrid" data-options="url:'listCards.do',method:'post',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,toolbar: '#toolbar',
			rownumbers:true,pageList:pageList,singleSelect:true">
		    <thead>  
		        <tr>
		        	<th data-options="field:'id',width:50">id</th>  
               		<th data-options="field:'cardName',width:50">卡名称</th>
               		<th data-options="field:'companyName',width:50">所属企业</th>
               		<th data-options="field:'defaultCard',width:50,formatter: function(v, r, i){if(v) return '是'; else return '否';}">是否默认卡</th>
               		<th data-options="field:'imageId',width:50, formatter: function(v, r, i){return previewImage(v, r, i);}">预览卡图片</th>
		        </tr>  
		    </thead>  
		</table> 
	</body>
</html>