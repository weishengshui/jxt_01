<%@ page language="java" contentType="text/html; charset=utf8"
	pageEncoding="utf8"%>
<%@ page import="com.chinarewards.metro.core.common.Constants" %>	
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link id="easyuiTheme" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/extend-easyui-validate.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/common.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/PCASClass.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/constant.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.json-2.4.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<style type="text/css">
	fieldset table tr{height: 35px;}
	fieldset{margin-bottom:10px;margin-left:30px;margin-top:10px;}
	.red{color:red;font-size:12px;}
	form{margin:0; padding:0} 
</style>
<script type="text/javascript">
		var baseURL = '<%=request.getContextPath()%>';
	
		$(function(){
			style="display:none";
	    	document.getElementById('divPreview').style.display = "none";
		});
		
		function show(url,width,height){
			width = (width> 500 ? 500: width);
			height = (height> 700 ? 500: height);
			parent.parent.dialog("预览图片",url,width,height);
		}
		function doSubmit(){
			/* if($('#image1').attr('src') == ""){
				alert("请先上传图片");
				$('#tt').tabs('select','图片维护');
				return;
			} */
			$('#fm').form('submit',{
				success:function(result){
					result = eval('(' + result + ')');
					if(result.success){//保存成功，清空表单
						//$('#fm').form('clear');	
						//deleteImage('key', 'divPreview', 'image1');
					} // 保存失败，不清空表单
					$('#_id').val(result.id);
					$.messager.show({
						title:'提示信息',
						msg:result.msg,
						timeout:5000,
						showType:'slide'
					});
					// alert(result.msg);
				}
			}); 
		}
		function saveImage(){
			if($('#_id').val() == ""){
				alert("请先保存基本信息");
				return;
			}
			if($('#image1').attr('src') == ""){
				alert("请先上传图片");
				return;
			}
			$.ajax({
				url:'saveImage',
				data:'imageSessionName='+$('#imageSessionName_dataForm').val()+'&id='+$('#_id').val(),
				dataType:'json',
				async:false,
				success:function(data){
					//alert(data.msg);
					$.messager.show({
						title:'提示信息',
						msg: data.msg,
						timeout:5000,
						showType:'slide'
					});
				}
			});
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
	function openDialog(){
		$('#dd').dialog('center');
		$('#dd').dialog('open');
	}
	function openAddIamgeDialog(){
		$('#addImage').dialog('center');
		$('#addImage').dialog('open');
	}
	function uploadImage(fileId,formId, keyId, aimageId,imageId, divPreviewId){
		if($('#'+fileId).val()==""){
			alert("请先添加图片");
			return ;
		}
		$('#'+formId).form('submit',{
			success:function(result){
				result = eval('('+result+')');
				if(!result.key){
					alert("请检查图片是否是完好的");
					return;
				}
				$('#'+keyId).val(result.key);
				$('#imageSessionName_dataForm').val(result.imageSessionName);
				$('#imageSessionName_imageForm').val(result.imageSessionName);
				$('#'+aimageId).attr('href','javascript:show(\''+baseURL+'/archive/imageShow?tempPath=BRAND_IMAGE_BUFFER&formalPath=BRAND_IMAGE_DIR&contentType='+result.contentType+'&fileName='+result.url+'\',\''+result.width+'\',\''+result.height+'\')');
				$('#'+imageId).attr('src',baseURL+'/archive/showGetthumbPic?tempPath=BRAND_IMAGE_BUFFER&formalPath=BRAND_IMAGE_DIR&contentType='+result.contentType+'&fileName='+result.url);
				style="display:none";
		    	document.getElementById(divPreviewId).style.display = "";
		    	$('#addImage').dialog('close');
			}
		}); 
	}
	function deleteImage(keyId, divPreviewId, imageId){ 
		$.ajax({
			url:'deleteImage',
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
	function deleteInputFile(name, id, spanId){// 清空input type=file 直接$('#'+imageId).val('');有浏览器不兼容的问题
		$('#'+spanId).html("<input type=file name="+ name +" id="+ id +" accept=image/* onchange=check(this,'"+spanId+"') />");
	}
</script>

</head>
<body>
	<div id="tt" class="easyui-tabs" style="">
	    <div title="品牌基本信息" style="padding:20px;">
	    	<form action="create" method="post" id="fm"> 
				<table border="0" style="font-size:13px;">
					<tr>
						<td>
							<fieldset style="font-size: 14px;width:570px;height:auto;">
								<legend style="color: blue;">品牌新增</legend>
									<table border="0">
										<tr>
											<td><span style="color: red;">*&nbsp;</span></td>
											<td>品牌名称：</td>
											<td>
												<input type="hidden" name="id" id="_id">
												<input type="hidden" name="imageSessionName" id="imageSessionName_dataForm">
												<input id="name" name="name" type="text" style="width:150px" class="easyui-validatebox" data-options="required:true" maxlength="20"/> 
											</td>
											<td></td>
										</tr>
										<tr>
											<td><span style="color: red;">*&nbsp;</span></td>
											<td>公司名称：</td>
											<td>
												<input id="companyName" name="companyName" type="text" style="width:150px" class="easyui-validatebox" data-options="required:true" maxlength="50"> 
											</td>
											<td></td>
										</tr>
										<tr>
											<td><span style="color: red;">*&nbsp;</span></td>
											<td>公司网址：</td>
											<td>
												<input id="companyWebSite" name="companyWebSite" type="text" style="width:150px" class="easyui-validatebox" data-options="required:true,validType:'url'" maxlength="50"> 
											</td>
											<td></td>
										</tr>
										<tr>
											<td><span style="color: red;">*&nbsp;</span></td>
											<td>联系人：</td>
											<td>
												<input id="contact" name="contact" type="text" style="width:150px" class="easyui-validatebox" data-options="required:true" maxlength="20"> 
											</td>
											<td></td>
										</tr>
										<tr>
											<td><span style="color: red;">*&nbsp;</span></td>
											<td>联系电话：</td>
											<td>
												<input id="phoneNumber" name="phoneNumber" type="text" style="width:150px" validType="phoneNumber" maxlength="13" class="easyui-validatebox" data-options="required:true,validType:'phoneNumber'"> 
											</td>
											<td>如：手机号(13089755311),座机(0755-86271266)</td>
										</tr>
										<tr>
											<td></td>
											<td>描述：</td>
											<td>
												<textarea rows="5" cols="15" name="description" id="description"></textarea>
											</td>
											<td></td>
										</tr>
										
										<tr>
											<td></td><td colspan="3"><input type="checkbox" name="unionInvited" id="unionInvited">联合会员申请</td>
										</tr>
										<tr>
											<td align="center" colspan="4">
												<a href="javascript:void(0)" onclick="doSubmit()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
											</td>
										</tr>
									</table>
							</fieldset>
						</td>
					</tr>
					
				</table>
			</form>
	    </div>
	    <div title="图片维护" style="padding:20px;"><!-- 图片维护start -->
	    	<table>
	    		<tr><td align="center"><span style="color:red;">*&nbsp;</span>图片</td></tr>
	    		<tr>
	    			<td align="center" style="height:120px;">
	    				<div id="divPreview" >
							<a id="aimage1" href=""><img id="image1" src=""></a><br>
							<a href="javascript:void(0)" onclick="deleteImage('key','divPreview','image1')" class="easyui-linkbutton" data-options="iconCls:'icon-remove'">删除</a>
						</div>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td align="center">
	    				<a href="javascript:void(0)" onclick="openAddIamgeDialog()" class="easyui-linkbutton" data-options="iconCls:'icon-upload'">上传图片</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="saveImage()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
	    			</td>
	    		</tr>
	    	</table>
	    	<div id="addImage" class="easyui-dialog" title="上传图片" style="width:600px;height:200px;"  
		        data-options="resizable:true,modal:true,inline:false,closed:true">
			        <div style="text-align:center;">
			        	<form action="imageUpload" id="fm2" method="post" enctype="multipart/form-data">
					    	<table>
					    	<tr>
								<td width="20px"></td>
								<td width="80px">图片：</td>
								<td width="200px" align="left">
									<input type="hidden" name="path" value="BRAND_IMAGE_BUFFER">
									<input type="hidden" name="key" id="key" />
									<input type="hidden" name="imageSessionName" id="imageSessionName_imageForm">
									<span id="span1">
										<input type="file" name="file" id="file1" accept="image/*" onchange="check(this,'span1')">
									</span>
								</td>
								<td>
									&nbsp;&nbsp;<a href="javascript:void(0)" onclick="uploadImage('file1','fm2', 'key', 'aimage1','image1','divPreview')" class="easyui-linkbutton" data-options="iconCls:'icon-upload'">上传</a>
								</td>
							</tr>
					    </table>
				    </form>
		        </div>
			</div>
		    <div id="divDialog">
		    	<iframe scrolling="auto" id='openIframe' name="openIframe" frameborder="0"  src="" style="width:100%;height:100%;overflow: hidden;"></iframe> 
			</div>
	    </div><!-- 图片维护end -->
    </div>
</body>
</html>