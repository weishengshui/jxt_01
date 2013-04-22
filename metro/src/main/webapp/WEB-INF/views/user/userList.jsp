<%@page import="com.chinarewards.metro.core.common.Dictionary"%>
<%@ page language="java" contentType="text/html; charset=utf8" pageEncoding="utf8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link id="easyuiTheme" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/common.js"></script>
<script>
	var reg = /^(-|\+)?\d+$/ ;
	function addDialog(){
		$("#userForm")[0].reset();
		loadRole();
		$("#userAdd").dialog({
			modal:true,
			title:'添加用户'
		});
	}
	
	function loadRole(){
		$('#cc').combogrid({
			panelWidth: 200,  
            multiple: true,  
            idField: 'id',  
            textField: 'name',  
            url: 'findRoles?desc=user',  
            columns: [[  
                {field:'ck',checkbox:true},  
                {field:'id',hidden:true}, 
                {field:'name',title:'角色',width:60},  
                {field:'desc',title:'描述',width:80,align:'center'}
            ]],
            fitColumns: true  
		});
		$('#cc').combogrid('clear');
	}
	
	function submituser(){
		var cc= $('#cc').combogrid('getValues');
		var roles = '';
		if(cc != ''){
			for(var i=0;i<cc.length;i++){
				if(roles != '') roles += ',';
				if(reg.test(cc[i])){
					roles += cc[i];
				}else{
					roles='';break;
				}
			}
		}
		$("#roleIds").val(roles);
		if(!$('#userForm').form('validate')){return false;}
    	if($("#password").val()!=$("#repassword").val()){
    		$.messager.alert('提示','两次密码不一致','warning');
			return;	
		}
    	if(findUserByName($("#userName").val())){
    		$.messager.alert('提示','用户名已经存在','warning');
    		return;
		};
		$.ajax({
            url:'save',
            type:'post',
            data:$("#userForm").serialize(),
            async: false,
            success:function(data){
            	$.messager.show({  
                    title:'提示',  
                    msg:'保存成功!',  
                    showType:'show'  
                });
            	$('.easyui-datagrid').datagrid('reload');
		    	$("#userForm")[0].reset();
				$("#userAdd").dialog('close');
            },error:function(data){
                alert('保存失败');
            }
        });
	}
	function findUserByName(userName){
		var rs = '';
		$.ajax({
			async:false,
			url:'findUserByName',
			type :'post',
			data:'userName='+userName,
			success:function(data){
				rs = data;
			}
		});
		return rs == 'suc';
	}
	
	function lock(c,disable){
		var rows = $('#user_table').datagrid('getSelections');
		if(rows==''){$.messager.alert('提示','请选择要操作的数据');return;}
		$.messager.confirm('确认框','确定要'+c+'选中用户吗 ?',function(r){  
		    if (r){
		    	var s = '',n=''; 
				for(var i=0; i<rows.length; i++){
		            if (s != '') s += ',';  
		            s += rows[i].id;
		            n += rows[i].userName;
		            if(rows[i].userName == 'admin'){
	    				$.messager.alert('警告','不能操作管理员帐号','warning');return;	
	    			}
		        }
		    	$.ajax({
		        	url:'lockUser',
		        	type:'post',
		        	dataType:'json',
		        	data:"ids="+s+"&disable="+disable+"&names="+encodeURI(n),
		        	success:function(data){
		        		$.messager.show({  
		                    title:'提示',  
		                    msg:'操作成功!',  
		                    showType:'show'  
		                });
		        		$('.easyui-datagrid').datagrid('reload');
		        	}
				});
		    }  
		});
	}
	var ids = '',n='';
	function editPassword(userName,id){
		var rows = $('#user_table').datagrid('getSelections');
		if(rows==''){$.messager.alert('提示','请选择要操作的数据');return;}
    	var s = '';
		for(var i=0; i<rows.length; i++){
            if (s != '') s += ',';  
	        s += rows[i].id;
	        n += rows[i].userName;
	        /*if(rows[i].userName == 'admin'){
	        	$.messager.alert('警告','不能操作管理员帐号','warning');return;
	        } */
	    }
		ids = s;
		showPwd();	
	}
	function searchs(){
    	$('#user_table').datagrid('load',getForms("searchForm"));
    }

	function addRole(){
		var rows = $('#user_table').datagrid('getSelected');
		if(rows==null){$.messager.alert('提示','请选择要操作的数据');return;}
   		$("#roleUser_table").datagrid('uncheckAll');
   	   	$("#userId").val(rows.id);
   	 	$("#userName_").val(rows.userName);
		$("#roleAdd").dialog({
			modal:true,
			title:'给用户添加角色',
			height:330
		});
		checked();
   	} 
	function checked(){
   		$.ajax({
            url:'findUserRole',
            type:'post',
            data:"userId="+$("#userId").val(),
            success:function(data){
               	if(data.length > 0){
               		var rows = $("#roleUser_table").datagrid('getRows');
            	 	for(var i=0;i<rows.length;i++){
                	 	for(var n=0;n<data.length;n++){
                 	 		if(rows[i].id == data[n]){
          						$("#roleUser_table").datagrid('selectRow',i);
          						break;
          					}
                        }
               	 	}
                }
            }
        });
   	}
	function saveUserRole(){
   		var rows  = $("#roleUser_table").datagrid('getSelections');
   		var roleIds = '',rname='';
        for(var i=0;i<rows.length;i++){
			if(roleIds!='') roleIds+=',';
			roleIds += rows[i].id;	
			rname += rows[i].name;
        }
        $.ajax({
            url:'saveUserRole',
            type:'post',
            data:'roleIds='+roleIds+"&userId="+$("#userId").val()+"&rname="+encodeURI(rname)+"&uname="+encodeURI($("#userName_").val()),
            success:function(){
                $("#user_table").datagrid('reload');
                $('#roleAdd').dialog('close');
                $.messager.show({  
                    title:'提示',  
                    msg:'保存成功!',  
                    showType:'show'  
                });
            }
        });
   	}
	function del(){
		var rows = $('#user_table').datagrid('getSelections');
		if(rows==''){$.messager.alert('提示','请选择要操作的数据');return;}
		$.messager.confirm('确认框','确定删除选中用户吗 ?',function(r){
			 if (r){
				var s = '',n=''; 
				for(var i=0; i<rows.length; i++){
		            if (s != ''){ s += ',',n+=",";}  
		            s += rows[i].id;
		            n += rows[i].userName;
		            if(rows[i].userName == 'admin'){
	    				$.messager.alert('警告','不能操作管理员帐号','warning');return;	
	    			}
		        }
				$.ajax({
		            url:'deleteUser',
		            type:'post',
		            data:'ids='+s+"&names="+encodeURI(n),
		            success:function(){
		            	$.messager.show({  
		                    title:'提示',  
		                    msg:'删除成功!',  
		                    showType:'show'  
		                });
						$("#user_table").datagrid('reload');
		            }
		        });
			}
		});
	}
	
	function showPwd(){
		$("#newpwd").val('');
		$("#repwd").val('');
		$("#pdiv").dialog({
			modal:true,
			title:'修改密码'
		});
	}
	function updatePwd(){
		if($("#newpwd").val() =='' || $("#repwd").val()==''){
			$.messager.alert("提示","不能为空","warning");
			return ;	
		}
		if($("#newpwd").val() != $("#repwd").val()){
			$.messager.alert("提示","两次密码不一致","warning");
			$("#newpwd").focus();
			return ;
		}

		$.ajax({
			url:'updatePwds',
			data:'ids='+ids+"&newpwd="+$("#newpwd").val()+"&names="+n,
			type:'post',
			success:function(data){
				$("#pdiv").dialog('close');
	    		$.messager.alert('提示','修改成功','info');
			}
		});
	}
