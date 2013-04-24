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
		if(!$('#memberForm').form('validate')) return;
		if($('#sex').combobox('getValue')==""){
    		$.messager.alert('提示','请选择性别','warning');
	        return;
	    }
		var flag = false;
		
		if($("#surname").val()=='中文姓' || $.trim($("#surname").val()) == ''){
			$.messager.alert('提示','请输入姓名','warning');return;
		}
		if($("#name").val()=='中文名' || $.trim($("#name").val()) == ''){
			$.messager.alert('提示','请输入完整名字','warning');return;
		}
		
    	$.ajax({
            url:'findMemberByPhone',
            type:'post',
            async: false,
            data:'phone='+$("#phone").val()+"&id="+$("#id").val(),
            success:function(data){
            	if(data == 1){
            		$.messager.alert('提示','手机号码已经存在','warning');
            		flag = true; 
            		$("#phone").focus();
                }
            }
	    });
		if(flag) return ;
		if($("#email").val() != ''){
    		$.ajax({
	            url:'findMemberByEmail',
	            type:'post',
	            async: false,
	            data:'email='+$("#email").val()+"&id="+$("#id").val(),
	            success:function(data){
	            	if(data == 1){
	            		$.messager.alert('提示','Email已经存在','warning');
	                	$("#email").focus();
	                	flag = true; 
	                }
	            }
	        });
    	}
		if(flag) return ;
		if($("#identityCard").val() != ''){
    		$.ajax({
	            url:'findMemberByIdentityCard',
	            type:'post',
	            async: false,
	            data:'idCard='+$("#identityCard").val()+"&id="+$("#id").val(),
	            success:function(data){
	            	if(data == 1){
	            		$.messager.alert('提示','身份证已经存在','warning');
	                	$("#identityCard").focus();
	                	flag = true;
	                }
	            }
	        });
    	}
		if(flag) return ;
		if($("#weixin").val() != ''){
    		$.ajax({
	            url:'findMemberByWeixin',
	            type:'post',
	            async: false,
	            data:'weixin='+$("#weixin").val()+"&id="+$("#id").val(),
	            success:function(data){
	            	if(data == 1){
	            		$.messager.alert('提示','微信号已经存在','warning');
	                	$("#weixin").focus();
	                	flag = true; 
	                }
	            }
	        });
    	}
		if(flag) return ;
		if($("#qq").val() != ''){
    		$.ajax({
	            url:'findMemberByQq',
	            type:'post',
	            async: false,
	            data:'qq='+$("#qq").val()+"&id="+$("#id").val(),
	            success:function(data){
	            	if(data == 1){
	                	$.messager.alert('提示','QQ号码已经存在','warning');
	                	$("#qq").focus();
	                	flag = true;
	                }
	            }
	        });
    	}
		if(flag) return ;
		if($("#cardNo").val() != ''){
			$.ajax({
	            url:'findMemberByCard',
	            type:'post',
	            async: false,
	            data:'cardNo='+$("#cardNo").val()+"&id="+$("#id").val(),
	            success:function(data){
	            	if(data == 1){
	            		$.messager.alert('提示','卡号已经存在','warning');
	            		flag = true;
	            	}
	            }
	        });
		}
		if(flag) return;
		$('#memberForm').form('submit', {
		    success:function(data){ 
		    	if(eval('('+data+')').msg==1){
		    		$.messager.show({  
	                    title:'提示',  
	                    msg:"保存成功",  
	                    showType:'show'  
	                });
		    		setTimeout(reloads,1000);
		    	}else{
		    		$.messager.show({  
	                    title:'提示',  
	                    msg:eval('('+data+')').msg,  
	                    showType:'show'  
	                });
		    	}
		    	c = false;
		    },
		    error:function(data){
		    	alert('保存失败');
			}
		});	
	}
	function reloads(){
		window.location.reload()
	}
	function resetPassword(){
		$.messager.confirm('确认框','您确定要重置密码吗?',function(r){  
			if(r){
				$.ajax({
		            url:'resetPassword',
		            type:'post',
		            data:'ids=${member.id}'+"&name=${member.surname}${member.name}",
		            success:function(data){
						$.messager.show({  
		                    title:'提示',  
		                    msg:'重置成功,密码通过短信发送!',  
		                    showType:'show'  
		                });
		            },
		            error:function(e){
		            	alert('操作失败: ' + e.status);
		            }
		        });	
			}
		});
	}

	function logout(){
		$.messager.confirm('确认框','您确定要注销吗?',function(r){  
			if(r){
				$.ajax({
		            url:'logoutMember',
		            type:'post',
		            data:'ids=${member.id}',
		            success:function(){
		            	$.messager.show({  
		                    title:'提示',  
		                    msg:'注销成功!',  
		                    showType:'show'  
		                });
						window.location.reload();
		            },
		            error:function(e){
		            	alert('操作失败: ' + e.status);
		            }
		        });	
			}
		});
	}
	
	var c = true;
	function activation(){
		if('<c:out value="${member.surname}"/>' == ''){
			if(!$('#memberForm').form('validate')){
	    		$.messager.alert('提示','请先保存完基本信息','warning');
	    		return ;
			}
			if($('#sex').combobox('getValue')==""){
	    		$.messager.alert('提示','请选择性别','warning');
		        return;
		    }
			if(c) {
	    		$.messager.alert('提示','请先保存,才能激活','warning');return ;
			}
		}
		
		$.messager.confirm('确认框','您确定要激活吗?',function(r){  
			if(r){
				 $.ajax({
			            url:'activationMember',
			            type:'post',
			            data:'ids=${member.id}&phone='+$("#phone").val()+"&name="+$("#surname").val()+$("#name").val(),
			            success:function(){
			            	$.messager.show({  
			                    title:'提示',  
			                    msg:'激活成功!',  
			                    showType:'show'  
			                });
			            	setTimeout(reloads,1000);
			            },
			            error:function(e){
			            	alert('操作失败: ' + e.status);
			            }
			        });
			}
		});
	}
	function reloads(){
		window.location.reload();
	}
	function sendActivationCode(){
		$.messager.confirm('确认框','您确定要发送验证码吗?',function(r){  
			if(r){
				$.ajax({
		            url:'sendActivationCode',
		            type:'post',
		            data:'id='+$("#id").val()+"&phone="+$("#phone").val(),
		            success:function(){
						$.messager.show({  
		                    title:'提示',  
		                    msg:'发送成功!',  
		                    showType:'show'  
		                });
		            },
		            error:function(e){
		            	alert('操作失败: ' + e.status);
		            }
		        });
			}
		});
	}
