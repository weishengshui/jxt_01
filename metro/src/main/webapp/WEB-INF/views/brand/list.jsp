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

<script type="text/javascript">
	
	$(document).ready(function(){
		$('#tt').datagrid({
			onDblClickRow: function(rowIndex,rowData){
					var titile = "维护"+rowData.name + '的信息' ;
					parent.addTab(titile,'<%=request.getContextPath()%>/brand/edit?id='+ rowData.id);			
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
		
	    $('#tt').datagrid('load',{  
	    	name:$('#name').val(),  
	    	companyName:$('#companyName').val(),
	    	createStart:$('#createStart').datebox('getValue'),
	    	createEnd:$('#createEnd').datebox('getValue'),
	    	unionInvited:$('#unionInvited').val()
	    });  
	}
	function del(){
		var rows = $('#tt').datagrid('getSelections');
		if(rows){
			if(rows.length == 0){
				alert("请先选择要删除的品牌");
				return;
			}
			var data = '';
			for(var i=0,length=rows.length; i < length; i++){
				var row = rows[i];
				data += 'ids='+row.id+'&';
			}	
			data = data.substring(0, data.length -1);
			if(!confirm("确认删除？")){
				return;
			}
			$.ajax({
				url:'delete',
				type:'post',
				data:data,
				success: function(data){
					if(data.success){ //删除成功
						$('#tt').datagrid('reload');
					}
					$.messager.show({
						title:'提示信息',
						msg:data.msg,
						timeout:5000,
						showType:'slide'
					});
					//alert(data.msg);
				}
			}); 
		}else{
			alert("请先选择要删除的品牌");			
		}
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
			alert("请选择要编辑的数据");
			return;
		}
		parent.addTab('维护'+row.name+'的信息','brand/edit?id='+row.id);
	}
	function clearForm(){
		$('#fm').form('clear');
	}
</script>

</head>
	<body>
		<form action="" id="fm" style="width:1100px;">
			<table border="0" style="font-size: 14px;">
				<tr>
					<td>品牌名称：</td>
					<td>
						<input id="name" name="name" type="text" style="width:150px"/> 
					</td>
					<td>&nbsp;公司名称：</td>
					<td>
						<input id="companyName" name="companyName" type="text" style="width:150px"> 
					</td>
				</tr>
				<tr>
					<td>创建时间：</td>
					<td>
						<input id="createStart" name="createStart" type="text" style="width:150px" class="easyui-datebox" editable="false"/>
					</td>
					<td>&nbsp;至</td>
					<td>
						<input id="createEnd" name="createEnd" type="text" style="width:150px" class="easyui-datebox" editable="false"/>
					</td>
				</tr>
				<tr>
					<td>联合会员申请状态：</td>
					<td>
						<select id="unionInvited" name="unionInvited" style="width:150px">
							<option value="">请选择</option>
							<option value="ON">已申请</option>
							<option value="OFF">未申请</option>
						</select>
					</td>
					<td>
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
		<table id="tt" class="easyui-datagrid" data-options="url:'list',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,toolbar: '#toolbar',
			rownumbers:true,pageList:pageList,singleSelect:false">
		    <thead>  
		        <tr>  
               		<th data-options="field:'name',width:50">品牌名称</th>
               		<th data-options="field:'companyName',width:50">公司名称</th>
               		<th data-options="field:'contact',width:50">联系人</th>
               		<th data-options="field:'phoneNumber',width:50">联系电话</th>
               		<th data-options="field:'createdAt',formatter:function(v,r,i){return dateFormat(v);}" >创建时间</th>
               		<th data-options="field:'unionInvited',formatter:function(v,r,i){if(v){return '已申请';}else{return '未申请';}}">联合会员申请</th>
		         	<th data-options="field:'id',hidden:true">id</th>
		        </tr>  
		    </thead>  
		</table> 
	</body>
</html>