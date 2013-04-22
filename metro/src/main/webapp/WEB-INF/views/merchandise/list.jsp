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
<script type="text/javascript" src="<%=request.getContextPath()%>/js/common.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<style type="text/css">
	.table select{width:140px;height:22px;margin-right:20px;}
	form{margin:0; padding:0}
</style>
<script type="text/javascript">
	
	$(document).ready(function(){
		$('#tt').datagrid({
			onDblClickRow: function(rowIndex,rowData){
					var titile = "维护"+rowData.name + '的信息' ;
					parent.addTab(titile,'<%=request.getContextPath()%>/merchandise/show?id='+ rowData.id);			
			}
		});	  
	});
	function formatterdate(val, row) {
        var date = new Date(val);
        var m = (date.getMonth()+1) < 10 ? "0"+(date.getMonth()+1):(date.getMonth()+1);
        var d = date.getDate() < 10 ? "0"+date.getDate() : date.getDate();
        return date.getFullYear() + '-' + m + '-' + d;
	}

	function doSearch(){  
		
	    $('#tt').datagrid('load',{  
	    	name:$('#name').val(),  
	    	code:$('#code').val(),
	    	model:$('#model').val(),
	    	unitId:$('#sellform').val(),
	    	rmbPrcieFrom:$('#rmbPrcieFrom').numberbox('getValue'),
	    	rmbPrcieTo:$('#rmbPrcieTo').numberbox('getValue'),
	    	rmbPreferentialPrcieFrom:$('#rmbPreferentialPrcieFrom').numberbox('getValue'),
	    	rmbPreferentialPrcieTo:$('#rmbPreferentialPrcieTo').numberbox('getValue'),
	    	binkePrcieFrom:$('#binkePrcieFrom').numberbox('getValue'),
	    	binkePrcieTo:$('#binkePrcieTo').numberbox('getValue'),
	    	binkePreferentialPrcieFrom:$('#binkePreferentialPrcieFrom').numberbox('getValue'),
	    	binkePreferentialPrcieTo:$('#binkePreferentialPrcieTo').numberbox('getValue')
	    });  
	}
	function del(){
		var rows = $('#tt').datagrid('getSelections');
		if(rows){
			if(rows.length == 0){
				alert("请先选择要删除的行");
				return;
			}
			var data = '';
			for(var i=0,length=rows.length; i < length; i++){
				var row = rows[i];
				data += 'id='+row.id+'&';
			}	
			data = data.substring(0, data.length -1);
			
			if(!confirm("确认删除？")){
				return;
			}
			$.ajax({
				url:'delete',
				data:data,
				type: 'post',
				success: function(data){
					//alert(data.msg);
					$.messager.show({
						title:'提示信息',
						msg: data.msg,
						timeout:5000,
						showType:'slide'
					});
					$('#tt').datagrid('reload');
				}
			}); 
		}else{
			alert("请先选择要删除的行");			
		}
	}
	function updateMerchandise(){
		var rows = $('#tt').datagrid('getChecked');
		if(rows){
			if(rows.length == 0){
				alert("请先选择要修改的行");
				return;
			}
			if(rows.length > 1){
				alert("修改数据，一次只能选择一行");
				return;
			}
			var row = rows[0];
			var titile = '维护' + row.name + '的信息';
			parent.addTab(titile,'merchandise/show?id='+ row.id);
			
		}else{
			alert("请先选择要修改的行");			
		}
	}
	function edit(){
		var row = $('#tt').datagrid('getSelected');
		if(row == null){
			alert("请选择要编辑的数据");
			return;
		}
		parent.addTab('维护'+row.name+'的信息','merchandise/show?id='+row.id);
	}
	function clearForm(){
		enabledPriceInput();
		$('#fm').form('clear');
	}
	function enabledPriceInput(){
		$('#binkePrcieFrom').numberbox({
			disabled:false
		});
		$('#binkePreferentialPrcieFrom').numberbox({
			disabled:false
		});
		$('#binkePrcieTo').numberbox({
			disabled:false
		});
		$('#binkePreferentialPrcieTo').numberbox({
			disabled:false
		});
		
		$('#rmbPrcieFrom').numberbox({
			disabled:false
		});
		$('#rmbPreferentialPrcieFrom').numberbox({
			disabled:false
		});
		$('#rmbPrcieTo').numberbox({
			disabled:false
		});
		$('#rmbPreferentialPrcieTo').numberbox({
			disabled:false
		});
	}
	function formatSaleform(v, r, i){
		var saleFormVos = r.saleFormVos;
		var str = "";
		if(saleFormVos && saleFormVos.length){
			for(var i=0, length = saleFormVos.length; i< length; i++){
				var saleFormVo = saleFormVos[i];
				if(saleFormVo.unitId == '0'){
					str += "正常售卖/";
				}else{
					str += "积分兑换/";
				}
			}
		}
		if(str.length > 0){
			str = str.substring(0, str.length -1);
		}
		return str;
	}
	function formatPrice(v, r, i){
		var saleFormVos = r.saleFormVos;
		var str = "";
		if(saleFormVos && saleFormVos.length){
			for(var i=0, length = saleFormVos.length; i< length; i++){
				var saleFormVo = saleFormVos[i];
				str += saleFormVo.price + "/";
			}
		}
		if(str.length > 0){
			str = str.substring(0, str.length -1);
		}
		return str;
	}
	function formatPreferentialPrice(v, r, i){
		var saleFormVos = r.saleFormVos;
		var str = "";
		if(saleFormVos && saleFormVos.length){
			for(var i=0, length = saleFormVos.length; i< length; i++){
				var saleFormVo = saleFormVos[i];
				var preferentialPrice = saleFormVo.preferentialPrice;
				if(preferentialPrice){
					str += preferentialPrice + "/";	
				}else{
					str += "无/";
				}
				
			}
		}
		if(str.length > 0){
			str = str.substring(0, str.length -1);
		}
		return str;
	}
	function changeSaleform(obj){
		enabledPriceInput();
		if(obj.value == "0"){
			$('#binkePrcieFrom').numberbox('setValue','');
			$('#binkePrcieTo').numberbox('setValue','');
			$('#binkePreferentialPrcieFrom').numberbox('setValue','');
			$('#binkePreferentialPrcieTo').numberbox('setValue','');
			$('#binkePrcieFrom').numberbox({
				disabled:true
			});
			$('#binkePreferentialPrcieFrom').numberbox({
				disabled:true
			});
			$('#binkePrcieTo').numberbox({
				disabled:true
			});
			$('#binkePreferentialPrcieTo').numberbox({
				disabled:true
			});
		}else if(obj.value == "1"){
			$('#rmbPrcieFrom').numberbox('setValue','');
			$('#rmbPreferentialPrcieFrom').numberbox('setValue','');
			$('#rmbPrcieTo').numberbox('setValue','');
			$('#rmbPreferentialPrcieTo').numberbox('clear');
			$('#rmbPrcieFrom').numberbox({
				disabled:true
			});
			$('#rmbPreferentialPrcieFrom').numberbox({
				disabled:true
			});
			$('#rmbPrcieTo').numberbox({
				disabled:true
			});
			$('#rmbPreferentialPrcieTo').numberbox({
				disabled:true
			});
		}
	}