</script>
</head>
<body>
	<div id="tt" class="easyui-tabs" style="height:755px;">  
	    <div title="会员资料" style="padding:20px;">  
	        <form id="memberForm" method="post" action="updateMember">
			  <input type="hidden" name="id" id="id" value="${member.id }"/>
			  <input type="hidden" name="card.id" value="${card.id }"/>
			  <input type="hidden" name="cardNumber" value="${member.phone }"/>
			  <fieldset style="font-size:14px;">
			  	<legend style="color: blue;">基本信息</legend>
			  	<table>
			  		<tr>
			  			<td><span class="red">*</span></td>
			  			<td width="80">姓名：</td>
			  			<td width="200">
				  			<input id="surname" type='text' name='surname' value="<c:out value="${member.surname }"/>" style="width:60px" maxlength="20" class="easyui-validatebox" data-options="required:true" />
		  					-
			  				<input id="name" type='text' name='name' value='<c:out value="${member.name }"></c:out>' style="width:70px" maxlength="20" 
						class="easyui-validatebox" data-options="required:true"/>
			  			</td>
			  			<td width="80">出生日期：</td>
			  			<td>
			  				<input id="birthDay" name="birthDay" value="<c:out value="${fn:substring(member.birthDay,0,10)}" />" type="text" style="width:150px" class="easyui-datebox" editable="false"/>
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
								<option value="<%=Dictionary.MEMBER_SEX_MALE%>" ${member.sex == male ? 'selected' : '' }>男</option>
								<option value="<%=Dictionary.MEMBER_SEX_FEMALE%>" ${member.sex == female ? 'selected=selected' : '' }>女</option>
							</select>
			  			</td>
			  			<td>身份证：</td>
			  			<td>
			  				<input id="identityCard" name="identityCard" value="${member.identityCard}" class="easyui-validatebox" data-options="validType:'idcard'" type='text' />
			  			</td>
			  		</tr>
			  		<tr>
			  			<td><span class="red">*</span></td>
			  			<td>手机：</td>
			  			<td>
			  				<input id="phone" type='text' name='phone' value="${member.phone}" validType="mobile" style="width:150px" maxlength="11" 
						class="easyui-validatebox" data-options="required:true,validType:'mobile'"/>
			  			</td>
			  			<td>QQ号：</td>
			  			<td>
			  				<input id="qq" name="qq" type='text' value="<c:out value="${member.qq}"/>" class="easyui-validatebox" data-options="validType:'number'" maxlength="11"  />
			  			</td>
			  		</tr>
			  		<tr>
			  			<td></td>
			  			<td>E-mail：</td>
			  			<td>
			  				<input id="email" name="email" type='text' value="${member.email}" class="easyui-validatebox" data-options="validType:'email'"  />
			  			</td>
			  			<td>微信号：</td>
			  			<td>
			  				<input id="weixin" name="weixin" type='text' maxlength="20" value="<c:out value="${member.weixin }"/>" />
			  			</td>
			  		</tr>
			  		<tr>
			  			<td></td>
			  			<td>激活手机：</td>
			  			<td>
			  				<input type='text' id="acphone" disabled="disabled" value="${member.activePhone}"  />
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
			  				<select name="province" id="province" class="easyui-combobox" style="width:155px;" ></select>
			  			</td>
			  			<td width="80">地址：</td>
			  			<td>
			  				<input id="address" type='text' name="address" value="<c:out value="${member.address}"/>" maxlength="200" />
			  			</td>
			  		</tr>
			  		<tr>
			  			<td></td>
			  			<td>市：</td>
			  			<td>
							<select name="city" id="city" class="easyui-combobox" style="width:155px;"></select>
			  			</td>
			  			<td>邮编：</td>
			  			<td>
			  				<input id="postcode" name="postcode" value="${member.postcode}"  type='text' class="easyui-validatebox" data-options="validType:'ZIP'" />
			  			</td>
			  		</tr>
			  		<tr>
			  			<td></td>
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
			  			<td></td>
			  			<td width="80">行业：</td>
			  			<td width="200">
			  				<select name="industry" id="industry" class="easyui-combobox" style="width:155px;">
			  					<option value="" >请选择行业</option>
			  				</select>
			  			</td>
			  			<td width="80">公司名称：</td>
			  			<td>
			  				<input id="company" name="company" value="<c:out value="${member.company }"/>" type='text' maxlength="200"  />
			  			</td>
			  		</tr>
			  		<tr>
			  			<td></td>
			  			<td>职业：</td>
			  			<td>
							<select name="profession" id="profession" class="easyui-combobox" style="width:155px;">
								<option value="" >请选择职页</option>
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
			  			<td></td>
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
			  			<td width="200" colspan="5">
			  				<input type="text" id="cardNo" name="card.cardNumber" value="<c:out value="${member.card.cardNumber }"/>" class="easyui-validatebox" data-options=""/>
			  			</td>
			  		</tr>
			  	</table>
			  </fieldset>
			  <br/>
			  <fieldset style="text-align: right;border: none;">
			  	<c:if test="${member.status != member_state_logout}">
				<a id="btn" href="javascript:void(0)" onclick="doSubmit()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
				</c:if>
				<c:if test="${member.status != member_state_logout && member.status != member_state_active}">
					<a id="btn" href="javascript:void(0)" onclick="sendActivationCode()" class="easyui-linkbutton" data-options="iconCls:''">发送激活码</a>	
					<a id="btn" href="javascript:void(0)" onclick="activation()" class="easyui-linkbutton" data-options="iconCls:''">激活</a>
				</c:if>
				<c:if test="${member.status != member_state_noactive && member.status != member_state_logout}">
					<a id="btn" href="javascript:void(0)" onclick="resetPassword()" class="easyui-linkbutton" data-options="iconCls:''">重置密码</a>
				</c:if>
				<%--
				<c:if test="${member.status != member_state_noactive && member.status != member_state_logout}">
					<a id="btn" href="javascript:void(0)" onclick="logout()" class="easyui-linkbutton" data-options="iconCls:''">注销会员</a>
				</c:if>
				
				<c:if test="${member.status == member_state_logout}">
					<font color='red'>已注销</font>
				</c:if>
				 --%>
			  </fieldset>
			</form>  
	    </div>  
	    <div title="账户信息"  style="padding:20px;">  
	        <iframe frameborder="0"  src="" style="width:100%;height: 100%;" scrolling="auto" ></iframe>
	    </div>  
	    <div title="获得积分记录"  style="padding:20px;">  
	        <iframe frameborder="0"  src="" style="width:100%;height: 100%;" scrolling="auto" ></iframe>
	    </div>  
	    <div title="使用积分记录"  style="padding:20px;">  
	        <iframe frameborder="0"  src="" style="width:100%;height: 100%;" scrolling="auto" ></iframe>
	    </div>
	    <div title="失效积分记录"  style="padding:20px;">  
	        <iframe frameborder="0"  src="" style="width:100%;height: 100%;" scrolling="auto" ></iframe>
	    </div>   
	    <div title="储蓄账户充值记录"  style="padding:20px;">  
	        <iframe frameborder="0"  src="" style="width:100%;height: 100%;" scrolling="auto" ></iframe>
	    </div> 
	    <div title="储蓄账户使用记录" style="padding:20px;">  
	        <iframe frameborder="0"  src="" style="width:100%;height: 100%;" scrolling="auto" ></iframe>
	    </div> 
	    <div title="优惠码记录" style="padding:20px;">  
	        <iframe frameborder="0"  src="" style="width:100%;height: 100%;" scrolling="auto" ></iframe>
	    </div> 
	    <div title="联合会员" style="padding:20px;">
	    	<iframe frameborder="0"  src="" style="width:100%;height: 100%;" scrolling="auto" ></iframe>
	    </div> 
	    <div title="发送短信历史" style="padding:20px;">
	    	<iframe frameborder="0"  src="" style="width:100%;height: 100%;" scrolling="auto" ></iframe>
	    </div> 
	</div> 
