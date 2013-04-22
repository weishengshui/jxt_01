<%@page import="com.chinarewards.metro.core.common.Dictionary"%>
<%@ page language="java" contentType="text/html; charset=utf8" pageEncoding="utf8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"><%--"http://www.w3.org/TR/html4/loose.dtd" --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
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
	fieldset{margin-bottom:10px;margin:0px;width:600px;}
	select{width:155px;height:20px;}
	.red{color:red;font-size:12px;}
	.gray{color:gray}
</style>
<script type="text/javascript">
	function submits(){
	 	var flag = false;
    	if($('#memberForm').form('validate')){
    		if($("#surname").val()=='中文姓' || $.trim($("#surname").val()) == ''){
    			$.messager.alert('提示','请输入姓名','warning');return;
    		}
    		if($("#name").val()=='中文名' || $.trim($("#name").val()) == ''){
    			$.messager.alert('提示','请输入完整名字','warning');return;
    		}
    		if($('#sex').combobox('getValue')==""){
        		$.messager.alert('提示','请选择性别','warning');
		        return false;
		    }
    		
	    	$.ajax({
	            url:'findMemberByPhone',
	            type:'post',
	            async: false,
	            data:'phone='+$("#phone").val(),
	            success:function(data){
	            	if(data == 1){
	                	$.messager.alert('提示','手机号码已经存在','warning');
	                	$("#phone").focus();
	                }else if(data==0){
	                	flag = true; 
	                }
	            }
	        });
	    	if(!flag){return;}
	    	if($("#email").val() != ''){
	    		$.ajax({
		            url:'findMemberByEmail',
		            type:'post',
		            async: false,
		            data:'email='+$("#email").val(),
		            success:function(data){
		            	if(data == 1){
		            		$.messager.alert('提示','Email已经存在','warning');
		                	$("#email").focus();
		                	flag = false; 
		                }else if(data==0){
		                	flag = true; 
		                }
		            }
		        });
	    	}
	    	if(!flag){return;}
	    	if($("#identityCard").val() != ''){
	    		$.ajax({
		            url:'findMemberByIdentityCard',
		            type:'post',
		            async: false,
		            data:'idCard='+$("#identityCard").val(),
		            success:function(data){
		            	if(data == 1){
		            		$.messager.alert('提示','身份证已经存在','warning');
		                	$("#identityCard").focus();
		                	flag = false;
		                }else if(data==0){
		                	flag = true; 
		                }
		            }
		        });
	    	}
	    	if(!flag){return;}
	    	if($("#weixin").val() != ''){
	    		$.ajax({
		            url:'findMemberByWeixin',
		            type:'post',
		            async: false,
		            data:'weixin='+$("#weixin").val(),
		            success:function(data){
		            	if(data == 1){
		            		$.messager.alert('提示','微信号已经存在','warning');
		                	$("#weixin").focus();
		                	flag = false;
		                }else if(data==0){
		                	flag = true; 
		                }
		            }
		        });
	    	}
	    	if(!flag){return;}
	    	if($("#qq").val() != ''){
	    		$.ajax({
		            url:'findMemberByQq',
		            type:'post',
		            async: false,
		            data:'qq='+$("#qq").val(),
		            success:function(data){
		            	if(data == 1){
		                	$.messager.alert('提示','QQ号码已经存在','warning');
		                	$("#qq").focus();
		                	flag = false;
		                }else if(data==0){
		                	flag = true; 
		                }
		            }
		        });
	    	}
	    	if(!flag){return;}
	    	if($("#cardNo").val() != ''){
	    		$.ajax({
		            url:'findMemberByCard',
		            type:'post',
		            async: false,
		            data:'cardNo='+$("#cardNo").val(),
		            success:function(data){
		            	if(data != 0){
		            		$.messager.alert('提示','卡号已经存在','warning');
		            		$("#cardNo").focus();
		            		flag = false;
		            	}else{
		            		flag = true;
		            	}
		            }
		        });
	    	}
    	}
    	
    	if(flag){
    		$.ajax({
	            url:'saveMember',
	            type:'post',
	            data:$("#memberForm").serialize(),
	            success:function(data){
            		$.messager.show({  
                        title:'提示',  
                        msg:'保存成功',  
                        showType:'show'  
                    });
			    	redo();
	            },
	            error:function(data){
		            alert('保存失败');
		        }
	        });
	    }
	}
	function redo(){
		//$('#memberForm').form('clear');
		memberForm.reset();
	}
	function checkName(v){
		if(v=='surname'){
			if($("#surname").val()=='中文姓'){
				$("#surname").val('');
				$("#surname").removeClass('gray');
			}
		}else{
			if($("#name").val()=='中文名'){
				$("#name").val('');
				$("#name").removeClass('gray');
			}
		}
	}
	function blueName(v){
		if(v=='surname'){
			if($("#surname").val()=='' || $("#surname").val()=='中文姓'){
				$("#surname").val('中文姓');
				$("#surname").addClass('gray');
			}
		}else{
			if($("#name").val()=='' || $("#name").val()=='中文名'){
				$("#name").val('中文名');
				$("#name").addClass('gray');
			}
		}
	}
