<%@ page language="java" contentType="text/html; charset=utf8"
	pageEncoding="utf8"%>
<%@ page import="com.chinarewards.metro.domain.merchandise.MerchandiseStatus" %>		
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link id="easyuiTheme" rel="stylesheet" type="text/css"
	href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css"
	href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<style type="text/css">
	fieldset  {height: 35px;}
	fieldset{margin-bottom:10px;margin-left:30px;margin-top:10px;}
	.red{color:red;font-size:12px;}
	.table select{width:140px;height:22px;margin-right:20px;}
	form{margin:0; padding:0}
</style>
	<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/ueditor/editor_config.js"></script>
	<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/ueditor/editor_all_min.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/common.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.json-2.4.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/PCASClass.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/map.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<script type="text/javascript">
		var baseURL = '<%=request.getContextPath()%>';
		var editor;
		var shopMap = new Map();
		var categoryMap = new Map();
		var keywordsMap = new Map();
	
	$(document).ready(function(){
		style="display:none";
    	document.getElementById('divPreview').style.display = "none";
		editor= new UE.ui.Editor();
		editor.render('instruction');
		editor.ready(function(){
		    //需要ready后执行，否则可能报错
		    editor.setContent('${coupon.instruction }');
		});
		
		var images = $.toJSON(${images});
		images = eval('('+images+')');
		if(images){
			var index = 1;
			for(var i in images){
				var image = images[i];
				if(image){
					$('#key').val(i);
					$('#aimage1').attr('href','javascript:show(\''+baseURL+'/archive/imageShow?formalPath=COUPON_IMAGE_DIR&contentType='+image.mimeType+'&fileName='+image.url+'\',\''+image.width+'\',\''+image.height+'\')');
					$('#image1').attr('src',baseURL+'/archive/showGetthumbPic?formalPath=COUPON_IMAGE_DIR&contentType='+image.mimeType+'&fileName='+image.url);
					style="display:none";
			    	document.getElementById('divPreview').style.display = "";
				}
			}
		}
		isValidDateButtEnable();
	});
	
	function show(url,width,height){
		width = (width> 500 ? 500: width);
		width = (width < 100 ? 100: width);
		height = (height> 700 ? 500: height);
		height = (height < 100 ? 100: height);
		parent.parent.dialog("预览图片",url,width,height);
	}
	
	function doSubmit(){
		if($('#shop').attr('checked') == 'checked' && $('#shopId').val() == ''){
			alert("请选择一个门市");
			return;
		}
		if($('#shopChain').attr('checked') == 'checked' && $('#shopChainId').val() == ''){
			alert("请选择一个连锁");
			return;
		} 
		
		var validDateFromStr = $('#validDateFrom').datebox('getValue');
		var validDateToStr = $('#validDateTo').datebox('getValue');
		if(validDateFromStr == '' || validDateToStr == ''){
			alert("请选择有效期");
			return;
		} 
		var validDateFrom = new Date(Date.parse(validDateFromStr.replaceAll('-','/')));
		var validDateTo = new Date(Date.parse(validDateToStr.replaceAll('-','/')));
		if(validDateTo < validDateFrom){
			alert("有效期的结束时间不能小于开始时间");
			return;
		}
		
		$('#instruction2').val(editor.getContent());
		
		if($('#image1').attr('src')==''){
			alert("请上传图片");
			return;
		}
		
		$('#fm').form('submit',{
			url: 'create',
			success: function(result){
				result = eval('('+result+')'); 
				if(result.msg){
					//alert(result.msg);
					$.messager.show({
						title:'提示信息',
						msg: result.msg,
						timeout:5000,
						showType:'slide'
					});
					//$('#id_').val(result.id);
				}
				if(result.success){
					clearForm();
				}
			},
			error:function(result){
				alert('error');
			}
		});
		
	}
		
	function clearForm(){
		$('#identifyCode').val('');
		$('#sortCode').numberbox('setValue','');
		$('#price').numberbox('setValue','');
		$('#comment').val('');
		deleteAllImage('divPreview','image1');
		document.getElementById("description").value = "";
	}
	function openDialog(){
		$('#dd').dialog('center');
		$('#dd').dialog('open');
	}
	function addBrandDialog(){
		$('#brandDialog').dialog('center');
		$('#brandDialog').dialog('open');
	}
	function doSearch(){  
	    $('#tt').datagrid('load',{  
	    	name:$('#brandSearchName').val() 
	    });  
	}
	function replaceSomeChar(content){
		content = content.replaceAll("'" , "&#39;");
		content = content.replaceAll('"' , "&quot;");
		content = content.replaceAll("<" , "&lt;");
		content = content.replaceAll(">" , "&gt;");
		return content;
	}
	function getAddress(v,o,i){
        return (o.province == null ? '' : o.province) + 
         	   (o.city == null ? '' : o.city) + 
         	   (o.region == null ? '' : o.region ) + 
         	   (o.address == null ? '' : o.address);
    }
	function check(path,spanId){
		var filepath=path.value;
		filepath=filepath.substring(filepath.lastIndexOf('.')+ 1,filepath.length);
		filepath = filepath.toLocaleLowerCase();
		if(filepath != 'jpg' && filepath != 'gif' && filepath!='jpeg' && filepath !='bmp' && filepath!='png'){
			alert("只能上传JPG, GIF, JPEG, BMP, PNG 格式的图片");
			deleteInputFile(path.name, path.id, spanId);
		}
	}
	function openAddIamgeDialog(){
		deleteInputFile('file', 'file1','span1');
		$('#addImage').dialog('center');
		$('#addImage').dialog('open');
	}
	function uploadImage(fileId,formId, keyId, aimageId,imageId, divPreviewId){
		if($('#'+fileId).val()==""){
			alert("请先添加图片");
			return ;
		}
		//alert("uploadImage");
		$('#'+formId).form('submit',{
			type:'post',
			success:function(result){
				//alert('hello'+result);
				result = eval('('+result+')');
				//alert("key is "+result.key);
				//alert("url is"+result.url);
				if(!result.key){
					alert("请检查图片是否是完好的");
					return;
				}
				// alert("key is "+result.key);
				$('#'+keyId).val(result.key);
				$('#imageSessionName_imageForm').val(result.imageSessionName);
				$('#imageSessionName_dataForm').val(result.imageSessionName);
				$('#'+aimageId).attr('href','javascript:show(\''+baseURL+'/archive/imageShow?tempPath=COUPON_IMAGE_BUFFER&formalPath=COUPON_IMAGE_DIR&contentType='+result.contentType+'&fileName='+result.url+'\',\''+result.width+'\',\''+result.height+'\')');
				$('#'+imageId).attr('src',baseURL+'/archive/showGetthumbPic?tempPath=COUPON_IMAGE_BUFFER&formalPath=COUPON_IMAGE_DIR&contentType='+result.contentType+'&fileName='+result.url);
				style="display:none";
		    	document.getElementById(divPreviewId).style.display = "";
		    	$('#addImage').dialog('close');
			}
		}); 
	}
	function deleteImage(keyId, divPreviewId, imageId){ 
		$.ajax({
			url:baseURL+'/archive/deleteImage',
			data:'imageSessionName='+$('#imageSessionName_imageForm').val()+'&key='+$('#'+keyId).val(),
			dataType:'json',
			async:false,
			success:function(data){
			}
		});
		style="display:none";
    	document.getElementById(divPreviewId).style.display = "none";
    	$('#'+imageId).attr('src','');
	}
	function deleteAllImage(divPreviewId, imageId){ 
		$.ajax({
			url:baseURL+'/archive/deleteAllImage',
			data:'imageSessionName='+$('#imageSessionName_imageForm').val(),
			dataType:'json',
			async:false,
			success:function(data){
			}
		});
		style="display:none";
    	document.getElementById(divPreviewId).style.display = "none";
    	$('#'+imageId).attr('src','');
	}
	function deleteInputFile(name, id, spanId){// 清空input type=file 直接$('#'+imageId).val('');有浏览器不兼容的问题
		$('#'+spanId).html("<input type=file name="+ name +" id="+ id +" accept=image/* onchange=check(this,'"+spanId+"') />");
	}
	function selectMenshi(){
		if($('#shop').attr('checked') == 'checked'){
			$('#shopDialog').dialog('center');
			$('#shopDialog').dialog('open');
		}
		if($('#shopChain').attr('checked') == 'checked'){
			$('#shopChainDialog').dialog('center');
			$('#shopChainDialog').dialog('open');
		}
	}
	function selectShop(){
		var row = $('#shops').datagrid('getSelected');
		if(row){
			var nameZH = row.name;
			var id = row.id;
			if(!nameZH){
				nameZH = "";
			}
			$('#shopId').val(id);
			$('#shopChainId').val('');
			$('#menshiName').val(nameZH);
			$('#shopDialog').dialog('close');
		}else{
			alert("请选择一个门市，如不选择门市，请点击\"关闭\"。");
		}
	}
	function selectShopChain(){
		var row = $('#shopChains').datagrid('getSelected');
		if(row){
			var name = row.name;
			var id = row.id;
			if(!name){
				name = "";
			}
			$('#shopId').val('');
			$('#shopChainId').val(id);
			$('#menshiName').val(name);
			$('#shopChainDialog').dialog('close');
		}else{
			alert("请选择一个连锁，如不选择连锁，请点击\"关闭\"。");
		}
	}
	function clearShopForm(){
		$('#shopForm').form('clear');
	}
	function clearShopChainForm(){
		$('#shopChainForm').form('clear');
	}
	function isValidDateButtEnable(){
		if($('#validDateNew').attr('checked') == 'checked'){
			$('#validDateButt').linkbutton('disable');
		}else if($('#validDateOld').attr('checked') == 'checked'){
			$('#validDateButt').linkbutton('enable');
		}
	}
	function openAddValidDateDialog(){
		if($('#menshiName').val() == ''){
			alert("请先选择一个门市或连锁");
			return;
		}
		$('#selectValidDateButt').linkbutton('disable');
		$('#addValidDate').dialog('center');
		$('#addValidDate').dialog('open');
		searchValidDateList();
	}
	function searchValidDateList(){
		$('#validDateList').datagrid('load',{
			shopId: $('#shopId').val(),
			shopChainId: $('#shopChainId').val()
		});
	}
	function selectValidDate(){
		var row = $('#validDateList').datagrid('getSelected');
		if(row){
			$('#validDateFrom').datebox('setValue', row.validDateFrom);
			$('#validDateTo').datebox('setValue', row.validDateTo);
			editor.setContent(row.instruction);
			$('#addValidDate').dialog('close');
		}
	}
	function checkChange(){
		if($('#shop').attr('checked') == 'checked' && $('#shopChainId').val() != ''){
			clearTop();
		} else if($('#shopChain').attr('checked') == 'checked' && $('#shopId').val() != ''){
			clearTop();
		}
	}
	// 清空“门市选择”、“优惠说明”
	function clearTop(){
		$('#shopId').val('');
		$('#shopChainId').val('');
		$('#menshiName').val('');
		$('#validDateNew').attr('checked','checked');
		isValidDateButtEnable();
		$('#validDateFrom').datebox('setValue', '');
		$('#validDateTo').datebox('setValue', '');
		editor.setContent('');
	}
