<%@page import="com.chinarewards.metro.core.common.Dictionary"%>
<%@ page language="java" contentType="text/html; charset=utf8" pageEncoding="utf8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<link id="easyuiTheme" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>


<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
 <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/extend-easyui-validate.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/common.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/constant.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/uuid.js"></script>
<style>
	.table select{
	    width:140px;height:22px;margin-right:20px;
	}
	#statutd{
	  width:110px;
	}
	 .table tr {
	height: 35px;
}
	
</style>
<script>

var baseURL = '<%=request.getContextPath()%>';
var uuid = new UUID().id;
var timeId;



	function searchs(){
            //load 加载数据分页从第一页开始, reload 从当前页开始
        	$('#table').datagrid('load',getForms("searchForm"));
        	$('#table').datagrid({url:'findDiscountNumberToReport'});
    }
	function exportM(){
		window.location.href = "exportDiscountData?source="+$("#source").val()+"&status="+$("#status").val()+
				"&shopActivityName="+$("#shopActivityName").val()+'&temp='+(new Date().getTime())+'&uuid='+uuid;
		openProgressDialog();
	}
	function openProgressDialog(){
		$('#progressDialog').dialog('open');
		$('#progressDialog').dialog('center');
		$('#progress').progressbar('setValue', 0);
		timeId = window.setInterval("getProgress()",500);
	}
    function getStatus(v){
        var status = ${statusJson};
        for(var i=0;i<status.length;i++){
            if(v == status[i].key){
            	return status[i].value;
            };
        };
    }
  
    jQuery.extend({
    		test: function( hold ) {
    			alert(hold);
    		}
    });
    
    
    function getProgress(){
		var value = $('#progress').progressbar('getValue');
	
		if(value < 100){
	        $.ajax({
	        	url: baseURL+'/getProgress?key='+uuid+'&temp='+(new Date().getTime()),
	        	//data: 'temp='+(new Date().getTime()),
	        	async: false,
	        	success: function(data){
	        		if(data){
		        		data = eval('('+data+')');
		        		// alert('progress is '+data);
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
	<!-- 查询条件Table -->
	<form id="searchForm" onsubmit="return false"> 
		<table class="table" style="font-size:13px;">
			<tr>
				<td>来源选择:</td>
				<td>
				  <select name="source" id="source">
				     <option value="0">全部</option>
				    <option value="2">活动</option>
				    <option value="1">门店</option>
				  </select>
				 </td>
				<td id="statutd">优惠码状态:</td>
				<td>
				   <select name="status" id="status">
				     <option value="3">全部</option>
				     <option value="0">未使用</option>
				     <option value="1">已使用</option>
				     <option value="2">已过期</option>
				  </select>
				</td>
			</tr>
			<tr>
				<td>门店或活动名称:</td>
				<td><input type="text" name="shopActivityName" id="shopActivityName" size="18"/></td>
				<td >
					<a id="btn" href="javascript:void(0)" onclick="searchs()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
				</td>
				<td>
				<a style="margin-left: 20px;" href="javascript:void(0)" onclick="javascript:$('#searchForm')[0].reset()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a>
				
				</td>
				
			</tr>
			
		</table>
	</form>

	<div style="height: 30px;" id="toolbar">
		<span>
			<a id="exportData" href="javascript:void(0)" data-options="iconCls:'icon-download'" onclick="exportM()" plain="true" class="easyui-linkbutton">导出</a>
		</span>
	</div>
    
	<!-- 显示列表Table -->
	<table id="table" class="easyui-datagrid" data-options="fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,toolbar: '#toolbar',
		rownumbers:true,pageList:pageList">
	    <thead>  
	        <tr>  
	            <th data-options="field:'memberName',width:30">姓名</th>  
	            <th data-options="field:'memberCard',width:30">会员卡号</th>
	            <th data-options="field:'transactionNO',width:50">交易编号</th>
	            <th data-options="field:'usedDate',width:50 ,formatter:function(v){return dateFormat(v)}">交易时间</th>
	            <th data-options="field:'discountNum',width:80">优惠码</th>
	            <th data-options="field:'description',width:50">优惠内容</th>
	            <th data-options="field:'shopActivityName',width:50">名称</th>
	            <th data-options="field:'status',width:50,formatter:function(v,o,i){return getStatus(v,o,i)}">状态</th>
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