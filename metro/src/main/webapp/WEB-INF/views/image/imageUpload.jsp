<%@ page language="java" contentType="text/html; charset=utf8" pageEncoding="utf8"%>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.json-2.4.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/map.js"></script>
<style type="text/css">
	form{margin:0; padding:0}
</style>
<script type="text/javascript">
		var baseURL = '<%=request.getContextPath()%>';
		var length = 7;
		var map = new Map();
		var imagePreIdMap = new Map();
	
		function show(url,width,height){
			width = (width> 500 ? 500: width);
			width = (width < 100 ? 100: width);
			height = (height> 700 ? 500: height);
			height = (height < 100 ? 100: height);
			parent.parent.dialog("预览图片",url,width,height);
		}
	$(function() {
		style="display:none";
		for(var i = 0; i < length; i++){
	    	document.getElementById('divPreview'+i).style.display = "none";
			var perArray = new  Array();
			perArray[0] = 'key'+i;
			perArray[1] = 'IMAGE'+i;
			perArray[2] = 'aimage'+i;
			perArray[3] = 'divPreview'+i;
			imagePreIdMap.put(i, perArray);
	    }

    	var images = $.toJSON(${images});
    	//alert(images);
		images = eval('('+images+')');
		if(images){
			var index = 1;
			for(var i in images){
				var preArray = imagePreIdMap.get(index);
				var image = images[i];
				if(image){
					//alert('image.imageType is '+image.imageType);
					if(image.imageType == "OVERVIEW"){
						//alert('image.url is ' + image.url);
						// ${formal_dir} 正式目录，在查询图片时设定
						$('#key0').val(i);
						$('#aimage0').attr('href','javascript:show(\''+baseURL+'/archive/imageShow?formalPath=${param.formalPath}&contentType='+image.mimeType+'&fileName='+image.url+'\',\''+image.width+'\',\''+image.height+'\')');
						$('#OVERVIEW').attr('src',baseURL+'/archive/showGetthumbPic?formalPath=${param.formalPath}&contentType='+image.mimeType+'&fileName='+image.url);
						style="display:none";
				    	document.getElementById('divPreview0').style.display = "";
					}else{
						//alert('image.url is ' + image.url);
						var imageType = image.imageType;
						var imageIndex = imageType.substring(imageType.length - 1);
						$('#key'+imageIndex).val(i);
						$('#aimage'+imageIndex).attr('href','javascript:show(\''+baseURL+'/archive/imageShow?formalPath=${param.formalPath}&contentType='+image.mimeType+'&fileName='+image.url+'\',\''+image.width+'\',\''+image.height+'\')');
						$('#IMAGE'+imageIndex).attr('src',baseURL+'/archive/showGetthumbPic?formalPath=${param.formalPath}&contentType='+image.mimeType+'&fileName='+image.url);
						style="display:none";
				    	document.getElementById('divPreview'+imageIndex).style.display = "";
				    	index++;
					}
				}
			}
		}
	});
	
	function check(path,spanId){
		var filepath=path.value;
		filepath=filepath.substring(filepath.lastIndexOf('.')+ 1,filepath.length);
		filepath = filepath.toLocaleLowerCase();
		if(filepath != 'jpg' && filepath != 'gif' && filepath!='jpeg' && filepath !='bmp' && filepath!='png'){
			alert("只能上传JPG, GIF, JPEG, BMP, PNG 格式的图片");
			deleteInputFile(path.name, path.id, spanId);
		}
	}

	function deleteInputFile(name, id, spanId){
		$('#'+spanId).html("<input type=file name="+ name +" id="+ id +" accept=image/* onchange=check(this,'"+spanId+"') />");
	}
	function openAddIamgeDialog(){
		for(var i =0; i < length; i++){
			deleteInputFile('file','file'+i,'span'+i);
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
				$('#'+aimageId).attr('href','javascript:show(\''+baseURL+'/archive/imageShow?tempPath=${param.tempPath}&formalPath=${param.formalPath}&contentType='+result.contentType+'&fileName='+result.url+'\',\''+result.width+'\',\''+result.height+'\')');
				$('#'+imageId).attr('src',baseURL+'/archive/showGetthumbPic?tempPath=${param.tempPath}&formalPath=${param.formalPath}&contentType='+result.contentType+'&fileName='+result.url);
				style="display:none";
		    	document.getElementById(divPreviewId).style.display = "";
			}
		}); 
	}
	function deleteImage(keyId, divPreviewId, imageId){ 
		$.ajax({
			url:baseURL+'/archive/deleteImage',
			data:'imageSessionName='+$('#imageSessionName_dataForm').val()+'&key='+$('#'+keyId).val()+'&path=${param.tempPath}',
			dataType:'json',
			async:false,
			success:function(data){
			}
		});
		style="display:none";
    	document.getElementById(divPreviewId).style.display = "none";
    	$('#'+imageId).attr('src','');
	}
	function deleteAllImage(){
		$.ajax({
			url:baseURL+'/archive/deleteAllImage',
			data:'imageSessionName='+$('#imageSessionName_dataForm').val(),
			dataType:'json',
			async:false,
			success:function(data){
			}
		});
    	style="display:none";
		for(var i = 0; i < length; i++){
	    	document.getElementById('divPreview'+i).style.display = "none";
	    	$('#image'+i).attr('src','');
	    }
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
	function checkupLoadImage(imageId){
		if($('#'+imageId).attr('src')==""){
			return false;
		}
		return true;
	}
	function addStar(starId){
		$('#'+starId).html("*&nbsp;");
	}
</script>
	    <div title="图片维护" style="padding:20px;">
	    	<table>
	    		<tr>
	    			<td align="center" width="100px">
	    				<table>
	    					<tr><td align="center"><span id="star0" style="color: red;"></span>&nbsp;基本图片</td></tr>
				    		<tr>
				    			<td align="center" style="height:120px;">
				    				<div id="divPreview0" >
				    					<table>
				    						<tr>
				    							<td align="center" valign="bottom" height="80px">
													<a id="aimage0" href=""><img id="OVERVIEW" src=""></a>
				    							</td>
				    						</tr>
				    						<tr>
				    							<td align="center" valign="bottom" height="20px">
				    								<a href="javascript:void(0)" onclick="deleteImage('key0','divPreview0','OVERVIEW')" class="easyui-linkbutton" data-options="iconCls:'icon-remove'">删除</a>
				    							</td>
				    						</tr>
				    					</table>
									</div>
				    			</td>
				    		</tr>			
	    				</table>
	    			</td>
	    			<td align="center" width="100px">
	    				<table>
	    					<tr><td align="center"><span id="star1" style="color: red;"></span>&nbsp;图片一</td></tr>
				    		<tr>
				    			<td align="center" style="height:120px;">
				    				<div id="divPreview1" >
				    					<table>
				    						<tr>
				    							<td align="center" valign="bottom" height="80px">
													<a id="aimage1" href=""><img id="IMAGE1" src=""></a>
				    							</td>
				    						</tr>
				    						<tr>
				    							<td align="center" valign="bottom" height="20px">
				    								<a href="javascript:void(0)" onclick="deleteImage('key1','divPreview1','IMAGE1')" class="easyui-linkbutton" data-options="iconCls:'icon-remove'">删除</a>
				    							</td>
				    						</tr>
				    					</table>
									</div>
				    			</td>
				    		</tr>			
	    				</table>
	    			</td>
	    			<td align="center" width="100px">
	    				<table>
	    					<tr><td align="center"><span id="star2" style="color: red;"></span>&nbsp;图片二</td></tr>
				    		<tr>
				    			<td align="center" style="height:120px;">
				    				<div id="divPreview2" >
				    					<table>
				    						<tr>
				    							<td align="center" valign="bottom" height="80px">
													<a id="aimage2" href=""><img id="IMAGE2" src=""></a>
				    							</td>
				    						</tr>
				    						<tr>
				    							<td align="center" valign="bottom" height="20px">
				    								<a href="javascript:void(0)" onclick="deleteImage('key2','divPreview2','IMAGE2')" class="easyui-linkbutton" data-options="iconCls:'icon-remove'">删除</a>
				    							</td>
				    						</tr>
				    					</table>
									</div>
				    			</td>
				    		</tr>			
	    				</table>
	    			</td>
	    			<td align="center" width="100px">
	    				<table>
	    					<tr><td align="center"><span id="star3" style="color: red;"></span>&nbsp;图片三</td></tr>
				    		<tr>
				    			<td align="center" style="height:120px;">
				    				<div id="divPreview3" >
				    					<table>
				    						<tr>
				    							<td align="center" valign="bottom" height="80px">
													<a id="aimage3" href=""><img id="IMAGE3" src=""></a>
				    							</td>
				    						</tr>
				    						<tr>
				    							<td align="center" valign="bottom" height="20px">
				    								<a href="javascript:void(0)" onclick="deleteImage('key3','divPreview3','IMAGE3')" class="easyui-linkbutton" data-options="iconCls:'icon-remove'">删除</a>
				    							</td>
				    						</tr>
				    					</table>
									</div>
				    			</td>
				    		</tr>			
	    				</table>
	    			</td>
	    			<td align="center" width="100px">
	    				<table>
	    					<tr><td align="center"><span id="star4" style="color: red;"></span>&nbsp;图片四</td></tr>
				    		<tr>
				    			<td align="center" style="height:120px;">
				    				<div id="divPreview4" >
				    					<table>
				    						<tr>
				    							<td align="center" valign="bottom" height="80px">
													<a id="aimage4" href=""><img id="IMAGE4" src=""></a>
				    							</td>
				    						</tr>
				    						<tr>
				    							<td align="center" valign="bottom" height="20px">
				    								<a href="javascript:void(0)" onclick="deleteImage('key4','divPreview4','IMAGE4')" class="easyui-linkbutton" data-options="iconCls:'icon-remove'">删除</a>
				    							</td>
				    						</tr>
				    					</table>
									</div>
				    			</td>
				    		</tr>			
	    				</table>
	    			</td>
	    			<td align="center" width="100px">
	    				<table>
	    					<tr><td align="center"><span id="star5" style="color: red;"></span>&nbsp;图片五</td></tr>
				    		<tr>
				    			<td align="center" style="height:120px;">
				    				<div id="divPreview5" >
				    					<table>
				    						<tr>
				    							<td align="center" valign="bottom" height="80px">
													<a id="aimage5" href=""><img id="IMAGE5" src=""></a>
				    							</td>
				    						</tr>
				    						<tr>
				    							<td align="center" valign="bottom" height="20px">
				    								<a href="javascript:void(0)" onclick="deleteImage('key5','divPreview5','IMAGE5')" class="easyui-linkbutton" data-options="iconCls:'icon-remove'">删除</a>
				    							</td>
				    						</tr>
				    					</table>
									</div>
				    			</td>
				    		</tr>			
	    				</table>
	    			</td>
	    			<td align="center" width="100px">
	    				<table>
	    					<tr><td align="center"><span id="star6" style="color: red;"></span>&nbsp;图片六</td></tr>
				    		<tr>
				    			<td align="center" style="height:120px;">
				    				<div id="divPreview6" >
				    					<table>
				    						<tr>
				    							<td align="center" valign="bottom" height="80px">
													<a id="aimage6" href=""><img id="IMAGE6" src=""></a>
				    							</td>
				    						</tr>
				    						<tr>
				    							<td align="center" valign="bottom" height="20px">
				    								<a href="javascript:void(0)" onclick="deleteImage('key6','divPreview6','IMAGE6')" class="easyui-linkbutton" data-options="iconCls:'icon-remove'">删除</a>
				    							</td>
				    						</tr>
				    					</table>
									</div>
				    			</td>
				    		</tr>			
	    				</table>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td align="center" colspan="6">
	    				<a href="javascript:void(0)" onclick="openAddIamgeDialog()" class="easyui-linkbutton" data-options="iconCls:'icon-upload'">上传图片</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="saveImage()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
	    			</td>
	    		</tr>
	    	</table>
	    	<div id="addImage" class="easyui-dialog" title="上传图片" style="width:490px;height:320px;"  
		        data-options="resizable:true,modal:true,inline:false,closed:true">
			        	<table >
							<tr>
								<td>
									<form action="<%=request.getContextPath()%>/archive/imageUpload" id="fm0" method="post" enctype="multipart/form-data">
								    	<table>
									    	<tr>
												<td width="20px"></td>
												<td width="80px">基本图片：</td>
												<td width="200px" align="left">
													<input type="hidden" name="path" value="${param.tempPath }" />
													<input type="hidden" name="key" id="key0" />
													<input type="hidden" name="imageType" value="OVERVIEW" />
													<input type="hidden" name="imageSessionName" id="imageSessionName_image0" value="${imageSessionName }">
													<span id="span0">
														<input type="file" name="file" id="file0" accept="image/*" onchange="check(this,'span0')">
													</span>
												</td>
												<td align="right">
													&nbsp;&nbsp;<a href="javascript:void(0)" onclick="uploadImage('file0','fm0', 'key0', 'aimage0','OVERVIEW','divPreview0')" class="easyui-linkbutton" data-options="iconCls:'icon-upload'">上传</a>
												</td>
											</tr>
										</table>
									</form>
								</td>
							</tr>
							<tr>
								<td>
									<form action="<%=request.getContextPath()%>/archive/imageUpload" id="fm1" method="post" enctype="multipart/form-data">
								    	<table>
									    	<tr>
												<td width="20px"></td>
												<td width="80px">图片一：</td>
												<td width="200px" align="left">
													<input type="hidden" name="path" value="${param.tempPath }" />
													<input type="hidden" name="key" id="key1" />
													<input type="hidden" name="imageType" value="IMAGE1" />
													<input type="hidden" name="imageSessionName" id="imageSessionName_image1" value="${imageSessionName }">
													<span id="span1">
														<input type="file" name="file" id="file1" accept="image/*" onchange="check(this,'span1')">
													</span>
												</td>
												<td align="right">
													&nbsp;&nbsp;<a href="javascript:void(0)" onclick="uploadImage('file1','fm1', 'key1', 'aimage1','IMAGE1','divPreview1')" class="easyui-linkbutton" data-options="iconCls:'icon-upload'">上传</a>
												</td>
											</tr>
										</table>
									</form>
								</td>
							</tr>
							<tr>
								<td>
									<form action="<%=request.getContextPath()%>/archive/imageUpload" id="fm2" method="post" enctype="multipart/form-data">
								    	<table>
									    	<tr>
												<td width="20px"></td>
												<td width="80px">图片二：</td>
												<td width="200px" align="left">
													<input type="hidden" name="path" value="${param.tempPath }" />
													<input type="hidden" name="key" id="key2" />
													<input type="hidden" name="imageType" value="IMAGE2" />
													<input type="hidden" name="imageSessionName" id="imageSessionName_image2" value="${imageSessionName }">
													<span id="span2">
														<input type="file" name="file" id="file2" accept="image/*" onchange="check(this,'span2')">
													</span>
												</td>
												<td align="right">
													&nbsp;&nbsp;<a href="javascript:void(0)" onclick="uploadImage('file2','fm2', 'key2', 'aimage2','IMAGE2','divPreview2')" class="easyui-linkbutton" data-options="iconCls:'icon-upload'">上传</a>
												</td>
											</tr>
										</table>
									</form>
								</td>
							</tr>	
							<tr>
								<td>
									<form action="<%=request.getContextPath()%>/archive/imageUpload" id="fm3" method="post" enctype="multipart/form-data">
								    	<table>
									    	<tr>
												<td width="20px"></td>
												<td width="80px">图片三：</td>
												<td width="200px" align="left">
													<input type="hidden" name="path" value="${param.tempPath }" />
													<input type="hidden" name="key" id="key3" />
													<input type="hidden" name="imageType" value="IMAGE3" />
													<input type="hidden" name="imageSessionName" id="imageSessionName_image3" value="${imageSessionName }">
													<span id="span3">
														<input type="file" name="file" id="file3" accept="image/*" onchange="check(this,'span3')">
													</span>
												</td>
												<td align="right">
													&nbsp;&nbsp;<a href="javascript:void(0)" onclick="uploadImage('file3','fm3', 'key3', 'aimage3','IMAGE3','divPreview3')" class="easyui-linkbutton" data-options="iconCls:'icon-upload'">上传</a>
												</td>
											</tr>	
										</table>
									</form>
								</td>
							</tr>	
							<tr>
								<td>
									<form action="<%=request.getContextPath()%>/archive/imageUpload" id="fm4" method="post" enctype="multipart/form-data">
								    	<table>
									    	<tr>
												<td width="20px"></td>
												<td width="80px">图片四：</td>
												<td width="200px" align="left">
													<input type="hidden" name="path" value="${param.tempPath }" />
													<input type="hidden" name="key" id="key4" />
													<input type="hidden" name="imageType" value="IMAGE4" />
													<input type="hidden" name="imageSessionName" id="imageSessionName_image4" value="${imageSessionName }">
													<span id="span4">
														<input type="file" name="file" id="file4" accept="image/*" onchange="check(this,'span4')">
													</span>
												</td>
												<td align="right">
													&nbsp;&nbsp;<a href="javascript:void(0)" onclick="uploadImage('file4','fm4', 'key4', 'aimage4','IMAGE4','divPreview4')" class="easyui-linkbutton" data-options="iconCls:'icon-upload'">上传</a>
												</td>
											</tr>	
										</table>
									</form>
								</td>
							</tr>	
							<tr height="15px">
								<td>
									<form action="<%=request.getContextPath()%>/archive/imageUpload" id="fm5" method="post" enctype="multipart/form-data" style="height:25;">
								    	<table>
									    	<tr>
												<td width="20px"></td>
												<td width="80px">图片五：</td>
												<td width="200px" align="left">
													<input type="hidden" name="path" value="${param.tempPath }" />
													<input type="hidden" name="key" id="key5" />
													<input type="hidden" name="imageType" value="IMAGE5" />
													<input type="hidden" name="imageSessionName" id="imageSessionName_image5" value="${imageSessionName }">
													<span id="span5">
														<input type="file" name="file" id="file5" accept="image/*" onchange="check(this,'span5')">
													</span>
												</td>
												<td align="right">
													&nbsp;&nbsp;<a href="javascript:void(0)" onclick="uploadImage('file5','fm5', 'key5', 'aimage5','IMAGE5','divPreview5')" class="easyui-linkbutton" data-options="iconCls:'icon-upload'">上传</a>
												</td>
											</tr>	
										</table>
									</form>
								</td>
							</tr>
							<tr>
								<td>
									<form action="<%=request.getContextPath()%>/archive/imageUpload" id="fm6" method="post" enctype="multipart/form-data">
								    	<table>
									    	<tr>
												<td width="20px"></td>
												<td width="80px">图片六：</td>
												<td width="200px" align="left">
													<input type="hidden" name="path" value="${param.tempPath }" />
													<input type="hidden" name="key" id="key6" />
													<input type="hidden" name="imageType" value="IMAGE6" />
													<input type="hidden" name="imageSessionName" id="imageSessionName_image6" value="${imageSessionName }">
													<span id="span6">
														<input type="file" name="file" id="file6" accept="image/*" onchange="check(this,'span6')">
													</span>
												</td>
												<td align="right">
													&nbsp;&nbsp;<a href="javascript:void(0)" onclick="uploadImage('file6','fm6', 'key6', 'aimage6','IMAGE6','divPreview6')" class="easyui-linkbutton" data-options="iconCls:'icon-upload'">上传</a>
												</td>
											</tr>	
										</table>
									</form>
								</td>
							</tr>	
							<tr>
								<td align="right">
									&nbsp;&nbsp;<a href="javascript:void(0)" onclick="closeAddIamgeDialog()" class="easyui-linkbutton" data-options="iconCls:'icon-back'">关闭</a>
								</td>
							</tr>	        		
			        	</table>
		        </div>
		    <div id="divDialog">
		    	<iframe scrolling="auto" id='openIframe' name="openIframe" frameborder="0"  src="" style="width:100%;height:100%;overflow: hidden;"></iframe> 
			</div>
	    </div>
