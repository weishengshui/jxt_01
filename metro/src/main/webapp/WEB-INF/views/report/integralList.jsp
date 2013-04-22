<%@ page language="java" contentType="text/html; charset=utf8" pageEncoding="utf8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<link id="easyuiTheme" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/common.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/uuid.js"></script>
<style type="text/css">
	body {
		font-family: 黑体、宋体、Arial;
		font-size: 12px;
	}
</style>

<script type="text/javascript">
var baseURL = '<%=request.getContextPath()%>';
var uuid = new UUID().id;
var timeId;
function getStatus(v){
	if(v == 'FROZEN'){
		return '冻结';
	}else if(v == 'DISABLED'){
		return '失效';
	}else if(v == 'COMPLETED'){
		return '到账';
	}else if(v == 'RETURNED'){
		return '退单';
	}
}

function getType(v){
	if(v == 'POS_SALES'){
		return 'POS机端获取积分';
	}else if(v == 'EXT_ORDER'){
		return '外部订单';
	}else if(v == 'POS_REDEMPTION'){
		return 'POS机端消费积分';
	}else if(v == 'EXPIRY_POINT'){
		return '过期积分';
	}else if(v == 'HAND_POINT'){
		return '手动添加积分';
	}else if(v == 'HAND_MONEY'){
		return '手动处理卡充值';
	}else if(v == 'EXTERNAL_POINT'){
		return '外部接口注册时送的积分';
	}else if(v == 'SAVING_ACCOUNT_CONSUMPTION'){
		return '储值卡消费接口扣除金额';
	}else if(v == 'EXT_REDEMPTION'){
		return '外部兑换订单';
	}else{
		return v ;
	}
	
}

function getIdentif(v,o){
	return o.memberCard;
}

function getOrigin(v,o){
	return o.orderSource;
}

$(document).ready(function(){
	
	window.onresize = function(){
		var changeWidth  = document.documentElement.clientWidth;

	    if(changeWidth <= 830){
	    	$('#table').datagrid({width:1200});
	    }else{
	    	$('#table').datagrid({width:changeWidth-18});
	    }
	};
	
/* 	$('#table').datagrid({
		url:'queryIntegralList',
		onLoadSuccess:function(data){
			$("#g").text(data.getTotalIntegral);
			$("#u").text(data.useTotalIntegral);
		}
	}); */
	
	
	$('#searchbtn').click(function(){
		$("#type_1").val($('input[name="type"]:checked').val());
		$("#startDate_1").val($('input[name="startDate"]').val());
		$("#endDate_1").val($('input[name="endDate"]').val());
		$("#status_1").val($('input[name="status"]').val());
		$("#origin_1").val($('input[name="origin"]').val());
		
		var form = getForms("searchForm");
		
		$('#table').datagrid({
			url:'queryIntegralList',
			queryParams: {
				type: form.type,
				startDate:form.startDate,
				endDate:form.endDate,
				status:form.status,
				origin:form.origin,
				memName:form.memName,
				memberCard:form.memberCard
			},
			onLoadSuccess:function(data){
				$("#g").text(data.getTotalIntegral);
				$("#u").text(data.useTotalIntegral);
			}
		});
		$('#table').datagrid('load',getForms("searchForm"));
	});
	
	$('#exportData').click(function(){
		uuid = new UUID().id;
		var type = $("#type_1").val();
		var startDate = $("#startDate_1").val();
		var endDate = $("#endDate_1").val();
		var status = $("#status_1").val();
		var origin = $("#origin_1").val();
		var memName = $("#memName").val();
		var memberCard = $("#memberCard").val();
		window.location.href = "exportIntegralData?type="+type+"&startDate="+startDate+"&endDate="+endDate+"&status="+status+"&origin="+origin+"&memName="+memName+"&memberCard="+memberCard+'&temp='+(new Date().getTime())+'&uuid='+uuid;
		//window.setTimeout('openProgressDialog()', 200);
		openProgressDialog();
	});
	
	
});
function openProgressDialog(){
	$('#progressDialog').dialog('open');
	$('#progressDialog').dialog('center');
	$('#progress').progressbar('setValue', 0);
	//getProgress();
	timeId = window.setInterval("getProgress()",500);
}

