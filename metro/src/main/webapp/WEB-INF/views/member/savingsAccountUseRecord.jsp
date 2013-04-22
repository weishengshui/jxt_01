<%@page import="com.chinarewards.metro.core.common.Dictionary"%>
<%@page import="com.chinarewards.metro.domain.account.TxStatus" %>
<%@ page language="java" contentType="text/html; charset=utf8" pageEncoding="utf8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%--"http://www.w3.org/TR/html4/loose.dtd" --%>
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
<style>
	fieldset{margin-bottom:10px;margin:0px;font-size:14px;}
	.showTable td{}
	form{margin:0; padding:0}
</style>
<script type="text/javascript">
	function searchs(){
		$('#table').datagrid('load',{  
			id: $('#id_').val(),
			businiessNo: $('#businiessNo').val(),
			transactionDateStart: $('#transactionDateStart').datebox('getValue'),
			transactionDateEnd: $('#transactionDateEnd').datebox('getValue')
	    }); 
	}
	function formateTxStatus(v){
		var txStatuses = ${txStatusesJson};
		for(var i=0, length = txStatuses.length; i < length; i++){
			 if(v == txStatuses[i].key){
            	return txStatuses[i].value;
            }
		}
	}
	function reset1(){
		$('#transactionDateStart').datebox('setValue','');
		$('#transactionDateEnd').datebox('setValue','');
		$('#businiessNo').val('');
	}
	function redemptionDetail(v){
		var flag = false ;
		$.ajax({
            url:'<%=request.getContextPath()%>/merchandise/checkDetails',
            type:'post',
            async: false,
            data:{
            	orderInfoId: v
            },
            success:function(data){
            	if(data > 0){
            		flag = true ;
            	}
            }
        });
		if(!v){
			v = "''";
		}else{
			v = "'"+v +"'"; 
		}
		if(flag){
			return '<a onclick="showDetail('+v+')" href="#">查看礼品明细</a>';
		}else{
			return '' ;
		}
	}
	function showDetail(ids){
        $('#table_1').datagrid({
			queryParams: {
				orderInfoId: ids
			}
		});
		$('#win').window('open');  
	}
</script>
</head>
<body style="padding:20px;">
	<input type="hidden" name="id" id="id_" value="${id }">
	<fieldset>
		<legend>查询条件</legend>
		<table class="showTable">
			<tr>
				<td>交易编号：</td>
				<td><input type="text" name="businiessNo" id="businiessNo" /></td>
				<td>&nbsp;时间段：</td>
				<td><input type="text" name="transactionDateStart" id="transactionDateStart" style="width:120px" class="easyui-datebox" editable="false" /></td>
				<td>&nbsp;至</td>
				<td><input type="text" name="transactionDateEnd" id="transactionDateEnd" style="width:120px" class="easyui-datebox" editable="false"  /></td>
				<td><a id="btn" href="javascript:void(0)" onclick="searchs()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>&nbsp;&nbsp;<a id="btn" href="javascript:void(0)" onclick="reset1()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a></td>
			</tr>
		</table>
	</fieldset>
	<br/>
	<fieldset>
		<legend>储蓄账户使用记录</legend>
		<table id="table" class="easyui-datagrid" data-options="url:'savingsAccountUseRecord',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
			rownumbers:true,pageList:pageList,singleSelect:true,queryParams:{
				id: ${id }
			}">
			<thead>  
		        <tr>  
		            <th data-options="field:'tx',width:40,formatter:function(v,r,i){if(v.txId){return v.txId;}}">交易编号</th>  
<!-- 		            <th data-options="field:'orderTime',width:40,formatter:function(v,r,i){if(r.orderTime){return dateFormat(v);}}">交易时间</th> -->
		            <th data-options="field:'e',width:40,formatter:function(v,r,i){var tx = r.tx;if(r.tx){return dateFormat(tx.transactionDate);}}">交易时间</th>
<!-- 		            <th data-options="field:'redemptionName',width:40">礼品名称</th> -->
<!-- 		            <th data-options="field:'redemptionQuantity',width:40">数量</th> -->
					<th data-options="field:'id',width:40,formatter:function(v,r,i){return redemptionDetail(v);}">礼品明细</th>
		            <th data-options="field:'beforeCash',width:40">交易前余额</th>
		            <th data-options="field:'usingCode',width:40">使用金额</th>
		            <th data-options="field:'orderSource',width:40">交易来源</th>
		            <th data-options="field:'b',width:40,formatter:function(v,r,i){if(r.tx){return formateTxStatus(r.tx.status);}}">状态</th>
		        </tr>  
		    </thead>  
		</table> 
			
	</fieldset>
	<div id="win" class="easyui-window" title="礼品明细" style="width:800px;height:300px" data-options="modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false">  
		<br>
		<table id="table_1" class="easyui-datagrid" data-options="url:'<%=request.getContextPath() %>/merchandise/details',fitColumns:true,striped:true,loadMsg:'正在载入...',rownumbers:true,singleSelect:true">
			<thead>  
		        <tr class="datagrid-header-row">
		            <th data-options="field:'merchandiseName',width:80">礼品名称</th>
		            <th data-options="field:'quantity',width:100">礼品数量</th>
		        </tr>
		    </thead>  
		</table> 
	</div>
</body>
</html>