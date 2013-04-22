<%@ page language="java" contentType="text/html; charset=utf8"
	pageEncoding="utf8"%>
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
<script type="text/javascript" src="<%=request.getContextPath()%>/js/map.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.json-2.4.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/uuid.js"></script>
<style type="text/css">
	fieldset table tr{height: 35px;}
	fieldset{margin-bottom:10px;margin-left:30px;margin-top:10px;}
	.select{width:140px;height:22px;margin-right:20px;}
	.red{color:red;font-size:12px;}
	form{margin:0; padding:0}
</style>
<script type="text/javascript">
		var baseURL = '<%=request.getContextPath()%>';
		var imagePreIdMap = new Map();
		var uuid = new UUID().id;
		var timeId;
		
		function show(url,width,height){
			width = (width> 500 ? 500: width);
			height = (height> 700 ? 500: height);
			parent.parent.dialog("预览图片",url,width,height);
		}
		
		$(function(){
			for(var i = 0; i < 1; i++){
				var perArray = new  Array();
				perArray[0] = 'key';
				perArray[1] = 'image1';
				perArray[2] = 'aimage1';
				perArray[3] = 'divPreview';
				
				imagePreIdMap.put(i, perArray);
			}
			style="display:none";
	    	document.getElementById('divPreview').style.display = "none";
	    	var images = $.toJSON(${images});
	    	//alert(images);
			images = eval('('+images+')');
			if(images){
				var index = 0;
				for(var i in images){
					var preArray = imagePreIdMap.get(index);
					var image = images[i];
					if(image){
						//alert('image.url is ' + image.url);
						$('#'+preArray[0]).val(i);
						$('#'+preArray[2]).attr('href','javascript:show(\''+baseURL+'/archive/imageShow?formalPath=BRAND_IMAGE_DIR&contentType='+image.mimeType+'&fileName='+image.url+'\',\''+image.width+'\',\''+image.height+'\')');
						$('#'+preArray[1]).attr('src',baseURL+'/archive/showGetthumbPic?formalPath=BRAND_IMAGE_DIR&contentType='+image.mimeType+'&fileName='+image.url);
						style="display:none";
				    	document.getElementById(preArray[3]).style.display = "";
				    	index++;
					}else{
						style="display:none";
				    	document.getElementById(preArray[3]).style.display = "none";
						break;
					}
				}
			}
			//简单测了10W个UUID
		});
		
	function doSubmit(){
		/* if($('#image1').attr('src','')==""){
			alert("请先到图片维护中上传图片");
			return;
		} */
		$('#fm').form('submit',{
			success:function(result){
				//alert(eval('('+result+')').msg);
				$.messager.show({
					title:'提示信息',
					msg:eval('('+result+')').msg,
					timeout:5000,
					showType:'slide'
				});
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
				$.messager.show({
					title:'提示信息',
					msg:data.msg,
					timeout:5000,
					showType:'slide'
				});
				//alert(data.msg);
			}
		});
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
	
	function exportUnionMember(){
		uuid = new UUID().id;
		window.location.href = 'exportUnionMember?brandId='+$('#_id').val()+'&memberName='+$('#memberName').val()+'&cardNumber='+$('#cardNumber').val()+'&joinedStart='+$('#joinedStart').datebox('getValue')+'&joinedEnd='+$('#joinedEnd').datebox('getValue')+'&temp='+(new Date().getTime())+'&uuid='+uuid;
		openProgressDialog();
	}
	
	function openProgressDialog(){
		$('#progressDialog').dialog('open');
		$('#progressDialog').dialog('center');
		$('#progress').progressbar('setValue', 0);
		// getProgress();
		timeId = window.setInterval("getProgress()",500);
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
		$('#addImage').dialog('center');
		$('#addImage').dialog('open');
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
	
	function deleteInputFile(name, id, spanId){
		$('#'+spanId).html("<input type=file name="+ name +" id="+ id +" accept=image/* onchange=check(this,'"+spanId+"') />");
	}
	function doSearchMerchandise(){
			
	    $('#tt3').datagrid('load',{  
	    	name:$('#merName').val(),  
	    	code:$('#merCode').val(),
	    	model:$('#merModel').val(),
	    	brandId:$('#_id').val()
	    });  
	}
	function doSearch(){//查询品牌下的会员
		$('#tt2').datagrid({
			url:'listUnionMember',
			queryParams:{
				memberName:$('#memberName').val(),  
				cardNumber:$('#cardNumber').val(),
				joinedStart:$('#joinedStart').datebox('getValue'),
				joinedEnd:$('#joinedEnd').datebox('getValue'),
		    	brandId:$('#_id').val()
				}
		}); 
		/*$('#tt2').datagrid('load',{  
			memberName:$('#memberName').val(),  
			cardNumber:$('#cardNumber').val(),
			joinedStart:$('#joinedStart').datebox('getValue'),
			joinedEnd:$('#joinedEnd').datebox('getValue'),
	    	brandId:$('#_id').val()//,
	    	//temp: (new Date()).getTime()
	    });*/ 
	}
	function clearForm2(){
		$('#fm22').form('clear');
	}
	function clearForm3(){
		$('#fm3').form('clear');
	}
	function getProgress(){
		var value = $('#progress').progressbar('getValue');
		if(value < 100){
	        $.ajax({
	        	url: baseURL+'/getProgress?key='+uuid+'&temp='+(new Date().getTime()),
	        	//data: 'temp='+(new Date().getTime()),
	        	async: false,
	        	success: function(data){
	        		if(data){
		        		data = eval('('+data+')');
		        		// alert('progress is '+data);
				   		$('#progress').progressbar('setValue', data);  
	        		}
	        	}
	        });
	        //window.setTimeout('getProgress()', 400);
		}else{
			window.clearInterval(timeId);
			$('#progressDialog').dialog('close');
			$.ajax({
	        	url: baseURL+'/removeProgress?key='+uuid+'&temp='+(new Date().getTime()),
	        	async: false,
	        	success: function(data){
	        	}
	        });
		}
	}
</script>

</head>
<body>
	
	<div id="tt" class="easyui-tabs" style="">  
       <div title="品牌基本信息" style="padding:20px;">
       		<form action="create" method="post" id="fm" enctype="multipart/form-data"> 
				<table border="0" style="font-size: 14px;">
					<tr>
						<td>
							<fieldset style="width:570px;height:auto;">
								<legend style="color: blue;">修改品牌信息</legend>
									<table border="0">
										<tr>
											<td><span style="color: red;">*&nbsp;</span></td>
											<td>品牌名称：</td>
											<td>
												<input type="hidden" name="id" id="_id" value="${brand.id }">
												<input type="hidden" name="imageSessionName" id="imageSessionName_dataForm" value="${imageSessionName }">
												<input id="name" name="name" type="text" style="width:150px" class="easyui-validatebox" data-options="required:true" maxlength="20" value='<c:out value="${brand.name }"></c:out>'> 
											</td>
											<td></td>
										</tr>
										<tr>
											<td><span style="color: red;">*&nbsp;</span></td>
											<td>公司名称：</td>
											<td>
												<input id="companyName" name="companyName" type="text" style="width:150px" class="easyui-validatebox" data-options="required:true" maxlength="50" value='<c:out value="${brand.companyName }"></c:out>'> 
											</td>
											<td></td>
										</tr>
										<tr>
											<td><span style="color: red;">*&nbsp;</span></td>
											<td>公司网址：</td>
											<td>
												<input id="companyWebSite" name="companyWebSite" type="text" style="width:150px" class="easyui-validatebox" data-options="required:true,validType:'url'" maxlength="50" value='<c:out value="${brand.companyWebSite }"></c:out>'> 
											</td>
											<td></td>
										</tr>
										<tr>
											<td><span style="color: red;">*&nbsp;</span></td>
											<td>联系人：</td>
											<td>
												<input id="contact" name="contact" type="text" style="width:150px" class="easyui-validatebox" data-options="required:true" maxlength="20" value='<c:out value="${brand.contact }"></c:out>'> 
											</td>
											<td></td>
										</tr>
										<tr>
											<td><span style="color: red;">*&nbsp;</span></td>
											<td>联系电话：</td>
											<td>
												<input id="phoneNumber" name="phoneNumber" value='<c:out value="${brand.phoneNumber }"></c:out>' type="text" style="width:150px" validType="phoneNumber" maxlength="13" class="easyui-validatebox" data-options="required:true,validType:'phoneNumber'"> 
											</td>
											<td>如：手机号(13089755311),座机(0755-86271266)</td>
										</tr>
										<tr>
											<td></td>
											<td>描述：</td>
											<td>
												<textarea rows="5" cols="15" name="description" id="description"><c:out value="${brand.description }"></c:out></textarea>
											</td>
											<td></td>
										</tr>
										<tr>
											<td></td><td colspan="3">
												<c:choose>
													<c:when test="${(! empty brand) && brand.unionInvited==true }">
														<input type="checkbox" name="unionInvited" id="unionInvited" checked="checked">联合会员申请
													</c:when>
													<c:otherwise>
														<input type="checkbox" name="unionInvited" id="unionInvited">联合会员申请
													</c:otherwise>
												</c:choose>
											</td>
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
	    	<table style="font-size: 14px;">
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
					    	<table style="font-size: 14px;">
					    	<tr>
								<td width="20px"></td>
								<td width="80px">图片：</td>
								<td width="200px" align="left">
									<input type="hidden" name="path" value="BRAND_IMAGE_BUFFER">
									<input type="hidden" name="key" id="key" />
									<input type="hidden" name="imageSessionName" id="imageSessionName_imageForm" value="${imageSessionName }">
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
       <div title="联合会员" style="padding:20px;">
       		<form action="#" id="fm22" style="width:800px">
				<table border="0" style="font-size: 14px;">
					<tr>
						<td>会员名称：</td>
						<td align="left">
							<input id="memberName" name="memberName" type="text" style="width:150px"/> 
						</td>
						<td>&nbsp;会员卡号：</td>
						<td align="left">
							<input id="cardNumber" name="cardNumber" type="text" style="width:150px"> 
						</td>
						<td></td>
					</tr>
					<tr>
						<td>加入时间：</td>
						<td align="left">
							<input id="joinedStart" name="joinedStart" type="text" style="width:150px" class="easyui-datebox" editable="false"/>
						</td>
						<td>&nbsp;至</td>
						<td align="left">
							<input id="joinedEnd" name="joinedEnd" type="text" style="width:150px" class="easyui-datebox" editable="false"/>
						</td>
						<td>
							&nbsp;&nbsp;<a href="javascript:void(0)" onclick="doSearch()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>&nbsp;&nbsp;<a href="javascript:void(0)" onclick="clearForm2()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a>
						</td>
					</tr>
				</table>
			</form>
			<table id="tt2" class="easyui-datagrid" 
					data-options="fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
					rownumbers:true,pageList:pageList,singleSelect:false">  
				<thead>  
     				<tr>  
			<!-- 		    <th field="id" checkbox="true"></th>  -->
	           		<th data-options="field:'memberName',width:100">会员名称</th>
	           		<th data-options="field:'cardNumber',width:100">会员卡号</th>
	           		<th data-options="field:'joinDate',width:150,formatter:function(v,r,i){return dateFormat(v);}" >加入时间</th>
        			</tr>  
      			</thead>  
 			</table> 
	 		<div style="text-align:right;">
	 			<br />
	 			<a href="javascript:void(0)" onclick="exportUnionMember()" class="easyui-linkbutton" data-options="iconCls:'icon-download'">导出EXCEL</a>
	 			<br />
	 		</div>
       </div>
       <div title="商品" style="padding:20px;">
       	<form action="#" id="fm3" style="width:800px">
			<table border="0">
				<tr>
					<td>商品编号：</td>
					<td align="left">
						<input id="merCode" name="code" type="text" style="width:150px"/> 
					</td>
					<td>商品名称：</td>
					<td align="left">
						<input id="merName" name="name" type="text" style="width:150px"> 
					</td>
				</tr>
				<tr>
					<td>商品型号：</td>
					<td align="left">
						<input id="merModel" name="model" type="text" style="width:150px"/> 
					</td>
					<td>
						<a href="javascript:void(0)" onclick="doSearchMerchandise()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
					</td>
					<td align="left">
						<a href="javascript:void(0)" onclick="clearForm3()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a>
					</td>
				</tr>
			</table>
		</form>
			<table id="tt3" class="easyui-datagrid"  
				data-options="url:'<%=request.getContextPath()%>/merchandise/list',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
				rownumbers:true,pageList:pageList,singleSelect:false,queryParams:{
				brandId:${brand.id }
				}">  
				<thead>  
       				<tr>  
	               		<th data-options="field:'code',width:100">商品编号</th>
	               		<th data-options="field:'name',width:100">商品名称</th>
	               		<th data-options="field:'model',width:100">商品型号</th>
	           		</tr>  
		       	</thead>  
	   		</table>
       </div>
	</div>	
	<div id="progressDialog" class="easyui-dialog" title="正在准备数据，请稍候。。。"
		style="width: 400px; height: auto;align:center;"
		data-options="resizable:false,modal:true,closed:true,closable:false">
		<div id="progress" class="easyui-progressbar" style="width:380px;"></div>
	</div>
</body>
</html>