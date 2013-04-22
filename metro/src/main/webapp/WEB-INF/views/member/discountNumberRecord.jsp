<%@page import="com.chinarewards.metro.core.common.Dictionary"%>
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
			discountNum: $('#discountNum').val(),
			discountNumStatus: $('#discountNumStatus').val(),
			transactionDateStart: $('#transactionDateStart').datebox('getValue'),
			transactionDateEnd: $('#transactionDateEnd').datebox('getValue')
	    }); 
	}
	function formateStatus(v){
		var discountNumberSatuses = ${discountNumberSatusesJson};
		for(var i=0, length = discountNumberSatuses.length; i < length; i++){
			 if(v == discountNumberSatuses[i].key){
           	return discountNumberSatuses[i].value;
           }
		}
	}
	function reset1(){
		$('#transactionDateStart').datebox('setValue','');
		$('#transactionDateEnd').datebox('setValue','');
		$('#discountNum').val('');
		$('#discountNumStatus').val('');
	}
</script>
</head>
<body style="padding:20px;">
	<input type="hidden" name="id" id="id_" value="${id }">
	<fieldset>
		<legend>查询条件</legend>
		<form action="#" id="searchDiscountForm">
			<table class="showTable">
				<tr>
					<td>优惠码：</td>
					<td><input type="text" name="discountNum" id="discountNum" style="width:93px;" /></td>
					<td>&nbsp;状态：</td>
					<td>
						<select name="discountNumStatus" id="discountNumStatus" style="width:98px">
							<option value="">全部</option>
							<option value="<%=Dictionary.MEMBER_DISCOUNT_NUMBER_USED %>">已使用</option>
							<option value="<%=Dictionary.MEMBER_DISCOUNT_NUMBER_NOT_USED%>">未使用</option>
							<option value="<%=Dictionary.MEMBER_DISCOUNT_NUMBER_EXPIRED%>">已过期</option>
						</select>
					</td>
					<td></td>
				</tr>
				<tr>
					<td>&nbsp;时间段：</td>
					<td><input type="text" name="transactionDateStart" id="transactionDateStart" style="width:100px" class="easyui-datebox" editable="false" /></td>
					<td>&nbsp;至</td>
					<td><input type="text" name="transactionDateEnd" id="transactionDateEnd" style="width:100px" class="easyui-datebox" editable="false"  /></td>
					<td><a id="btn" href="javascript:void(0)" onclick="searchs()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>&nbsp;&nbsp;<a id="btn" href="javascript:void(0)" onclick="reset1()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a></td>
				</tr>
			</table>
		</form>
	</fieldset>
	<br/>
	<fieldset>
		<legend>优惠码记录</legend>
		<table id="table" class="easyui-datagrid" data-options="url:'discountNumberRecord',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
			rownumbers:true,pageList:pageList,singleSelect:true,queryParams:{
				id: ${id }
			}">
			<thead>  
		        <tr>  
		            <th data-options="field:'txId',width:80">交易编号</th>  
		            <th data-options="field:'transactionDate',width:80,formatter:function(v,r,i){return dateFormat(v);}">交易时间</th>
		            <th data-options="field:'discountNum',width:80">优惠码</th>
		            <th data-options="field:'content',width:80">优惠内容</th>
		            <th data-options="field:'sources',width:80">来源</th>
		            <th data-options="field:'status',width:80,formatter:function(v,r,i){return formateStatus(v);}">状态</th>
		        </tr>  
		    </thead>  
		</table> 
			
	</fieldset>
</body>
</html>