</body>
<script type="text/javascript">
	for(var i=0;i<Constant.industry.length;i++){
		if(Constant.industry[i].id == '${member.industry}'){
			$("#industry").append("<option value="+Constant.industry[i].id+" selected='selected'>"+Constant.industry[i].text+"</option>");
		}else{
			$("#industry").append("<option value="+Constant.industry[i].id+">"+Constant.industry[i].text+"</option>");
		}
	}
	for(var i=0;i<Constant.profession.length;i++){
		if(Constant.profession[i].id == '${member.profession}'){
			$("#profession").append("<option value="+Constant.profession[i].id+" selected='selected'>"+Constant.profession[i].text+"</option>");
		}else{
			$("#profession").append("<option value="+Constant.profession[i].id+">"+Constant.profession[i].text+"</option>");
		}
	}
	for(var i=0;i<Constant.position.length;i++){
		if(Constant.position[i].id == '${member.position}'){
			$("#position").append("<option value="+Constant.position[i].id+" selected='selected'>"+Constant.position[i].text+"</option>");
		}else{
			$("#position").append("<option value="+Constant.position[i].id+">"+Constant.position[i].text+"</option>");
		}
	}
	for(var i=0;i<Constant.salary.length;i++){
		if(Constant.salary[i].id == '${member.salary}'){
			$("#salary").append("<option value="+Constant.salary[i].id+" selected='selected'>"+Constant.salary[i].text+"</option>");
		}else{
			$("#salary").append("<option value="+Constant.salary[i].id+">"+Constant.salary[i].text+"</option>");
		}
	}
	for(var i=0;i<Constant.education.length;i++){
		if(Constant.education[i].id == '${member.education}'){
			$("#education").append("<option value="+Constant.education[i].id+" selected='selected'>"+Constant.education[i].text+"</option>");
		}else{
			$("#education").append("<option value="+Constant.education[i].id+">"+Constant.education[i].text+"</option>");
		}
	}
	new PCAS("province","city","area","${member.province}","${member.city}","${member.area}");
	
	$('#tt').tabs({
		onSelect:function(title){
		  var p = $(this).tabs('getTab', title);
		  if(p.find('iframe').attr('src')==''){
			  if('账户信息' == title){
				  p.find('iframe').attr('src','accountInfo?id=${member.id }')
			  } 
			  if('获得积分记录' == title){
				  p.find('iframe').attr('src','integralGetRecord?id=${member.id }')
			  } 
			  if('使用积分记录' == title){
				  p.find('iframe').attr('src','integralUseRecord?id=${member.id }')
			  }
			  if('失效积分记录' == title){
				  p.find('iframe').attr('src','expiredIntegralGet?id=${member.id }')
			  }
			  if('储蓄账户充值记录' == title){
				  p.find('iframe').attr('src','savingsAccountGetRecord?id=${member.id }')
			  }
			  if('储蓄账户使用记录' == title){
				  p.find('iframe').attr('src','savingsAccountUseRecord?id=${member.id }')
			  }
			  if('优惠码记录' == title){
				  p.find('iframe').attr('src','discountNumberRecord?id=${member.id }')
			  }
			  if('联合会员' == title){
				  p.find('iframe').attr('src','attendBrands?id=${member.id }')
			  }
			  if('发送短信历史' == title){
				  p.find('iframe').attr('src','memberSMSOutboxHistory?id=${member.id }')
			  }
		  }
		}
	})
</script>
</html>