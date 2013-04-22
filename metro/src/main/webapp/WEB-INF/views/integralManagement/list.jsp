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

	$(document).ready(function(){
			$('#tt').datagrid({
				onLoadSuccess:function(data){
					$('#gpinfo').html("<span style='padding-top: 20px;'><strong>会员人数：</strong>"+data.countAccount+"&nbsp;&nbsp;&nbsp;&nbsp;<strong>积分总数：</strong>"+data.amountPoints+"</span>");	
			}
		});
	});
	
	function cleardt(){
		$('#from').datebox('setValue', '');
		$('#to').datebox('setValue', '');
	}
	
	function doSearch(){
	    $('#tt').datagrid('load',{  
	    	from:$('#from').datebox('getValue'),
	    	to:$('#to').datebox('getValue')
	    });  
	}
	
	function doExpiry(){
		
		$('#f_from').val($('#from').datebox('getValue'));
		$('#f_to').val($('#to').datebox('getValue'));
		
		if($('#f_from').val()==''){
			$.messager.alert('提示','开始时间不能为空!');
			return ;
		}
		
		if($('#f_to').val()==''){
			$.messager.alert('提示','截止时间不能为空!');
			return ;	
		}
		$.messager.confirm('信息','确定要失效从'+$('#f_from').val()+'到'+$('#f_to').val()+'的会员积分吗?',function(r){   
			if (r){   
				$('#expiryForm').form('submit', {
				    success:function(data){ 
				    	doSearch();
				    	$.messager.alert('提示',eval('('+data+')').msg);
				    },
				    error:function(data){
				    	$.messager.alert('提示','保存失败!');
					}
				});	
			}   
		});
	}
	
	
</script>
</head>
	<body>
		<table border="0">
			<tr>
				<td>
					<form action="" >
						<table border="0" >
							<tr>
								<td width="100px">获取时间：</td>
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
					<div id="gpinfo" style=""></div>
           			<table  id="tt"  title=""  class="easyui-datagrid" data-options="url:'list',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
						rownumbers:true,pageList:pageList,singleSelect:true,toolbar: '#gpinfo',onCheck:function(rowIndex, rowData){}">
       					<thead>  
           				<tr>  
	                		<th data-options="field:'memberName',width:100">会员名称</th>
	                		<th data-options="field:'memberCard',width:120">卡号</th>
	                		<th data-options="field:'memberMobile',width:120">手机号</th>
	                		<th data-options="field:'obtainedAt',width:80,formatter:function(v,r,i){return dateFormat(v);}" >获取时间</th>
	                		<th data-options="field:'units',width:80">积分</th>
	                		<th data-options="field:'unitPrice',width:85">积分价值(RMB)</th>
			           	</tr>  
				       	</thead>  
			   		</table> 
				</td>
			</tr>
		</table>
		<div>
			<form id="expiryForm" name="expiryForm" action="expiry" method="post">
				<input type="hidden" id="f_from" name="from">
				<input type="hidden" id="f_to" name="to">
				<a onclick='doExpiry()' name="expiryPoints" href="javascript:void(0)"  class="easyui-linkbutton" data-options="iconCls:'icon-ok'">确定失效积分</a>
			</form> 
		</div>
	</body>
</html>