</script>

</head>
<body>
			<form action="create" method="post" id="fm">
				<table border="0" style="font-size: 14px;">
					<tr>
						<td>
							<fieldset style="font-size: 14px;width:1100px;height:auto;">
								<legend style="color: blue;">门市选择</legend>
									<table border="0">
										<tr>
											<td>
												<span style="color: red;">*&nbsp;</span>
												<c:choose>
													<c:when test="${(empty coupon.shop) && (empty coupon.shopChain)  }">
														<input type="radio" name="menshi" id="shop" checked="checked" onclick="checkChange()"/>门市<input type="radio" name="menshi" id="shopChain" onclick="checkChange()"/>连锁
													</c:when>
													<c:otherwise>
														<c:choose>
															<c:when test="${!empty coupon.shop }">
																<input type="radio" name="menshi" id="shop" checked="checked" onclick="checkChange()"/>门市<input type="radio" name="menshi" id="shopChain" onclick="checkChange()"/>连锁
															</c:when>
															<c:otherwise>
																<input type="radio" name="menshi" id="shop" onclick="checkChange()"/>门市<input type="radio" name="menshi" id="shopChain" checked="checked" onclick="checkChange()"/>连锁
															</c:otherwise>
														</c:choose>
													</c:otherwise>
												</c:choose>
												：
											</td>
											<td>
												<input name="id" type="hidden" id="id_" value="${coupon.id }" />
												<input name="shop.id" id="shopId" type="hidden"  value="${coupon.shop.id }" />
												<input name="shopChain.id" id="shopChainId" type="hidden" value="${coupon.shopChain.id }" />
												<c:choose>
													<c:when test="${(empty coupon.shop) && (empty coupon.shopChain)  }">
														<input name="menshiName" id="menshiName" readonly="readonly" value=""/>
													</c:when>
													<c:otherwise>
														<c:choose>
															<c:when test="${!empty coupon.shop }">
																<input name="menshiName" id="menshiName" readonly="readonly" value="${coupon.shop.name }"/>
															</c:when>
															<c:otherwise>
																<input name="menshiName" id="menshiName" readonly="readonly" value="${coupon.shopChain.name }"/>
															</c:otherwise>
														</c:choose>
													</c:otherwise>
												</c:choose>
												<input type="hidden" name="imageSessionName" id="imageSessionName_dataForm" value="${imageSessionName }" />
											</td>
											<td>
												<a href="javascript:void(0)" onclick="selectMenshi()" class="easyui-linkbutton" data-options="iconCls:'icon-add'">选择</a>
											</td>
										</tr>
										<tr>
											<td>
												<span style="color: red;">*&nbsp;</span>
												<input type="radio" name="validDateFrom_" id="validDateNew" checked="checked" onclick="isValidDateButtEnable()" />新建有效期
											</td>
											<td>
												<input type="radio" name="validDateFrom_" id="validDateOld" onclick="isValidDateButtEnable()" />已存在有效期
											</td>
											<td>
												<a id="validDateButt" href="javascript:void(0)" onclick="openAddValidDateDialog()" class="easyui-linkbutton" data-options="iconCls:'icon-add'">选择</a>
											</td>
										</tr>
										<tr>
											<td><span style="color: red;">*&nbsp;</span>有效期：</td>
											<td align="left" colspan="2">
												<input type="text" name="validDateFrom" id="validDateFrom" value="${fn:substring(coupon.validDateFrom,0,10)}" style="width:120px" class="easyui-datebox" editable="false" />&nbsp;至<input type="text" name="validDateTo" id="validDateTo" value="${fn:substring(coupon.validDateTo,0,10)}" style="width:120px" class="easyui-datebox" editable="false" />
											</td>
										</tr>
									</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td width="1200px">
							<fieldset style="font-size: 14px;width:1100px;height:auto;">
								<legend style="color: blue;"><span style="color:red;"></span>优惠说明</legend>
									<table border="0">
										<tr>
											<td align="left">
												<textarea id="instruction"></textarea>
												<input type="hidden" name="instruction" id="instruction2">
											</td>
										</tr>
									</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td width="1200px">
							<fieldset style="font-size: 14px;width:1100px;height:auto;">
								<legend style="color: blue;">优惠券基本信息</legend>
								<table border="0">
									<tr>
										<td><span style="color: red;">*&nbsp;</span>描述：</td>
										<td align="left">
											<textarea name="description" id="description" rows="5" cols="15" class="easyui-validatebox" data-options="required:true"><c:out value="${coupon.description }" ></c:out></textarea>
										</td>
										<td></td>
									</tr>
									<tr>
										<td><span style="color: red;">*&nbsp;</span>识别编号：</td>
										<td>
											<input id="identifyCode" name="identifyCode" value='<c:out value="${coupon.identifyCode }"></c:out>' type="text" style="width:150px" class="easyui-validatebox" data-options="required:true" maxlength="20"/>
										</td>
										<td></td>
									</tr>
									<tr>
										<td><span style="color: red;">*&nbsp;</span>排序编号：</td>
										<td>
											<input id="sortCode" name="sortCode" value='<c:out value="${coupon.sortCode }"></c:out>' type="text" style="width:150px" class="easyui-numberbox" data-options="min:1,precision:0,required:true" maxlength="10"/>
										</td>
										<td></td>
									</tr>
									<tr>
										<td><span style="color: red;">*&nbsp;</span>售价：</td>
										<td>
											<input id="price" name="price" value='<c:out value="${coupon.price }"></c:out>' type="text" style="width:150px" class="easyui-numberbox" data-options="min:0.01,precision:2,required:true" maxlength="10"/>
										</td>
										<td></td>
									</tr>
									<tr>
										<td><span style="color: red;">*&nbsp;</span>备注：</td>
										<td>
											<input id="comment" name="comment" value='<c:out value="${coupon.comment }"></c:out>' type="text" style="width:150px" class="easyui-validatebox" data-options="required:true" maxlength="50"/>
										</td>
										<td></td>
									</tr>
									<tr>
										<td><span style="color: red;">*&nbsp;</span>图片：</td>
										<td>
											<div id="divPreview" >
												<a id="aimage1" href=""><img id="image1" src=""></a><br>
