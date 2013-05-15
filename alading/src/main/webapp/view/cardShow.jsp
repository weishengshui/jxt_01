<%@ page language="java" contentType="text/html; charset=utf8"
	pageEncoding="utf8"%>
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
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.json-2.4.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<style type="text/css">
	fieldset table tr{height: 35px;}
	fieldset{margin-bottom:10px;margin-left:30px;margin-top:10px;}
	.red{color:red;font-size:12px;}
	form{margin:0; padding:0} 
</style>
<% response.setHeader("Cache-Control","no-store");%>
<script type="text/javascript">
		var baseURL = '<%=request.getContextPath()%>';
	
		
		$(document).ready(function(){
			$('#comfirmImage').linkbutton('disable');
			$('#comfirmCompany').linkbutton('disable');
			$.ajax({
				url: 'unitJson',
				type: 'get',
				dataType:'json',
				success: function(data){
					if(data && data != null){
						$('#unitId').val(data.pointId);
						$('#unit_name').text(data.pointName);
					}
				}
			}); 
		});
		
		function doSubmit(){
			var cardName = $('#cardName').val();
			if(cardName){
				if(cardName.trim() == ''){
					alert("卡名称不能为空或全是空格");
					return ;
				}
			} else {
				alert("请输入卡名称");
				return; 
			}
			var unitId = $('#unitId').val();
			if(unitId == ''){
				alert("请先到积分单位管理中添加积分单位");
				return;
			}
			
			var picId = $('#picId').val();
			if(picId == ''){
				alert('请选择卡图片');
				return;
			}
			
			var params = 'id='+$('#id').val();
			params += '&cardName='+cardName;
			params += '&defaultCard='+(($('#defaultCard').attr('checked')=='checked') ? 'true' : 'false');
			params += '&unitId='+unitId;
			params += '&picId='+picId;
			params += '&companyId='+$('#companyId').val(); 
			$.ajax({
				url:'card',
				type:'put',
				data: params,
				success: function(data){
					$.messager.show({
						title:'提示信息',
						msg: data,
						timeout:5000,
						showType:'slide'
					});
				}
			}); 
		}
		
	function getId(v, r, i){
		return r.id;
	}
	function openImageDialog(){
		$('#imageDialog').dialog('center');
		$('#imageDialog').dialog('open');
	}
	
	function previewImage(v, r, i){
		var url = baseURL + "/view/cardImageGet/"+r.id;
		return '<a href=javascript:show(\''+url+'\',\''+500+'\',\''+300+'\')>预览</a>';
	}
	
	function show(url,width,height){
        width = (width> 500 ? 500: width);
        width = (width < 100 ? 100: width);
        height = (height> 700 ? 500: height);
        height = (height < 100 ? 100: height);
        parent.parent.dialog("预览图片",url,width,height);
	}
	function searchImage(){
		$('#imageTable').datagrid('load',{  
	    	description:$('#description').val()
	    });  
	}
	function selectImage(){
		var row = $('#imageTable').datagrid('getSelected');
		if(row){
			if(row.description && row.description != ''){
				$('#image_desc').text(row.description);
			} else {
				$('#image_desc').text(row.id);
			}
			$('#picId').val(row.id);
			$('#imageDialog').dialog('close')
		}
	}
	function defaultCardCheck(){
		isSelectCompany();
	}
	function isSelectCompany(){
		if($('#defaultCard').attr('checked') != 'checked'){
			$('#companyStart').text('* ');
			$('#openCompanyButton').linkbutton('enable');
		} else {
			$('#companyStart').text('');
			$('#openCompanyButton').linkbutton('disable');
			$('#companyId').val('');
			$('#company_name').text('');
		}
	}
	function openCompanyDialog(){
		$('#companyDialog').dialog('center');
		$('#companyDialog').dialog('open');
	}
	function searchCompany(){
		$('#companyTable').datagrid('load',{  
			companyName:$('#companyName').val(),
			companyCode:$('#companyCode').val()
	    });  
	}
	function selectCompany(){
		var row = $('#companyTable').datagrid('getSelected');
		if(row){
			$('#company_name').text(row.name);
			$('#companyId').val(row.id);
			$('#companyDialog').dialog('close')
		}
	}
</script>

</head>
<body>
   	<form action="card" method="put" id="fm"> 
		<table border="0" style="font-size:13px;">
			<tr>
				<td>
					<fieldset style="font-size: 14px;width:570px;height:auto;">
						<legend style="color: blue;">卡新增</legend>
							<table border="0">
								<tr>
									<td><span style="color: red;">*&nbsp;</span></td>
									<td>卡名称：</td>
									<td>
										<input type="hidden" name="id" id="id" value="${card.id}">
										<input type="text" name="cardName" id="cardName" value='<c:out value="${card.cardName }"></c:out>' maxlength="20"> 
									</td>
									<td></td>
								</tr>
								<tr>
									<td><span style="color: red;"></span></td>
									<td>默认卡：</td>
									<td>
										<input type="checkbox" name="defaultCard" id="defaultCard" onclick="defaultCardCheck()" />
									</td>
									<td></td>
								</tr>
								<tr>
									<td><span style="color: red;">*&nbsp;</span></td>
									<td>
										积分单位：
										<input type="hidden" id="unitId" name="unitId" />
									</td>
									<td id="unit_name">
