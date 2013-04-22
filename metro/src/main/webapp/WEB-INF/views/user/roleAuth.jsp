<%@ page language="java" contentType="text/html; charset=utf8" pageEncoding="utf8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
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
	function save(){
		var nodes = $('#tt').tree('getChecked');
		var nodes_indeterminate = $('#tt').tree('getChecked', 'indeterminate');
		var s = ''; 
        for(var i=0; i<nodes.length; i++){
            if(nodes[i].id == undefined || nodes[i].id == '')  continue;
            if (s != '') s += ',';  
            s += nodes[i].id;
        }
        
        for(var i=0; i<nodes_indeterminate.length; i++){
            if(nodes_indeterminate[i].id == undefined || nodes_indeterminate[i].id == '')  continue;
            if (s != '') s += ',';  
            s += nodes_indeterminate[i].id;
        }
        if(s == ''){
        	$.messager.alert('提示','请选择','warning');return;
        }
        var roleName = "${role.name }";
        $.ajax({
            url:'saveRoleAuthority',
            type:'post',
            data:'roleId=${role.id }&resourceIds='+s+'&old='+$("#oldId").val()+"&name="+encodeURI(roleName),
            success:function(newResourceIds){
            	$.messager.show({  
                    title:'提示',  
                    msg:'保存成功!',  
                    showType:'show'  
                });
				$("#oldId").val(newResourceIds);
            }
        });
	}
	function expandAll(){
		$(".easyui-tree").tree("expandAll");
	}
	function collapseAll(){
		$(".easyui-tree").tree("collapseAll");
	}
	
	function selectAll(){
		var nodes = $('#tt').tree('getChecked', 'unchecked');	// get unchecked nodes
		for(var i=0; i<nodes.length; i++){
			var node = $('#tt').tree('find',nodes[i].id);
            $('.easyui-tree').tree('check',node.target);  
		}
	}
	
	function unSelectAll(){
		var nodes = $('#tt').tree('getChecked')
		var nodes1 = $('#tt').tree('getChecked','unchecked')
		for(var i=0; i<nodes.length; i++){
			var node = $('#tt').tree('find',nodes[i].id);
            $('.easyui-tree').tree('uncheck',node.target);  
		}
		for(var i=0; i<nodes1.length; i++){
			var node = $('#tt').tree('find',nodes1[i].id);
            $('.easyui-tree').tree('check',node.target);  
		}
	}
	
	
</script>
</head>
<body>
    <div id="tt" class="easyui-panel" title="${role.name }角色权限" style="height:auto">
    	<input type="hidden" id="oldId" value="${old }"/>
    	<br/><br/>&nbsp;
    	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-redo" plain="true" onclick="expandAll()">展开</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-undo" plain="true" onclick="collapseAll()">折叠</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" plain="true" onclick="selectAll()">全选</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-reload" plain="true" onclick="unSelectAll()">反选</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save" plain="true" onclick="save()">保存</a>
    	<br/><br/>
        <ul class="easyui-tree" data-options="url:'findResources?roleId=${role.id }',animate:true,checkbox:true"></ul>    
	    <br/><br/>
    </div>
</body>
</html>