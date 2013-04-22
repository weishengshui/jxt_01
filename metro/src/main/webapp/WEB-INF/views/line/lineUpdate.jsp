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
	var isSave = false;
	function addDialog(){
		if(isSave){
			$('#table').datagrid('reload',getForms("searchForm"));	
		}
		$("#site").dialog({
			height:333,
			width:550,
			modal:true,
			resizable:true,
			title:"选择站台"
		});
	}
	function selectSite(){
		var rows = $('#table').datagrid('getSelections');//getSelected选一个
		for(var i=0; i<rows.length; i++){
			append(rows[i].id,rows[i].name,rows[i].descs);
		}
		$("#site").dialog("close");
		isSave = false;
	}
	function submitLine(){
		if($('#lineForm').form('validate')){
			accept();
			if(checkRepeat()){
				return false;
			}
			/*
			if(!checkupLoadImage('image0') && !checkupLoadImage('image0')){
				alert('请至少上传两张图片');return false;
			}*/
			var flag = false;
			/* 编号可以重复
			$.ajax({
	            url:'findMetroLineByNum',
	            type:'post',
	            async: false,
	            data:'numno='+$("#numno").val()+"&id="+$("#id").val(),
	            success:function(data){
	            	if(data == 1){
	                	alert('编号已经存在');
	                	flag = true;
	                }
	            }
	        });
			if(flag){return false;} 
			$.ajax({
	            url:'findMetroLineByName',
	            type:'post',
	            async: false,
	            data:'name='+$("#name").val()+"&id="+$("#id").val(),
	            success:function(data){
	            	if(data == 1){
	                	$.messager.alert('提示','名称已经存在','warning');
	                	flag = true;
	                }
	            }
	        });
			if(flag){return false;}*/
			var inserted = JSON.stringify($('#dg').datagrid('getChanges', "inserted"));
			var deleted = JSON.stringify($('#dg').datagrid('getChanges', "deleted"));
			var updated = JSON.stringify($('#dg').datagrid('getChanges', "updated"));
	        var param = $("#lineForm").serialize();
	        if(inserted=='[]'){inserted='';};
	        if(deleted=='[]'){deleted='';};
	        if(updated=='[]'){updated='';};
	        $.post("updateMetroLine?"+param+"&inserted="+inserted+"&deleted="+deleted+"&updated="+updated, function(id) {
	           //$('#dg').datagrid('acceptChanges');
	           	$('#dg').datagrid('load',{lindId_:id});
	           	$.messager.show({  
                    title:'提示',  
                    msg:'保存成功!',  
                    showType:'show'  
                });
	           	$("#id").val(id);
	           	editIndex = undefined;
	           	isSave = true;
	        }, "JSON").error(function() {
	            $.messager.alert('提示','保存错误了','warning');
	        });
		}
    }
	function resets(){
		deleteAll();
		$('#lineForm').form('clear');
	}
	function siteNames(v,o,i){
		if(o.site  != undefined)
			return o.site.name;
		if(v != undefined)
			return v;
	}
	function siteDescs(v,o,i){
		if(o.site  != undefined)
			return o.site.descs;
		if(v != undefined)
			return v;
	}
	function searchs(){
        //load 加载数据分页从第一页开始, reload 从当前页开始
    	$('#table').datagrid('load',getForms("searchForm"));
    }
	$(document).ready(function(){
		addStar("star0");
		addStar("star1");
	})
	function saveImage(){
		if($('#id').val() == ""){
			$.messager.alert('提示','请先保存基本信息','warning');
			return;
		}
		
		if(!checkupLoadImage('OVERVIEW') || !checkupLoadImage('IMAGE1')){
			$.messager.alert('提示','请至少上传两张图片','warning');
			return false;
		}
		$.ajax({
			url:'saveLineFile',
			data:'imageSessionName='+$('#imageSessionName_dataForm').val()+'&lineId='+$('#id').val(),
			dataType:'json',
			async:false,
			success:function(data){
				$.messager.show({  
                    title:'提示',  
                    msg:data.msg,  
                    showType:'show'  
                });
			}
		});
	}
