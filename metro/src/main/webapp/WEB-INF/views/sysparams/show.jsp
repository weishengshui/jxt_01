<%@ page language="java" contentType="text/html; charset=utf8"
	pageEncoding="utf8"%>
<%@ page import="com.chinarewards.metro.core.common.Constants" %>	
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
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
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.json-2.4.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<style type="text/css">
	fieldset table tr{height: 35px;}
	fieldset{margin-bottom:10px;margin-left:30px;margin-top:10px;}
	.red{color:red;font-size:12px;}
	form{margin:0; padding:0} 
</style>
<script type="text/javascript">
		var baseURL = '<%=request.getContextPath()%>';
	
		$(function(){
		});
		function saveParam(){
			if($('#paramName').val() == 'expresion'){// 优惠码范围参数值校验
				var str = '参数值不正确, 比如: 1~1000';
				var nums = $('#paramValue').val().split('~');
				if(nums){
					if(nums.length == 2){
						var num1 = nums[0];
						var num2 = nums[1];
						// 去掉数字前的 0
						num1 = num1.replace(/\b(0+)/gi,"")
						num2 = num2.replace(/\b(0+)/gi,"")
						if(num1 == '' || num2 == ''){
							alert(str);
							return ;
						}
						if(num1 >= num2){
							alert(str);
							return ;

						}
						if(!isNaN(num1) && !isNaN(num2)){
							$('#paramValue').val(num1+'~'+num2);
						}else {
							alert(str);
							return;
						}
					} else {
						alert(str);
						return;
					}
				} else {
					alert(str);
					return;
				}
			}
			$.ajax({
				url: 'setSystemParam',
				type: 'post',
				data:{key:$('#paramName').val(), value:$('#paramValue').val()},
				success: function(data){
					$("#pValue").dialog('close');
					$.messager.show({  
		                title: '提示信息',  
		                msg: data.msg,  
		                timeout: 5000,  
		                showType: 'slide'  
		            }); 
					//refresh();
					$('#tt').datagrid('load');
				}
			});
		}
		function refresh(){
			
			$.ajax({
				url: 'refresh',
				type: 'post',
				async: false,
				success: function(data){
								
				}
			});
			$('#tt').datagrid('load');
		}

		function updatePvalue(v,r,i){
			return '<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="showEdit(\''+r.key+'\',\''+r.value+'\')">'+
				   '<img style="border:0" src="<%=request.getContextPath()%>/js/jquery/themes/icons/pencil.png" title="修改参数值" />'+
				   '</a>';
		}
		function showEdit(key, value){
			var keyName = formateKeyName(key);
			$('#paramName').val(key);
			$('#paramValue').val(value);
			$("#pValue").dialog({
				height:120,
				width:350,
				modal:true,
				resizable:true,
				title: keyName+" 参数值"
			});
		}
		function formateKeyName(v){
			var txTypes = ${systemParamNamesJSON};
			for(var i=0, length = txTypes.length; i < length; i++){
				 if(v == txTypes[i].key){
	            	return txTypes[i].value;
		         }
			}		
		}
</script>

</head>
<body>
	<div id="toolbar">  
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-reload" plain="true" onclick="refresh()">刷新</a>
    </div> 
	<!-- 显示列表Table -->
	<table id="tt" class="easyui-datagrid" data-options="url:'getAllParams',fitColumns:true">  
    	<thead> 
        	<tr>  <!-- ,formatter:function(v,r,i){return formateKeyName(v);} -->
	            <th data-options="field:'key',width:180">参数名称</th>
	            <th data-options="field:'1',width:180,formatter:function(v,r,i){return formateKeyName(r.key);}">参数说明</th>
	            <th data-options="field:'value',width:180">参数值</th>
	            <th data-options="field:'op',align:'center',width:30,formatter:function(v,o,i){return updatePvalue(v,o,i) }">修改参数值</th>    
	        </tr>  
	    </thead>
	</table>  
	
	<div style="display: none;">
		<div id="pValue" style="padding: 10px;">
			<table>
				<tr>
					<td>参数值:</td>
					<td>
						<input id="paramName" type="hidden" value="">
						<input id="paramValue" type="text" />	
						&nbsp;&nbsp;
						<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save" plain="true" onclick="saveParam()">保存</a>
					</td>
				</tr>
			</table>
		</div>
	</div>
</body>
</html>