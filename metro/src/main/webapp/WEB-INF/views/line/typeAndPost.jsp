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
<script type="text/javascript" src="<%=request.getContextPath()%>/js/PCASClass.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/json2.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/map.js"></script>
<style type="text/css">
	fieldset{margin-bottom:10px;margin:0px;width:500px;}
	.red{color:red;font-size:12px;}
	textarea{font-size:13px;}
</style>
<script type="text/javascript">
	var v = true;
	var map = new Map();
	function save(){
		var shopId = parent.getId();
		var shopName = parent.getName();
		if(shopId == 0){
			$.messager.alert('提示','请先保存门店','warning');
			return false;
		}
		if(validate() && validate1()){
			accept();
			accept1();
			if(checkRepeat()){
				return false;
			}
			if(checkRepeat1()){
				return false;
			}
			var typeinserted = JSON.stringify($('#dg').datagrid('getChanges', "inserted"));
			var typedeleted = JSON.stringify($('#dg').datagrid('getChanges', "deleted"));
			var typeupdated = JSON.stringify($('#dg').datagrid('getChanges', "updated"));
			var posinserted = JSON.stringify($('#dg1').datagrid('getChanges', "inserted"));
			var posdeleted = JSON.stringify($('#dg1').datagrid('getChanges', "deleted"));
			var posupdated = JSON.stringify($('#dg1').datagrid('getChanges', "updated"));
			if(typeinserted=='[]'){typeinserted = '';};
	        if(typedeleted=='[]'){typedeleted = '';};
	        if(typeupdated=='[]'){typeupdated = '';};
	        if(posinserted=='[]'){posinserted = '';};
	        if(posdeleted=='[]'){posdeleted = '';};
	        if(posupdated=='[]'){posupdated = '';};
	        //delete
	        /*
	        var ss = $('#dg1').datagrid('getChanges', "deleted");
	        if(ss.length > 0){
	        	var posdeleted = '[';
	        	for(var i=0;i<ss.length;i++){
		        	if(posdeleted!='[') posdeleted +=","; 
		        	posdeleted += '{"id":'+ss[i].id+'}';
		        }
	        	posdeleted += ']';
	        }
	        */
	        if(typeinserted =='' && posinserted=='' && typedeleted=='' && posdeleted=='' && posupdated=='' && typeupdated==''){
		        $.messager.alert('提示','请添加消费类型或pos机','warning');
		        return false;
		    }
	        json = "&typeinserted="+encodeURI(typeinserted)+"&typedeleted="+encodeURI(typedeleted)+"&typeupdated="+encodeURI(typeupdated)+
     	   		   "&posinserted="+encodeURI(posinserted)+"&posdeleted="+encodeURI(posdeleted)+"&posupdated="+encodeURI(posupdated)+"&shopId="+shopId+"&shopName="+encodeURI(shopName);
	     	
	        $.post("saveTypeAndPost?"+json, function(rsp) {
	        	parent.showMessage('保存成功');
	        	map.clear();
	        	$('#dg').datagrid('load',{shopId_:shopId});
	        	$('#dg1').datagrid('load',{shopId_:shopId});
	        	editIndex = undefined;
	        	editIndex1 = undefined;
	        }, "JSON").error(function() {
	           $.messager.alert("提示", "提交错误了！");
	        });
			return false;
		}
    }
	function init(){ //jie jue IE xia bu xianshi
		if(v){
			$('#dg').datagrid('load',{});
        	$('#dg1').datagrid('load',{});
		}
		v = false;
	}
	function onlyRead(){
		$(".combo-text").attr("readonly",'true');
	}