</script>
</head>
<body>
	<form id="memberForm" name="memberForm" method="post">
	  <input type="hidden" name="id" id="id" />
	  <input type="hidden" name="card.id" />
	  <fieldset style="font-size:14px;">
	  	<legend style="color: blue;">基本信息</legend>
	  	<table>
	  		<tr>
	  			<td><span class="red">*</span></td>
	  			<td width="80">姓名：</td>
	  			<td width="200">
	  				<input value="中文姓" onfocus="checkName('surname')" onblur="blueName('surname')" class="gray" id="surname" type='text' name='surname' style="width:60px" maxlength="20" class="easyui-validatebox" data-options="required:true" />
	  				-
	  				<input value="中文名" onfocus="checkName()" onblur="blueName()" class="gray" id="name" type='text' name='name' style="width:70px" maxlength="20" 
				class="easyui-validatebox" data-options="required:true"/>
	  			</td>
	  			<td width="80">出生日期：</td>
	  			<td>
	  				<input id="birthDay" name="birthDay" type="text" style="width:150px" class="easyui-datebox" editable="false"/>
	  				<!-- 验证  
	  				<input name="s2" class="easyui-datebox" required="true" validType="TimeCheck['s1']" invalidMessage="s1必须大于s2" editable="false"></input>
					<input name="s3" class="easyui-datebox" required="true" validType="TimeCheck['s2']" editable="false"></input>
					-->  
	  			</td>
	  		</tr>
	  		<tr>
	  			<td><span class="red">*</span></td>
	  			<td>性别：</td>
	  			<td>
					<select name="sex" id="sex" class="easyui-combobox" style="width:155px;">
						<option value="">请选择</option>
						<option value="<%=Dictionary.MEMBER_SEX_MALE%>">男</option>
						<option value="<%=Dictionary.MEMBER_SEX_FEMALE%>">女</option>
					</select>
	  			</td>
	  			<td>身份证：</td>
	  			<td>
	  				<input id="identityCard" name="identityCard" class="easyui-validatebox" data-options="validType:'idcard'" type='text' />
	  			</td>
	  		</tr>
	  		<tr>
	  			<td><span class="red">*</span></td>
	  			<td>手机：</td>
	  			<td>
	  				<input id="phone" type='text' name='phone' validType="mobile" style="width:150px" maxlength="11" 
				class="easyui-validatebox" data-options="required:true,validType:'mobile'"/>
	  			</td>
	  			<td>QQ号：</td>
	  			<td>
	  				<input id="qq" name="qq" type='text' class="easyui-validatebox" data-options="validType:'number'" maxlength="11"  />
	  			</td>
	  		</tr>
	  		<tr>
	  			<td></td>
	  			<td>E-mail：</td>
	  			<td>
	  				<input id="email" name="email" type='text' class="easyui-validatebox" data-options="validType:'email'"  />
	  			</td>
	  			<td>微信号：</td>
	  			<td>
	  				<input id="weixin" name="weixin" type='text' maxlength="20" />
	  			</td>
	  		</tr>
	  	</table>
	  </fieldset>
	  <br/>
	  <fieldset style="font-size:14px;">
	  	<legend style="color: blue;">地址信息</legend>
	  	<table>
	  		<tr>
	  			<td>&nbsp;</td>
	  			<td width="80">省：</td>
	  			<td width="200">
	  				<select name="province" id="province" class="easyui-combobox" style="width:155px;"></select>
	  			</td>
	  			<td width="80">地址：</td>
	  			<td>
	  				<input id="address" type='text' name="address" maxlength="200" />
	  			</td>
	  		</tr>
	  		<tr>
	  			<td>&nbsp;</td>
	  			<td>市：</td>
	  			<td>
					<select name="city" id="city" class="easyui-combobox" style="width:155px;"></select>
	  			</td>
	  			<td>邮编：</td>
	  			<td>
	  				<input id="postcode" name="postcode" type='text' class="easyui-validatebox" data-options="validType:'ZIP'" />
	  			</td>
	  		</tr>
	  		<tr>
	  			<td>&nbsp;</td>
	  			<td>区：</td>
	  			<td colspan="3">
					<select name="area" id="area" class="easyui-combobox" style="width:155px;"></select>		
	  			</td>
	  		</tr>
	  	</table>
	  </fieldset>
	  <br/>
	  <fieldset style="font-size:14px;">
	  	<legend style="color: blue;">职业信息</legend>
	  	<table>
	  		<tr>
	  			<td>&nbsp;</td>
	  			<td width="80">行业：</td>
	  			<td width="200">
	  				<select name="industry" id="industry" class="easyui-combobox" style="width:155px;">
	  					<option value="">请选择行业</option>
	  				</select>
	  			</td>
	  			<td width="80">公司名称：</td>
	  			<td>
	  				<input id="company" name="company" type='text' maxlength="200"  />
	  			</td>
	  		</tr>
	  		<tr>
	  			<td>&nbsp;</td>
	  			<td>职业：</td>
	  			<td>
					<select name="profession" id="profession" class="easyui-combobox" style="width:155px;">
						<option value="">请选择职业</option>
					</select>
	  			</td>
	  			<td>职位：</td>
	  			<td>
	  				<select name="position" id="position" class="easyui-combobox" style="width:155px;">
	  					<option value="" >请选择职位</option>
	  				</select>
	  			</td>
	  		</tr>
	  		<tr>
	  			<td>&nbsp;</td>
	  			<td>年薪：</td>
	  			<td>
	  				<select name="salary" id="salary" class="easyui-combobox" style="width:155px;">
	  					<option value="" >请选择年薪</option>
	  				</select>
	  			</td>
	  			<td>学历：</td>
	  			<td>
	  				<select name="education" id="education" class="easyui-combobox" style="width:155px;">
	  					<option value="" >请选择学历</option>
	  				</select>
	  			</td>
	  		</tr>
	  	</table>
	  </fieldset>
	  <br/>
	  <fieldset style="font-size:14px;">
	  	<legend style="color: blue;">会员绑定</legend>
	  	<table>
	  		<tr>
	  			<td><span class="red"></span></td>
	  			<td width="80">卡号绑定：</td>
	  			<td width="200">
	  				<input type="text" id="cardNo" name="card.cardNumber" class="easyui-validatebox" data-options=""/>
	  			</td>
	  			<td colspan="2">
	  				<label><input id="valiCode" name="valiCode" type='checkbox' checked="checked" />&nbsp;发送激活码</label>
	  			</td>
	  		</tr>
	  	</table>
	  </fieldset>
	  <br/>
	  <fieldset style="text-align: right;border: none;">
		<a id="btn" href="javascript:void(0)" onclick="redo()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a>
		<a id="btn" href="javascript:void(0)" onclick="submits()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
	  </fieldset>
	</form>
</body>
<script type="text/javascript">
	for(var i=0;i<Constant.industry.length;i++){
		$("#industry").append("<option value="+Constant.industry[i].id+">"+Constant.industry[i].text+"</option>");
	}
	for(var i=0;i<Constant.profession.length;i++){
		$("#profession").append("<option value="+Constant.profession[i].id+">"+Constant.profession[i].text+"</option>");
	}
	for(var i=0;i<Constant.position.length;i++){
		$("#position").append("<option value="+Constant.position[i].id+">"+Constant.position[i].text+"</option>");
	}
	for(var i=0;i<Constant.salary.length;i++){
		$("#salary").append("<option value="+Constant.salary[i].id+">"+Constant.salary[i].text+"</option>");
	}
	for(var i=0;i<Constant.education.length;i++){
		$("#education").append("<option value="+Constant.education[i].id+">"+Constant.education[i].text+"</option>");
	}
	new PCAS("province","city","area","","","");
	$("#birthDay").attr("readonly","readonly");
</script>
</html>