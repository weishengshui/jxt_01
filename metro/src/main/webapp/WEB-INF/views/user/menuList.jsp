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
	var id_ = 0;
	function showUrl(v,o,i){
		return v.url;
	}
	function updateSeq(v,o,i){
		return '<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="showEdit(\''+o.id+'\',\''+o.seq+'\',\''+o.text+'\')">'+
			   '<img style="border:0" src="<%=request.getContextPath()%>/js/jquery/themes/icons/pencil.png" title="修改排序" />'+
			   '</a>';
	}
	function showEdit(id,seq,name){
		id_ = id;
		$("#ss").numberspinner('setValue', seq); 
		$("#seq").dialog({
			height:120,
			width:300,
			modal:true,
			resizable:true,
			title:name+" 排序编号"
		});
	}
	function expandAll(){
		$(".easyui-treegrid").treegrid("expandAll");
	}
	function collapseAll(){
		$(".easyui-treegrid").treegrid("collapseAll");
	}
	function reload(){
		$(".easyui-treegrid").treegrid("reload");
	}
	function saveSeq(){
	 	$.ajax({
            url:'updateMenuSeq',
            type:'post',
            data:'id='+id_+'&seq='+$("#ss").numberspinner('getValue'),
            success:function(newResourceIds){
            	$("#seq").dialog('close');
    			$.messager.show({  
                    title:'提示',  
                    msg:'保存成功!',  
                    showType:'show'  
                });
				reload();
            }
        });
	}
</script>
</head>
<body>
	<div id="toolbar">  
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-redo" plain="true" onclick="expandAll()">展开</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-undo" plain="true" onclick="collapseAll()">折叠</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-reload" plain="true" onclick="reload()">刷新</a>
    </div> 
	<!-- 显示列表Table -->
	<table id="tt" class="easyui-treegrid" data-options="url:'findMenus',idField:'id',treeField:'text',fitColumns:true">  
    	<thead> 
        	<tr>  
	            <th data-options="field:'text',width:180">菜单名称</th>
	            <th data-options="field:'attributes',width:180,formatter:function(v,o,i){return showUrl(v,o,i) }">路径</th>  
	            <th data-options="field:'seq',width:180">排序</th>
	            <th data-options="field:'op',align:'center',width:30,formatter:function(v,o,i){return updateSeq(v,o,i) }">修改排序</th>    
	        </tr>  
	    </thead>
	</table>  
	
	<div style="display: none;">
		<div id="seq" style="padding: 10px;">
			<table>
				<tr>
					<td>排序号:</td>
					<td>
						<input id="ss" class="easyui-numberspinner" style="width:120px;" required="required" data-options="min:0,max:1000" />	
						&nbsp;&nbsp;
						<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save" plain="true" onclick="saveSeq()">保存</a>
					</td>
				</tr>
			</table>
		</div>
	</div>
</body>
</html>