</script>

</head>
	<body>
		<form action="#" id="fm" style="width:1100px;">
			<table border="0" style="font-size: 14px;">
				<tr>
					<td>商品编号：</td>
					<td>
						<input id="code" name="code" type="text" style="width:158px"/> 
					</td>
					<td>&nbsp;商品名称：</td>
					<td>
						<input id="name" name="name" type="text" style="width:158px"> 
					</td>
					<td></td>
				</tr>
				<tr>
					<td>售卖形式：</td>
					<td>
						<select id="sellform" name="sellform" style="width:162px" onchange="changeSaleform(this)">
							<option value="">请选择</option>
							<option value="0">正常售卖</option>
							<option value="1">积分兑换</option>
						</select>
					</td>
					<td>&nbsp;型号：</td>
					<td>
						<input id="model" name="model" type="text" style="width:158px"> 
					</td>
					<td></td>
				</tr>
				<tr>
					<td>正常售卖：</td>
					<td>
						<input id="rmbPrcieFrom" name="rmbPrcieFrom" type="text" style="width:70px" class="easyui-numberbox">至<input id="rmbPrcieTo" name="rmbPrcieTo" type="text" style="width:70px" class="easyui-numberbox">
					</td>
					<td>&nbsp;优惠价格：</td>
					<td>
						<input id="rmbPreferentialPrcieFrom" name="rmbPreferentialPrcieFrom" type="text" style="width:70px" class="easyui-numberbox">至<input id="rmbPreferentialPrcieTo" name="rmbPreferentialPrcieTo" type="text" style="width:70px" class="easyui-numberbox">
					</td>
					<td></td>
				</tr>
				<tr>
					<td>兑换积分：</td>
					<td>
						<input id="binkePrcieFrom" name="binkePrcieFrom" type="text" style="width:70px" class="easyui-numberbox">至<input id="binkePrcieTo" name="binkePrcieTo" type="text" style="width:70px" class="easyui-numberbox">
					</td>
					<td>&nbsp;优惠积分：</td>
					<td>
						<input id="binkePreferentialPrcieFrom" name="binkePreferentialPrcieFrom" type="text" style="width:70px" class="easyui-numberbox">至<input id="binkePreferentialPrcieTo" name="binkePreferentialPrcieTo" type="text" style="width:70px" class="easyui-numberbox">
					</td>
					<td>
						&nbsp;&nbsp;<a href="javascript:void(0)" onclick="doSearch()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>&nbsp;&nbsp;<a href="javascript:void(0)" onclick="clearForm()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a>
					</td>
				</tr>
			</table>
		</form>
		<div id="toolbar">  
	       <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="edit()">修改</a>  
	       <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="del()">删除</a>  
	   	</div>
	   	<!-- 显示列表Table -->
		<table id="tt" class="easyui-datagrid" data-options="url:'list',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,toolbar: '#toolbar',
			rownumbers:true,pageList:pageList,singleSelect:false">
		    <thead>  
		        <tr>  
               		<!--   				<th field="id" checkbox="true"></th>  -->
             		<th data-options="field:'code',width:30">商品编号</th>
             		<th data-options="field:'brandName',width:30" >品牌</th>
             		<th data-options="field:'name',width:30" >商品名称</th>
             		<th data-options="field:'model',width:30" >型号</th>
             		<th data-options="field:'a',width:30,formatter:function(v,r,i){return formatSaleform(v, r, i);}">售卖形式</th>
             		<th data-options="field:'b',width:30,formatter:function(v,r,i){return formatPrice(v, r, i);}">售价</th>
             		<th data-options="field:'c',width:30,formatter:function(v,r,i){return formatPreferentialPrice(v, r, i);}">优惠价</th>
             		<th data-options="field:'purchasePrice',width:20">采购价</th>
             		<th data-options="field:'id',hidden:true">id</th>
		        </tr>  
		    </thead>  
		</table>
<!-- 		<table border="0"> -->
<!-- 			<tr> -->
<!-- 				<td width="1000px"> -->
<!-- 					<fieldset style="font-size: 14px;width:auto;height:auto;"> -->
<!-- 						<legend style="color: blue;">查询条件</legend> -->
<!-- 					</fieldset> -->
<!-- 				</td> -->
<!-- 			</tr> -->
<!-- 			<tr> -->
<!-- 				<td width="1000px"> -->
<!-- 					<fieldset style="font-size: 14px;width:auto;height:auto;"> -->
<!-- 						<legend style="color: blue;">商品列表</legend> -->
<!-- 				   		<div style="text-align:right;"> -->
<!-- 				   			<br> -->
<!-- 				   			<button type="button" onclick="updateMerchandise()">修改</button>&nbsp;&nbsp;&nbsp;&nbsp;<button type="button" onclick="deleteMerchandises()">删除</button>&nbsp;&nbsp;&nbsp;&nbsp; -->
<!-- 				   		</div> -->
<!-- 					</fieldset> -->
<!-- 				</td> -->
<!-- 			</tr> -->
<!-- 		</table> -->
	</body>
</html>