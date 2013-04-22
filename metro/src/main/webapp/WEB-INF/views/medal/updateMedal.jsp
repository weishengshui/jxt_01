<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css"
	href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<style type="text/css">
body {
	font-family: 黑体、宋体、Arial;
	font-size: 12px;
}

#main {
	width: 1000px;
	height: 350px;
	overflow: hidden
}

#t2 {
	float: left;
	width: 450px;
	height: 350px;
}

#t3 {
	float: left;
	width: 450px;
	height: 350px;
}

</style>
<link id="easyuiTheme" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/common.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.json-2.4.js"></script>	
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<script type="text/javascript">
	
	var baseURL = '<%=request.getContextPath()%>';
	
	function show(url,width,height){
		width = width> 500 ? 500: width;
		height = height> 700 ? 500: height;
		$("#openIframe").attr("src",url);
		$("#divDialog").dialog({
			height:height,
			width:width,
			modal:true,
			maximizable:true,
			resizable:true,
			title:'预览图片'
		});
	}
	
	$(function() {
		
		
		style="display:none";
    	document.getElementById('divPreview1').style.display = "none";
    	document.getElementById('divPreview2').style.display = "none";
    	var images = $.toJSON(${images});
		images = eval('('+images+')');
		if(images){
			for(var i in images){
				var image = images[i];
				if(image){
					style="display:none";
					if(i=="key1"){
						$('#key1').val(i);
						$('#aimage1').attr('href','javascript:show(\''+baseURL+'/archive/imageShow?formalPath=ACTIVITY_IMAGE_DIR&contentType='+image.mimeType+'&fileName='+image.url+'\',\''+image.width+'\',\''+image.height+'\')');
						$('#image1').attr('src',baseURL+'/archive/imageShow?formalPath=ACTIVITY_IMAGE_DIR&contentType='+image.mimeType+'&fileName='+image.url);
				    	document.getElementById('divPreview1').style.display = "";
					}else{
						$('#key2').val(i);
						$('#aimage2').attr('href','javascript:show(\''+baseURL+'/archive/imageShow?formalPath=ACTIVITY_IMAGE_DIR&contentType='+image.mimeType+'&fileName='+image.url+'\',\''+image.width+'\',\''+image.height+'\')');
						$('#image2').attr('src',baseURL+'/archive/imageShow?formalPath=ACTIVITY_IMAGE_DIR&contentType='+image.mimeType+'&fileName='+image.url);
						document.getElementById('divPreview2').style.display = "";
					}
				}else{
					style="display:none";
					if(i=="key1"){
				    	document.getElementById('divPreview1').style.display = "none";
					}else{
				    	document.getElementById('divPreview2').style.display = "none";
					}
				}
			}
		}
	});
	
	
	$(document).ready(function() {
		
    	
		$('#updateMedal').click(function(){
			var tag_1 = false ;
			var tag_2 = false ;
			var name = $("input[id='medalName']").val();
			var revealSort = $("input[id='revealSort']").val();
			var obtainCondition = $("textarea[id='obtainCondition']").val();
			var validTime = $("textarea[id='validTime']").val();
			$.ajax({
	            url:'checkName',
	            type:'post',
	            async: false,
	            data:{
	            	name:name,
	            	id:${medal.id }
	            },
	            success:function(data){
	            	tag_1 = data ;
	            }
	        });
			$.ajax({
	            url:'checkRevealSort',
	            type:'post',
	            async: false,
	            data:{
	            	revealSort:revealSort,
	            	id:${medal.id }
	            },
	            success:function(data){
	            	tag_2 = data ;
	            }
	        });
			if(tag_1 == 'true'){
				$.messager.alert('提示',"不能存储相同的勋章名称！");
				return false ;
			}
			if(tag_2 == 'true'){
				$.messager.alert('提示',"显示排序号不能重复！");
				return false ;
			}
			
			if(revealSort.length > 9){
				$.messager.alert('提示',"显示排序号最大长度为9字符！");
				return false ;
			}
			
			if(obtainCondition.length > 200){
				$.messager.alert('提示',"获取条件最大长度为400字符！");
				return false ;
			}
			if(validTime.length > 200){
				$.messager.alert('提示',"有效时间最大长度为400字符！");
				return false ;
			}
			$('#medalForm').form('submit', {
			    url:'updateMedal',
			    success:function(data){
			    	$("#id").val(data);
			    	$("#medalId").val(data);
		    		$.messager.show({  
		    			title:'提示信息',  
		    			msg:'保存成功！',  
		    			timeout:5000,  
		    			showType:'slide'  
		    		});
			    },
			    error:function(data){
			    	//alert('保存失败');
				}
			});	
		});
    	
		
	});
	
	
	
	function check(path,spanId){
		var filepath=path.value;
		filepath=filepath.substring(filepath.lastIndexOf('.')+ 1,filepath.length);
		filepath = filepath.toLocaleLowerCase();
		if(filepath != 'jpg' && filepath != 'gif' && filepath!='jpeg' && filepath !='bmp' && filepath!='png'){
			$.messager.alert('提示',"只能上传JPG, GIF, JPEG, BMP, PNG 格式的图片");
			deleteInputFile(path.name, path.id, spanId);
		}
	}
	function uploadImage(fileId,formId, keyId, aimageId,imageId, divPreviewId){
		if($('#'+fileId).val()==""){
			$.messager.alert('提示',"请先添加图片");
			return ;
		}
		$('#'+formId).form('submit',{
			success:function(result){
				result = eval('('+result+')');
				if(!result.key){
					$.messager.alert('提示',"请检查图片是否是完好的");
					return;
				}
				$('#'+keyId).val(result.key);
				$('#imageSessionName_dataForm').val(result.imageSessionName);
				$('#imageSessionName_image1').val(result.imageSessionName);
				$('#imageSessionName_image2').val(result.imageSessionName);
				$('#'+aimageId).attr('href','javascript:show(\''+baseURL+'/archive/imageShow?formalPath=ACTIVITY_IMAGE_DIR&tempPath=ACTIVITY_IMAGE_BUFFER&contentType='+result.contentType+'&fileName='+result.url+'\',\''+result.width+'\',\''+result.height+'\')');
				$('#'+imageId).attr('src',baseURL+'/archive/imageShow?formalPath=ACTIVITY_IMAGE_DIR&tempPath=ACTIVITY_IMAGE_BUFFER&contentType='+result.contentType+'&fileName='+result.url);
				style="display:none";
		    	document.getElementById(divPreviewId).style.display = "";
			}
		}); 
	}
	function deleteImage(keyId, divPreviewId){ 
		$.ajax({
			url:baseURL+'/brand/deleteImage',
			data:'imageSessionName='+$('#imageSessionName_imageForm').val()+'&key='+$('#'+keyId).val(),
			dataType:'json',
			async:false,
			success:function(data){
			}
		});
		style="display:none";
    	document.getElementById(divPreviewId).style.display = "none";
	}
	function deleteInputFile(name, id, spanId){// 清空input type=file 直接$('#'+imageId).val('');有浏览器不兼容的问题
		$('#'+spanId).html("<input type=file name="+ name +" id="+ id +" accept=image/* onchange=check(this,'"+spanId+"') />");
	}
	
