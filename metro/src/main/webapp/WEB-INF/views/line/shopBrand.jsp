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
<script type="text/javascript" src="<%=request.getContextPath()%>/js/map.js"></script>
<style type="text/css">
	fieldset{margin-bottom:10px;margin:0px;width:500px;}
	.red{color:red;font-size:12px;}
	textarea{font-size:13px;}
</style>
<script type="text/javascript">
	var deleted = "",v = true;
	var map = new Map();
	function addDialog(){
		$("#site").dialog({
			height:340,
			width:500,
			modal:true,
			resizable:true,
			title:"选择品牌"
		});
	}
	function selectSite(){
		var rows = $('#table').datagrid('getSelections');//getSelected选一个
		for(var i=0; i<rows.length; i++){
			append(rows[i].id,rows[i].name,rows[i].companyName);
			
		}
		$("#site").dialog("close");
	}
	function submitLine(){
		if($('#lineForm').form('validate')){
			var shopId = parent.getId();
			var shopName = parent.getName();
			if(shopId == 0){
				$.messager.alert('提示','请先保存门店','warning');return;
			}
			accept();
			//var inserted = JSON.stringify($('#dg').datagrid('getChanges', "inserted"));
			//var deleted = JSON.stringify($('#dg').datagrid('getChanges', "deleted"));
			var updated = JSON.stringify($('#dg').datagrid('getChanges', "updated"));
			var insertedArr = $('#dg').datagrid('getChanges', "inserted");
			var deletedArr = $('#dg').datagrid('getChanges', "deleted");
			var inserted="",deleted = "";
			for(var i = 0;i<insertedArr.length;i++){
				if(inserted != "") inserted+=",";
				inserted += insertedArr[i].id;
			}
			for(var i = 0;i<deletedArr.length;i++){
				if(deleted != "") deleted+=",";
				deleted += deletedArr[i].id;
			}
			var json = "&inserted="+inserted+"&deleted="+deleted+"&updated="+updated+"&shopId="+shopId+"&shopName="+encodeURI(shopName);
	        if(json=='[]'){$.messager.alert('提示','请选择品牌','warning');return;};
	        
	        $.post("saveShopBrand?"+json, function(rsp) {
	        	parent.showMessage('保存成功');
	        	$('#dg').datagrid('load',{shopId_:shopId});
	        }, "JSON").error(function() {
	        	$.messager.alert('提示','保存失败','error');
	        });
		}
    }
	function resets(){
		deleteAll();
		$('#lineForm').form('clear');
	}
	function getName(v,o,i){
		if(v == undefined){
			map.put(o.id,o.brand.name);
			return o.brand.name;
		}else{
			return v;
		}
		
	}
	function getCompany(v,o,i){
		if(v == undefined){
			return o.brand.companyName;
		}else{
			return v;
		}
	}
	function init(){ //	jie jue ie XIA BU XIANSHI
		if(v){
			$('#dg').datagrid('load',{});
		}
		v = false;
	}
	function searchs(){
        //load 加载数据分页从第一页开始, reload 从当前页开始
    	$('#table').datagrid('load',getForms("searchForm"));
    }
</script>
</head>
<body style="padding:10px;" onmousemove="">
	<form style="font-size:14px;">
	  	<table id="dg" class="easyui-datagrid" style="width:550px;height:auto"  
		            data-options="  
		                singleSelect: true,  
		                toolbar: '#tb',  
		                url: 'findShopBrand?shopId=${shopId }',
		                onClickCell: onClickCell,
		                height:280,
		                rownumbers:true
		            ">
        <thead>
            <tr>
            	<th data-options="field:'id',hidden:true">id</th>
                <th data-options="field:'name',width:200,align:'left',formatter:function(v,o,i){return getName(v,o,i) }">品牌名称</th>          
                <th data-options="field:'companyName',width:250,formatter:function(v,o,i){return getCompany(v,o,i) }">公司名称</th>  
                <th data-options="field:'op',align:'center',width:50,styler:cellStyler">操作</th>
            </tr>
      	  </thead>
    	</table>
    	<div align="right" style="padding-top:8px;width: 550px;">
    		<c:if test="${empty shopId }">
				<a id="btn" href="javascript:void(0)" onclick="resets()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a>
			</c:if>
			<a id="btn" href="javascript:void(0)" onclick="submitLine()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>    	
    	</div>
    </form>
    	
	  <br/>
	  <div id="tb" style="height:auto">  
	      <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="addDialog()">添加品牌</a>
	  </div>  
	
	<div style="display: none;">
		<div id="site">
			<div style="margin-top:5px;margin-bottom: 5px;">
			<form id="searchForm">
			&nbsp;品牌：<input type="text" name="name" />
			<a id="btn" href="javascript:void(0)" onclick="searchs()" class="easyui-linkbutton">搜索</a>
			<a id="btn" href="javascript:void(0)" onclick="selectSite()" class="easyui-linkbutton">确定</a>
			</form>
			</div>
			<table id="table" class="easyui-datagrid" data-options="url:'<%=request.getContextPath() %>/brand/list',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
				rownumbers:true,pageList:pageList,singleSelect:false,height:250" >
			    <thead>
			        <tr>
    			        <th field="ck" checkbox="true"></th>  
			        	<th data-options="field:'id',hidden:true"></th>
			            <th data-options="field:'name',width:30">品牌</th>
			            <th data-options="field:'companyName',width:30">公司</th>
			        </tr>  
			    </thead>  
			</table> 
		</div>
	</div>
	<script type="text/javascript">
		var editIndex = undefined;
        function append(id,name,companyName){
            var rows = $('#dg').datagrid('getRows');
            if(rows != ''){
                for(var i=0;i<rows.length;i++){
                    if(rows[i]['name'] == name || map.get(rows[i].id) == name){
                        return ;break;
                    }
                }
            }
    		$('#dg').datagrid('appendRow',{id:id,name: name,companyName:companyName});
    		editIndex = $('#dg').datagrid('getRows').length-1;  
          	$('#dg').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
          	accept(); 
        }
        function accept(){  
        	var ed = $('#dg').datagrid('getEditor', {index:editIndex,field:'orderNo'});
        	if(ed==null){return;}
            $('#dg').datagrid('getRows')[editIndex]['orderNo'] = '33';
            $('#dg').datagrid('endEdit', editIndex);
        }
        function deleteAll(){
        	var indexs = $('#dg').datagrid('getRows');
        	if(indexs != ''){
                for(var i=indexs.length-1;i>=0;i--){
            		$('#dg').datagrid('cancelEdit',i).datagrid('deleteRow', i);
                }
        	}
      	}
        function onClickCell(rowIndex, field, value){
        	if(field == 'op'){
        		var rows = $('#dg').datagrid('getRows');
        		map.remove(rows[rowIndex].id);
            	$('#dg').datagrid('cancelEdit', rowIndex).datagrid('deleteRow', rowIndex);
            }
            if(field != 'op'){
            	//$('#dg').datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
            	//accept();
            	editIndex = rowIndex;
            }
        }
        function cellStyler(value,row,index){  
           return 'background:url(<%=request.getContextPath()%>/js/jquery/themes/icons/cancel.png) no-repeat center;cursor:pointer';  
        } 
    </script>  
</body>
</html>