<%-- 										<input id="unitId" class="easyui-combobox" name="unitId" data-options="valueField:'pointId',textField:'pointName',url:'<%=request.getContextPath() %>/view/unitJson',method:'get'" />  --%>
									</td>
									<td></td>
								</tr>
								<tr>
									<td><span style="color: red;">*&nbsp;</span></td>
									<td>
										<input type="hidden" id="picId" name="picId" />
										卡图片：
									</td>
									<td id="image_desc">
									</td>
									<td>
										<a href="javascript:void(0)" onclick="openImageDialog()" class="easyui-linkbutton" data-options="iconCls:'icon-add'">选择</a>
									</td>
								</tr>
								<tr>
									<td><span style="color: red;" id="companyStart">*&nbsp;</span></td>
									<td>
										所属企业：
										<input type="hidden" name="companyId" id="companyId" />
									</td>
									<td id="company_name">
									</td>
									<td>
										<a id="openCompanyButton" href="javascript:void(0)" onclick="openCompanyDialog()" class="easyui-linkbutton" data-options="iconCls:'icon-add'">选择</a>
									</td>
								</tr>
								<tr>
									<td align="right" colspan="4">
										<a href="javascript:void(0)" onclick="doSubmit()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
									</td>
								</tr>
							</table>
					</fieldset>
				</td>
			</tr>
		</table>
	</form>
	
	<!-- card image dialog -->
    <div id="imageDialog" class="easyui-dialog" title="卡图片选择" style="width:500px;height:430px;"  
           data-options="iconCls:'icon-add',resizable:false,modal:true,closed:true,cache:false">  
           <form action="" id="imageForm" style="width:auto;">
			<table border="0" style="font-size: 14px;">
				<tr>
					<td>图片描述：</td>
					<td>
						<input id="description" name="description" type="text" style="width:150px"/> 
					</td>
					<td>
						<a href="javascript:void(0)" onclick="searchImage()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>&nbsp;&nbsp;<a href="javascript:void(0)" onclick="javascript:$('#imageForm').form('clear')" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a>
					</td>
				</tr>
			</table>
		</form>
		<!-- 显示列表Table -->
		<table id="imageTable" class="easyui-datagrid" data-options="url:'cardImageList',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
			rownumbers:true,pageList:pageList,singleSelect:true,onCheck:function(rowIndex, rowData){
				$('#comfirmImage').linkbutton('enable');
			}">
		    <thead>  
		        <tr>
		        	<th data-options="field:'id',checkbox:true"></th>
		        	<th data-options="field:'b',width:50,formatter: function(v, r, i){return getId(v, r, i);}">id</th>  
               		<th data-options="field:'description',width:50">描述</th>
               		<th data-options="field:'mimeType',width:50">图片类型</th>
               		<th data-options="field:'originalFilename',width:50">图片原名</th>
               		<th data-options="field:'a',width:50,formatter: function(v, r, i){return previewImage(v, r, i);}">操作</th>
		        </tr>  
		    </thead>  
		</table>
		<table align="right">
			<tr align="right">
				<td>
					<a id="comfirmImage" href="javascript:void(0)" onclick="selectImage()" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">确定</a>
				<td>
				<td>
					<a href="javascript:void(0)" onclick="javascript:$('#imageDialog').dialog('close')" class="easyui-linkbutton" data-options="iconCls:'icon-back'">关闭</a>
				</td>
			</tr>
		</table>
    </div>
    
    <!-- company dialog -->
    <div id="companyDialog" class="easyui-dialog" title="企业选择" style="width:600px;height:430px;"  
           data-options="iconCls:'icon-add',resizable:false,modal:true,closed:true,cache:false">  
           <form action="" id="companyForm" style="width:auto;" method="get">
			<table border="0" style="font-size: 14px;">
				<tr>
					<td>企业名称：</td>
					<td>
						<input id="companyName" name="companyName" type="text" style="width:100px" maxlength="300"/> 
					</td>
					<td>企业编号：</td>
					<td>
						<input id="companyCode" name="companyCode" type="text" style="width:100px" maxlength="300"/> 
					</td>
					<td>
						<a href="javascript:void(0)" onclick="searchCompany()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>&nbsp;&nbsp;<a href="javascript:void(0)" onclick="javascript:$('#companyForm').form('clear')" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a>
					</td>
				</tr>
			</table>
		</form>
		<!-- 显示列表Table -->
		<table id="companyTable" class="easyui-datagrid" data-options="url:'companyList',method:'get',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
			rownumbers:true,pageList:pageList,singleSelect:true,onCheck:function(rowIndex, rowData){
				$('#comfirmCompany').linkbutton('enable');
			}">
		    <thead>  
		        <tr>
		        	<th data-options="field:'id',checkbox:true"></th>
		        	<th data-options="field:'b',width:50,formatter: function(v, r, i){return getId(v, r, i);}">id</th>  
               		<th data-options="field:'name',width:50">描企业名称</th>
               		<th data-options="field:'code',width:50">企业编号</th>
		        </tr>  
		    </thead>  
		</table>
		<table align="right">
			<tr align="right">
				<td>
					<a id="comfirmCompany" href="javascript:void(0)" onclick="selectCompany()" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">确定</a>
				<td>
				<td>
					<a href="javascript:void(0)" onclick="javascript:$('#companyDialog').dialog('close')" class="easyui-linkbutton" data-options="iconCls:'icon-back'">关闭</a>
				</td>
			</tr>
		</table>
    </div>  
</body>
</html>