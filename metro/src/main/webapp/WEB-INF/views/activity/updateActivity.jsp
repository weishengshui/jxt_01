<%@ page language="java" contentType="text/html; charset=utf8" pageEncoding="utf8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<style type="text/css">
	body {
		font-family: 黑体、宋体、Arial;
		font-size: 12px;
	}
</style>
<link id="easyuiTheme" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/common.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/map.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.json-2.4.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/extend-easyui-validate.js"></script>
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
	
	
	
	$(function(){
		
		style="display:none";
    	document.getElementById('divPreview').style.display = "none";

    	var images = $.toJSON(${images});
		images = eval('('+images+')');
		if(images){
			for(var i in images){
				var image = images[i];
				if(image){
					$('#key').val(i);
					$('#aimage1').attr('href','javascript:show(\''+baseURL+'/archive/imageShow?formalPath=ACTIVITY_IMAGE_DIR&contentType='+image.mimeType+'&fileName='+image.url+'\',\''+image.width+'\',\''+image.height+'\')');
					$('#image1').attr('src',baseURL+'/archive/imageShow?formalPath=ACTIVITY_IMAGE_DIR&contentType='+image.mimeType+'&fileName='+image.url);
					style="display:none";
			    	document.getElementById('divPreview').style.display = "";
			    	break;
				}else{
					style="display:none";
			    	document.getElementById('divPreview').style.display = "none";
					break;
				}
			}
		}
	}
);
		function getId(){
			return $("#id").val();
		}
		
		$(document).ready(function(){
			$('#savePic').attr("disabled","true");
			$('#searchbtn1').click(function(){
				$('#table1').datagrid('load',getForms("searchForm1"));
			});
			
			$('#searchbtn2').click(function(){
				var values = getForms("searchForm2");
				var companyName = values.companyName;
				var name = values.name;
				$('#table2').datagrid({
					url:'findBrandNotBandAct',
					queryParams: {
						companyName:companyName,
						name:name,
	    				id: getId()
	    			}
				});
				//$('#table2').datagrid('load',getForms("searchForm2"));
			});
			$('#updateAct').click(function(){
				$('#win').window('open');
				//$('#table2').datagrid('reload');
				$('#table2').datagrid({
					url:'findBrandNotBandAct',
					queryParams: {
	    				id: getId()
	    			}
				});
			});
			
			$('#updatePos').click(function(){
				$('#posForm').form('clear');
				$('#winPos').window('open');
				$('#table3').datagrid('reload');
			});
			
			$('#updateActivity').click(function(){
				var name = $("input[name='activityName']").val();
				var startDate = $("input[name='startDate']").val();
				var endDate = $("input[name='endDate']").val();
				var title = $("input[name='title']").val();
				if(name.length>200){
					$.messager.alert('提示',"活动名称长度不能超过200字符");
					return false ;
				}
				if(title.length>200){
					$.messager.alert('提示',"标题长度不能超过200字符");
					return false ;
				}
				if(startDate == ''){
					$.messager.alert('提示',"请选择开始时间！");
					return false ;
				}
				
				if(endDate == ''){
					$.messager.alert('提示',"请选择结束时间！");
					return false ;
				}
				
				var tag = false ;
				$.ajax({
		            url:'checkActNameAndTime',
		            type:'post',
		            async: false,
		            data:{
		            	name:name,
		            	dTime:startDate,
		            	id:${activity.id }
		            },
		            success:function(data){
		            	if(data == 1){
		            		tag = true ;
		            	}
		            }
		        });
				
				if(tag){
					$.messager.alert('提示','活动名称和开始日期不能相同！');
					return false ;
				}
				
				$('#updateForm').form('submit', {
				    url:'update',
				    success:function(data){ 
				    	if(data == 1){
				    		$.messager.show({  
				    			title:'提示信息',  
				    			msg:'修改成功！',  
				    			timeout:5000,  
				    			showType:'slide'  
				    		});
				    	}
				    },
				    error:function(data){
				    	//alert('保存失败');
					}
				});	
			});
			
			$('#tabAct').tabs({
				onSelect: function(title,index){
					if(index == 2){
						$('#table1').datagrid({
							url:'query_actBands?id='+${activity.id }
						});
						$('#table2').datagrid({
							url:'findBrandNotBandAct?id='+${activity.id }
						});
					}else if(index == 3){
						$('#table3').datagrid({
							url:'query_posBands?id='+${activity.id }
						});
					}
				  }
			});
			$('#win').window({
				onClose:function(){
					$('#searchForm2').form('clear');
				}
			});
			$('#delAct').click(function(){
				var data ='';
				var rows = $('#table1').datagrid('getSelections');
				for(var i in rows){
					data += rows[i].gid+',';
				}
				data = data.substring(0, data.length -1);
				if(rows.length == 0){
					$.messager.alert('提示',"请先选择要删除的品牌");
					return false; 	
				}
				$.messager.confirm('信息','确认是否删除?',function(r){   
					if (r){   
						$.ajax({
				            url:'delActAndBran',
				            type:'post',
				            async: false,
				            data:{
				            	ids:data,
				            	tag:'update'
				            },
				            success:function(data){
				            	if(data == 1){
				            		$.messager.show({  
						    			title:'提示信息',  
						    			msg:'删除成功！',  
						    			timeout:5000,  
						    			showType:'slide'  
						    		});
				            		$('#table1').datagrid('reload');
				            	}else{
				            		$.messager.show({  
						    			title:'提示信息',  
						    			msg:'删除失败！',  
						    			timeout:5000,  
						    			showType:'slide'  
						    		});
				            	}
				            }
				        });
					}   
				});
				
			});
			
			$('#savePic').click(function(){
				if($('#file1').val()==""){
					$.messager.alert('提示',"请先添加图片");
					return ;
				}
				var imgSessionName = $("input[id='imageSessionName_dataForm']").val();
				$.ajax({
		            url:'savePic',
		            type:'post',
		            async: false,
		            data:{
		            	actId:getId(),
		            	imageSessionName:imgSessionName
		            },
		            success:function(data){
		            	if(data == 1){
		            		$.messager.show({  
				    			title:'提示信息',  
				    			msg:'成功保存图片信息！',  
				    			timeout:5000,  
				    			showType:'slide'  
				    		});
		            	}
		            }
		        });
			});
			
			$('#actSure').click(function(){
				var data ='';
				var rows = $('#table2').datagrid('getChecked');
				for(var i in rows){
					data += rows[i].id+',';
				}
				data = data.substring(0, data.length -1);
				if(rows.length == 0){
					$.messager.alert('提示',"请先选择要参加活动的品牌");
					return false; 	
				}
				$.ajax({
		            url:'addBrandAct',
		            type:'post',
		            async: false,
		            data:{
		            	ids:data,
		            	tag:'update',
		            	actId:getId()
		            },
		            beforeSend:function(){
		            	if(getId()==""){
		            		$.messager.alert('提示',"请先添加活动信息！");
		            		$('#win').window('close');
		            		$('#tab').tabs('enableTab', 0);
		            		return false ;
		            	}
		            },
		            success:function(data){
		            	$.messager.show({  
			    			title:'提示信息',  
			    			msg:'品牌成功参加活动！',  
			    			timeout:5000,  
			    			showType:'slide'  
			    		});
		            	$('#table2').datagrid('reload');
		            	$('#win').window('close');
		            	$('#table1').datagrid('reload');
		            	$('#searchForm2').form('clear');
		            }
		        });
				
			});
			
			
			$('#delPos').click(function(){
				var data ='';
				var rows = $('#table3').datagrid('getSelections');
				for(var i in rows){
					data += rows[i].id+',';
				}
				data = data.substring(0, data.length -1);
				if(rows.length == 0){
					$.messager.alert('提示',"请先选择要删除的POS机");
					return false; 	
				}
				$.messager.confirm('信息','确认是否删除?',function(r){   
					if (r){   
						$.ajax({
				            url:'delPosBand',
				            type:'post',
				            async: false,
				            data:{
				            	ids:data,
				            	tag:'update'
				            },
				            success:function(data){
				            	if(data == 1){
				            		$.messager.show({  
						    			title:'提示信息',  
						    			msg:'删除成功！',  
						    			timeout:5000,  
						    			showType:'slide'  
						    		});
				            		$('#table3').datagrid('reload');
				            	}else{
				            		$.messager.show({  
						    			title:'提示信息',  
						    			msg:'删除失败！',  
						    			timeout:5000,  
						    			showType:'slide'  
						    		});
				            	}
				            	
				            }
				        }); 
					}   
				});
			});
			
			
			$('#savePos').click(function(){
				var code = $("#code").val();
				var bindDate = $("input[name='bindDate']").val();
				$.ajax({
		            url:'savePos',
		            type:'post',
		            async: false,
		            data:{
		            	code:code,
		            	actId:getId(),
		            	tag:'update',
		            	bindDate:bindDate
		            },
		            beforeSend:function(){
		            	if(code == ""){
		            		$.messager.alert('提示',"请输入绑定POS机！");
		            		return false ;
		            	}
		            	if(bindDate == ""){
		            		$.messager.alert('提示',"请输入绑定日期！");
		            		return false ;
		            	}
		            	var flag = false;
		            	$.ajax({
		    	            url:'checkPosBand',
		    	            type:'post',
		    	            async: false,
		    	            data:{
		    	            	code:code
		    	            },
		    	            success:function(data){
		    	            	flag = data ;
		    	            }
		    	        });
		            	if(flag > 0){
		            		$.messager.alert('提示',"POS机编号为"+code+"已经绑定了,请重新输入！");
		            		return false ;
		            	}
		            	if(getId()==""){
		            		$.messager.alert('提示',"请先添加活动信息！");
		            		$('#winPos').window('close');
		            		$('#tabAct').tabs('enableTab', 0);
		            		return false ;
		            	}
		            },
		            success:function(data){
		            	$.messager.show({  
			    			title:'提示信息',  
			    			msg:'保存成功',  
			    			timeout:5000,  
			    			showType:'slide'  
			    		});
		            	$('#winPos').window('close');
		            	$('#table3').datagrid('reload');
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
			$('#savePic').removeAttr("disabled");
			$('#'+formId).form('submit',{
				success:function(result){
					result = eval('('+result+')');
					if(!result.key){
						$.messager.alert('提示',"请检查图片是否是完好的");
						return;
					}
					$('#'+keyId).val(result.key);
					$('#imageSessionName_dataForm').val(result.imageSessionName);
					$('#imageSessionName_imageForm').val(result.imageSessionName);
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
<div id="tabAct" class="easyui-tabs" style="width:650px;height:550px">  
        <div title="活动信息新增" style="padding:10px">  
            <form id="updateForm" method="post" enctype="multipart/form-data">
            <fieldset>
			<legend style="color: blue;">活动基本信息</legend>
		     <table style="width: 600px;" >
		        	<tr>
		        	<input type="hidden" name="imageSessionName" id="imageSessionName_dataForm" value="${imageSessionName }">
		        	<input type="hidden" id="id" name="id" value="${activity.id }"/>
		        		<td><span style="font-weight: bolder;color: red;">*&nbsp;&nbsp;</span>活动名称：</td>
		        		<td><input id="activityName" value='<c:out value="${activity.activityName }"></c:out>' class="easyui-validatebox" data-options="required:true" name="activityName" type="text" style="width: 211px;"/></td>
		        	</tr>
		        	<tr>
		        		<td><span style="font-weight: bolder;color: red;">*&nbsp;&nbsp;</span>开始时间：</td>
		        		<td><input id="startDate" value="${activity.startDate }" name="startDate" type="text" style="width: 215px;" class="easyui-datetimebox" editable="false"/></td>
		        	</tr>
		        	<tr>
		        		<td><span style="font-weight: bolder;color: red;">*&nbsp;&nbsp;</span>结束时间：</td>
		        		<td><input id="endDate" value="${activity.endDate }" name="endDate" type="text" style="width: 215px;" class="easyui-datetimebox" editable="false"/></td>
		        	</tr>
		        	<tr>
		        		<td><span style="font-weight: bolder;color: red;">*&nbsp;&nbsp;</span>描述：</td>
		        		<td>
		        			<textarea id="description"  class="easyui-validatebox" data-options="required:true" name="description" rows="3" cols="24"><c:out value="${activity.description}"></c:out></textarea>
		        		</td>
		        	</tr>
		        	<tr>
		        		<td>&nbsp;&nbsp;&nbsp;举办方：</td>
		        		<td><input id="hoster" name="hoster" value='<c:out value="${activity.hoster}"></c:out>' type="text" style="width: 211px;"/></td>
		        	</tr>
		        	<tr>
		        		<td>&nbsp;&nbsp;&nbsp;活动网址：</td>
		        		<td><input id="activityNet" name="activityNet" value="${activity.activityNet }" class="easyui-validatebox" data-options="validType:'url'" type="text" style="width: 211px;"/></td>
		        	</tr>
		        	<tr>
		        		<td>&nbsp;&nbsp;&nbsp;联系人：</td>
		        		<td><input id="contacts" name="contacts" type="text" value="${activity.contacts }" style="width: 211px;"/></td>
		        	</tr>
		        	<tr>
		        		<td>&nbsp;&nbsp;&nbsp;联系电话：</td>
		        		<td><input id="conTel" name="conTel" type="text" value="${activity.conTel }" style="width: 211px;" class="easyui-validatebox" data-options="validType:'phoneNumber'"/></td>
		        	</tr>
		        </table>
		        </fieldset>
		        <br>
		        <fieldset>
				<legend style="color: blue;">优惠信息</legend>
					<table style="width: 600px;" >
						<tr>
							<td><span style="font-weight: bolder;color: red;">*&nbsp;&nbsp;</span>标题：</td>
							<td><input id="title" class="easyui-validatebox" data-options="required:true" name="title" type="text" value='<c:out value="${activity.title }"></c:out>' style="width: 211px;"/></td>
							<td>Pos机存根显示权益：</td>
						</tr>
						<tr>
							<td>&nbsp;&nbsp;&nbsp;描述：</td>
							<td><textarea id="descr"  name="descr" rows="3" cols="24"><c:out value="${activity.descr }"></c:out></textarea></td>
							<td><textarea id="posDescr"  name="posDescr" rows="3" cols="24"><c:out value="${activity.posDescr }"></c:out></textarea></td>
						</tr>
					</table>
				</fieldset>
				<br><br>
				<div align="center">
					<a id="updateActivity" href="javascript:void(0)" data-options="iconCls:'icon-save'" class="easyui-linkbutton" >保存</a>
				</div>
				
	        </form> 
        </div>  
        <div title="上传活动图片" style="padding:20px;text-align:center;"><!-- 图片维护start -->
			<div style="">
		        	<form action="<%=request.getContextPath()%>/brand/imageUpload" id="fm2" method="post" enctype="multipart/form-data">
				    	<table>
				    	<tr>
							<td width="20px"></td>
							<td width="80px">请选择图片：</td>
							<td width="200px" align="left">
								<input type="hidden" name="path" value="ACTIVITY_IMAGE_BUFFER">
								<input type="hidden" name="key" id="key" />
								<input type="hidden" name="imageSessionName" id="imageSessionName_imageForm" value="${imageSessionName }">
								<span id="span1">
									<input type="file" name="file" id="file1" accept="image/*" onchange="check(this,'span1')">
								</span>
							</td>
							<td width="100px">&nbsp;&nbsp;
							<a href="javascript:void(0)" onclick="uploadImage('file1','fm2', 'key', 'aimage1','image1','divPreview')" data-options="iconCls:'icon-upload'"  class="easyui-linkbutton" >上传</a>
							</td>
							<td>
								<a id="savePic" href="javascript:void(0)" data-options="iconCls:'icon-save'" class="easyui-linkbutton" >保存</a>
							</td>
						</tr>
				    </table>
			    </form>
	        </div><br><br>
			<div align="left">图片预览：</div>
	    	<div id="divPreview" >
				<a id="aimage1" href=""><img id="image1" src="" style="width: 400px;height: 250px;"></a><br><br><br>
				<a href="javascript:void(0)" onclick="deleteImage('key','divPreview')" class="easyui-linkbutton" >删除</a>
			</div>
		    <div id="divDialog">
		    	<iframe scrolling="auto" id='openIframe' name="openIframe" frameborder="0"  src="" style="width:100%;height:100%;overflow: hidden;"></iframe> 
			</div>
	    </div><!-- 图片维护end --> 
        <div title="参与品牌" style="padding:10px">  
            
			<form id="searchForm1" method="post" >
				<table style="" id="search1">
					<tr>
						<td>品牌名称：</td>
						<td><input id="name" name="name"  type="text"/></td>
						<td>
							<a id="searchbtn1" href="javascript:void(0)"  class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
							<a style="margin-left: 20px;" href="javascript:void(0)" data-options="iconCls:'icon-redo'" onclick="$('#searchForm1').form('clear');" class="easyui-linkbutton" >重置</a>
						</td>
					</tr>
				</table>
			</form>

			<!-- 显示列表Table -->
			<table style="height:350px" id="table1"  title="" style="" class="easyui-datagrid" data-options="fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
				rownumbers:true,pageList:pageList,toolbar: '#toolbar_1',singleSelect:false">
			    <thead>  
			        <tr>  
			        	<th data-options="field:'gid',width:30,hidden:true">活动编号</th>
			            <th data-options="field:'name',width:30">品牌名称</th>  
			            <th data-options="field:'companyName',width:30">公司名称</th>
			            <th data-options="field:'joinTime',width:30,formatter:function(v){return dateFormat(v);}">加入时间</th>
			        </tr>  
			    </thead>  
			</table> 
			<br>
			<div id="toolbar_1">
				<a id="updateAct" href="javascript:void(0)" onclick="" iconCls="icon-add" class="easyui-linkbutton" >新增</a>
				<a id="delAct" href="javascript:void(0)" onclick="" iconCls="icon-remove" class="easyui-linkbutton" >删除</a>
			</div>
        </div>  
        <div title="POS机维护" style="padding:10px">  

			<!-- 显示列表Table -->
			<table style="height:400px" id="table3"  title="" style="" class="easyui-datagrid" data-options="fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
				rownumbers:true,pageList:pageList,toolbar: '#toolbar_2',singleSelect:false">
			    <thead>  
			        <tr>  
			        	<th data-options="field:'id',width:30,hidden:true">POS机编号</th>
			        	<th data-options="field:'code',width:30">POS机号</th>
			            <th data-options="field:'bindDate',width:30,formatter:function(v){return v;}">绑定时间</th>
			        </tr>  
			    </thead>  
			</table>  
			<br>
			<div id="toolbar_2">
				<a id="updatePos" href="javascript:void(0)" onclick="" iconCls="icon-add" class="easyui-linkbutton" >新增</a>
				<a id="delPos" href="javascript:void(0)" onclick="" iconCls="icon-remove" class="easyui-linkbutton" >删除</a>
			</div>
        </div>  
    </div> 
	<div id="win" class="easyui-window" title="选择参与活动的品牌" style="width:700px;height:350px"  
	        data-options="modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false">  
	    	<form id="searchForm2" method="post" >
				<table style="" id="search">
					<tr>
						<td>品牌名称：</td>
						<td><input id="name" name="name" type="text"/></td>
						<td>公司名称：</td>
						<td><input id="companyName" name="companyName" type="text"/></td>
						<td>
							<a id="searchbtn2" href="javascript:void(0)"  class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
							<a style="margin-left: 20px;" href="javascript:void(0)" data-options="iconCls:'icon-redo'" onclick="$('#searchForm2').form('clear');" class="easyui-linkbutton" >重置</a>
						</td>
					</tr>
				</table>
			</form>

			<!-- 显示列表Table -->
			<table id="table2" style="height:200px" idField="name" style="" class="easyui-datagrid" data-options="fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
				rownumbers:true,pageList:pageList,singleSelect:false">
			    <thead>  
			        <tr>  
			        	<th field="ck" checkbox="true"></th>
			        	<th data-options="field:'id',width:30,hidden:true">品牌编号</th> 
			            <th data-options="field:'name',width:30">品牌名称</th>  
			            <th data-options="field:'companyName',width:30">公司名称</th>
			        </tr>  
			    </thead>  
			</table> 
			
			<br>
			<a id="actSure" href="javascript:void(0)" onclick="" iconCls="icon-ok" class="easyui-linkbutton" >确定</a>  
	</div>
	
	</table>
	<div id="winPos" class="easyui-window" title="添加绑定的POS机" style="width:280px;height:160px"  
        data-options="modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false"> 
        <br>
        <form id="posForm">
        	<table>
        		<tr>
        			<td>绑定POS机：</td>
        			<td>
        				<input type="text" name="code" id="code" />
        			</td>
        		</tr>
        		<tr>
        			<td>绑定日期：</td>
        			<td>
        				<input type="text" name="bindDate" style="width: 155px" id="bindDate" class="easyui-datetimebox" />
        			</td>
        		</tr>
        		<tr>
        			<td colspan="2" align="right">
        				<a id="savePos" href="javascript:void(0)" onclick="" iconCls="icon-save" class="easyui-linkbutton" >保存</a>
        			</td>
        		</tr>
        	</table>
        </form> 
    </div>  
</div> 
</body>
</html>