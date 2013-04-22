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
<style type="text/css">
	body {
		font-family: 黑体、宋体、Arial;
		font-size: 14px;
	}
</style>

<script type="text/javascript">
	
	function doSearch(){  
	    $('#tt').datagrid('load',{  
	    	opt:$('#opt').val(),  
	    	from:$('#from').datebox('getValue'),
	    	to:$('#to').datebox('getValue')
	    });  
	}
	
	function cleardt(){
		$('#from').datebox('setValue', '');
		$('#to').datebox('setValue', '');
	}
	
	function showDetail(id){
		parent.addTab(id+'失效积分明细','integralManagement/expired_detail?transactionNo='+id);
	}
	
	function operates(v,o,i){
		return '<a onclick="showDetail('+v+')" href="#">'+v+'</a>';
	}
</script>
</head>
	<body>
		<table border="0">
			<tr>
				<td>
					<form action="" >
						<table border="0">
							<tr>
								<td width="100px">操作员：</td>
								<td width="160px" align="left">
									<input id="opt" name="opt" type="text" style="width:150px"/> 
								</td>
							</tr>
							<tr>
								<td width="100px">操作时间：</td>
								<td width="160px" align="left">
									<input id="from" name="from" type="text" style="width:150px" class="easyui-datebox" editable="false"/>
								</td>
								<td width="20px">至</td>
								<td width="160px" align="left">
									<input id="to" name="to" type="text" style="width:150px" class="easyui-datebox" editable="false"/>
								</td>
								<td>
									<a onclick="doSearch()" href="javascript:void(0)"  class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
									&nbsp;&nbsp;
									<a onclick="cleardt()" href="javascript:void(0)"  class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a>
								</td>
							</tr>
						</table>
					</form>
				</td>
			</tr>
			<tr>
				<td>
           				<table  id="tt"  title=""  class="easyui-datagrid" data-options="url:'expired_list',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
						rownumbers:true,pageList:pageList,singleSelect:true,onCheck:function(rowIndex, rowData){}">
       					<thead>  
           				<tr>  
	                		<th data-options="field:'transactionNo',formatter:function(v,o,i){return operates(v,o,i)},width:130" >批次号</th>
	                		<th data-options="field:'opt',width:100">操作员</th>
	                		<th data-options="field:'transactionDate',width:100,formatter:function(v,r,i){return dateFormat(v);}">操作时间</th>
	                		<th data-options="field:'countMembers',width:100">会员人数</th>
	                		<th data-options="field:'amountPoints',width:100">积分总数</th>
	                		<th data-options="field:'status',width:100" >状态</th>
			           	</tr>  
				       	</thead>  
			   		</table> 
				</td>
			</tr>
		</table>
	</body>
</html>