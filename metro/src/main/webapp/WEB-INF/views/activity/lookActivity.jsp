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
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.json-2.4.js"></script>
	<script type="text/javascript">
	var baseURL = '<%=request.getContextPath()%>';
	
	function show(url,width,height){
		width = width> 500 ? 500: width;
		height = height> 300 ? 300: height;
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
			$('#searchbtn1').click(function(){
				$('#table1').datagrid('load',getForms("searchForm1"));
			});
			
			$('#searchbtn2').click(function(){
				$('#table2').datagrid('load',getForms("searchForm2"));
			});
			$('#updateAct').click(function(){
				$('#table2').datagrid('reload');
			});
			
			$('#updatePos').click(function(){
				$('#table3').datagrid('reload');
			});
			$('#tabAct').tabs({
				onSelect: function(title,index){
					if(index == 2){
						$('#table1').datagrid({
							url:'query_actBands?id='+${activity.id }
						});
					}else if(index == 3){
						$('#table3').datagrid({
							url:'query_posBands?id='+${activity.id }
						});
					}
				  }
			});
		});
	</script>
</head>
<body>
<div id="tabAct" class="easyui-tabs" style="width:650px;height:550px"> 

        <div title="活动信息" style="padding:10px">  
            <form id="updateForm" method="post" enctype="multipart/form-data">
            <fieldset>
			<legend style="color: blue;">活动基本信息</legend>
		     <table style="width: 600px;" >
		        	<tr>
		        	<input type="hidden" name="imageSessionName" id="imageSessionName_dataForm" value="${imageSessionName }">
		        	<input type="hidden" id="id" name="id" value="${activity.id }"/>
		        		<td width="80px;"><span style="font-weight: bolder;color: red;">*&nbsp;&nbsp;</span>活动名称：</td>
		        		<td style="border-bottom: 1px solid #ccc;"><c:out value="${activity.activityName }"></c:out></td>
		        		<td rowspan="8" colspan="2" >
		        		</td>
		        	</tr>
		        	<tr>
		        		<td width="80px;"><span style="font-weight: bolder;color: red;">*&nbsp;&nbsp;</span>开始时间：</td>
		        		<td style="border-bottom: 1px solid #ccc;">${activity.startDate }</td>
		        	</tr>
		        	<tr>
		        		<td width="80px;"><span style="font-weight: bolder;color: red;">*&nbsp;&nbsp;</span>结束时间：</td>
		        		<td style="border-bottom: 1px solid #ccc;">${activity.endDate }</td>
		        	</tr>
		        	<tr>
		        		<td width="80px;"><span style="font-weight: bolder;color: red;">*&nbsp;&nbsp;</span>描述：</td>
		        		<td style="border-bottom: 1px solid #ccc;">
		        			<c:out value="${activity.description}"></c:out>
		        		</td>
		        	</tr>
		        	<tr>
		        		<td width="80px;">&nbsp;&nbsp;&nbsp;举办方：</td>
		        		<td style="border-bottom: 1px solid #ccc;"><c:out value="${activity.hoster}"></c:out></td>
		        	</tr>
		        	<tr>
		        		<td width="80px;">&nbsp;&nbsp;&nbsp;活动网址：</td>
		        		<td style="border-bottom: 1px solid #ccc;">${activity.activityNet }</td>
		        	</tr>
		        	<tr>
		        		<td width="80px;">&nbsp;&nbsp;&nbsp;联系人：</td>
		        		<td style="border-bottom: 1px solid #ccc;">${activity.contacts }</td>
		        	</tr>
		        	<tr>
		        		<td width="80px;">&nbsp;&nbsp;&nbsp;联系电话：</td>
		        		<td style="border-bottom: 1px solid #ccc;">${activity.conTel }</td>
		        	</tr>
		        </table>
		        </fieldset>
		        <br>
		        <fieldset>
				<legend style="color: blue;">优惠信息</legend>
					<table style="width: 600px;" >
						<tr>
							<td width="60px;"><span style="font-weight: bolder;color: red;">*&nbsp;&nbsp;</span>标题：</td>
							<td style="border-bottom: 1px solid #ccc;"><c:out value="${activity.title }"></c:out></td>
						</tr>
						<tr>
							<td width="60px;">&nbsp;&nbsp;&nbsp;&nbsp;描述：</td>
							<td style="border-bottom: 1px solid #ccc;"><c:out value="${activity.descr }"></c:out></td>
						</tr>
						<tr>
							<td width="130px;">&nbsp;&nbsp;&nbsp;&nbsp;Pos机存根显示权益：</td>
							<td style="border-bottom: 1px solid #ccc;"><c:out value="${activity.posDescr }"></c:out></td>
						</tr>
					</table>
				</fieldset>
	        </form> 
        </div>
        <div title="上传活动图片" style="padding:20px;text-align:center;"><!-- 图片维护start -->
			<div align="left">图片预览：</div>
	    	<div id="divPreview" >
				<a id="aimage1" href=""><img id="image1" src="" style="width: 400px;height: 250px;"></a><br><br><br>
			</div>
		    <div id="divDialog">
		    	<iframe scrolling="no" id='openIframe' name="openIframe" frameborder="0"  src="" style="width:100%;height:100%;overflow: hidden;"></iframe> 
			</div>
	    </div><!-- 图片维护end -->   
        <div title="参与品牌" style="padding:10px">  
            
			<form id="searchForm1" method="post" >
				<fieldset>
					<legend style="color: blue;">查询条件</legend>
					
					<table style="" id="search1">
						<tr>
							<td>品牌名称：</td>
							<td><input id="name" name="name"  type="text"/></td>
							<td>
								<a id="searchbtn1" href="javascript:void(0)"  class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
							</td>
						</tr>
					</table>
				</fieldset>
			</form>

			<!-- 显示列表Table -->
			<table style="height:350px" id="table1"  title="参与活动的品牌" style="" class="easyui-datagrid" data-options="fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
				rownumbers:true,pageList:pageList,singleSelect:false">
			    <thead>  
			        <tr>  
			        	<th checkbox="true"></th>
			        	<th data-options="field:'gid',width:30,hidden:true">活动编号</th>
			            <th data-options="field:'name',width:30">品牌名称</th>  
			            <th data-options="field:'companyName',width:30">公司名称</th>
			            <th data-options="field:'joinTime',width:30,formatter:function(v){return dateFormat(v);}">加入时间</th>
			        </tr>  
			    </thead>  
			</table> 
        </div>  
        <div title="POS机维护" style="padding:10px">  

			<!-- 显示列表Table -->
			<table style="height:400px" id="table3"  title="所绑定活动的Pos机信息" style="" class="easyui-datagrid" data-options="fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
				rownumbers:true,pageList:pageList,singleSelect:false">
			    <thead>  
			        <tr>  
			        	<th checkbox="true"></th>
			        	<th data-options="field:'id',width:30,hidden:true">POS机编号</th>
			        	<th data-options="field:'code',width:30">POS机号</th>
			            <th data-options="field:'bindDate',width:30,formatter:function(v){return v;}">绑定时间</th>
			        </tr>  
			    </thead>  
			</table>  
        </div>  
    </div> 
</div> 
</body>
</html>