<%@ page language="java" contentType="text/html; charset=utf8" pageEncoding="utf8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" id="easyuiTheme" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<style type="text/css">
	.table select{width:140px;height:22px;margin-right:20px;}
	form{margin:0; padding:0}
</style>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/common.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/PCASClass.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<script type="text/javascript">
	
	$(document).ready(function(){
		$('#tt').datagrid({
			onDblClickRow: function(rowIndex,rowData){
					var titile = "维护"+rowData.identifyCode + '的信息' ;
					parent.addTab(titile,'<%=request.getContextPath()%>/discountcoupon/show?id='+ rowData.id);			
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
	    	shopId:$('#shopId').val(),  
	    	shopChainId:$('#shopChainId').val(),
	    	queryType: $('#queryType').val()
	    });  
	}
	function deleteCoupons(){
		var rows = $('#tt').datagrid('getSelections');
		if(rows){
			if(rows.length == 0){
				alert("请先选择要删除的行");
				return;
			}
			var data = '';
			for(var i=0,length=rows.length; i < length; i++){
				var row = rows[i];
				data += 'ids='+row.id+'&';
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
	function updateCoupon(){
		var row = $('#tt').datagrid('getSelected');
		if(row){
			var titile = '维护' + row.identifyCode + '的信息';
			parent.addTab(titile,'discountcoupon/show?id='+ row.id);
			
		}else{
			alert("请先选择要修改的行");			
		}
	}
	function selectMenshi(){
		if($('#shop').attr('checked') == 'checked'){
			$('#shopDialog').dialog('center');
			$('#shopDialog').dialog('open');
		}
		if($('#shopChain').attr('checked') == 'checked'){
			$('#shopChainDialog').dialog('center');
			$('#shopChainDialog').dialog('open');
		}
	}
	function selectShop(){
		var row = $('#shops').datagrid('getSelected');
		if(row){
			var nameZH = row.name;
			var id = row.id;
			if(!nameZH){
				nameZH = "";
			}
			$('#shopId').val(id);
			$('#shopChainId').val('');
			$('#menshiName').val(nameZH);
			$('#queryType').val('');
			$('#shopDialog').dialog('close');
			doSearch();
		}else{
			alert("请选择一个门市，如不选择门市，请点击\"关闭\"。");
		}
	}
	function selectShopChain(){
		var row = $('#shopChains').datagrid('getSelected');
		if(row){
			var name = row.name;
			var id = row.id;
			if(!name){
				name = "";
			}
			$('#shopId').val('');
			$('#shopChainId').val(id);
			$('#menshiName').val(name);
			$('#queryType').val('');
			$('#shopChainDialog').dialog('close');
			doSearch();
		}else{
			alert("请选择一个连锁，如不选择连锁，请点击\"关闭\"。");
		}
	}
	function getAddress(v,o,i){
        return (o.province == null ? '' : o.province) + 
         	   (o.city == null ? '' : o.city) + 
         	   (o.region == null ? '' : o.region ) + 
         	   (o.address == null ? '' : o.address);
    }
	function clearForm(){
		$('#shop').attr('checked', 'checked');
		$('#queryType').val('1');
		$('#shopId').val('');
		$('#shopChainId').val('');
		$('#menshiName').val('');
		doSearch();
	}
	function clearShopForm(){
		$('#shopForm').form('clear');
	}
	function clearShopChainForm(){
		$('#shopChainForm').form('clear');
	}
	// 查询所有门市或连锁的优惠券
	function queryAllShopCoupon(){
		if($('#shop').attr('checked') == 'checked'){
			$('#queryType').val('1');
		} else if($('#shopChain').attr('checked') == 'checked'){
			$('#queryType').val('2');
		}
		$('#shopId').val('');
		$('#shopChainId').val('');
		$('#menshiName').val('');
		doSearch();
	}
</script>

</head>
	<body>
		<form action="#" id="fm" style="width:800px;">
			<table border="0" style="font-size: 14px;">
				<tr>
					<td><input type="radio" name="menshi" id="shop" checked="checked" onclick="queryAllShopCoupon()" />门市<input type="radio" name="menshi" id="shopChain" onclick="queryAllShopCoupon()" />连锁：</td>
					<td>
						<input name="shopId" id="shopId" type="hidden" />
						<input name="shopChainId" id="shopChainId" type="hidden" />
						<input name="queryType" id="queryType" type="hidden" value="1">
						<input name="menshiName" id="menshiName" readonly="readonly"/>
					</td>
					<td>
						&nbsp;&nbsp;<a href="javascript:void(0)" onclick="selectMenshi()" class="easyui-linkbutton" data-options="iconCls:'icon-add'">选择</a>
					</td>
					<td>
						&nbsp;&nbsp;<a href="javascript:void(0)" onclick="doSearch()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
					</td>
					<td>
						&nbsp;&nbsp;<a href="javascript:void(0)" onclick="clearForm()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a>
					</td>
				</tr>
			</table>
		</form>
		<div id="toolbar">  
	       <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="updateCoupon()">修改</a>  
	       <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteCoupons()">删除</a>  
	   </div>
	   <table id="tt" class="easyui-datagrid"   width="100%" height="100%"
        				data-options="url:'list',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,toolbar: '#toolbar',
			rownumbers:true,pageList:pageList,singleSelect:false,queryParams: {
				queryType: '1'
			}">  
    		<thead>  
        		<tr>  
        			<th data-options="field:'identifyCode',width:30">识别编号</th>
             		<th data-options="field:'validDateFrom',width:30">开始时间</th>
             		<th data-options="field:'validDateTo',width:30" >结束时间</th>
             		<th data-options="field:'createdAt',width:30,formatter:function(v,r,i){return formatterdate(v,r);}" >创建时间</th>
             		<th data-options="field:'price',width:20" >售价</th>
             		<th data-options="field:'id',hidden:true">id</th>
           		</tr>  
	       	</thead>  
   		</table>
		<div id="shopDialog" class="easyui-dialog" title="优惠券基本信息-门市选择" style="width:755px;height:480px;" data-options="resizable:false,modal:true,closed:true">
					<form action="#" id="shopForm" style="height:55px">
						<table>
							<tr>
								<td >门店中文名称:</td>
								<td ><input type="text" id="shopName" name="name" style="width:100px;"/></td>
								<td >门店英文名称:</td>
								<td><input type="text" id="shopEnName"  name="enName" style="width:100px;"/></td>
							</tr>
							<tr>
								<td >区域:</td>
								<td colspan="2">
									<select id="shopProvince" name="province" style="width:100px;"></select>
					  				<select id="shopCity" name="city" style="width:100px;"></select>
					  				<select id="shopRegion" name="region" style="width:100px;"></select>
								</td>
								<td>
									<a href="javascript:void(0);" onclick="javascript:$('#shops').datagrid('load',{
										name: $('#shopName').val(),
										province: $('#shopProvince').val(),
										city: $('#shopCity').val(),
										region: $('#shopRegion').val(),
										enName: $('#shopEnName').val()			
									});" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a></td><td><a href="javascript:void(0)" onclick="clearShopForm()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a>
								</td>
							</tr>
						</table>
					</form>
					<table id="shops" class="easyui-datagrid" data-options="url:'<%=request.getContextPath()%>/line/findShopList',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,rownumbers:true,pageList:pageList,singleSelect:true">
					    <thead>  
					        <tr> 
					        	<th field="id" checkbox="true"></th> 
					        	<th data-options="field:'num',width:130">总店编号</th>
					            <th data-options="field:'name',width:130">门店中文名</th>
					            <th data-options="field:'enName',width:130">门店英文名</th>
					            <th data-options="field:'region',width:200,formatter:function(v,o,i){return getAddress(v,o,i) }">区域</th>  
					        </tr>  
					    </thead>  
					</table>
			<table align="right">					
			<tr align="right">
				<td align="right">
					<a href="javascript:void(0)" onclick="selectShop()" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">确定</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="javascript:$('#shopDialog').dialog('close');" class="easyui-linkbutton" data-options="iconCls:'icon-back'">关闭</a>
				</td>
			</tr>
		</table> 
	</div>
	<div id="shopChainDialog" class="easyui-dialog" title="优惠券基本信息-连锁选择" style="width:755px;height:450px;" data-options="resizable:false,modal:true,closed:true"> 
		<form action="#" id="shopChainForm">
			<table>
				<tr>
					<td align="right">总店编号:</td>
					<td align="left"><input type="text" id="shopChainNum" name="shopChainNum" style="width:100px;"/></td>
					<td align="right">总店名称:</td>
					<td align="left"><input type="text" id="shopChainName" name="shopChainName" style="width:100px;"/></td>
					<td><a id="btn" href="javascript:void(0);" onclick="javascript:$('#shopChains').datagrid('load',{
						numno: $('#shopChainNum').val(),
						name: $('#shopChainName').val()		
					});" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a></td><td><a href="javascript:void(0)" onclick="clearShopChainForm()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a></td>
				</tr>
			</table>
		</form>
		<table id="shopChains" class="easyui-datagrid" data-options="url:'<%=request.getContextPath()%>/line/findShopChain',pagination:true,rownumbers:true,singleSelect:true">
		    <thead>  
		        <tr> 
		        	<th field="id" checkbox="true"></th> 
		        	<th data-options="field:'numno',width:120">总店编号</th>
		            <th data-options="field:'name',width:120">总店名称</th>
		            <th data-options="field:'linkman',width:120">联系人</th>
		            <th data-options="field:'hotline',width:130">固定电话</th>
		            <th data-options="field:'email',width:130">邮箱</th>
		        </tr>  
		    </thead>  
		</table> 
		<table align="right">
			<tr>
				<td align="right">
					<a href="javascript:void(0)" onclick="selectShopChain()" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">确定</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="javascript:$('#shopChainDialog').dialog('close');" class="easyui-linkbutton" data-options="iconCls:'icon-back'">关闭</a>
				</td>
			</tr>
		</table>
	</div>
	</body>
<script type="text/javascript">
new PCAS("province","city","region","${shop.province}","${shop.city}","${shop.region}");
</script>
</html>