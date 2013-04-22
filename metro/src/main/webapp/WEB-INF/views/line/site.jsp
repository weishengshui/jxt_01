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
<script type="text/javascript" src="https://maps.google.com/maps/api/js?sensor=false"></script>
<style type="text/css">
	fieldset{margin-bottom:10px;margin:0px;width:500px;}
	.red{color:red;font-size:12px;}
	textarea{font-size:13px;}
	.addr{width:100px;}
</style>
<script type="text/javascript">
	var isLoad = true;
	function showMap(){
		$("#mapdiv").dialog({
			height:450,
			width:630,
			modal:true,
			resizable:true,
			title:"选择站台"
		});
		if(isLoad){
			load();
			isLoad = false;
		}
	}
	function addDialog(){
		$("#site").dialog({
			height:375,
			width:600,
			modal:true,
			resizable:true,
			title:"选择线路"
		});
	}
	function addStoreDialog(){
		$("#store").dialog({
			height:410,
			width:800,
			modal:true,
			resizable:true,
			title:"选择门店"
		});
	}
	function selectSite(){
		var rows = $('#table').datagrid('getSelections');
		for(var i=0; i<rows.length; i++){
			append(rows[i].id,rows[i].name);
		}
		$("#site").dialog("close");
	}
	
	function selectShop(){
		var rows = $('#shopTable').datagrid('getSelections');//getSelected选一个
		for(var i=0; i<rows.length; i++){
			append1(rows[i].id,rows[i].name);
		}
		$("#store").dialog("close");
	}
	function submitLine(){
		if($('#siteForm').form('validate')){
			accept();
			accept1();
			var lineJson = JSON.stringify($('#dg').datagrid('getChanges', "inserted"));
			var shopJson = JSON.stringify($('#dg1').datagrid('getChanges', "inserted"));
	        var param = $("#siteForm").serialize();
	        if(lineJson=='[]'){$.messager.alert('提示','请选择线路','warning');return;};
	        if(shopJson=='[]'){shopJson = '';};
	        if(checkRepeat()){
				return false;
			}
	        if(checkRepeat1()){
				return false;
			}
			if(!checkupLoadImage('image0') || !checkupLoadImage('image1')){
				$.messager.alert('提示','请至少上传两张图片','warning');return false;
			}
	        var flag = false;
	        $.ajax({
				url:'findSiteByName',
				async: false,
				type :'post',
				data:'name='+$("#name").val(),
				success:function(data){
					if(data == 1){
						flag = true;
					}
				}
			});
	        if(flag){$.messager.alert('提示','站点名称已经存在','warning');return false;}
	        $.post("saveSite?"+param+"&lineJson="+lineJson+"&shopJson="+shopJson, function(rsp) {
	           	$('#dg').datagrid('acceptChanges');
	           	$.messager.show({  
                    title:'提示',  
                    msg:'保存成功!',  
                    showType:'show'  
                });
	           	resets();
	           	deleteAllImage();
	        }, "JSON").error(function() {
	        	$.messager.alert('提示','保存错误','warning');
	        });
		}
    }
	function resets(){
		deleteAll();
		deleteAll1();
		$('#siteForm').form('clear');
	}
	function getAddress(v,o,i){
        return (o.province == null ? '' : o.province) + 
         	   (o.city == null ? '' : o.city) + 
         	   (o.region == null ? '' : o.region ) + 
         	   (o.address == null ? '' : o.address);
    }
	function searchs(){
        //load 加载数据分页从第一页开始, reload 从当前页开始
    	$('#table').datagrid('load',getForms("searchForm"));
    }
	function searchss(){
    	$('#shopTable').datagrid('load',getForms("searchForms"));
    }
	
	function load() { 
		var longitude = '${shop.longitude }';
		var latitude = '${shop.latitude }';
		if(longitude == ''){
			latitude = 31.342660073054077;
			longitude = 121.59584283828735;
		}
		var latlng = new google.maps.LatLng(latitude,longitude);
        var myOptions = {
          zoom: 8,
          center: latlng,
          mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        var map = new google.maps.Map(document.getElementById("map_canvas"),myOptions);
    	
    	var marker = new google.maps.Marker({
          position: latlng, 
          map: map,
    	  draggable:true
    	});
    	
    	google.maps.event.addListener(marker, 'dragend', function() {
    		var latlng = marker.getPosition(); 
    		var lng = String(latlng.lng()); 
    		var lat = String(latlng.lat()); 
    		$("#longitude").val(lng);
    		$("#latitude").val(lat);
    	});
    }  
	$(document).ready(function(){
		addStar("star0");
		addStar("star1");
	})
</script>
</head>
<body style="padding:10px;" >
	<div class="easyui-tabs" style="">
	 <div title="站台增加" style="padding:20px;">
	  <fieldset style="font-size:14px;">
	  	<legend style="color: blue;">站台信息</legend>
	  	<form id="siteForm" method="post">
	  	<table>
	  		<tr>
	  			<td><span class="red">*</span></td>
	  			<td>站台名称：</td>
	  			<td>
	  				<input type="hidden" name="imageSessionName" id="imageSessionName_dataForm" />
	  				<input id="name" type='text' name='name' id="name" style="width:200px" maxlength="100" 
				class="easyui-validatebox" data-options="required:true" />
	  			</td>
	  		</tr>
	  		<tr>
	  			<td><span class="red">*</span></td>
	  			<td>经纬度：</td>
	  			<td>
	  				<input type="text" style="width:50px;" value="${site.longitude }" name="longitude" id="longitude" readonly="readonly" maxlength="200" class="easyui-validatebox" data-options="required:true"/>&nbsp;
			  		<input type="text" style="width:50px;" value="${site.latitude }" name="latitude" id="latitude"  readonly="readonly" maxlength="200" class="easyui-validatebox" data-options="required:true" />
			  		<input type="button" value="标记" onclick="showMap()"/>
	  			</td>
	  		</tr>
	  		<tr>
	  			<td><span class="red">*</span></td>
	  			<td>区域热点：</td>
	  			<td>
	  				<input type="text" name="hotArea" id="hotArea" maxlength="200" class="easyui-validatebox" data-options="required:true"/>&nbsp;
	  			</td>
	  		</tr>
	  		<tr>
	  			<td></td>
	  			<td>站台描述：</td>
	  			<td>
	  				<textarea rows="3" cols="25" name="descs"></textarea>
	  			</td>
	  		</tr>
	  	</table>
	  	</form>
	  	
	  	<br/>
	  	<table id="dg" class="easyui-datagrid" style="width:500px;height:auto;"  
		            data-options="  
		                singleSelect: true,  
		                toolbar: '#tb',  
		                url: '',
		                onClickCell: onClickCell,
		                height:220
		            ">
        <thead>
            <tr>
            	<th data-options="field:'id',hidden:true">id</th>
            	<th data-options="field:'c',hidden:true"></th>
                <th data-options="field:'name',width:250,align:'left'">线路名称</th>          
                <th data-options="field:'orderNo',width:180,editor:'numberbox'">线路排序编号</th>
                <th data-options="field:'op',align:'center',width:50,styler:cellStyler">操作</th>  
            </tr>
      	  </thead>  
    	</table>
    	
    	<br/>
	  	<table id="dg1" class="easyui-datagrid" style="width:500px;height:auto;"  
		            data-options="  
		                singleSelect: true,  
		                toolbar: '#tb1',  
		                url: '',
		                onClickCell: onClickCell1,
		                height:220
		            ">
        <thead>
            <tr>
            	<th data-options="field:'id',hidden:true">id</th>
                <th data-options="field:'name',width:250,align:'left'">门店中文名</th>          
                <th data-options="field:'orderNo',width:180,editor:'numberbox'">门店排序编号</th>
                <th data-options="field:'op',align:'center',width:50,styler:cellStyler">操作</th>  
            </tr>
      	  </thead>  
    	</table>
    	
    	<div align="right" style="padding-top:8px;">
			<a id="btn" href="javascript:void(0)" onclick="resets()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a>
			<a id="btn" href="javascript:void(0)" onclick="submitLine()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>    	
    	</div>
    	
	  </fieldset>
	  <br/>
	  
	  <div id="tb" style="height:auto">  
	      <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="addDialog()">所属线路选择<span style="color:red">*</span></a>
	  </div>  
	  <div id="tb1" style="height:auto">  
	      <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="addStoreDialog()">所有门店选择</a>
	  </div>
	
	<div style="display: none;">
		<div id="site">
			<div style="margin-top:5px;margin-bottom: 5px;">
			<form id="searchForm">
			&nbsp;线路编号：<input type="text" style="width: 100px;" name="numno"/>
			线路名称：<input type="text" style="width: 100px;" name="name"/>
			<a id="btn" href="javascript:void(0)" onclick="searchs()" class="easyui-linkbutton">搜索</a>
			<a id="btn" href="javascript:void(0)" onclick="selectSite()" class="easyui-linkbutton">确定</a>
			</form>
			</div>
			<table id="table" class="easyui-datagrid" data-options="url:'findLines',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
				rownumbers:true,pageList:pageList,singleSelect:false,height:290" >
			    <thead>
			        <tr>
			        	<th field="ck" checkbox="true"></th>  
			        	<th data-options="field:'id',hidden:true"></th>
			            <th data-options="field:'numno',width:30">线路编号</th>
			            <th data-options="field:'name',width:30">线路名称</th>
			            <th data-options="field:'descs',width:30">线路描述</th>
			        </tr>  
			    </thead>  
			</table> 
		</div>
	</div>
	
	<div style="display: none;">
		<div id="store">
			<div style="margin-top:5px;margin-bottom: 5px;">
			<form id="searchForms">
				&nbsp;
				总店编号：<input type="text" style="width:100px;" name="num" />
				门店中文名：<input type="text" style="width:100px;" name="name" />
				联系人：<input type="text" style="width:100px;" name="linkman"/>
				<a id="btn" href="javascript:void(0)" onclick="searchss()" class="easyui-linkbutton">搜索</a>
				<a id="btn" href="javascript:void(0)" onclick="selectShop()" class="easyui-linkbutton">确定</a>
				<div style="margin-top: 7px;margin-left:12px;">
					<select name="province"></select>
					<select name="city"></select>
					<select name="area"></select>
				</div>
			</form>
			</div>
			<table id="shopTable" class="easyui-datagrid" data-options="url:'findShopList?note=site',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
				rownumbers:true,pageList:pageList,singleSelect:false,height:300" >
			    <thead>
			        <tr>
			        	<th field="ck" checkbox="true"></th>  
			        	<th data-options="field:'id',hidden:true"></th>
			            <th data-options="field:'num',width:30">总店编号</th>
			            <th data-options="field:'name',width:30">门店中文名</th>
			            <th data-options="field:'region',width:30,formatter:function(v,o,i){return getAddress(v,o,i) }">区域</th>
			            <th data-options="field:'linkman',width:20">联系人</th>
			            <th data-options="field:'workPhone',width:20">联系电话</th>
			        </tr>
			    </thead>  
			</table> 
		</div>
	</div>
	</div>
	<jsp:include page="../image/imageUpload.jsp">
    	<jsp:param value="SITE_BUFFEREN_IMG" name="tempPath"></jsp:param>
    	<jsp:param value="SITE_IMG" name="formalPath"></jsp:param>
	</jsp:include>
	</div>
	<div style="display: none;">
		<div id="mapdiv"><div id="map_canvas" style="width: 600px; height: 400px;"> </div></div>
	</div>
	<script type="text/javascript">
		var editIndex = undefined;
        function append(id,name){
            var rows = $('#dg').datagrid('getRows');
            if(rows != ''){
                for(var i=0;i<rows.length;i++){
                    if(rows[i]['name'] == name){
                        return ;break;
                    }
                }
            }
    		$('#dg').datagrid('appendRow',{id:id,c:id,name: name});
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
    				alert('线路排序编号不能为空');
    				flag = true;
    			}else{
    				if(rows[i].orderNo <= 0){
        				alert('线路排序编号不能小于0');
        				flag = true;
        			}
    			}
        		if(flag) break;
        		$.ajax({
    	        	url:'findSiteOrderNo',
    	        	type:'post',
    	        	dataType:'json',
    	        	async:false,
    	        	data:"lineId="+rows[i].c+"&orderNo="+rows[i].orderNo,
    	        	success:function(data){
    	        		if(data != 0){
    	        			alert(rows[i].name+"排序编号"+rows[i].orderNo+'已经存在,不能重复');
    	    				flag = true;
    	        		}
    	        	}
    			});
        		if(flag) break;
        	}
        	return flag;
        }
        
		<%----------             门店选择        ------------%>
		var editIndex1 = undefined;
        function append1(id,name){
            var rows = $('#dg1').datagrid('getRows');
            if(rows != ''){
                for(var i=0;i<rows.length;i++){
                    if(rows[i]['name'] == name){
                        return ;break;
                    }
                }
            }
    		$('#dg1').datagrid('appendRow',{id:id,name: name});
    		editIndex1 = $('#dg1').datagrid('getRows').length-1;  
          	$('#dg1').datagrid('selectRow', editIndex1).datagrid('beginEdit', editIndex1);
          	accept1(); 
        }
        function accept1(){
        	var ed = $('#dg1').datagrid('getEditor', {index:editIndex1,field:'orderNo'});
        	if(ed==null){return;}
            $('#dg1').datagrid('getRows')[editIndex1]['orderNo'] = '';
            $('#dg1').datagrid('endEdit', editIndex1);
        }
        function deleteAll1(){
        	var indexs = $('#dg1').datagrid('getRows');
        	if(indexs != ''){
                for(var i=indexs.length-1;i>=0;i--){
            		$('#dg1').datagrid('cancelEdit',i).datagrid('deleteRow', i);
                }
        	}
      	}
        function onClickCell1(rowIndex, field, value){
            if(field == 'op'){
            	$('#dg1').datagrid('cancelEdit', rowIndex).datagrid('deleteRow', rowIndex);
            }
            if(field == 'orderNo'){
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
        }
        function cellStyler1(value,row,index){  
           return 'background:url(<%=request.getContextPath()%>/js/jquery/themes/icons/cancel.png) no-repeat center;cursor:pointer';  
        } 
    	function checkRepeat1(){
        	var flag = false;
        	var rows = $('#dg1').datagrid('getRows');
        	for(var i=0;i<rows.length;i++) {
        		if(rows[i].orderNo == null || rows[i].orderNo==''){
    				alert('门店排序编号不能为空');
    				flag = true;
    			}else{
    				if(rows[i].orderNo <= 0){
        				alert('门店排序编号不能小于0');
        				flag = true;
        			}
    			}
        		if(flag)break;
        		for(var n=i+1;n<rows.length;n++) {
            		if(rows[i].orderNo == rows[n].orderNo) {
    					alert("门店不能有重复排序编号：" + rows[i].orderNo);
    					flag = true;
    				}
            	}
        		if(flag)break;
        		$.ajax({
    	        	url:'findShopSite',
    	        	type:'post',
    	        	dataType:'json',
    	        	async:false,
    	        	data:"shopId="+rows[i].id,
    	        	success:function(data){
    	        		if(data != 0){
    	        			alert("门店"+rows[i].name+'已有所属站台,不能添加');
    	        			flag = true;
    	        		}
    	        	}
    			});
        		if(flag)break;
        	}
        	return flag;
        }
    	
    	new PCAS("province","city","area","","","");
    </script>  
</body>
</html>