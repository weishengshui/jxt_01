<%@ page language="java" contentType="text/html; charset=utf8"
	pageEncoding="utf8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" type="text/css"
	href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css"
	href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<link id="easyuiTheme" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/common.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery/ajaxfileupload.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/uuid.js"></script>
<style type="text/css">
table tr{

}

</style>
<script type="text/javascript">
		var baseURL = '<%=request.getContextPath()%>';
	    $(function(){
	    });
	    
	
</script>

</head>
<body>
		<fieldset style="font-size: 14px;width:700px;margin-top:20px;margin-left:10px;">
					<form action="addSave" method="post" id="messageForm" target="suc"  enctype="multipart/form-data">  
					 
						<table  border="0" >
					       <tr>
								<td>&nbsp;<span style="color: red;">*</span>&nbsp;任务名称:</td>
								<td>
								  <input id="taskName" name="taskName" type="text" style="width:150px" class="easyui-validatebox" data-options="required:true" /> 
								</td>
							</tr>
							
							<tr id="trcontent">
								<td>&nbsp;<span style="color: red;">*</span>&nbsp;短信内容:</td>
								<td><textarea name="content" id="overFont" style="height: 80px; width: 380px;"  data-options="required:true"  onfocus="cancelCheckC()"></textarea></td>
							</tr>
							<tr>
								<td>
								    &nbsp;&nbsp;<input type="radio" name="sendType" value="1" checked="checked"> 立即发送
								</td>
							</tr>
							<tr id="trplanSendDate">
								<td>
								    &nbsp;&nbsp;<input type="radio" name="sendType" value="2"/> 计划发送时间 
								</td>
							    <td>
							      <input id="planSendDate" name="planSendDate" type="text" style="width:150px" class="easyui-datetimebox" editable="false" />
							    </td>
							</tr>
							<tr id="trtelephone">
								<td>
								     &nbsp;<span style="color: red;">*</span> &nbsp;接受号码<span style="font-size: 13px;">(只能上传csv格式文件)：</span>
								</td>
							    <td>
							      <input type="file" name="telephoneFile" id="telephoneFile" style="width:150px"  onchange="check(this)" class="easyui-validatebox"  onfocus="cancelCheckF()">
							    </td>
							</tr>
							
							<tr>
									<td align="center" colspan="4">
									   <a id="btn" href="javascript:void(0)" onclick="doSubmit()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
									<a style="margin-left: 10px;" href="javascript:void(0)" onclick="javascript:$('#messageForm')[0].reset()" class="easyui-linkbutton"  data-options="iconCls:'icon-redo'">重置</a>
									<input type="hidden" name="uuid" id="uuid" />
									
									</td>
								</tr>
							</table>
						
						</form>
						<div id="fileDia" class="easyui-dialog" title="文件预览" style="width:400px;height:400px;"  
					        data-options="resizable:true,modal:true,inline:false,closed:true">
						        <div style="text-align:center;">
						        	<img id="perviewFile" name="perviewFile" src="" />
						        </div>
						</div> 
						
					<div id="progressDialog" class="easyui-dialog" title="正在准备数据，请稍候。。。"
						style="width: 400px; height: auto;align:center;"
						data-options="resizable:false,modal:true,closed:true,closable:false">
						<div id="progress" class="easyui-progressbar" style="width:380px;"></div>
					</div>
	</fieldset>
