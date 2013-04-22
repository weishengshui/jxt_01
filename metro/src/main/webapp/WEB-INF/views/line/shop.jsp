<%@page import="com.chinarewards.metro.core.common.Dictionary"%>
<%@ page language="java" contentType="text/html; charset=utf8" pageEncoding="utf8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
<link id="easyuiTheme" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.form.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/extend-easyui-validate.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/common.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/PCASClass.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/constant.js"></script>
<script type="text/javascript" src="https://maps.google.com/maps/api/js?sensor=false"></script>
<style type="text/css">
	fieldset table tr{height: 35px;}
	fieldset table {font-size:14px}
	fieldset{margin-bottom:10px;margin:0px;width:600px;font-size:14px;}
	.table select{width:155px;height:20px;}
	.red{color:red;font-size:12px;}
	.combo{margin-top:2px;}
</style>
<script type="text/javascript">
	var isLoad = true;
    function showMap(){
    	$("#mapdiv").dialog({
			height:450,
			width:630,
			modal:true,
			resizable:true,
			title:"google map <font color='blue'>(拖动红色标注选择坐标)</font>"
		});
    	if(isLoad){
			load();
			isLoad = false;
		}
    }
    
    function showMessage(msg){
    	$.messager.show({  
            title:'提示',  
            msg:msg,  
            showType:'show'  
        });
    }
	function submits(){
		var upl = $('#csv').val();
		if($("#autoc").attr("checked")=='checked' || upl == ''){
			$("#myform").attr("action","saveShopWithOut");
		}else{
			$("#myform").attr("action","saveShop");
		}
		
		$("#myform").ajaxSubmit({ 
			    type: "post",
			    dataType: "json",
			    beforeSubmit: function(formData, jqForm, options){
			    	
			    	if($("#activeDate").datebox('getValue') > $("#expireDate").datebox('getValue')){
						$.messager.alert('提示','请输入正确的有效时间！','warning');
				    	return false;
				    }
			    	
			    	if(upl == '' && $("#fileModel").attr('checked') == 'checked' && $("#id").val()==''){
						$.messager.alert('提示','请选择要上传的CSV文件！','warning');
						return false
			    	}
			    	
					if(upl != "" && $("#autoc").attr("checked")!='checked'){
						if(upl.toLowerCase().substring(upl.length-4,upl.length)!=".csv"){
							$.messager.alert('提示','文件格式不对，请选择CSV文件！','warning');
							return false;
						}
					}
					
					if($('#myform').form('validate')){
						if($("#province").combobox('getValue')=='' || $("#city").combobox('getValue')=='' || $("#area").combobox('getValue')==''){
				    		$.messager.alert('提示','请选择区域','warning');
				    		return false;
				    	}
						
						return true;
			    	}
					return false;
			    },success:  function (data) { 
			        $("#id").val(data.id);
		           	$.messager.show({  
	                    title:'提示',  
	                    msg:"门店保存成功 <br/><br/>" + (data.exportTip == null?'':data.exportTip.replaceAll('n','<br/>')),  
	                    showType:'show', 
	                    height:200
	                });
			   	}
		 }); 	
	}

	function checkMethod(n){
		if(n==1){
			$("#mspan").css("display","none");
		}else{
			$("#mspan").css("display","");
		}
	}
	function getId(){
		return $("#id").val();
	}
	function getName(){
		return $("#name").val();
	}
	function load() { 
		var longitude = '${shop.longitude }';
		var latitude = '${shop.latitude }';
		if(longitude == ''){
			latitude = 31.342660073054077;
			longitude = 121.59584283828735;
		}
		var latlng = new google.maps.LatLng(latitude,longitude);
        var myOptions = {zoom: 8,center: latlng,mapTypeId: google.maps.MapTypeId.ROADMAP};
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
	})
	function saveImage(){
		if($('#id').val() == ""){
           	$.messager.alert('提示','请先保存基本信息','warning');
			return;
		}
		if(!checkupLoadImage('OVERVIEW')){
			$.messager.alert('提示','请至少上传一张图片','warning');return false;
		}
		$.ajax({
			url:'saveShopFile',
			data:'imageSessionName='+$('#imageSessionName_dataForm').val()+'&shopId='+$('#id').val(),
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
	function resetChain(){
		$("#num").val('');
		$("#chainName").val('');
		$("#chainId").val('');
	}
	function showChain(){
		$("#chain").dialog({
			height:450,
			width:630,
			modal:true,
			resizable:true,
			title:"选择总店"
		});
	}
	function searchs(){
        //load 加载数据分页从第一页开始, reload 从当前页开始
    	$('#table').datagrid('load',getForms("searchForm"));
    }
	function queren(){
		var row = $('#table').datagrid('getSelected');//getSelected / getSelected
		if(row == null){
			$.messager.alert('提示','请选择总店数据','warning');return;
		}
		$("#num").val(row.numno);
		$("#chainName").val(row.name);
		$("#chainId").val(row.id);
		$("#chain").dialog("close");
	}
</script>
</head>
<body>
	<div class="easyui-tabs" id="tt">
	    <div title="门店基本信息" style="padding:20px;">
	        <form id="myform" method="post" action="" enctype="multipart/form-data">
	          <input type="hidden" value="${shop.id }" name="id" id="id" />
	          <fieldset style="font-size:14px;">
			  	<legend style="color: blue;">总店店基本信息</legend>
			  	<table>
			  		<tr>
			  			<td>总店编号：</td>
			  			<td>
			  				<input type="hidden" name="imageSessionName" id="imageSessionName_dataForm" value="${imageSessionName}" />
			  				<input type="hidden" name="chainId" id="chainId" value="${shop.chainId}" />
			  				<input id="num" type='text' name='num' value="<c:out value="${shop.num }"/>" style="width:150px" maxlength="200" readonly="readonly"/>
			  			</td>
			  			<td>总店名称：</td>
			  			<td><input type="text" readonly="readonly" name="chainName" id="chainName" value="<c:out value="${shop.chainName}"/>" /></td>
			  		</tr>
			  		<tr>
			  			<td colspan="4" align="center">
			  				<a id="btn" href="javascript:void(0)" onclick="showChain()" class="easyui-linkbutton">选择</a>
			  				&nbsp;
			  				<a id="btn" href="javascript:void(0)" onclick="resetChain()" class="easyui-linkbutton">重置</a>
			  			</td>
			  		</tr>
			  	</table>
			  </fieldset>
			  <br/>
			  <fieldset style="font-size:14px;">
			  	<legend style="color: blue;">门店基本信息</legend>
			  	<table>
			  		<tr>
			  			<td><span class="red">*</span></td>
			  			<td width="100">门店类型：</td>
			  			<td width="200">
			  				<select name="shopType" id="shopType" style="width:155px;">
			  					<c:forEach items="${shopTypes }" var="type">
			  						<option value="${type.key }" ${type.key==shop.shopType?'selected':'' } >${type.value }</option>
			  					</c:forEach>
			  				</select>
			  			</td>
			  			<td width="100">&nbsp;网址：</td>
			  			<td>
			  				<input id="url" name="url" type="text" value="<c:out value="${shop.url }"/>" style="width:150px" maxlength="200"/>
			  			</td>
			  		</tr>
			  		<tr>
			  			<td><span class="red">*</span></td>
			  			<td>门店中文名：</td>
			  			<td>
			  				<input id="name" type='text' name='name' value="<c:out value="${shop.name }"/>" style="width:150px" maxlength="200" class="easyui-validatebox" data-options="required:true"/>
			  			</td>
			  			<td><span class="red" style="margin-right:3px;">*</span>门店地址：</td>
			  			<td>
			  				<input id="address" type='text' name='address' value="<c:out value="${shop.address }"/>" style="width:150px" maxlength="200" class="easyui-validatebox" data-options="required:true" />
			  			</td>
			  		</tr>
			  		<tr>
			  			<td><span class="red">*</span></td>
			  			<td>门店英文名：</td>
			  			<td>
			  				<input id="name" type='text' name='enName' value="<c:out value="${shop.enName }"/>" style="width:150px" maxlength="200" class="easyui-validatebox" data-options="required:true"/>
			  			</td>
			  			<td><span class="red" style="margin-right:3px;">*</span>经纬度：</td>
			  			<td>
			  				<input type="text" style="width:50px;" value="${shop.longitude }" name="longitude" id="longitude" readonly="readonly" maxlength="200" class="easyui-validatebox" data-options="required:true"/>&nbsp;
			  				<input type="text" style="width:50px;" value="${shop.latitude }" name="latitude" id="latitude"  readonly="readonly" maxlength="200" class="easyui-validatebox" data-options="required:true" />
			  				<input type="button" value="标记" onclick="showMap()"/>
			  			</td>
			  			
			  		</tr>
			  		<tr>
			  			<td><span class="red">*</span></td>
			  			<td>固定电话</td>
			  			<td>
			  				<input id="workPhone" name="workPhone" class="easyui-validatebox" data-options="validType:'phoneNumber',required:true" value="${shop.workPhone }" class="easyui-validatebox" data-options="required:true" maxlength="15" type='text' />
			  			</td>
			  			<td><span class="red" style="margin-right:3px;">*</span>区域：</td>
			  			<td width="200">
			  				<select name="province" id="province" class="easyui-combobox" style="width:155px;"></select>
			  				<select name="city" id="city" class="easyui-combobox" style="width:155px;"></select>
			  				<select name="region" id="area" class="easyui-combobox"style="width:155px;"></select>
			  			</td>
			  		</tr>
			  		<tr>
			  			<td><span class="red">*</span></td>
			  			<td>联系人：</td>
			  			<td>
			  				<input id="linkman" type='text' name='linkman' value="<c:out value="${shop.linkman }"/>" style="width:150px" maxlength="200"  class="easyui-validatebox" data-options="required:true" />
			  			</td>
			  			<td><span class="red" style="margin-right:3px;">*</span>电子邮件：</td>
			  			<td>
			  				<input id="email" name="email" type='text' value="${shop.email }" class="easyui-validatebox" data-options="required:true,validType:'email'"  />
			  			</td>
			  		</tr>
			  		<tr>
			  			<td><span class="red">*</span></td>
			  			<td>营业时间：</td>
			  			<td>
			  				<textarea name="businessHours" id="businessHours" rows="3" style="width:150px;" class="easyui-validatebox" data-options="required:true" onblur="this.value = this.value.substring(0,250)" onkeyup="this.value = this.value.substring(0,250)"><c:out value="${shop.businessHours }"/></textarea>
			  			</td>
			  			<td>&nbsp;特色描述：</td>
			  			<td>
			  				<textarea id="features" name="features" rows="3" style="width:150px;" onblur="this.value = this.value.substring(0,250)" onkeyup="this.value = this.value.substring(0,250)"><c:out value="${shop.features }"/></textarea>
			  			</td>
			  		</tr>
			  	</table>
			  </fieldset>
			  <br/>
			  <fieldset style="font-size:14px;">
			  	<legend style="color: blue;">优惠信息</legend>
			  	<table>
			  		<tr>
			  			<td></td>
			  			<td width="80">标题：</td>
			  			<td width="200">
			  				<Input name="privilegeTile" type="text" value="<c:out value="${shop.privilegeTile }"/>" />
			  			</td>
			  			<td>POS机存根显示权益</td>
			  		</tr>
			  		<tr>
			  			<td></td>
			  			<td width="80">描述：</td>
			  			<td width="200">
			  				<textarea name="privilegeDesc" rows="3" cols="25" onblur="this.value = this.value.substring(0,250)" onkeyup="this.value = this.value.substring(0,250)"><c:out value="${shop.privilegeDesc }" /></textarea>
			  			</td>
			  			<td width="200">
			  				<textarea name="posout" rows="3" cols="25" onblur="this.value = this.value.substring(0,250)" onkeyup="this.value = this.value.substring(0,250)"><c:out value="${shop.posout }"/></textarea>
			  			</td>
			  		</tr>
			  		<tr>
			  			<td></td>
			  			<td width="80">有效期：</td>
			  			<td width="300" colspan="2">
			  				<input type="text" name="activeDate" id="activeDate" value="${fn:substring(shop.activeDate,0,10)}" class="easyui-datebox" editable="false"/> 
			  				&nbsp;至&nbsp;
			  				<input type="text" name="expireDate" id="expireDate" value="${fn:substring(shop.expireDate,0,10)}" class="easyui-datebox" editable="false"/>
			  			</td>
			  		</tr>
			  	</table>
			  </fieldset>
			  <br/>
			  <fieldset style="font-size:14px;">
			  	<legend style="color: blue;">优惠码生成方式</legend>
			  	<table>
			  		<tr>
			  			<td></td>
			  			<td>
			  			  <label><input type="radio" id="autoc" name="discountModel" checked="checked" onclick="checkMethod(1)" value="<%=Dictionary.PROME_Code_AUTO %>" />系统生成</label>
			  			  <label><input type="radio" id="fileModel" name="discountModel" ${shop.discountModel==1?'checked':'' } onclick="checkMethod(2)" value="<%=Dictionary.PROME_Code_IMPORT %>"/>文件导入</label>
			  			  <span style="display: ${shop.discountModel==1?'':'none'};" id="mspan">
			  			  	说明:<input type="text" name="note" style="width: 110px;" value="${shop.note }" />
			  			  	<input type="file" name="csv" id="csv" />
			  			  </span>
			  			</td>	
			  		</tr>
			  	</table>
			  </fieldset>
			  <br/>
			  <fieldset style="text-align: right;border: none;">
				<a id="btn" href="javascript:void(0)" onclick="submits()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
			  </fieldset>
			</form>
	    </div>  
	    <div title="图片维护">  
	    	<!-- 
	        <iframe frameborder="0"  src="shopPic?shopId=${shop.id }" style="width:100%;height: 700px;" scrolling="auto" ></iframe>
	         -->
	         <jsp:include page="../image/imageUpload.jsp">
		    	<jsp:param value="SHOP_BUFFEREN_IMG" name="tempPath"></jsp:param>
		    	<jsp:param value="SHOP_IMG" name="formalPath"></jsp:param>
			</jsp:include>
	    </div>  
	    <div title="消费类型及POS机维护" >
	        <iframe frameborder="0"  src="" style="width:100%;height: 700px;" scrolling="auto" ></iframe>
	    </div>  
	    <div title="所属站台维护">
	        <iframe frameborder="0"  src="" style="width:100%;height: 700px;" scrolling="auto" ></iframe>
	    </div>  
	    <div title="品牌维护">
	        <iframe frameborder="0"  src="" style="width:100%;height: 700px;" scrolling="auto" ></iframe>
	    </div> 
	    <div title="所有商品">
	        <iframe frameborder="0"  src="" style="width:100%;height: 700px;" scrolling="auto" ></iframe>
	    </div> 
	    <div title="导入优惠码" style="padding:20px;">
	        <iframe frameborder="0"  src="" style="width:100%;height: 700px;" scrolling="auto" ></iframe>
	    </div> 
	</div> 
	<div style="display: none;">
		<div id="mapdiv"><div id="map_canvas" style="width: 600px; height: 400px;"> </div></div>
		<div id="chain">
			<form id="searchForm" name="searchForm">
				<table class="table" id="#table" style="font-size:13px;">
					<tr>
						<td>总店编号:</td>
						<td><input type="text" name="numno" style="width:100px;"/></td>
						<td>总店名称:</td>
						<td><input type="text" name="name" style="width:100px;"/></td>
						<td>
							<a id="btn" href="javascript:void(0)" onclick="searchs()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
							<a id="btn" href="javascript:void(0)" onclick="searchForm.reset()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a>
							<a id="btn" href="javascript:void(0)" onclick="queren()" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">确认</a>
						</td>
					</tr>
				<table>
			</form>
			<table id="table" class="easyui-datagrid" data-options="url:'findShopChain',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,toolbar: '#toolbar',
				rownumbers:true,pageList:pageList,singleSelect:true,height:380">
			    <thead>  
			        <tr> 
			        	<th data-options="field:'id',hidden:true,width:30">id</th>
			            <th data-options="field:'numno',width:30">总店编号</th>
			            <th data-options="field:'name',width:30">总店名称</th>
			            <th data-options="field:'linkman',width:30">联系人</th>
			            <th data-options="field:'hotline',width:30">固定电话</th>
			            <th data-options="field:'email',width:30">电子邮件</th>
			        </tr>  
			    </thead>  
			</table> 
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
	new PCAS("province","city","region","${shop.province}","${shop.city}","${shop.region}");
	/*
	$(function(){  
        var tabs = $('#tt').tabs().tabs('tabs');  
        for(var i=0; i<tabs.length; i++){  
            tabs[i].panel('options').tab.unbind().bind('mouseenter',{index:i},function(e){  
                $('#tt').tabs('select', e.data.index);
            });  
        }
    });*/  
	$('#tt').tabs({
		onSelect:function(title){
		  var p = $(this).tabs('getTab', title);
		  if(p.find('iframe').attr('src')==''){
			  if('消费类型及POS机维护' == title){
				  p.find('iframe').attr('src','typeAndPost?shopId=${shop.id }')
			  } 
			  if('所属站台维护' == title){
				  p.find('iframe').attr('src','shopSite?id=${shop.siteId }&orderNo=${shop.orderNo}')
			  }
			  if('品牌维护' == title){
				  p.find('iframe').attr('src','shopBrand?shopId=${shop.id }')
			  }
			  if('所有商品' == title){
				  p.find('iframe').attr('src','shopMerchandise?shopId=${shop.id }')
			  }
			  if('导入优惠码' == title){
				  p.find('iframe').attr('src','shopPromoCode?shopId=${shop.id }')
			  }
		  }
		}
	})
</script>
</html>