</script>
</head>
<body style="padding:10px;" onmousemove="">
	  <fieldset style="font-size:14px;">
	  	<legend style="color: blue;">消费类型</legend>
	  	<table id="dg" class="easyui-datagrid" style="width:500px;height:auto;"  
		            data-options="
		                singleSelect: true,
		                toolbar: '#tb',
		                onClickCell: onClickCell,
		                url:'findType?shopId=${shopId}',
		                height:220
		            ">
        	<thead>
            <tr style="width:500px;">
            	<th data-options="field:'id',hidden:true">id</th>
                <th data-options="field:'name',width:210,align:'left',editor:'text',options:{required:true}">消费类型名称</th>          
                <th data-options="field:'num',width:210,editor:'numberbox'">POS机显示排序</th>
                <th data-options="field:'op',align:'center',width:50,styler:cellStyler">操作</th>
            </tr>
      	  </thead>  
    	</table>
    </fieldset>
    	<br/>
    <fieldset style="font-size:14px;">
	  	<legend style="color: blue;">POS机绑定</legend>	
	  	<table id="dg1" class="easyui-datagrid" style="width:500px;height:auto;"  
		            data-options="  
		                singleSelect: true,
		                toolbar: '#tb1',  
		                url: 'findPost?shopId=${shopId}',
		                onClickCell: onClickCell1,
		                height:220
		            ">
        <thead>
            <tr>
            	<th data-options="field:'id',hidden:true">id</th>
                <th data-options="field:'code',width:210,align:'left',editor:'text'">POS编号</th>          
                <th data-options="field:'bindDate',width:210,editor:'datebox'">绑定时间</th>
                <th data-options="field:'op',align:'center',width:50,styler:cellStyler1">操作</th>  
            </tr>
      	  </thead>  
    	</table>
    	
    	<div align="right" style="padding-top:8px;">
			<!-- <a id="btn" href="javascript:void(0)" onclick="resets()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a> -->
			<a id="btn" href="javascript:void(0)" onclick="save()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
    	</div>
   	</fieldset>
	  
	  <br/>
	  
	  <div id="tb" style="height:auto">  
	      <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="append()">新增</a>
	  </div>  
	  <div id="tb1" style="height:auto">  
	      <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="append1()">新增</a>
	  </div>
	
	<script type="text/javascript">
		var editIndex = undefined;
		function endEditing(){
            if (editIndex == undefined){return true;}  
            if (validate()){
            	accept();
                return true;
            } else {
                return false;
            }  
        }
		function append(){
            if (endEditing()){
            	$('#dg').datagrid('appendRow',{});
                editIndex = $('#dg').datagrid('getRows').length-1;  
                $('#dg').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);  
            }
        }  
        
        function accept(){  
        	var ed = $('#dg').datagrid('getEditor', {index:editIndex,field:'name'});
        	if(ed==null){return;}
            $('#dg').datagrid('getRows')[editIndex]['num'] = '33';
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
            if(field != 'op'){
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

        function validate(){
        	var name = $('#dg').datagrid('getEditor', {index:editIndex,field:'name'});
        	var num = $('#dg').datagrid('getEditor', {index:editIndex,field:'num'});
        	if(name != null){
            	if($(name.target).val()==''){
                	alert("请输入消费类型名称");
            		return false;
            	}
            }
        	if(num != null){
            	if($(num.target).val()==''){
                	alert("POS机显示排序不能为空");
            		return false;
            	}
            }
        	return true;
        }

        /**         pos机绑定  			**/
        
        var editIndex1 = undefined;
		function endEditing1(){
            if (editIndex1 == undefined){return true;}  
            if (validate1()){
            	accept1();
                return true;  
            } else {  
                return false;  
            }  
        }
		function append1(){
            if (endEditing1()){
            	$('#dg1').datagrid('appendRow',{});
                editIndex1 = $('#dg1').datagrid('getRows').length-1;  
                $('#dg1').datagrid('selectRow', editIndex1)  
                        .datagrid('beginEdit', editIndex1);  
            }
            onlyRead();
        }  
        
        function accept1(){  
        	var ed = $('#dg1').datagrid('getEditor', {index:editIndex1,field:'code'});
        	if(ed==null){return;}
            //$('#dg1').datagrid('getRows')[editIndex1]['bindDate'] = '33';
            $('#dg1').datagrid('endEdit', editIndex1);
        }
        
        function onClickCell1(rowIndex, field, value){
            if(field == 'op'){
            	$('#dg1').datagrid('cancelEdit', rowIndex).datagrid('deleteRow', rowIndex);
            }
            if(field != 'op'){
            	var rows = $('#dg1').datagrid('getRows');
            	if(rows.length == 1){
            		$('#dg1').datagrid('selectRow', 0).datagrid('beginEdit', 0);
            	}else{
            		$('#dg1').datagrid('endEdit', 0);
            		$('#dg1').datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
            		accept1();
            	}
            	editIndex1 = rowIndex;
            }
            onlyRead();
        }
        function deleteAll1(){
        	var indexs = $('#dg1').datagrid('getRows');
        	if(indexs != ''){
                for(var i=indexs.length-1;i>=0;i--){
            		$('#dg1').datagrid('cancelEdit',i).datagrid('deleteRow', i);
                }
        	}
      	}
        function cellStyler1(value,row,index){
        	if(row.id != undefined){
        		if(!map.containsKey(row.id)){
        			map.put(row.id,row.code);	
        		}
           }
           return 'background:url(<%=request.getContextPath()%>/js/jquery/themes/icons/cancel.png) no-repeat center;cursor:pointer';  
        } 
        function validate1(){
        	var code = $('#dg1').datagrid('getEditor', {index:editIndex1,field:'code'});
        	var bindDate = $('#dg1').datagrid('getEditor', {index:editIndex1,field:'bindDate'});
        	if(code != null ){
            	if($(code.target).val()==''){
                	alert("请输入POS编号");
            		return false;
            	}
            }
        	if(bindDate != null ){
            	if($(bindDate.target).combobox('getText')==''){
                	alert("请输入绑定时间");
            		return false;
            	}
            }
        	return true;
        }
        function checkRepeat(){
        	var flag = false;
        	var rows = $('#dg').datagrid('getRows');
        	for(var i=0;i<rows.length;i++) {
        		if(rows[i].num == null || rows[i].num==''){
    				alert('POS机显示排序不能为空');
    				flag = true;
    			}
        		if(flag){
        			break;
        		}
        		for(var n=i+1;n<rows.length;n++) {
            		if(rows[i].num == rows[n].num) {
    					alert("POS机显示排序不能重复：" + rows[i].num);
    					flag = true;
    					break;
    				}
            	}
        	}
        	return flag;
        }
        
        function checkRepeat1(){
        	var flag = false;
        	var rows = $('#dg1').datagrid('getRows');
        	for(var i=0;i<rows.length;i++) {
        		if(rows[i].code == null || rows[i].code==''){
    				alert('POS编号不能为空');
    				flag = true;
    			}
        		if(flag)break;
        		$.ajax({
    	        	url:'findPosBinByCode',
    	        	type:'post',
    	        	dataType:'json',
    	        	async:false,
    	        	data:"code="+rows[i].code+"&oldCode="+(map.get(rows[i].id)==undefined?0:map.get(rows[i].id)),
    	        	success:function(data){
    	        		if(data != 0){
    	        			alert("POS机编号 "+rows[i].code+' 已经被绑定');
    	        			flag = true;
    	        		}
    	        	}
    			});
        		if(flag)break;
        		if(rows[i].bindDate == null || rows[i].bindDate==''){
    				alert('绑定时间不能为空');
    				flag = true;
    			}
        		if(flag)break;
        	}
        	return flag;
        }
    </script>  
</body>
</html>