function getProgress(){
	var value = $('#progress').progressbar('getValue');
	if(value < 100){
        $.ajax({
        	url:baseURL+'/getProgress?key='+uuid+'&temp='+(new Date().getTime()),
        	//data: 'temp='+(new Date().getTime()),
        	//async: false,
        	success: function(data){
        		if(data){
	        		data = eval('('+data+')');
	        		$('#progress').progressbar('setValue', data);  
        		}
        	}
        });
        //window.setTimeout('getProgress()', 400);
	}else{
		window.clearInterval(timeId);
		$('#progressDialog').dialog('close');
		$.ajax({
        	url: baseURL+'/removeProgress?key='+uuid+'&temp='+(new Date().getTime()),
        	async: false,
        	success: function(data){
        	}
        });
	}
}
</script>

</head>
<body>

<div >
		<form id="searchForm" method="post" >
				<table style="width: 800px;">
					<tr>
						<td colspan="5">
								类型：
								<input value="0" type="radio" name="type" checked="true"/>全部
								<input value="1" style="margin-left: 130px" type="radio" name="type"/>获得积分
								<input value="2" style="margin-left: 130px" type="radio" name="type"/>使用积分
						</td>
					</tr>
					<tr>
						<td>时间段：</td>
						<td><input id="startDate" name="startDate" style="width: 156px;" type="text" class="easyui-datebox"/></td>
						<td>至</td>
						<td><input id="endDate" name="endDate" style="width: 156px;" type="text" class="easyui-datebox"/></td>
						<td >
						</td>
					</tr>
					<tr>
						<td>会员名称：</td>
						<td><input id="memName" name="memName" style="width: 152px;" type="text" /></td>
						<td>会员标识：</td>
						<td><input id="memberCard" name="memberCard" style="width: 152px;" type="text" /></td>
						<td >
						</td>
					</tr>
					<tr>
						<td>积分状态：</td>
						<td>
							<select style="width: 156px;" class="easyui-combobox" name="status" id="status">
								<option value="0">请选择</option>
								<option value="FROZEN">冻结</option>
								<option value="COMPLETED">到账</option>
								<!-- <option value="DISABLED">失效</option>
								<option value="RETURNED">退单</option> -->
							</select>
						</td>
						<td>来源：</td>
						<td>
							<input style="width: 152px;" name="origin" id="origin" />
						</td>
						<td align="right">
							<a id="searchbtn" href="javascript:void(0)" onclick="" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
							<a style="margin-left: 20px;" href="javascript:void(0)" data-options="iconCls:'icon-redo'" onclick="javascript:$('#searchForm').form('clear');" class="easyui-linkbutton" >重置</a>
						</td>
					</tr>
				</table>
		</form>
</div><br>

	<div style="height: 30px;" id="toolbar">
		<span>
			<input type="hidden" id="type_1">
			<input type="hidden" id="startDate_1">
			<input type="hidden" id="endDate_1">
			<input type="hidden" id="status_1">
			<input type="hidden" id="origin_1">
			<a id="exportData" href="javascript:void(0)" data-options="iconCls:'icon-download'" onclick="" plain="true" class="easyui-linkbutton">导出</a>
		</span>
		<span style="margin-left: 30px"><strong>获得积分总额：</strong><span id="g"></span></span>
		<span style="margin-left: 80px"><strong>使用积分总额：</strong><span id="u"></span></span>
	</div>

	<!-- 显示列表Table -->
	
	<table  id="table"  title=""  class="easyui-datagrid" data-options="fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
				rownumbers:true,pageList:pageList,singleSelect:true,toolbar: '#toolbar',onCheck:function(rowIndex, rowData){}">    
	    <thead>  
	        <tr>  
	        	<th data-options="field:'memName',width:50">姓名</th>
	            <th data-options="field:'memberCard',width:50,formatter:function(v,o){return getIdentif(v,o)}">会员标识</th>  
	            <th data-options="field:'type',width:50,formatter:function(v){return getType(v)}">类型</th>
	            <th data-options="field:'integralCount',width:50">获取积分数</th>
	            <th data-options="field:'usedIntegral',width:50">使用积分数</th>
	            <th data-options="field:'origin',width:50,formatter:function(v,o){return getOrigin(v,o)}">来源</th>
	            <th data-options="field:'status',width:50,formatter:function(v){return getStatus(v)}">积分状态</th>
	            <th data-options="field:'exchangeHour',width:50,formatter:function(v){return v}">交易时间</th>
	        </tr>  
	    </thead>  
	</table> 
	
	<div id="progressDialog" class="easyui-dialog" title="正在准备数据，请稍候。。。"
		style="width: 400px; height: auto;align:center;"
		data-options="resizable:false,modal:true,closed:true,closable:false">
		<div id="progress" class="easyui-progressbar" style="width:380px;"></div>
	</div>
</body>
</html>