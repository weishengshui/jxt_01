<%@ page language="java" contentType="text/html; charset=utf8" pageEncoding="utf8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link id="easyuiTheme" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<style type="text/css">
	.table select{width:140px;height:22px;margin-right:20px;}
	form{margin:0; padding:0}
</style>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script id="easyuiTheme" type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/common.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.json-2.4.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>	
<script type="text/javascript">
	var editIndex = undefined;
	var merCodes = null;
	var merNames = null;
	var merModels = null;
	var sorts = null;
	var addRows = 10;
	
	$(document).ready(function(){
		$('#tt').datagrid({
			onDblClickRow: function(rowIndex,rowData){
				$('#catalogId').val(rowData.id);
				$('#merchaniseCode').html(rowData.code);
				$('#merchaniseName').html(rowData.name);
				$('#merchaniseModel').html(rowData.model);
				$('#merchaniseStatus').val(rowData.status);
				$('#displaySort').numberbox('setValue',rowData.displaySort);
				$('#dd').dialog('center');	
				$('#dd').dialog('open');
			}
		});	  
		merCodes = new Array();
		merNames = new Array();
		merModels = new Array();
		sorts = new Array();
		for(var i = 0; i < addRows; i++){
			var index = i+1;
			merCodes[i] = 'merCode' + index;
			merNames[i] = 'merName' + index;
			merModels[i] = 'merModel' + index;
			sorts[i] = 'merSort' + index;
		}
	});
	
	$(function(){
		setTimeout("expandRoot()", 200);
	});
	
	function expandRoot(){
		var root = $('#tt2').tree('getRoot');
		if(root){
			$('#tt2').tree('reload', root.target); 
			$('#tt2').tree('expandAll', root.target);
		}
	}
	function formatterdate(val, row) {
        var date = new Date(val);
        return date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate();
	}

	function doSearch(){  
		if($('#categoryId').val()==''){
			alert("请先选择一个叶子节点");
			return;
		}
		
	    $('#tt').datagrid('load',{  
	    	name:$('#name').val(),  
	    	code:$('#code').val(),
	    	categoryId:$('#categoryId').val()
	    });  
	}
	function addMerchandise(){
		if($('#categoryId').val()==''){
			alert("请先选择一个叶子节点");
			return;
		}
		$('#cName').html($('#categoryName').html());
		clearAcForm();
		$('#dd2').dialog('center');	
		$('#dd2').dialog('open');	
		// TODO
	}
	function updateMerchandise(){
		if($('#categoryId').val()==''){
			alert("请先选择一个叶子节点");
			return;
		}
		var row = $('#tt').datagrid('getSelected');
		if(row){
			$('#catalogId').val(row.id);
			$('#merchaniseCode').html(row.code);
			$('#merchaniseName').html(row.name);
			$('#merchaniseModel').html(row.model);
			$('#merchaniseStatus').val(row.status);
			$('#displaySort').numberbox('setValue',row.displaySort);
			$('#dd').dialog('center');	
			$('#dd').dialog('open');	
		}else{
			alert("请先选择要修改的行");
		}
	}
	function deleteMerchandise(){
		if($('#categoryId').val()==''){
			alert("请先选择一个叶子节点");
			return;
		}
		var rows = $('#tt').datagrid('getSelections');
		if(rows.length > 0){
			if(!confirm('确认删除?')){
				return;
			}
			//check merchandise only has one category
			var merhcandiseCode ="";
			var onlyOne = false;
			for(var i=0, length=rows.length; i < length; i++){
				var row = rows[i];
				$.ajax({
					url:'checkMerchandiseCategorysCount',
					data:'id='+row.id,
					type:'post',
					async:false,
					success: function(result){//返回类型的是AjaxResponseCommonVo
						if(result.msg == "true"){
							merhcandiseCode = row.code;
							onlyOne = true;
						}
					}
				});
				if(onlyOne){
					break;
				}
			}
			if(onlyOne){
				// alert("商品编号为\""+merhcandiseCode+"\"的商品只属于当前一个类别，不能删除");
				 $.messager.show({
						title:'提示信息',
						msg: "商品编号为\""+merhcandiseCode+"\"的商品只属于当前一个类别，不能删除",
						timeout:5000,
						showType:'slide'
					});
				return;
			}

			var ids = '';
			for(var i=0, length=rows.length; i < length; i++){
				ids +='id='+rows[i].id+'&';
			}
			ids = ids.substring(0, ids.length -1);
			$.ajax({
				url:'removeCataFromCategory',
				data:ids,
				success: function(result){
					result = eval('('+result+')');
					//alert(result.msg);
					$.messager.show({
						title:'提示信息',
						msg: result.msg,
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
	
	//商品上下架操作
	function upAndDown(v, r, i){
		if(r.status == 'ON'){
			return '<a href="javascript:void(0)" onclick="changeStatus(\''+r.id+'\',\'OFF\')">下架</a>';
		}else{
			return '<a href="javascript:void(0)" onclick="changeStatus(\''+r.id+'\',\'ON\')">上架</a>';
		}
	}
	//改变商品目录的上下架状态
	function changeStatus(id, status){
		$.ajax({
			url:'changeCataStatus',
			data: 'id='+id+'&status='+status+'&temp='+(new Date().getTime()),
			success: function(result){
				$('#tt').datagrid('reload');
			}
		});
	}
	//修改商品目录信息
	function updateCatalog(){
		$('#uc').form('submit',{
			onSubmit: function(){
				return $(this).form('validate');
			},
			success: function(result){
				result = eval('('+result+')');
				$.messager.show({
					title:'提示信息',
					msg: result.msg,
					timeout:5000,
					showType:'slide'
				});
				if(result.categoryId){
					//alert(result.msg);
					return;
				}
				$('#tt').datagrid('reload');
				$('#dd').dialog('close');				
			}
		});
	}
	function loadCataMerCode(loadCataMerCodeInput, merName, merModel, merSort, mc){
		$('#'+merName).html("");
		$('#'+merModel).html("");
		$('#'+merSort).validatebox({required:false});
		$('#'+merSort).val("");
		var merCode = loadCataMerCodeInput.value;
		if(merCode != ''){
			for(var i=0; i < addRows; i++){
				if(mc != merCodes[i] && $('#'+mc).val() == $('#'+merCodes[i]).val()){
					alert("该商品编号已经输入");
					loadCataMerCodeInput.value = "";
					return;
				}
			}
			var mer = null;
			$.ajax({
				url:'checkMerCodeExists',
				data:{merCode:merCode},
				async:false,
				success: function(result){
					result = $.toJSON(result); 
					result = eval('('+result+')');
					if(result.id){mer = result;}
					else{
						//alert("商品编号\""+merCode+"\"不存在");
						$.messager.show({
							title:'提示信息',
							msg: "商品编号\""+merCode+"\"不存在",
							timeout:5000,
							showType:'slide'
						});
						loadCataMerCodeInput.value = "";
					}
				}
			});
			if(mer){
				$.ajax({
					url:'loadMerByMerCode',
					data:'merCode='+merCode+'&cateId='+$('#categoryId').val(),
					async:false,
					success: function(result){
						result = $.toJSON(result); 
						result = eval('('+result+')');
						if(result.id){
							// alert("商品编号\""+merCode+"\"已在该类别下");
							$.messager.show({
								title:'提示信息',
								msg: "商品编号\""+merCode+"\"已在该类别下",
								timeout:5000,
								showType:'slide'
							});
							loadCataMerCodeInput.value = "";
						}
						else{
							$('#'+merName).html(mer.name);
							$('#'+merModel).html(mer.model);
							$('#'+merSort).validatebox({required:true});
						}
					}
				});
			}
		}
	}
	 function validateNum(val, merCode){//验证整数
		 if(val.value == ""){
			 return;
		 }
		 if($('#'+merCode).val()==""){
			 alert("请先输入商品编号");
			 val.value="";
			 return;
		 }
	 	
		 var patten = /^-?\d+$/;
		 if(!patten.test(val.value)){
			alert("请输入一个整数值");
			val.value="";
			return;
		 }else if(val.value * 1 < 1){
			 alert("排序值必须大于0");
			 val.value="";
			 return;
		 }
		 for(var i=0; i < addRows; i++){
			if(val.id != sorts[i] && val.value == $('#'+sorts[i]).val() && val.value !=""){
				alert("该显示排序已经输入");
				val.value="";
				return;
			}
		}
		 $.ajax({
				url:'checkDisplaySortExists',
				data:'cateId='+$('#categoryId').val()+'&displaySort='+val.value,
				async:false,
				success: function(result){
					if((eval('('+result+')')).msg){
						//alert("显示排序\""+ val.value +"\"已存在，请重新输入");
						$.messager.show({
							title:'提示信息',
							msg: "显示排序\""+ val.value +"\"已存在，请重新输入",
							timeout:5000,
							showType:'slide'
						});
						val.value= "";
					}
				}
			});	 	
	}
	 function addCatalog(){
		 // 至少输入一条记录
		 var leastOne = false;
		for(var i=0; i < addRows; i++){
			if($('#'+merCodes[i]).val() != ''){
				leastOne = true;
				break;
			}
		}
		if(!leastOne){
			alert("请至少输入一条记录");
			return;
		}
		 $('#ac').form('submit',{
			 url: 'addCatalog?cateId='+$('#categoryId').val(),
			 onSubmit: function(){
				 return $(this).form('validate');
			 },
			 success: function(result){
				 //alert(eval('('+result+')').msg);
				 $.messager.show({
						title:'提示信息',
						msg: eval('('+result+')').msg,
						timeout:5000,
						showType:'slide'
					});
				 $('#dd2').dialog('close');
				 doSearch();
			 }			
		 });
	 }
	 function clearAcForm(){
		 for(var i =0; i < addRows; i++){
			 $('#'+merCodes[i]).val('');
			 $('#'+sorts[i]).val('');
			 $('#'+merNames[i]).html('');
			 $('#'+merModels[i]).html('');
		 }
	 }
	 function clearForm(){
		 $('#code').val('');
		 $('#name').val('');
	 }
</script>

</head>
	<body>
		<table border="0">
			<tr>
				<td valign="top">
					<fieldset style="font-size: 14px;width:auto;height:100%;">
						<legend style="color: blue;">商品类别树</legend>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;选择商品类别：
						<ul id="tt2" class="easyui-tree" style="margin-top:10px;margin-left:20px;" data-options="url:'<%=request.getContextPath()%>/category/get_tree_nodes2'
								,onClick:function(node){
									if($('#tt2').tree('isLeaf',node.target)){
										var root = $('#tt2').tree('getRoot');
										if(node.id == root.id){
											alert('当前还没有可选的类别，请先添加类别');
										}else{
											$('#categoryName').html(node.text);
											$('#categoryId').val(node.id);
											doSearch();
										}
										
									}
								}"></ul>
					
					</fieldset>
				</td>
				<td>
					<fieldset style="font-size: 14px;width:550px;height:100%;">
						<legend style="color: blue;">类别商品信息</legend>
						<form action="#" id="ff">
							<table border="0">
								<tr>
									<td colspan="3">
									请从左边商品类别树选择商品类别<br/>
									类别名称：<span id="categoryName"></span><input type="hidden" id="categoryId" />
									</td>
								</tr>
								<tr>
									<td width="80px">商品编号：</td>
									<td width="200px" align="left">
										<input id="code" name="code" type="text" style="width:150px"> 
									</td>
									<td width="80px">商品名称：</td>
									<td width="200px" align="left">
										<input id="name" name="name" type="text" style="width:150px"> 
									</td>
								</tr>
								<tr>
									<td></td><td></td>
									<td colspan="2">
										<a href="javascript:void(0)" onclick="doSearch()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>&nbsp;&nbsp;<a href="javascript:void(0)" onclick="clearForm()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a>
									</td>
								</tr>
							</table>
						</form>
						<div id="toolbar">  
							<a href="javascript:void(0)" onclick="addMerchandise()" class="easyui-linkbutton" plain="true" data-options="iconCls:'icon-add'">新增</a>
							<a href="javascript:void(0)" onclick="updateMerchandise()" class="easyui-linkbutton" plain="true" data-options="iconCls:'icon-edit'">修改</a>
							<a href="javascript:void(0)" onclick="deleteMerchandise()" class="easyui-linkbutton" plain="true" data-options="iconCls:'icon-remove'">删除</a>
					   	</div>
						<table id="tt" class="easyui-datagrid" width="100%" height="100%"  
	           				data-options="url:'getMerCatas',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,toolbar: '#toolbar',
							rownumbers:true,pageList:pageList,singleSelect:false">  
	       					<thead>  
	           				<tr>  
<!-- 	           				<th field="id" checkbox="true"></th>  -->
	                		<th data-options="field:'code'">商品编号</th>
	                		<th data-options="field:'name'" >商品名称</th>
	                		<th data-options="field:'model'" >型号</th>
	                		<th data-options="field:'status',formatter:function(v,r,i){return upAndDown(v, r, i);}">上下架</th>
	                		<th data-options="field:'displaySort'">显示排序</th>
	                		<th data-options="field:'id',hidden:true">id</th>
				           	</tr>  
					       	</thead>  
				   		</table>
					</fieldset>
				</td>
			</tr>
		</table>
		<div id="dd" class="easyui-dialog" title="商品类别修改商品状态" style="width:400px;height:250px;text-align:center;"  
	        data-options="resizable:false,modal:true,closed:true">  
	        	<fieldset style="font-size: 14px;width:auto;height:auto;">
					<legend style="color: blue;">修改商品状态</legend>
					<form action="updateCatalog" id="uc" method="post">
						<table border="0">
							<tr>
								<td width="80px">商品编号：</td>
								<td width="200px" align="left">
									<input type="hidden" name="catalogId" id="catalogId">
									<span id="merchaniseCode"></span> 
								</td>
							</tr>
							<tr>
								<td width="80px">商品名称：</td>
								<td width="200px" align="left">
									<span id="merchaniseName"></span> 
								</td>
							</tr>
							<tr>
								<td width="80px">商品型号：</td>
								<td width="200px" align="left">
									<span id="merchaniseModel"></span> 
								</td>
							</tr>
							<tr>
								<td width="80px">上下架：</td>
								<td width="200px" align="left">
									<select id="merchaniseStatus" name="status">
										<option value="ON">上架</option>
										<option value="OFF">下架</option>
									</select> 
								</td>
							</tr>
							<tr>
								<td width="80px">商品排序：</td>
								<td width="200px" align="left">
									<input id="displaySort" name="displaySort" type="text" style="width:150px" class="easyui-numberbox" data-options="min:1,required:true">
								</td>
							</tr>
						</table>
					</form>
				</fieldset>
	        	<a href="javascript:void(0)" onclick="updateCatalog()" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">确定</a>&nbsp;&nbsp;<a href="javascript:void(0)" onclick="javascript:$('#dd').dialog('close');" class="easyui-linkbutton" data-options="iconCls:'icon-back'">关闭</a>
	        </div>
 		<div id="dd2" class="easyui-dialog" title="商品类别新增商品" style="width:600px;height:500px;"  
	        data-options="resizable:false,modal:true,closed:true">
	        	<br>  
	        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-size: 20px;">类别名称：</span><span id="cName" style="font-size: 20px;"></span>
	        	<fieldset style="font-size: 14px;width:auto;height:auto;">
					<legend style="color: blue;">商品类别新增商品</legend>
					<form action="addCatalog" id="ac" method="post">
						<table id="dg" class="easyui-datagrid" style="width:530px;height:300px;"  
						            data-options="singleSelect: true">
				        	<thead>
					            <tr>
					                <th data-options="field:'merCode',width:100,align:'left'">商品编号</th>          
					                <th data-options="field:'merName',width:100,align:'left'">商品名称</th>
					                <th data-options="field:'merModel',width:100,align:'left'">型号</th>
					                <th data-options="field:'merStatus',width:100,align:'left'">上下架</th>
					                <th data-options="field:'merSort',width:100,align:'left'">显示排序</th>
					            </tr>
				      	 	 </thead>
				      	 	 <tr>
					      	 	 	<td>
					      	 	 		<input type="text" name="merCode" id="merCode1" style="width:80px;" onblur="loadCataMerCode(this,'merName1','merModel1','merSort1','merCode1')">
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<span id="merName1"></span>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<span id="merModel1"></span>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<select name="status" style="width:80px;">
											<option value="ON">上架</option>
											<option value="OFF">下架</option>
										</select>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<input type="text" name="sort" id="merSort1" style="width:80px;" onblur="validateNum(this,'merCode1')" maxlength="10"></input>
					      	 	 	</td>
					      	 	 </tr>
					      	 	 <tr>
					      	 	 	<td>
					      	 	 		<input type="text" name="merCode" id="merCode2" style="width:80px;" onblur="loadCataMerCode(this,'merName2','merModel2','merSort2','merCode2')">
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<span id="merName2"></span>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<span id="merModel2"></span>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<select name="status" style="width:80px;">
											<option value="ON">上架</option>
											<option value="OFF">下架</option>
										</select>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<input type="text" name="sort" id="merSort2" style="width:80px;" onblur="validateNum(this,'merCode2')" maxlength="10"></input>
					      	 	 	</td>
					      	 	 </tr>
					      	 	 <tr>
					      	 	 	<td>
					      	 	 		<input type="text" name="merCode" id="merCode3" style="width:80px;" onblur="loadCataMerCode(this,'merName3','merModel3','merSort3','merCode3')">
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<span id="merName3"></span>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<span id="merModel3"></span>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<select name="status" style="width:80px;">
											<option value="ON">上架</option>
											<option value="OFF">下架</option>
										</select>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<input type="text" name="sort" id="merSort3" style="width:80px;" onblur="validateNum(this,'merCode3')" maxlength="10"></input>
					      	 	 	</td>
					      	 	 </tr>
					      	 	 <tr>
					      	 	 	<td>
					      	 	 		<input type="text" name="merCode" id="merCode4" style="width:80px;" onblur="loadCataMerCode(this,'merName4','merModel4','merSort4','merCode4')">
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<span id="merName4"></span>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<span id="merModel4"></span>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<select name="status" style="width:80px;">
											<option value="ON">上架</option>
											<option value="OFF">下架</option>
										</select>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<input type="text" name="sort" id="merSort4" style="width:80px;" onblur="validateNum(this,'merCode4')" maxlength="10"></input>
					      	 	 	</td>
					      	 	 </tr>
					      	 	 <tr>
					      	 	 	<td>
					      	 	 		<input type="text" name="merCode" id="merCode5" style="width:80px;" onblur="loadCataMerCode(this,'merName5','merModel5','merSort5','merCode5')">
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<span id="merName5"></span>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<span id="merModel5"></span>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<select name="status" style="width:80px;">
											<option value="ON">上架</option>
											<option value="OFF">下架</option>
										</select>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<input type="text" name="sort" id="merSort5" style="width:80px;" onblur="validateNum(this,'merCode5')" maxlength="10"></input>
					      	 	 	</td>
					      	 	 </tr>
					      	 	 <tr>
					      	 	 	<td>
					      	 	 		<input type="text" name="merCode" id="merCode6" style="width:80px;" onblur="loadCataMerCode(this,'merName6','merModel6','merSort6','merCode6')">
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<span id="merName6"></span>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<span id="merModel6"></span>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<select name="status" style="width:80px;">
											<option value="ON">上架</option>
											<option value="OFF">下架</option>
										</select>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<input type="text" name="sort" id="merSort6" style="width:80px;" onblur="validateNum(this,'merCode6')" maxlength="10"></input>
					      	 	 	</td>
					      	 	 </tr>
					      	 	 <tr>
					      	 	 	<td>
					      	 	 		<input type="text" name="merCode" id="merCode7" style="width:80px;" onblur="loadCataMerCode(this,'merName7','merModel7','merSort7','merCode7')">
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<span id="merName7"></span>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<span id="merModel7"></span>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<select name="status" style="width:80px;">
											<option value="ON">上架</option>
											<option value="OFF">下架</option>
										</select>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<input type="text" name="sort" id="merSort7" style="width:80px;" onblur="validateNum(this,'merCode7')" maxlength="10"></input>
					      	 	 	</td>
					      	 	 </tr>
					      	 	 <tr>
					      	 	 	<td>
					      	 	 		<input type="text" name="merCode" id="merCode8" style="width:80px;" onblur="loadCataMerCode(this,'merName8','merModel8','merSort8','merCode8')">
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<span id="merName8"></span>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<span id="merModel8"></span>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<select name="status" style="width:80px;">
											<option value="ON">上架</option>
											<option value="OFF">下架</option>
										</select>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<input type="text" name="sort" id="merSort8" style="width:80px;" onblur="validateNum(this,'merCode8')" maxlength="10"></input>
					      	 	 	</td>
					      	 	 </tr>
					      	 	 <tr>
					      	 	 	<td>
					      	 	 		<input type="text" name="merCode" id="merCode9" style="width:80px;" onblur="loadCataMerCode(this,'merName9','merModel9','merSort9','merCode9')">
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<span id="merName9"></span>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<span id="merModel9"></span>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<select name="status" style="width:80px;">
											<option value="ON">上架</option>
											<option value="OFF">下架</option>
										</select>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<input type="text" name="sort" id="merSort9" style="width:80px;" onblur="validateNum(this,'merCode9')" maxlength="10"></input>
					      	 	 	</td>
					      	 	 </tr>
					      	 	 <tr>
					      	 	 	<td>
					      	 	 		<input type="text" name="merCode" id="merCode10" style="width:80px;" onblur="loadCataMerCode(this,'merName10','merModel10','merSort10','merCode10')">
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<span id="merName10"></span>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<span id="merModel10"></span>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<select name="status" style="width:80px;">
											<option value="ON">上架</option>
											<option value="OFF">下架</option>
										</select>
					      	 	 	</td>
					      	 	 	<td>
					      	 	 		<input type="text" name="sort" id="merSort10" style="width:80px;" onblur="validateNum(this,'merCode10')" maxlength="10"></input>
					      	 	 	</td>
					      	 	 </tr>
			      	 	 </table>
					</form>
				</fieldset>
				<table align="right">
					<tr align="right">
						<td align="right">
				        	<a href="javascript:void(0)" onclick="addCatalog()" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">确定</a>&nbsp;&nbsp;<a href="javascript:void(0)" onclick="javascript:$('#dd2').dialog('close');" class="easyui-linkbutton" data-options="iconCls:'icon-back'">关闭</a>
						</td>
					</tr>				
				</table>
	       </div>
	</body>
</html>