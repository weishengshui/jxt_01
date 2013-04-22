<%@ page language="java" contentType="text/html; charset=utf8" pageEncoding="utf8"%>
<link rel="stylesheet" type="text/css"
	href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css"
	href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<style type="text/css">
	fieldset table tr{height: 35px;}
	fieldset{margin-bottom:10px;margin-left:30px;margin-top:10px;}
	select{width:155px;height:20px;}
	.red{color:red;font-size:12px;}
</style>
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.json-2.4.js"></script>
<script type="text/javascript">
		var baseURL = '<%=request.getContextPath()%>';
		var length = 7;
		var fileArray = new Array();
		var formArray = new Array();
		var keyArray = new Array();
		var aimageArray = new Array();
		var imageArray = new Array();
		var divPreviewArray = new Array();
	
		function show(url,width,height){
		/* 	width = (width> 500 ? 500: width);
			height = (height> 700 ? 500: height);
			$("#openIframe").attr("src",url);
			$("#divDialog").dialog({
				height:height,
				width:width,
				modal:true,
				resizable:true,
				title:'预览图片'
			}); */
			parent.parent.dialog("预览图片",url,width,height);
		}
	$(function() {
		style="display:none";
		for(var i = 0; i < length; i++){
			document.getElementById('divPreview'+i).style.display = "none";
			fileArray[i]='file'+i;
			formArray[i]='fm'+i;
			keyArray[i]='key'+i;
			aimageArray[i]='aimage'+i;
			imageArray[i]='image'+i;
			divPreviewArray[i] = 'divPreview'+i;
		}
	});
	
	function hiddenImage(){ //隐藏图片
		style="display:none";
		for(var i = 0; i < 7; i++){
			document.getElementById('divPreview'+i).style.display = "none";
		}
	}
	
	function checkCheckbox(obj, priceId){
		if(obj.checked){
			$('#'+priceId).validatebox({required: true});
		}else{
			$('#'+priceId).validatebox({required: false});
		}
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
		/* $('#tt2').tree({
			url:baseURL+'/category'+'/get_tree_nodes2',
			checkbox:true,
			onlyLeafCheck:true
		}); */
		$('#dd').dialog('center');
		$('#dd').dialog('open');
	}
	function deleteInputFile(name, id, spanId){
		$('#'+spanId).html("<input type=file name="+ name +" id="+ id +" accept=image/* onchange=check(this,'"+spanId+"') />");
	}
	function openAddIamgeDialog(){
		for(var i =0; i < length; i++){
			var name;
			if(i==0){
				name = 'overview';
			}else{
				name = 'others';
			}
			deleteInputFile(name,'file'+i,'span'+i);
		}
		$('#addImage').dialog('center');
		$('#addImage').dialog('open');
	}
	function closeAddIamgeDialog(){
		$('#addImage').dialog('close');
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
				if($('#imageSessionName_dataForm').val() == ""){
					initImageSession(result.imageSessionName);
				}
				$('#'+aimageId).attr('href','javascript:show(\''+baseURL+'/archive/imageShow?path=${param.path}&contentType='+result.contentType+'&fileName='+result.url+'\',\''+result.width+'\',\''+result.height+'\')');
				$('#'+imageId).attr('src',baseURL+'/archive/showGetthumbPic?path=${param.path}&contentType='+result.contentType+'&fileName='+result.url);
				style="display:none";
		    	document.getElementById(divPreviewId).style.display = "";
			}
		}); 
	}
	function deleteImage(keyId, divPreviewId){ 
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
	}
	function initImageSession(imageSessionName){
		$('#imageSessionName_dataForm').val(imageSessionName);
		$('#imageSessionName_image0').val(imageSessionName);
		$('#imageSessionName_image1').val(imageSessionName);		
		$('#imageSessionName_image2').val(imageSessionName);
		$('#imageSessionName_image3').val(imageSessionName);
		$('#imageSessionName_image4').val(imageSessionName);
		$('#imageSessionName_image5').val(imageSessionName);
		$('#imageSessionName_image6').val(imageSessionName);
	}