</script>
</head>
<body style="padding:10px;">
	<div class="easyui-tabs" style="">
	 <div title="线路基本信息" style="padding:20px;">
	  <input type="hidden" id="oldnum" value="${line.numno }" />
	  <input type="hidden" id="oldname" value="${line.name }" />
	  <fieldset style="font-size:14px;">
	  	<legend style="color: blue;">基本信息</legend>
	  	<form id="lineForm" method="post">
	  	<input type="hidden" value="${line.id }" name="id" id="id"/>
	  	<table>
	  		<tr>
	  			<td><span class="red">*</span></td>
	  			<td style="width: 80px;">线路编号：</td>
	  			<td>
	  				<input type="hidden" name="imageSessionName" id="imageSessionName_dataForm" value="${imageSessionName}"/>
	  				<input id="numno" type='text' name='numno' value="${line.numno}" style="width:200px" maxlength="10" 
				class="easyui-numberbox" data-options="required:true"/>
	  			</td>
	  		</tr>
	  		<tr>
	  			<td><span class="red">*</span></td>
	  			<td>线路名称：</td>
	  			<td>
	  				<input id="name" type='text' name='name' value="<c:out value="${line.name }"/>" style="width:200px" maxlength="30" 
				class="easyui-validatebox" data-options="required:true" />
	  			</td>
	  		</tr>
	  		<tr>
	  			<td></td>
	  			<td>线路描述：</td>
	  			<td>
	  				<textarea rows="3" cols="25" name="descs" onblur="this.value = this.value.substring(0,250)" onkeyup="this.value = this.value.substring(0,250)">${line.descs }</textarea>
	  			</td>
	  		</tr>
	  	</table>
	  	</form>
	  	<br/>
	  	<table id="dg" class="easyui-datagrid" style="width:500px;height:auto"  
		            data-options="  
		                singleSelect: true,  
		                toolbar: '#tb',
		                url: 'findMetroLineSites?lindId=${line.id}',
		                onClickCell: onClickCell,
		                fitColumns:true,
		                height:400
		            ">
        <thead>
            <tr>
            	<th data-options="field:'id',hidden:true">id</th>
                <th data-options="field:'name',width:250,align:'left',formatter:function(v,o,i){return siteNames(v,o,i) }">站台名称</th>
                <th data-options="field:'descs',width:250,align:'left',formatter:function(v,o,i){return siteDescs(v,o,i) }">描述</th>
                <th data-options="field:'orderNo',width:180,editor:'numberbox'">线路排序编号</th>
                <th data-options="field:'op',align:'center',width:50,styler:cellStyler">操作</th>  
            </tr>
      	  </thead>  
    	</table>
    	<div align="right" style="padding-top:8px;">
			<a id="btn" href="javascript:void(0)" onclick="submitLine()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>    	
    	</div>
	  </fieldset>
	  <br/>
	  <div id="tb" style="height:auto">  
	      <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="addDialog()">添加站台</a>
	  </div>  
	
	
	<div style="display: none;">
		<div id="site">
			<div style="margin-top:5px;margin-bottom: 5px;">
			<form id="searchForm" name="searchForm">
			&nbsp;站台名：<input type="text" name="name"/>
			<a id="btn" href="javascript:void(0)" onclick="searchs()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">搜索</a>
			<a id="btn" href="javascript:void(0)" onclick="searchForm.reset()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a>
			<a id="btn" href="javascript:void(0)" onclick="selectSite()" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">确定</a>
			</form>
			</div>
			<table id="table" class="easyui-datagrid" data-options="url:'findLineSites?lindId=${line.id}',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
				rownumbers:true,pageList:pageList,singleSelect:false,height:250" >
			    <thead>
			        <tr>
			        	<th field="ck" checkbox="true"></th>  
			        	<th data-options="field:'id',hidden:true"></th>
			            <th data-options="field:'name',width:30">站台名</th>
			            <th data-options="field:'descs',width:40">站台描述</th>
			        </tr>  
			    </thead>  
			</table> 
		</div>
	</div>
	</div>
	<jsp:include page="../image/imageUpload.jsp">
    	<jsp:param value="LINE_BUFFEREN_IMG" name="tempPath"></jsp:param>
    	<jsp:param value="LINE_IMG" name="formalPath"></jsp:param>
	</jsp:include>
</div>
	<script type="text/javascript">
		var editIndex = undefined;
        function append(id,name,descs){
            var rows = $('#dg').datagrid('getRows');
            if(rows != ''){
                for(var i=0;i<rows.length;i++){
                    var n = '',d = '',id_='';
                	if(rows[i].site  != undefined){
                		n = rows[i].site['name'];
                		d = rows[i].site['descs']
                		id_ = rows[i].site['id'];
                    }else{
                    	n = rows[i]['name'];
                    	d = rows[i]['descs'];
                    	id_ = rows[i]['id'];
                    }
                	
            		if(id_ == id){
                        return ;break;
                    }
                }
            }
    		$('#dg').datagrid('appendRow',{id:id,name: name,descs:descs});
    		editIndex = $('#dg').datagrid('getRows').length-1;  
          	$('#dg').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
          	accept(); 
          	editIndex = undefined;
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
            	$('#dg').datagrid('cancelEdit', rowIndex).datagrid('deleteRow', rowIndex);
            }
            if(field == 'orderNo'){
            	var rows = $('#dg').datagrid('getRows');
            	if(rows.length == 1){
            		$('#dg').datagrid('selectRow', 0).datagrid('beginEdit', 0);
            	}else{
            		$('#dg').datagrid('endEdit', 0);
            		$('#dg').datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
            		accept();
            	}
            	editIndex = rowIndex;
            }
        }
        function cellStyler(value,row,index){
           return 'background:url(<%=request.getContextPath()%>/js/jquery/themes/icons/cancel.png) no-repeat center;cursor:pointer';  
        } 
        function checkRepeat(){
        	var flag = false;
        	var rows = $('#dg').datagrid('getRows');
        	for(var i=0;i<rows.length;i++) {
        		if(rows[i].orderNo == null || rows[i].orderNo==''){
    				$.messager.alert('提示','序号不能为空','warning');
    				editIndex = undefined;
    				flag = true;
    			}else{
    				if(rows[i].orderNo <= 0){
        				$.messager.alert('提示','排序编号不能小于或等于0','warning');
        				editIndex = undefined;
        				flag = true;
        			}
    			}
        		if(flag)break;
        		for(var n=i+1;n<rows.length;n++) {
            		if(rows[i].orderNo == rows[n].orderNo) {
    					$.messager.alert('提示',"线路排序编号不能重复：" + rows[i].orderNo,'warning');
    					editIndex = undefined;
    					flag = true;
    				}
            	}
        		if(flag)break;
        	}
        	return flag;
        }
    </script>  
</body>
</html>