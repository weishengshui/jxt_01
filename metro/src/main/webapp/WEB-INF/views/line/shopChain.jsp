<%@page import="com.chinarewards.metro.core.common.Dictionary"%>
<%@ page language="java" contentType="text/html; charset=utf8" pageEncoding="utf8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
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
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/common.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/json2.js"></script>
<style type="text/css">
	fieldset{margin-bottom:10px;margin:0px;width:500px;}
	.red{color:red;font-size:12px;}
	textarea{font-size:13px;}
</style>
<script type="text/javascript">
	function save(){
		if($('#chainForm').form('validate')){
			if(!valiteNum()){
				$.messager.alert('提示','总店编号已存在','warning');return;
			}
			$.ajax({
				url:'saveShopChain',
				data:$("#chainForm").serialize(),
				dataType:'json',
				success:function(data){
					$.messager.show({  
		                title:'提示',  
		                msg:'保存成功!',  
		                showType:'show'  
		            });
					if($("#id").val()==''){
						$('#chainForm').form('clear');
					}
				}
			});
		}
	}
	function valiteNum(){
		var flag = false;
		$.ajax({
			url:'findShopChainByNo',
			data:"numno="+$("#numno").val()+"&id="+$("#id").val(),
			dataType:'json',
			async:false,
			success:function(data){
				if(data==0){
					flag = true;
				}
			}
		});
		return flag;
	}
	
	function resets(){
		$('#chainForm').form('clear');
	}
	
	function getAddress(v,o,i){
        return (o.province == null ? '' : o.province) + 
         	   (o.city == null ? '' : o.city) + 
         	   (o.region == null ? '' : o.region ) + 
         	   (o.address == null ? '' : o.address);
    }
</script>
</head>
<body style="padding:10px;">
	 <div class="easyui-tabs">
	 	<div title="总店信息" style="padding:20px;">
	  <fieldset style="font-size:14px;">
	  	<legend style="color: blue;">基本信息</legend>
	  	<form id="chainForm" method="post">
	  	<input type="hidden" name="id" id="id" value="${chain.id }" />
	  	<table>
	  		<tr>
	  			<td><span class="red">*</span></td>
	  			<td style="width: 80px;">总店编号：</td>
	  			<td><input id="numno" type='text' name='numno' value="<c:out value="${chain.numno }"/>" style="width:200px" maxlength="20" 
				class="easyui-validatebox" data-options="required:true"/>
	  			</td>
	  		</tr>
	  		<tr>
	  			<td><span class="red">*</span></td>
	  			<td>总店名称：</td>
	  			<td>
	  				<input id="name" type='text' name='name' value="<c:out value="${chain.name }"/>" style="width:200px" maxlength="100" 
				class="easyui-validatebox" data-options="required:true" />
	  			</td>
	  		</tr>
	  		<tr>
	  			<td><span class="red">*</span></td>
	  			<td>联系人：</td>
	  			<td>
	  				<input id="linkman" type='text' name='linkman' value="<c:out value="${chain.linkman }"/>" style="width:200px" maxlength="100" 
				class="easyui-validatebox" data-options="required:true" />
	  			</td>
	  		</tr>
	  		<tr>
	  			<td><span class="red">*</span></td>
	  			<td>固定电话：</td>
	  			<td>
	  				<input id="hotline" type='text' name='hotline' value="${chain.hotline }" style="width:200px" maxlength="15" 
				class="easyui-validatebox" data-options="validType:'phoneNumber',required:true" />
	  			</td>
	  		</tr>
	  		<tr>
	  			<td><span class="red">*</span></td>
	  			<td>电子邮件：</td>
	  			<td>
	  				<input id="email" type='text' name='email' value="${chain.email }" style="width:200px" maxlength="100" 
				class="easyui-validatebox" data-options="required:true,validType:'email'" />
	  			</td>
	  		</tr>
	  		<tr>
	  			<td align="right" colspan="4">
	  				<a id="btn" href="javascript:void(0)" onclick="save()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
	  				<!-- 
	  				<a id="btn" href="javascript:void(0)" onclick="resets()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a>
	  				 -->
	  			</td>
	  		</tr>
	  	</table>
	 </form>
	 </fieldset>
	 </div>
	 <c:if test="${not empty chain.id }">
	 <div title="分店信息">
		<table id="table" class="easyui-datagrid" data-options="url:'findShopList?chainId=${chain.id }',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
			rownumbers:true,pageList:pageList,singleSelect:true,onDblClickRow:function(rowIndex,rowData){edit(rowData.id,rowData.name);}">
		    <thead>  
		        <tr>
		        	<th data-options="field:'id',hidden:true,width:30">id</th>
		            <th data-options="field:'num',width:30">总店编号</th>
		            <th data-options="field:'name',width:30">中文名称</th>
		            <th data-options="field:'enName',width:30">英文名称</th>
		            <th data-options="field:'region',width:30,formatter:function(v,o,i){return getAddress(v,o,i) }">区域</th>
		            <th data-options="field:'linkman',width:30">联系人</th>
		            <th data-options="field:'workPhone',width:30">联系电话</th>
		        </tr>
		    </thead>  
		</table> 
	 </div>
	 </c:if>
	</div>
</body>
</html>