<script type="text/javascript">
var uuid = new UUID().id;
var timeId;
		function cancelCheckC(){
				$("#checkC").remove();
	   }
		function cancelCheckF(){
			$("#checkT").remove();
       }
	    function doSubmit(){
	    	var con=$("#overFont").val();
	    	var checkc=$("#checkC").html();
	    	if ((con==null||$.trim(con).length<1)&&$.trim(checkc).length<1){
	    		$("#trcontent").after("<tr  id='checkC'><td style='color: red;'>短信内容不能为空！</td></tr>");
	    		return;
	    	}
	    	var tf=$("#telephoneFile").val();
	    	var checkt=$("#checkT").html();
	    	if((tf==null||$.trim(tf).length<1)&&$.trim(checkt).length<1){
	    		$("#trtelephone").after("<tr id='checkT'><td style='color: red;'>请上传号码文件！</td></tr>");
	    		return;
	    	}
	    	uuid = new UUID().id;
	    	$("#uuid").val(uuid);
	    	
			$('#messageForm').form('submit',{
				success:function(result){
					var message=eval('('+result+')').msg;
					//alert(eval('('+result+')').msg);
					$.messager.show({  
		                title:'新增短信营销',  
		                msg:message,  
		                timeout:5000,  
		                showType:'slide'  
		            }); 
					
					$("#taskName").val("");
					$("#overFont").val("");
				//	$("#trplanSendDate td").eq(1).remove();
				//	$("#trplanSendDate td").after('<input id="planSendDate" name="planSendDate" type="text" style="width:150px" class="easyui-datetimebox" editable="false" />');
					$("#telephoneFile").val("");
			
				// location.replace(location);
				}
			}); 
			openProgressDialog();
			
		}
	    
	    
	    function openProgressDialog(){
			$('#progressDialog').dialog('open');
			$('#progressDialog').dialog('center');
			$('#progress').progressbar('setValue', 0);
			// getProgress();
			timeId = window.setInterval("getProgress()",500);
		}
		 function getProgress(){
			var value = $('#progress').progressbar('getValue');
			if(value < 100){
		        $.ajax({
		        	url: baseURL+'/getProgress?key='+uuid+'&temp='+(new Date().getTime()),
		        	async: false,
		        	success: function(data){
		        		if(data){
			        		data = eval('('+data+')');
			        		$('#progress').progressbar('setValue', data);  
		        		}
		        	}
		        });
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
		
	    function check(path){
			var filepath=path.value;
			filepath=filepath.substring(filepath.lastIndexOf('.')+ 1,filepath.length);
			filepath = filepath.toLocaleLowerCase();
			if(filepath != 'csv' ){
				alert("只能上传csv 格式的文件");
				
				path.value="";
				$("#telephoneFile").replaceWith('<input type="file" name="telephoneFile" id="telephoneFile" style="width:150px"  onchange="check(this)" class="easyui-validatebox"  onfocus="cancelCheckF()">');
			}
		}
		function openDialog(){
			$('#dd').dialog('center');
			$('#dd').dialog('open');
		}
		function previewFile(fileId){
	    	
			if($('#'+fileId).val()==''){
				alert("请先添加文件");
				return;
			}
			var width, height;
			width = '346px';
			height = '346px';
			var input = document.getElementById(fileId);
			var imgPre = document.getElementById('perviewFile');
			if($.browser.msie){
				input.select();
				var url = document.selection.createRange().text;
				var imgDiv = document.createElement("div");
				imgDiv.setAttribute("id",imgPre.id);
				var parent = imgPre.parentNode;
				parent.appendChild(imgDiv);
				parent.removeChild(imgPre);
			    imgDiv.style.width = width;    
				imgDiv.style.height = height;
			    imgDiv.style.filter="progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod = scale)";   
			    imgDiv.filters.item("DXImageTransform.Microsoft.AlphaImageLoader").src = url;
			}else {
				if (input.files && input.files[0]) {
		        	var reader = new FileReader();
		            reader.onload = function (e) {
		                    $('#perviewFile').attr('src', e.target.result);
		                    $('#perviewFile').attr('width', width);
		                    $('#perviewFile').attr('height', height);
		                };
		                reader.readAsDataURL(input.files[0]);
		        } 
			}
			$('#fileDia').resizable({  
			    maxWidth:20,  
			    maxHeight:100  
			}); 
			$('#fileDia').dialog('center');
			$('#fileDia').dialog('open');
		}
		function deleteFile(fileId){
			$('#'+fileId).val('');
		}
</script>
	
</body>
</html>