</script>

</head>
<body>
	<input type="hidden" id="medalId">
	<div id="tabAct">
			<div >
				<div id="t1">
				<form id="medalForm" method="post">
					<input type="hidden" name="imageSessionName" id="imageSessionName_dataForm" value="${imageSessionName }">
					<table style="width: 600px;">
						<tr>
						<input type="hidden" id="id" name="id" value='<c:out value="${medal.id }"></c:out>'>
							<td><span style="font-weight: bolder; color: red;">*&nbsp;&nbsp;</span>勋章名称：</td>
							<td><input id="medalName" class="easyui-validatebox" maxlength="200"
								data-options="required:true" name="medalName" type="text"
								style="width: 211px;" value='<c:out value="${medal.medalName }"></c:out>'/>
								<input name="key1" value="key1" type="hidden">
								<input name="key2" value="key2" type="hidden">
							</td>
						</tr>
						<tr style="height: 10px;"></tr>
						<tr>
							<td><span style="font-weight: bolder; color: red;">*&nbsp;&nbsp;</span>获取方式：</td>
							<td><input id="obtainWay" name="obtainWay" type="text" value='<c:out value="${medal.obtainWay }"></c:out>'
								style="width: 211px;" class="easyui-validatebox" maxlength="200" data-options="required:true" />
							</td>
						</tr>
						<tr style="height: 10px;"></tr>
						<tr>
							<td><span style="font-weight: bolder; color: red;">*&nbsp;&nbsp;</span>获取条件：</td>
							<td><textarea id="obtainCondition"
									class="easyui-validatebox" data-options="required:true"
									name="obtainCondition" rows="3" cols="24"><c:out value="${medal.obtainCondition }"></c:out></textarea>
							</td>
						</tr>
						<tr style="height: 10px;"></tr>
						<tr>
							<td><span style="font-weight: bolder; color: red;">*&nbsp;&nbsp;</span>有效时间：</td>
							<td><textarea id="validTime" class="easyui-validatebox"
									data-options="required:true" name="validTime" rows="3"
									cols="24"><c:out value="${medal.validTime }"></c:out></textarea></td>
						</tr>
						<tr style="height: 10px;"></tr>
						<tr>
							<td><span style="font-weight: bolder; color: red;">*&nbsp;&nbsp;</span>显示排序：</td>
							<td><input id="revealSort" name="revealSort" type="text" class="easyui-numberbox" maxlength="9" data-options="required:true" 
								style="width: 211px;" value='<c:out value="${medal.revealSort }"></c:out>'/>
							</td>
						</tr>
					</table>
					</form>
				</div>
				</div>
				<div id="main" style="margin-top: 10px;">
					<div id="t2">
					<div>
						<form action="<%=request.getContextPath()%>/brand/imageUpload" id="fm1" method="post" enctype="multipart/form-data">
						<table style="margin-top: 10px;">
							<tr>
								<td><span style="font-weight: bolder; color: red;">*&nbsp;&nbsp;</span>勋章手机图：</td>
								<td>
								<input type="hidden" name="path" value="ACTIVITY_IMAGE_BUFFER">
								<input type="hidden" name="key" id="key1" value="key1"/>
								<input type="hidden" name="imageSessionName" id="imageSessionName_image1" value="${imageSessionName }">
								<span id="span1">
									<input id="file1" name="file" type="file" style="width: 215px;" onchange="check(this,'span1')"/>
								</span>	
									<a id="" href="javascript:void(0)" data-options="iconCls:'icon-upload'" 
									onclick="uploadImage('file1','fm1', 'key1', 'aimage1','image1','divPreview1')"
									class="easyui-linkbutton">上传</a>
								</td>
							</tr>
						</table>
						</form>
					</div>
					<br><br>
					<div align="left">勋章手机图片预览：</div><br>
			    	<div id="divPreview1" >
						<a id="aimage1" href=""><img id="image1" src="" style="width: 300px;height: 150px;"></a><br><br><br>
						<a href="javascript:void(0)" onclick="deleteImage('key','divPreview1')" iconCls="icon-remove" class="easyui-linkbutton" >删除</a>
					</div>
				    <div id="divDialog">
				    	<iframe scrolling="auto" id='openIframe' name="openIframe" frameborder="0"  src="" style="width:100%;height:100%;overflow: hidden;"></iframe> 
					</div>
				</div>
				<div id="t3">
					<div>
						<form action="<%=request.getContextPath()%>/brand/imageUpload" id="fm2" method="post" enctype="multipart/form-data">
						<table style="margin-top: 10px;">
							<tr>
								<td><span style="font-weight: bolder; color: red;">*&nbsp;&nbsp;</span>勋章网站图：</td>
								<td>
								<input type="hidden" name="path" value="ACTIVITY_IMAGE_BUFFER">
								<input type="hidden" name="key" id="key2" value="key2"/>
								<input type="hidden" name="imageSessionName" id="imageSessionName_image2" value="${imageSessionName }">
								<span id="span2">
									<input id="file2" name="file" type="file" style="width: 215px;" onchange="check(this,'span2')"/>
								</span>	
									<a id="" href="javascript:void(0)" data-options="iconCls:'icon-upload'" 
									onclick="uploadImage('file2','fm2', 'key2', 'aimage2','image2','divPreview2')"
									class="easyui-linkbutton">上传</a>
								</td>
							</tr>
						</table>
						</form>
					</div>
					<br><br>
					<div align="left">勋章网站图片预览：</div><br>
			    	<div id="divPreview2" >
						<a id="aimage2" href=""><img id="image2" src="" style="width: 300px;height: 150px;"></a><br><br><br>
						<a href="javascript:void(0)" onclick="deleteImage('key','divPreview2')" iconCls="icon-remove" class="easyui-linkbutton" >删除</a>
					</div>
				    <div id="divDialog">
				    	<iframe scrolling="auto" id='openIframe' name="openIframe" frameborder="0"  src="" style="width:100%;height:100%;overflow: hidden;"></iframe> 
					</div>
				</div>
				</div>
				<div align="left">
					<a id="updateMedal" href="javascript:void(0)" data-options="iconCls:'icon-save'" onclick=""
						class="easyui-linkbutton">保存</a> <!-- <a style="margin-left: 20px;"
						href="javascript:void(0)" onclick="$('#medalForm')[0].reset();$('#fm1')[0].reset();$('#fm2')[0].reset();deleteImage('key','divPreview1', 'image1');deleteImage('key','divPreview2', 'image2');  "
						class="easyui-linkbutton">重置</a> -->
				</div>

	</div>
</body>

</html>