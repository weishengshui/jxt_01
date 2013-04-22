<%@page import="com.chinarewards.metro.core.common.Dictionary"%>
<%@ page language="java" contentType="text/html; charset=utf8" pageEncoding="utf8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link id="easyuiTheme" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/common.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/PCASClass.js"></script>
<style>
	.table select{width:140px;height:22px;margin-right:20px;}
</style>
<script>
	
	function edit(id_,name_){
		var id = id_;
		var name = name_;
		if(id == undefined){
			var row = $('#table').datagrid('getSelected');//getSelected / getSelected
			if(row == null){
				$.messager.alert('提示','请选择要编辑的数据','warning');return;
			}
			id = row.id;
			name = row.name;
		}
		parent.addTab('修改门店'+name,"line/updateShopPage?id="+id);
	}
	function del(){
		var rows = $('#table').datagrid('getSelections');
		if(rows==''){$.messager.alert('提示','请选择要删除的数据','warning');return;}
		$.messager.confirm('确认框','确定要删除吗 ?',function(r){
			if(r){
				var s = '',n=''; 
				for(var i=0; i<rows.length; i++){
		            if (s != '') { s += ',',n+=",";}  
		            s += rows[i].id;
		            n += rows[i].name;
		        }
				$.ajax({
		        	url:'delShop',
		        	type:'post',
		        	dataType:'json',
		        	data:"ids="+s+"&names="+encodeURI(n),
		        	success:function(data){
		        		$.messager.show({  
	                        title:'提示',  
	                        msg:'删除成功',  
	                        showType:'show'  
	                    });
		        		$('.easyui-datagrid').datagrid('reload');
		        	}
				});
			}		
		});
	}
	function searchs(){
        //load 加载数据分页从第一页开始, reload 从当前页开始
    	$('#table').datagrid('load',getForms("searchForm"));
    }
    function getAddress(v,o,i){
        return (o.province == null ? '' : o.province) + 
         	   (o.city == null ? '' : o.city) + 
         	   (o.region == null ? '' : o.region ) + 
         	   (o.address == null ? '' : o.address);
    }
    function resets(){
    	searchForm.reset();
    	$("#province").combobox('clear');
    	$("#city").combobox('clear');
    	$("#area").combobox('clear');
    }
</script>
</head>
<body>
	<!-- 查询条件Table -->
	<form id="searchForm">
		<table class="table" style="font-size:13px;">
			<tr>
				<td>总店编号:</td>
				<td><input type="text" name="num" style="width:100px;"/></td>
				<td>&nbsp;&nbsp;中文名称:</td>
				<td><input type="text" name="name" style="width:100px;"/></td>
				<td>&nbsp;&nbsp;英文名称:</td>
				<td><input type="text" name="enName" style="width:100px;"/></td>
				<td>&nbsp;&nbsp;联系人:</td>
				<td><input type="text" name="linkman" style="width:100px;"/></td>
				<td>
					<a id="btn" href="javascript:void(0)" onclick="searchs()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
					<a id="btn" href="javascript:void(0)" onclick="resets()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a>
				</td>
			</tr>
			<tr>
				<td>区域:</td>
				<td colspan="4">
					<select name="province" id="province" class="easyui-combobox" style="width:100px;"></select>
	  				<select name="city" id="city" class="easyui-combobox" style="width:100px;"></select>
	  				<select name="region" id="area" class="easyui-combobox" style="width:100px;"></select>
				</td>
				<td colspan="2">
				类型:
				<select name="shopType" class="easyui-combobox">
						<option value="0">全部</option>
						<c:forEach items="${shopTypes }" var="type">
	  						<option value="${type.key }" ${type.key==shop.shopType?'selected':'' } >${type.value }</option>
	  					</c:forEach>
					</select>
				</td>
			</tr>
		</table>
	</form>
	<div id="toolbar">  
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="edit()">修改</a>  
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="del()">删除</a>  
    </div>  
	<!-- 显示列表Table -->
	<table id="table" class="easyui-datagrid" data-options="url:'findShopList',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,toolbar: '#toolbar',
		rownumbers:true,pageList:pageList,singleSelect:false,onDblClickRow:function(rowIndex,rowData){edit(rowData.id,rowData.name);}">
	    <thead>  
	        <tr> 
	        	<th data-options="field:'id',hidden:true,width:30">id</th>
	            <th data-options="field:'num',width:30">总店编号</th>
	            <th data-options="field:'name',width:30">中文名称</th>
	            <th data-options="field:'enName',width:30">英文名称</th>
	            <th data-options="field:'region',width:30,formatter:function(v,o,i){return getAddress(v,o,i) }">区域</th>  
	            <th data-options="field:'linkman',width:30">联系人</th>
	            <th data-options="field:'workPhone',width:30">联系电话</th>
	            <th data-options="field:'siteName',width:30">所属站台</th>
	        </tr>  
	    </thead>  
	</table> 
	<script>
		new PCAS("province","city","region");
	</script>
</body>
</html>