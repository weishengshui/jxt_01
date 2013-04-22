<%@page import="com.chinarewards.metro.core.common.Dictionary"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"><%--"http://www.w3.org/TR/html4/loose.dtd" --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link id="easyuiTheme" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/extend-easyui-validate.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/common.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/PCASClass.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/constant.js"></script>
<style type="text/css">
	fieldset table tr{height: 35px;}
	fieldset{margin-bottom:10px;margin:0px;width:600px;font-size:14px;}
	select{width:155px;height:20px;}
	.red{color:red;font-size:12px;}
</style>
<script type="text/javascript">
	function doSubmit(){
		if($('#jifenForm').form('validate')){
			if($("#jfmoney").val() <= 0){
				$.messager.alert('提示','充值积分不能小于或等于0','warning');
				return;
			}
			$.ajax({
	            url:'saveAccountPay',
	            type:'post',
	            data:$("#jifenForm").serialize(),
	            success:function(data){
	            	$.messager.show({  
			            title:'提示',  
			            msg:'充值成功',
			            showType:'show'  
			        });
	            	reset0();
	            },
	            error:function(data){
	            	$.messager.alert('提示','充值失败','error');
				}
	        });
		}
	}
	function doSubmits(){
		if($('#chuzhiForm').form('validate')){
			if($("#czmoney").val() <= 0.00){
				$.messager.alert('提示','充值数额不能小于或等于0','warning');
				return;
			}
			$.ajax({
	            url:'saveAccountPay',
	            type:'post',
	            data:$("#chuzhiForm").serialize(),
	            success:function(data){
	            	$.messager.show({  
			            title:'提示',  
			            msg:'充值成功',
			            showType:'show'  
			        });
	            	reset1();
	            },
	            error:function(data){
	            	$.messager.alert('提示','充值失败','error');
				}
	        });
		}
	}
	function reset0(){
		$('#jfmoney').numberbox('clear');
    	$('#jfnote').val('');
	}
	function reset1(){
		$('#czmoney').numberbox('clear');
    	$('#cznote').val('');
	}
</script>
</head>
<body>
	<div class="easyui-tabs" style="height:670px;">  
	    <div title="积分充值" style="padding:20px;">  
	        <form id="jifenForm" method="post" action="saveAccountPay">
			  <fieldset>
			  	<legend style="color: blue;">积分充值</legend>
			  	<div style="margin:20px;font-size:14px">
			  	<table style="font-size: 14px;">
			  		<tr>
			  			<td>&nbsp;</td>
			  			<td>提示：</td>
			  			<td>充值完成积分后立即到帐</td>
			  		</tr>
			  		<tr>
			  			<td><span class="red"></span></td>
			  			<td width="80">会员名称：</td>
			  			<td width="200">
				  			${member.surname }${member.name }
				  			<input type="hidden" name="memberName" value="${member.surname }${member.name }" />
				  			<input type="hidden" name="memberId" value="${member.id }" />
				  		</td>
			  		</tr>
			  		<tr>
			  			<td><span class="red"></span></td>
			  			<td width="80">会员卡号:</td>
			  			<td>
			  				${member.card.cardNumber }
			  			</td>
			  		</tr>
			  		<tr>
			  			<td><span class="red"></span></td>
			  			<td>商家名称：</td>
			  			<td>缤刻<input type="hidden" name="source" value="缤刻" /></td>
			  		</tr>
			  		<tr>
			  			<td><span class="red"></span></td>
			  			<td>交易类型：</td>
			  			<td>积分充值<input type="hidden" name="payType" value="<%=Dictionary.SUFFICIENT_TYPE_INTEGRAL %>" /></td>
			  		</tr>
			  		<tr>
			  			<td><span class="red">*</span></td>
			  			<td>积分充值：</td>
			  			<td><input maxlength="8" type="text" name="money" id="jfmoney" class="easyui-numberbox" data-options="required:true" /></td>
			  		</tr>
			  		<tr>
			  			<td><span class="red"></span></td>
			  			<td>说明：</td>
			  			<td><textarea rows="4" cols="20" name="note" id="jfnote" onblur="this.value = this.value.substring(0,250)" onkeyup="this.value = this.value.substring(0,250)"></textarea></td>
			  		</tr>
			  		<tr>
			  			<td>&nbsp;</td>
			  			<td>&nbsp;</td>
			  			<td>
			  				<a id="btn" href="javascript:void(0)" onclick="doSubmit()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
			  				<a id="btn" href="javascript:void(0)" onclick="reset0()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a>
			  			<td>
			  		</tr>
			  	</table>
			  	</div>
			  </fieldset>
			  <br/>
			</form>  
	    </div>  
	    <div title="储值卡充值"  style="padding:20px;">  
	         <form id="chuzhiForm" method="post" action="saveAccountPay">
			  <fieldset>
			  	<legend style="color: blue;">储值卡充值</legend>
			  	<div style="margin:20px;font-size:14px">
			  	<table style="font-size: 14px;">
			  		<tr>
			  			<td></td>
			  			<td>提示：</td>
			  			<td>充值完成金额后立即到帐</td>
			  		</tr>
			  		<tr>
			  			<td><span class="red"></span></td>
			  			<td width="80">会员名称：</td>
			  			<td width="200">
				  			${member.surname }${member.name }
				  			<input type="hidden" name="memberName" value="${member.surname }${member.name }" />
				  			<input type="hidden" name="memberId" value="${member.id }" />
				  		</td>
			  		</tr>
			  		<tr>
			  			<td><span class="red"></span></td>
			  			<td width="80">会员卡号：</td>
			  			<td>
			  				${member.card.cardNumber }
			  			</td>
			  		</tr>
			  		<tr>
			  			<td><span class="red"></span></td>
			  			<td>交易来源：</td>
			  			<td>CRM
			  				<input type="hidden" name="source" value="CRM" />
			  				<input type="hidden" name="payType" value="<%=Dictionary.SUFFICIENT_TYPE_STORED %>" />
			  			</td>
			  		</tr>
			  		<tr>
			  			<td><span class="red">*</span></td>
			  			<td>充值数额：</td>
			  			<td><input maxlength="8" type="text" name="money" id="czmoney" class="easyui-numberbox" data-options="precision:2,required:true" /></td>
			  		</tr>
			  		<tr>
			  			<td><span class="red"></span></td>
			  			<td>说明：</td>
			  			<td><textarea rows="4" cols="20" name="note" id="cznote" onblur="this.value = this.value.substring(0,250)" onkeyup="this.value = this.value.substring(0,250)"></textarea></td>
			  		</tr>
			  		<tr>
			  			<td>&nbsp;</td>
			  			<td>&nbsp;</td>
			  			<td>
			  				<a id="btn" href="javascript:void(0)" onclick="doSubmits()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
			  				<a id="btn" href="javascript:void(0)" onclick="reset1()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a>
			  			<td>
			  		</tr>
			  	</table>
			  	</div>
			  </fieldset>
			  <br/>
			</form>  
	    </div>  
	</div> 
</body>
</html>