<!-- 												<button type="button"  onclick="deleteImage('key','divPreview','image1')">删除</button> -->
											</div>
										</td>
										<td align="center">
											<a href="javascript:void(0)" onclick="openAddIamgeDialog()" class="easyui-linkbutton" data-options="iconCls:'icon-upload'">上传图片</a>
						    			</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
					<tr align="center">
						<td align="center">
							<a href="javascript:void(0)" onclick="doSubmit()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a> 
						</td>
					</tr>
				</table>
			</form>
			<div id="addImage" class="easyui-dialog" title="上传图片" style="width:600px;height:200px;"  
		        data-options="resizable:true,modal:true,inline:false,closed:true">
			        <div style="text-align:center;">
			        	<form action="<%=request.getContextPath()%>/archive/imageUpload" id="fm1" method="post" enctype="multipart/form-data">
					    	<table>
					    	<tr>
								<td width="20px"></td>
								<td width="80px">图片：</td>
								<td width="200px" align="left">
									<input type="hidden" name="path" value="COUPON_IMAGE_BUFFER">
									<input type="hidden" name="key" id="key" />
									<input type="hidden" name="imageType" value="" />
									<input type="hidden" name="imageSessionName" id="imageSessionName_imageForm" value="${imageSessionName }">
									<span id="span1">
										<input type="file" name="file" id="file1" accept="image/*" onchange="check(this,'span1')">
									</span>
								</td>
								<td width="120px">
								&nbsp;&nbsp;<a href="javascript:void(0)" onclick="uploadImage('file1','fm1', 'key', 'aimage1','image1','divPreview')" class="easyui-linkbutton" data-options="iconCls:'icon-upload'">上传</a>
								</td>
							</tr>
					    </table>
				    </form>
		        </div>
			</div>
		    <div id="divDialog">
		    	<iframe scrolling="auto" id='openIframe' name="openIframe" frameborder="0"  src="" style="width:100%;height:100%;overflow: hidden;"></iframe> 
			</div>
	<div id="shopDialog" class="easyui-dialog" title="优惠券基本信息-门市选择" style="width:755px;height:480px;" data-options="resizable:false,modal:true,closed:true">
					<form action="#" id="shopForm" style="height:55px">
						<table>
							<tr>
								<td >门店中文名称:</td>
								<td ><input type="text" id="shopName" name="name" style="width:100px;"/></td>
								<td >门店英文名称:</td>
								<td><input type="text" id="shopEnName"  name="enName" style="width:100px;"/></td>
							</tr>
							<tr>
								<td >区域:</td>
								<td colspan="2">
									<select id="shopProvince" name="province" style="width:100px;"></select>
					  				<select id="shopCity" name="city" style="width:100px;"></select>
					  				<select id="shopRegion" name="region" style="width:100px;"></select>
								</td>
								<td>
									<a href="javascript:void(0);" onclick="javascript:$('#shops').datagrid('load',{
										name: $('#shopName').val(),
										province: $('#shopProvince').val(),
										city: $('#shopCity').val(),
										region: $('#shopRegion').val(),
										enName: $('#shopEnName').val()			
									});" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a></td><td><a href="javascript:void(0)" onclick="clearShopForm()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a>
								</td>
							</tr>
						</table>
					</form>
					<table id="shops" class="easyui-datagrid" data-options="url:'<%=request.getContextPath()%>/line/findShopList',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,	rownumbers:true,pageList:pageList,singleSelect:true">
					    <thead>  
					        <tr> 
					        	<th field="id" checkbox="true"></th> 
					        	<th data-options="field:'num',width:130">总店编号</th>
					            <th data-options="field:'name',width:130">门店中文名</th>
					            <th data-options="field:'enName',width:130">门店英文名</th>
					            <th data-options="field:'region',width:200,formatter:function(v,o,i){return getAddress(v,o,i) }">区域</th>  
					        </tr>  
					    </thead>  
					</table>
			<table align="right">					
			<tr align="right">
				<td align="right">
					<a href="javascript:void(0)" onclick="selectShop()" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">确定</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="javascript:$('#shopDialog').dialog('close');" class="easyui-linkbutton" data-options="iconCls:'icon-back'">关闭</a>
				</td>
			</tr>
		</table> 
	</div>
	<div id="shopChainDialog" class="easyui-dialog" title="优惠券基本信息-连锁选择" style="width:755px;height:450px;" data-options="resizable:false,modal:true,closed:true"> 
		<form action="#" id="shopChainForm">
			<table>
				<tr>
					<td align="right">总店编号:</td>
					<td align="left"><input type="text" id="shopChainNum" name="shopChainNum" style="width:100px;"/></td>
					<td align="right">总店名称:</td>
					<td align="left"><input type="text" id="shopChainName" name="shopChainName" style="width:100px;"/></td>
					<td><a id="btn" href="javascript:void(0);" onclick="javascript:$('#shopChains').datagrid('load',{
						numno: $('#shopChainNum').val(),
						name: $('#shopChainName').val()		
					});" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a></td><td><a href="javascript:void(0)" onclick="clearShopChainForm()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a></td>
				</tr>
			</table>
		</form>
		<table id="shopChains" class="easyui-datagrid" data-options="url:'<%=request.getContextPath()%>/line/findShopChain',pagination:true,rownumbers:true,singleSelect:true">
		    <thead>  
		        <tr> 
		        	<th field="id" checkbox="true"></th> 
		        	<th data-options="field:'numno',width:120">总店编号</th>
		            <th data-options="field:'name',width:120">总店名称</th>
		            <th data-options="field:'linkman',width:120">联系人</th>
		            <th data-options="field:'hotline',width:130">固定电话</th>
		            <th data-options="field:'email',width:130">邮箱</th>
		        </tr>  
		    </thead>  
		</table> 
		<table align="right">
			<tr>
				<td align="right">
					<a href="javascript:void(0)" onclick="selectShopChain()" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">确定</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="javascript:$('#shopChainDialog').dialog('close');" class="easyui-linkbutton" data-options="iconCls:'icon-back'">关闭</a>
				</td>
			</tr>
		</table>
	</div>
	<div id="addValidDate" class="easyui-dialog" title="优惠券基本信息-有效期选择" style="width:480px;height:410px;" data-options="resizable:false,modal:true,closed:true"> 
		<table id="validDateList" class="easyui-datagrid" data-options="url:'getCouponValidDateListById',pagination:true,rownumbers:true,singleSelect:true,method:'post',onCheck:function(index, data){
			$('#selectValidDateButt').linkbutton('enable');
		}">
		    <thead>  
		        <tr> 
		        	<th checkbox="true"></th> 
		        	<th data-options="field:'validDateFrom',width:120">开始时间</th>
		            <th data-options="field:'validDateTo',width:120">结束时间</th>
		            <th data-options="field:'createdAt',width:120">创建时间</th>
		            <th data-options="field:'instruction',hidden:true">优惠说明</th>
		            
		        </tr>  
		    </thead>  
		</table> 
		<table align="right">
			<tr>
				<td align="right">
					<a id="selectValidDateButt" href="javascript:void(0)" onclick="selectValidDate()" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">确定</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="javascript:$('#addValidDate').dialog('close');" class="easyui-linkbutton" data-options="iconCls:'icon-back'">关闭</a>
				</td>
			</tr>
		</table>
	</div>
</body>
<script type="text/javascript">
new PCAS("province","city","region","${shop.province}","${shop.city}","${shop.region}");
</script>
</html>