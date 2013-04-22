<%@page import="com.chinarewards.metro.core.common.Dictionary"%>
<%@page import="com.chinarewards.metro.domain.member.BalanceStatus" %>
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
				 if(v == '<%=TxStatus.COMPLETED.toString()%>'){
					 return "到账";
				 }else{
	            	return txStatuses[i].value;
				 }
            }
		}
	}
	function reset1(){
		$('#transactionDateStart').datebox('setValue','');
		$('#transactionDateEnd').datebox('setValue','');
		$('#businiessNo').val('');
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
		<legend>储蓄账户充值记录</legend>
		<table id="table" class="easyui-datagrid" data-options="url:'savingsAccountGetRecord',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
			rownumbers:true,pageList:pageList,singleSelect:true,queryParams:{
				id: ${id }
			}">
			<thead>  
		        <tr>  
		            <th data-options="field:'tx',width:80,formatter:function(v,r,i){if(v.txId){return v.txId;}}">交易编号</th>  
<!-- 		            <th data-options="field:'orderTime',width:80,formatter:function(v,r,i){if(r.orderTime){return dateFormat(v);}}">交易时间</th> -->
		            <th data-options="field:'e',width:80,formatter:function(v,r,i){var tx = r.tx;if(r.tx){return dateFormat(tx.transactionDate);}}">交易时间</th>
		            <th data-options="field:'beforeCash',width:80">交易前余额</th>
		            <th data-options="field:'integration',width:80">充值金额</th>
		            <th data-options="field:'orderSource',width:80">交易来源</th>
		            <th data-options="field:'chargeDesc',width:80">充值说明</th>
		            <th data-options="field:'b',width:80,formatter:function(v,r,i){if(r.tx){return formateTxStatus(r.tx.status);}}">状态</th>
		        </tr>  
		    </thead>  
		</table> 
			
	</fieldset>
</body>
</html>