</script>
	    <div title="图片${param.path }维护" style="padding:20px;text-align:center;">
	    	<table>
	    		<tr>
	    			<td>
	    				<table>
	    					<tr><td align="center">基本图片</td></tr>
				    		<tr>
				    			<td align="center" style="height:120px;">
				    				<div id="divPreview0" >
										<a id="aimage0" href=""><img id="image0" src=""></a><br>
										<button type="button"  onclick="deleteImage('key0','divPreview0')">删除</button>
									</div>
				    			</td>
				    		</tr>			
	    				</table>
	    			</td>
	    			<td>
	    				<table>
	    					<tr><td align="center">图片一</td></tr>
				    		<tr>
				    			<td align="center" style="height:120px;">
				    				<div id="divPreview1" >
										<a id="aimage1" href=""><img id="image1" src=""></a><br>
										<button type="button"  onclick="deleteImage('key1','divPreview1')">删除</button>
									</div>
				    			</td>
				    		</tr>			
	    				</table>
	    			</td>
	    			<td>
	    				<table>
	    					<tr><td align="center">图片二</td></tr>
				    		<tr>
				    			<td align="center" style="height:120px;">
				    				<div id="divPreview2" >
										<a id="aimage2" href=""><img id="image2" src=""></a><br>
										<button type="button"  onclick="deleteImage('key2','divPreview2')">删除</button>
									</div>
				    			</td>
				    		</tr>			
	    				</table>
	    			</td>
	    			<td>
	    				<table>
	    					<tr><td align="center">图片三</td></tr>
				    		<tr>
				    			<td align="center" style="height:120px;">
				    				<div id="divPreview3" >
										<a id="aimage3" href=""><img id="image3" src=""></a><br>
										<button type="button"  onclick="deleteImage('key3','divPreview3')">删除</button>
									</div>
				    			</td>
				    		</tr>			
	    				</table>
	    			</td>
	    			<td>
	    				<table>
	    					<tr><td align="center">图片四</td></tr>
				    		<tr>
				    			<td align="center" style="height:120px;">
				    				<div id="divPreview4" >
										<a id="aimage4" href=""><img id="image4" src=""></a><br>
										<button type="button"  onclick="deleteImage('key4','divPreview4')">删除</button>
									</div>
				    			</td>
				    		</tr>			
	    				</table>
	    			</td>
	    			<td>
	    				<table>
	    					<tr><td align="center">图片五</td></tr>
				    		<tr>
				    			<td align="center" style="height:120px;">
				    				<div id="divPreview5" >
										<a id="aimage5" href=""><img id="image5" src=""></a><br>
										<button type="button"  onclick="deleteImage('key5','divPreview5')">删除</button>
									</div>
				    			</td>
				    		</tr>			
	    				</table>
	    			</td>
	    			<td>
	    				<table>
	    					<tr><td align="center">图片六</td></tr>
				    		<tr>
				    			<td align="center" style="height:120px;">
				    				<div id="divPreview6" >
										<a id="aimage6" href=""><img id="image6" src=""></a><br>
										<button type="button"  onclick="deleteImage('key6','divPreview6')">删除</button>
									</div>
				    			</td>
				    		</tr>			
	    				</table>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td align="center" colspan="6">
	    				<button type="button" onclick="openAddIamgeDialog()">上传图片</button>
	    			</td>
	    		</tr>
	    	</table>
	    	<div id="addImage" class="easyui-dialog" title="上传图片" style="width:600px;height:400px;"  
		        data-options="resizable:true,modal:true,inline:false,closed:true">
			        <div style="text-align:center;">
			        	<table>
							<tr>
								<td>
									<form action="<%=request.getContextPath()%>/merchandise/imageUpload" id="fm0" method="post" enctype="multipart/form-data">
								    	<table>
									    	<tr>
												<td width="20px"></td>
												<td width="80px">基本图片：</td>
												<td width="200px" align="left">
													<input type="hidden" name="path" value="${param.path}">
													<input type="hidden" name="key" id="key0" />
													<input type="hidden" name="imageSessionName" id="imageSessionName_image0">
													<span id="span0">
														<input type="file" name="overview" id="file0" accept="image/*" onchange="check(this,'span0')">
													</span>
												</td>
												<td align="right">&nbsp;&nbsp;<button type="button"  onclick="uploadImage('file0','fm0', 'key0', 'aimage0','image0','divPreview0')">上传</button></td>
											</tr>
										</table>
									</form>
								</td>
							</tr>
							<tr>
								<td>
									<form action="<%=request.getContextPath()%>/merchandise/imageUpload" id="fm1" method="post" enctype="multipart/form-data">
								    	<table>
									    	<tr>
												<td width="20px"></td>
												<td width="80px">图片一：</td>
												<td width="200px" align="left">
													<input type="hidden" name="path" value="${param.path}">
													<input type="hidden" name="key" id="key1" />
													<input type="hidden" name="imageSessionName" id="imageSessionName_image1">
													<span id="span1">
														<input type="file" name="others" id="file1" accept="image/*" onchange="check(this,'span1')">
													</span>
												</td>
												<td align="right">&nbsp;&nbsp;<button type="button"  onclick="uploadImage('file1','fm1', 'key1', 'aimage1','image1','divPreview1')">上传</button></td>
											</tr>
										</table>
									</form>
								</td>
							</tr>
							<tr>
								<td>
									<form action="<%=request.getContextPath()%>/merchandise/imageUpload" id="fm2" method="post" enctype="multipart/form-data">
								    	<table>
									    	<tr>
												<td width="20px"></td>
												<td width="80px">图片二：</td>
												<td width="200px" align="left">
													<input type="hidden" name="path" value="${param.path}">
													<input type="hidden" name="key" id="key2" />
													<input type="hidden" name="imageSessionName" id="imageSessionName_image2">
													<span id="span2">
														<input type="file" name="others" id="file2" accept="image/*" onchange="check(this,'span2')">
													</span>
												</td>
												<td align="right">&nbsp;&nbsp;<button type="button"  onclick="uploadImage('file2','fm2', 'key2', 'aimage2','image2','divPreview2')">上传</button></td>
											</tr>
										</table>
									</form>
								</td>
							</tr>	
							<tr>
								<td>
									<form action="<%=request.getContextPath()%>/merchandise/imageUpload" id="fm3" method="post" enctype="multipart/form-data">
								    	<table>
									    	<tr>
												<td width="20px"></td>
												<td width="80px">图片三：</td>
												<td width="200px" align="left">
													<input type="hidden" name="path" value="${param.path}">
													<input type="hidden" name="key" id="key3" />
													<input type="hidden" name="imageSessionName" id="imageSessionName_image3">
													<span id="span3">
														<input type="file" name="others" id="file3" accept="image/*" onchange="check(this,'span3')">
													</span>
												</td>
												<td align="right">&nbsp;&nbsp;<button type="button"  onclick="uploadImage('file3','fm3', 'key3', 'aimage3','image3','divPreview3')">上传</button></td>
											</tr>	
										</table>
									</form>
								</td>
							</tr>	
							<tr>
								<td>
									<form action="<%=request.getContextPath()%>/merchandise/imageUpload" id="fm4" method="post" enctype="multipart/form-data">
								    	<table>
									    	<tr>
												<td width="20px"></td>
												<td width="80px">图片四：</td>
												<td width="200px" align="left">
													<input type="hidden" name="path" value="${param.path}">
													<input type="hidden" name="key" id="key4" />
													<input type="hidden" name="imageSessionName" id="imageSessionName_image4">
													<span id="span4">
														<input type="file" name="others" id="file4" accept="image/*" onchange="check(this,'span4')">
													</span>
												</td>
												<td align="right">&nbsp;&nbsp;<button type="button"  onclick="uploadImage('file4','fm4', 'key4', 'aimage4','image4','divPreview4')">上传</button></td>
											</tr>	
										</table>
									</form>
								</td>
							</tr>	
							<tr>
								<td>
									<form action="<%=request.getContextPath()%>/merchandise/imageUpload" id="fm5" method="post" enctype="multipart/form-data">
								    	<table>
									    	<tr>
												<td width="20px"></td>
												<td width="80px">图片五：</td>
												<td width="200px" align="left">
													<input type="hidden" name="path" value="${param.path}">
													<input type="hidden" name="key" id="key5" />
													<input type="hidden" name="imageSessionName" id="imageSessionName_image5">
													<span id="span5">
														<input type="file" name="others" id="file5" accept="image/*" onchange="check(this,'span5')">
													</span>
												</td>
												<td align="right">&nbsp;&nbsp;<button type="button"  onclick="uploadImage('file5','fm5', 'key5', 'aimage5','image5','divPreview5')">上传</button></td>
											</tr>	
										</table>
									</form>
								</td>
							</tr>
							<tr>
								<td>
									<form action="<%=request.getContextPath()%>/merchandise/imageUpload" id="fm6" method="post" enctype="multipart/form-data">
								    	<table>
									    	<tr>
												<td width="20px"></td>
												<td width="80px">图片六：</td>
												<td width="200px" align="left">
													<input type="hidden" name="path" value="${param.path}">
													<input type="hidden" name="key" id="key6" />
													<input type="hidden" name="imageSessionName" id="imageSessionName_image6">
													<span id="span6">
														<input type="file" name="others" id="file6" accept="image/*" onchange="check(this,'span6')">
													</span>
												</td>
												<td align="right">&nbsp;&nbsp;<button type="button"  onclick="uploadImage('file6','fm6', 'key6', 'aimage6','image6','divPreview6')">上传</button></td>
											</tr>	
										</table>
									</form>
								</td>
							</tr>	
							<tr>
								<td align="right">
									<button type="button" onclick="closeAddIamgeDialog()">关闭</button>
								</td>
							</tr>	        		
			        	</table>
		        </div>
			</div>
		    <div id="divDialog">
		    	<iframe scrolling="auto" id='openIframe' name="openIframe" frameborder="0"  src="" style="width:100%;height:100%;overflow: hidden;"></iframe> 
			</div>
	    </div>
