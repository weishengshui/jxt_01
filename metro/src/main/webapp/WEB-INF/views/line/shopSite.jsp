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
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/common.js"></script>
<style type="text/css">
#searchTable input{width:100px;}
</style>
<script>
	function save(){
		$('#myform').form('submit', {
		    url:'saveShopSite',
		    dataType:'json',
		    onSubmit: function(){
			    if(parent.getId()==0){
				    $.messager.alert('提示','请先保存门店','warning');
				    return false;
				}else{
					$("#shopId").val(parent.getId());
					$("#shopName").val(parent.getName());
				}
			    var flag = false;
		    	if($('#myform').form('validate')){
		    		 $.ajax({
		 				url:'validateShopSiteCode',
		 				async: false,
		 				type :'post',
		 				data:"siteId="+$("#siteId").val()+"&orderNo="+$("#orderNo").val()+"&shopId="+parent.getId(),
		 				success:function(data){
		 					if(data == 0){
		 						flag = true;
		 					}else{
		 						$.messager.alert('提示','编号已经存在','warning');
		 					}
		 				}
		 			});
		    	}
		    	return flag;
			},
		    success:function(id){
			    if($("#id").val()=='')$("#id").val(id);
			    parent.showMessage('保存成功');
		    }
		});
    }
	function addDialog(){
		$("#site").dialog({
			height:340,
			width:500,
			modal:true,
			resizable:true,
			title:"选择站台"
		});
	}
	function selectSite(){
		var row = $('#table').datagrid('getSelected');//getSelected选一个
		if(row == null) return;
		$("#siteName").val(row.name);
		$("#siteId").val(row.id);
		$("#site").dialog("close");
	}
	function searchs(){
        //load 加载数据分页从第一页开始, reload 从当前页开始
    	$('#table').datagrid('load',getForms("searchForm"));
    }
</script>
</head>
<body>
	<form id="myform" style="margin: 20px;font-size:13px;">
	    <input type="hidden" name="shopId" id="shopId"/>
	    <input type="hidden" name="shopName" id="shopName"/>
	    <input type="hidden" name="siteId" id="siteId" value="${site.id }"/>
	    <table>
	    	<tr>
	    		<td>站台名称：<input type="text" name="siteName" id="siteName" value="${site.name }" readonly="readonly" class="easyui-validatebox" data-options="required:true"/></td>
	    		<td>
	    			<a id="btn" href="javascript:void(0)" onclick="addDialog()()" class="easyui-linkbutton" data-options="iconCls:''">选择</a>
	    		</td>
	    	</tr>
	    	<tr>
	    		<td>排序编号：<input type="text" id="orderNo" name="orderNo" value="${orderNo }" class="easyui-numberbox" data-options="required:true"/></td>
	    		<td></td>
	    	</tr>
	    	<tr align="right" height="60">
	    		<td><a id="btn" href="javascript:void(0)" onclick="save()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a></td>
	    	</tr>
	    </table>
	</form>  
	<div style="display: none;">
		<div id="site">
			<div style="margin-top:5px;margin-bottom: 5px;">
			<form id="searchForm">
			&nbsp;站台名：<input type="text" name="name"/>
			<a id="btn" href="javascript:void(0)" onclick="searchs()" class="easyui-linkbutton">搜索</a>
			<a id="btn" href="javascript:void(0)" onclick="selectSite()" class="easyui-linkbutton">确定</a>
			</form>
			</div>
			<table id="table" class="easyui-datagrid" data-options="url:'findSites',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
				rownumbers:true,pageList:pageList,singleSelect:true,height:250" >
			    <thead>
			        <tr>
			        	<th field="ck" checkbox="true"></th>  
			        	<th data-options="field:'id',hidden:'true',width:5">id</th>
			            <th data-options="field:'name',width:30">站台名</th>
			        </tr>  
			    </thead>  
			</table> 
		</div>
	</div>
</body>
</html>