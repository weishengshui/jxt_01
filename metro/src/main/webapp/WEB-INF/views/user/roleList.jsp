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
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/common.js"></script>
<script>
	function addDialog(){
		$("#roleForm")[0].reset();
		$("#roleAdd").dialog({
			modal:true,
			title:'添加角色'
		});
	}
	function submitrole(){
		if(!$('#roleForm').form('validate')){return false;}
    	if(findRoleByName($("#name").val())){
    		$.messager.alert('提示','角色已经存在','warning');
    		return;
		};
		$.ajax({
            url:'saveRole',
            type:'post',
            data:$("#roleForm").serialize(),
            success:function(data){
            	$.messager.show({  
                    title:'提示',  
                    msg:'保存成功!',  
                    showType:'show'  
                });
                $('.easyui-datagrid').datagrid('reload');
		    	$("#roleForm")[0].reset();
				$("#roleAdd").dialog('close');
				$("#id").val('');
            },error:function(data){
                alert('保存失败');
            }
        });
		
	}
	function findRoleByName(roleName){
		var rs = '';
		$.ajax({
			url:'findRoleByName',
			async: false,
			type :'post',
			data:'roleName='+roleName+"&id="+$("#id").val(),
			success:function(data){
				rs = data;
			}
		});
		return rs == 'suc';
	}
	function edits(v,r,i){
		var name = r.name.replaceAll("'" , "&#39;");
		name = encodeURIComponent(name); 
		return '<a href="javascript:void(0)" onclick="edit(\''+v+'\',\''+name+'\',\''+r.desc+'\')">修改</a>&nbsp;&nbsp;'+
			   '<a href="javascript:void(0)" onclick="addAuthority(\''+v+'\',\''+name+'\',\''+r.desc+'\')">添加权限</a>';
    }
	function edit(id_,name_,desc_){
		//name = decodeURIComponent(name);
		//name = name.replaceAll("&#39;" , "'");
		var id = id_;
		var name = name_;
		var desc = desc_;
		if(id == undefined){
			var row = $('#role_table').datagrid('getSelected');
			if(row == null){
				$.messager.alert('提示','请选择要修改的数据','warning');return;
			}
			id = row.id;
			name = row.name;
			desc = row.desc;
		}
		$("#id").val(id);
		$("#name").val(name);
		$("#desc").val(desc);
		$("#roleAdd").dialog({
			modal:true,
			title:'修改角色'
		});
	}
	function searchs(){
    	$('#role_table').datagrid('load',getForms("searchForm"));
    }
   	function del(){
		var rows = $('#role_table').datagrid('getSelections');//getSelected选一个
		if(rows == '' ){$.messager.alert('提示','请选择要删除的数据','warning');return;}
		$.messager.confirm('确认框','确定删除选中角色吗 ?',function(r){
			if(r){
				var s = '',n=''; 
				for(var i=0; i<rows.length; i++){
		            if (s != '') s += ',',n+=',';  
		            s += rows[i].id;
		            n+=rows[i].name;
		        }
				$.ajax({
		            url:'deleteRole',
		            type:'post',
		            data:'ids='+s+"&names="+encodeURI(n),
		            success:function(data){
		            	if(data == 0){
		            		$.messager.show({  
		                        title:'提示',  
		                        msg:'删除成功!',  
		                        showType:'show'  
		                    });
							$("#role_table").datagrid('reload');
		            	}else{
		            		$.messager.alert('提示','角色已被使用,不能删除','warning');
		            	}
		            }
		        });
			}
		});
	}
   	function addAuth(){
   		var row = $('#role_table').datagrid('getSelected');
		if(row == null){
			$.messager.alert('提示','请选择要操作的数据','warning');return;
		}
   		parent.addTab(row.name+"—权限","user/roleAuthority?id="+row.id+"&name="+row.name);
   	}
</script>
</head>
<body>
	<!-- 查询条件Table -->
	<form id="searchForm" onsubmit="return false;">
		<table style="font-size:13px;">
			<tr>
				<td>角色名称:</td>
				<td><input type="text" name="name" size="18"/></td>
				<td>&nbsp;<a id="btn" href="javascript:void(0)" onclick="searchs()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a></td>
			</tr>
		</table>
	</form>

	<div id="toolbar">  
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addDialog()">添加角色</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="edit()">修改</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" plain="true" onclick="addAuth()">添加权限</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="del()">删除</a>
          
    </div> 
    
	<!-- 显示列表Table -->
	<table id="role_table" class="easyui-datagrid" data-options="url:'findRoles',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,toolbar: '#toolbar',
		rownumbers:false,pageList:pageList,singleSelect:false,onDblClickRow:function(rowIndex,rowData){edit(rowData.id,rowData.name,rowData.desc);}">
	    <thead>  
	        <tr>
	            <th data-options="field:'name',width:100">角色</th>  
	            <th data-options="field:'desc',width:100">描述</th>
	            <th data-options="field:'id',hidden:true">id</th>
	        </tr>  
	    </thead>  
	</table> 
	
	<!-- 添加窗口 -->
	<div style="display: none;">
		<div id="roleAdd" style="width:300px;height:220px;padding:15px;">
			<form id="roleForm" method="post">
			  <input type="hidden" name="id" id="id" />
			  <table border="0">
				<tr>
					<td width="50"><label for="name">角色</label></td>
					<td>
						<input id="name" type='text' name='name' style="width:150px" maxlength="20" 
						class="easyui-validatebox" data-options="required:true"/>
					</td>
				</tr>
				<tr>
					<td>描述</td>
					<td>
						<textarea rows="3" cols="18" style="font-size:13px;" name="desc" id="desc"></textarea>
					</td>
				</tr>
				<tr>
					<td></td>
					<td height="50" align="center">
						<a id="btn" href="javascript:void(0)" onclick="submitrole()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>  
						<a id="btn" href="javascript:void(0)" onclick="$('#roleAdd').dialog('close')" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'">取消</a>  
					</td>
				</tr>
			  </table>
			</form>
		</div>
	<div>
</body>
</html>