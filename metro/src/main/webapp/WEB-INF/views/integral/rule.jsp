<%@page import="com.chinarewards.metro.core.common.Dictionary"%>
<%@ page language="java" contentType="text/html; charset=utf8" pageEncoding="utf8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
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
	#ruleTable tr{height: 40px;}
	#ruleTable input{vertical-align: bottom;}
	#ruleTable label{vertical-align: bottom;}
</style>
<script>
function submits(){
	$('#ruleForm').form('submit', {
	    url:$("#id").val()==''?"saveRule":"updateRule",  
	    onSubmit: function(){
		    var flag = false;
	    	if($('#ruleForm').form('validate')){
	    		if($("#rangeFrom").datebox('getValue')!='' && $("#rangeTo").datebox('getValue') != ''){
	    			if($("#rangeFrom").datebox('getValue') > $("#rangeTo").datebox('getValue')){
	    	           	$.messager.alert('提示','时间段输入不正确,开始时间不能大于结束时间','warning');
				    	return false;
				    }
	    		}
			    var a = $("#rangeAgeFrom").val();
			    var b = $("#rangeAgeTo").val();
			    if(!((a=='' && b=='')||(a!='' && b!=''))){
			    	$.messager.alert('提示','请输入完整的年龄段','warning');
			    	return false;
			    }
			    if(a !='' && b != ''){
			    	if(parseInt(a) > parseInt(b)){
			    		$.messager.alert('提示','年龄段输入不正确,开始年龄不能大于结束年龄','warning');
				    	return false;
				    }
			    }
	    		
    			var c = $("#AmountConsumedFrom").val();
    			var d = $("#AmountConsumedTo").val();
    			if(!((c=='' && d=='')||(c!='' && d!=''))){
			    	$.messager.alert('提示','请输入完整的消费额度','warning');
			    	return false;
			    }
    			if(parseFloat(c) > parseFloat(d)){
		    		$.messager.alert('提示','消费额度输入不正确','warning');
			    	return false;
			    }
	    		
			    if($("#times").val() < 1){
		    		$.messager.alert('提示','积分倍数不能小于等于1','warning');
			    	return false;
			    }
			    
		    	$.ajax({
		            url:'validateRule',
		            type:'post',
		            async: false,
		            data:$("#ruleForm").serialize(),
		            success:function(data){
		            	if(data == 1){
		                	$.messager.alert('提示','规则名称已经存在','warning');
		                }else if(data==2){
		                	$.messager.alert('提示','该规则已经存在','warning');
		                }else{
		                	flag = true;
			            }
		            }
		        });
	    	}
	    	return flag;
		},
	    success:function(id){ 
		    //if(id > 0)$("#id").val(id);
           $.messager.show({  
                title:'提示',  
                msg:'保存成功!',  
                showType:'show'  
            }); 
		    if($("#id").val()==''){
		    	resets();
		    }
	    }
	});
}
function resets(){
	$('#ruleForm').form('clear');
	$("#nolimit").attr('checked','checked');
}
</script>
</head>
<body style="overflow: hidden">
	<input type="hidden" id="ruleName_" value="${rule.ruleName }"/>
	<form id="ruleForm" method="post">
		<input type="hidden" name="id" id="id" value="${rule.id }"/>
		<input type="hidden" name="createdAt" id="createdAt" value="${fn:substring(rule.createdAt,o,10) }"/>
		<input type="hidden" name="createdBy" id="createdBy" value="${rule.createdBy }"/>
		<fieldset style="font-size:12px;width:600px;">
			<legend style="color:blue">${rule==null?'新增':'修改' }消费积分规则</legend>
			<table id="ruleTable" border="0" style="width: 500px;">
				<tr>
					<td style="color:red">*</td>
					<td>规则名称</td>
					<td>
						<input value="<c:out value="${rule.ruleName }"/>" type="text" name="ruleName" id="ruleName" style="width:200px;" class="easyui-validatebox" data-options="required:true"/>
					</td>
				<tr>
					<td style="color:red">*</td>
					<td>积分倍数</td>
					<td>	
						<input value="${rule.times }" type="text" id="times" name="times" style="width:200px;" maxlength="4" class="easyui-numberbox" data-options="precision:2,required:true"/>
					</td>
				</tr>
				<tr>
					<td></td>
					<td>时间段</td>
					<td>
					    <input value="${fn:substring(rule.rangeFrom,0,10) }" name="rangeFrom" id="rangeFrom" type="text" class="easyui-datebox" editable="false"/>
						&nbsp;&nbsp;至
						<input value="${fn:substring(rule.rangeTo,0,10) }" name="rangeTo" id="rangeTo" type="text" class="easyui-datebox" editable="false"/>
					</td>
				</tr>
				<tr>
					<td></td>
					<td>年龄段</td>
					<td>
					    <input value="${rule.rangeAgeFrom }" name="rangeAgeFrom" id="rangeAgeFrom" type="text" class="easyui-numberbox" data-options="min:0" maxlength="3"/>
						岁至
						<input value="${rule.rangeAgeTo }" name="rangeAgeTo" id="rangeAgeTo" type="text" class="easyui-numberbox" data-options="min:0" maxlength="3"/>
						岁
					</td>
				</tr>
				<tr>
					<td></td>
					<td>消费额度</td>
					<td>
					    <input value="${rule.amountConsumedFrom }" name="AmountConsumedFrom" id="AmountConsumedFrom" type="text" class="easyui-numberbox" data-options="precision:2"/>
						元至
						<input value="${rule.amountConsumedTo }" name="AmountConsumedTo" id="AmountConsumedTo" type="text" class="easyui-numberbox" data-options="precision:2"/>
						元
					</td>
				</tr>	
				<tr>
					<td></td>
					<td>性别</td>
					<td>
					    <label>不限<input type="radio" id="nolimit" name="gender" value="<%=Dictionary.MEMBER_SEX_NOLIMIT %>" checked="checked" /></label>
					    &nbsp;
					    <label>男<input type="radio" name="gender" value="<%=Dictionary.MEMBER_SEX_MALE %>" ${rule.gender==male?'checked':''} /></label>
					    &nbsp;
					    <label>女<input type="radio" name="gender" value="<%=Dictionary.MEMBER_SEX_FEMALE %>" ${rule.gender==female?'checked':''}/></label>
					</td>
				</tr>
			 </table>
		</fieldset>  
	</form>
    <div style="margin-top:10px;width:600px;text-align: right">  
    	<a id="btn" href="javascript:void(0)" onclick="submits()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
    	<!-- 
        <a id="btn" href="javascript:void(0)" onclick="submit()" class="easyui-linkbutton" data-options="iconCls:'icon-add'">保存</a>
        <a id="btn" href="javascript:void(0)" onclick="addDialog()" class="easyui-linkbutton" data-options="iconCls:'icon-remove'">删除</a>
         -->
    </div>  
</body>
</html>