</script>
</head>
<body>
	<!-- 查询条件Table -->
	<form id="searchForm" onsubmit="return false">
		<table style="font-size:13px;">
			<tr>
				<td>用户名:</td>
				<td><input type="text" name="userName" size="18"/></td>
				<td>&nbsp;<a id="btn" href="javascript:void(0)" onclick="searchs()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a></td>
			</tr>
		</table>
	</form>

	<div id="toolbar">  
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addDialog()">添加用户</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-redo" plain="true" onclick="editPassword()">修改密码</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" plain="true" onclick="lock('启用','<%=Dictionary.USER_STATE_NORMAL%>')">启用用户</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-no" plain="true" onclick="lock('锁定','<%=Dictionary.USER_STATE_LOCKED%>')">锁定用户</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="addRole()">添加角色</a>  
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="del()">删除</a>  
    </div> 
	<!-- 显示列表Table -->
	<table id="user_table" class="easyui-datagrid" data-options="url:'findUserInfos',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,toolbar: '#toolbar',
		rownumbers:false,pageList:pageList,singleSelect:false">  
	    <thead>  
	        <tr>
	            <th data-options="field:'userName',width:100">用户名</th>  
	            <th data-options="field:'disable',width:100,formatter:function(v){return v == '<%=Dictionary.USER_STATE_NORMAL %>' ? '启用' : '锁定';}">启用/锁定</th>
	            <th data-options="field:'userRole',width:100">用户角色</th>
	        </tr>  
	    </thead>  
	</table> 
	
	<!-- 添加窗口 -->
	<div style="display: none;">
		<div id="userAdd" style="width:300px;height:240px;padding:15px;">
			<form id="userForm" method="post">
			  <input type="hidden" name="id" id="id" />
			  <input type="hidden" name="roleIds" id="roleIds" />
			  <table border="0">
				<tr>
					<td width="50"><label for="name">用户名</label></td>
					<td>
						<input id="userName" type='text' name='userName' style="width:150px" value="${user.name }" maxlength="20" 
						class="easyui-validatebox" data-options="required:true"/>
					</td>
				</tr>
				<tr>
					<td>密码</td>
					<td>
						<input type='password' name='password' id="password" style="width:150px" value="${user.name }" maxlength="20" 
						class="easyui-validatebox" data-options="required:true"/>
					</td>
				</tr>
				<tr>
					<td>重复密码</td>
					<td>
						<input type='password' id="repassword" style="width:150px" value="${user.name }" maxlength="20" 
						class="easyui-validatebox" data-options="required:true"/>
					</td>
				</tr>
				<tr>
					<td>选择角色</td>
					<td>
						<select id="cc" style="width:155px">  
					    </select>  
					</td>
				</tr>
				<tr>
					<td></td>
					<td height="50" align="center">
						<a id="btn" href="javascript:void(0)" onclick="submituser()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>  
						<a id="btn" href="javascript:void(0)" onclick="$('#userAdd').dialog('close')" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'">取消</a>  
					</td>
				</tr>
			  </table>
			</form>
		</div>
	<div>
	
	<!-- 修改密码 -->
	<div style="display: none;">
		<div id="pdiv" style="width:280px;height: 180px;">
			<table style="padding:20px;">
				<tr>
					<td>密码</td>
					<td><input type="password" id="newpwd" /></td>
				</tr>
				<tr>
					<td>确认密码</td>
					<td><input type="password" id="repwd" /></td>
				</tr>
				<tr>
					<td colspan="2" align="right">
						<a id="btn" href="javascript:void(0)" onclick="updatePwd()" class="easyui-linkbutton">修改</a>
						<a id="btn" href="javascript:void(0)" onclick="$('#pdiv').dialog('close')" class="easyui-linkbutton">取消</a>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<!-- 添加角色 -->
	<div style="display: none;">
		<div id="roleAdd" style="width:500px;height:320px;padding:15px;">
			<input type="hidden" id="userId" />
			<input type="hidden" id="userName_" />
			<a id="btn" href="javascript:void(0)" onclick="saveUserRole()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
			<a id="btn" href="javascript:void(0)" onclick="$('#roleAdd').dialog('close')" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'">取消</a>
			<br/><br/>
			<table id="roleUser_table" class="easyui-datagrid" data-options="url:'findRoles',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
				rownumbers:false,pageList:pageList,height:220">  
			    <thead>  
			        <tr>
			        	<th data-options="field:'id',checkbox:true"></th>
			            <th data-options="field:'name',width:100">角色</th>  
			            <th data-options="field:'desc',width:100">描述</th>
			        </tr>  
			    </thead>  
			</table> 
		</div>
	<div>
</body>
</html>