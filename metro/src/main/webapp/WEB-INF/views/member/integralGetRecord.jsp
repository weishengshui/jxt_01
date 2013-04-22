<%@page import="com.chinarewards.metro.core.common.Dictionary"%>
<%@page import="com.chinarewards.metro.domain.account.Business" %>
<%@page import="com.chinarewards.metro.domain.account.TxStatus" %>
<%@page import="com.chinarewards.metro.domain.member.IntegralStatus" %>
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
	function formateTxType(v){
		var txTypes = ${txTypesJson};
		for(var i=0, length = txTypes.length; i < length; i++){
			 if(v == txTypes[i].key){
            	return txTypes[i].value;
	         }
		}		
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
	
	function showDetail(ids){
        $('#table_1').datagrid({
        	url:'rules',
			queryParams: {
				ruleIds: ids
			},
			onLoadSuccess:function(data){
    			$("#g").text(data.birthdayRate);
    		}
		});
		$('#win').window('open');  
	}
	function getSex(v){
		if(v == 0){
			return "不限"	;
		}else if(v == 1){
			return "男"	;
		}else if(v == 2){
			return "女"	;
		}
	}
	function showRules(v,o,i){
		var flag = false ;
		$.ajax({
            url:'checkDetails',
            type:'post',
            async: false,
            data:{
            	ruleIds:v
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
			return '<a onclick="showDetail('+v+')" href="#">查看规则明细</a>';
		}else{
			return '' ;
		}
		
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
		<legend>获得积分纪录</legend>
		<table id="table" class="easyui-datagrid" data-options="url:'integralGetRecord',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
			rownumbers:true,pageList:pageList,singleSelect:true,queryParams:{
				id: ${id }
			}">
			<thead>  
		        <tr>  
		            <th data-options="field:'tx',width:80,formatter:function(v,r,i){if(v.txId){return v.txId;}}">交易编号</th>  
		            <th data-options="field:'e',width:80,formatter:function(v,r,i){var tx = r.tx;if(tx){return dateFormat(tx.transactionDate);}}">交易时间</th>
		            <th data-options="field:'shop',width:80,formatter:function(v,r,i){if(r.shop){return r.shop.name;}}">商家名称</th>
		            <th data-options="field:'a',width:80,formatter:function(v,r,i){if(r.tx){return formateTxType(r.tx.busines);}}">交易类型</th>
		            <th data-options="field:'orderPrice',width:80">交易金额</th>
		            <th data-options="field:'beforeUnits',width:80">交易前积分</th>
		            <th data-options="field:'integration',width:80">获得积分</th>
		            <th data-options="field:'c',width:80,formatter:function(v,o,i){if(o.chargeDesc && o.chargeDesc != ''){return o.chargeDesc;}return showRules(o.matchedRules,o,i);}">积分规则</th>
		            <th data-options="field:'b',width:80,formatter:function(v,r,i){if(r.tx){return formateTxStatus(r.tx.status);}}">积分状态</th>
		        </tr>  
		    </thead>  
		</table> 
			
	</fieldset>
	
	    <div id="rule_dialog"></div>  
	    
	<div id="win" class="easyui-window" title="规则列表" style="width:800px;height:300px" data-options="modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false">  
       
		<table id="table_1" class="easyui-datagrid" data-options="url:'',fitColumns:true,striped:true,loadMsg:'正在载入...',rownumbers:true,toolbar: '#toolbar',singleSelect:true">
			<thead>  
		        <tr class="datagrid-header-row">
		            <th data-options="field:'ruleName',width:80">规则名称</th>
		            <th data-options="field:'times',width:100">积分倍数</th>
		            <th data-options="field:'rangeFrom',width:100">开始时间</th>
		            <th data-options="field:'rangeTo',width:100">结束时间</th>
		         	<th data-options="field:'rangeAgeFrom',width:100">年龄起</th>
		         	<th data-options="field:'rangeAgeTo',width:100">年龄止</th>
		         	<th data-options="field:'amountConsumedFrom',width:100">消费金额起</th>
		         	<th data-options="field:'amountConsumedTo',width:100">消费金额止</th>
		         	<th data-options="field:'gender',width:50,formatter:function(v){return getSex(v)}">性别</th>
		        </tr>
		    </thead>  
		</table> 
	</div>
	 <div id="toolbar">
		<span id="g"></span>
	</div>	
	<br>
</body>
</html>