<%@page import="com.chinarewards.metro.core.common.Dictionary"%>
<%@ page language="java" contentType="text/html; charset=utf8" pageEncoding="utf8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />


<link id="easyuiTheme" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/extend-easyui-validate.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/common.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/constant.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/PCASClass.js"></script>


 <style type="text/css">
         
            tr .datagrid-row td div {
               overflow:hidden;
				text-overflow:ellipsis;
				white-space:nowrap;
            }
        </style>



<script>


$(function(){

//	doCellTip();
		$("input[type=checkbox]").css("display","none");		


	//alert($("select[name=taskStates]").val());
	
});

	
function getStatus(v){
    var status = ${statusJson};
    for(var i=0;i<status.length;i++){
        if(v == status[i].key){
        	return status[i].value;
        };
    };
}
         /**
         * 扩展两个方法
         */
        $.extend($.fn.datagrid.methods, {
            /**
             * 开打提示功能
             * @param {} params 提示消息框的样式
             */
            doCellTip: function(jq, params){
                function showTip(data, td, e){
                	//alert("width="+$(td).width()+"   size="+$(td).text().length);
                
                //	alert("text="+$(td).html());
                //	alert("class="+$(td).find("class").html());
                //	alert("text="+$(td).get(0).attr("class"));
                ///	alert("正文="+$(td).get(0).scrollWidth+"  包括边线的宽 =" +td.offsetWidth+"   文本长度："+$(td).text().length);
                    if ($(td).text() == "") 
                        return; 
                    
                    data.tooltip.text($(td).text()).css({
                        top: (e.pageY + 10) + 'px',
                        left: (e.pageX + 20) + 'px',
                        'z-index': $.fn.window.defaults.zIndex,
                        display: 'block'
                    });
                };
                return jq.each(function(){
                    var grid = $(this);
                    var options = $(this).data('datagrid');
                    if (!options.tooltip) {
                        var panel = grid.datagrid('getPanel').panel('panel');
                        var defaultCls = {
                            'border': '1px solid #333',
                            'padding': '2px',
                            'color': '#333',
                            'background': '#f7f5d1',
                            'position': 'absolute',
                            'max-width': '200px',
							'border-radius' : '4px',
							'-moz-border-radius' : '4px',
							'-webkit-border-radius' : '4px',
                            'display': 'none'
                        }
                        var tooltip = $("<div id='celltip'></div>").appendTo('body');
                        tooltip.css($.extend({}, defaultCls, params.cls));
                        options.tooltip = tooltip;
                        panel.find('.datagrid-body').each(function(){
                            var delegateEle = $(this).find('> div.datagrid-body-inner').length ? $(this).find('> div.datagrid-body-inner')[0] : this;
                            $(delegateEle).undelegate('td', 'mouseover').undelegate('td', 'mouseout').undelegate('td', 'mousemove').delegate('td', {
                                'mouseover': function(e){
                                    if (params.delay) {
                                        if (options.tipDelayTime) 
                                            clearTimeout(options.tipDelayTime);
                                        var that = this; 
                                        options.tipDelayTime = setTimeout(function(){
                                            showTip(options, that, e);
                                        }, params.delay);
                                    }
                                    else {
                                        showTip(options, this, e);
                                    }
                                    
                                },
                                'mouseout': function(e){
                                    if (options.tipDelayTime) 
                                        clearTimeout(options.tipDelayTime);
                                    options.tooltip.css({
                                        'display': 'none'
                                    });
                                },
                                'mousemove': function(e){
									var that = this;
                                    if (options.tipDelayTime) 
                                        clearTimeout(options.tipDelayTime);
                                    //showTip(options, this, e);
									options.tipDelayTime = setTimeout(function(){
                                            showTip(options, that, e);
                                        }, params.delay);
                                }
                            });
                        });
                        
                    }
                    
                });
            },
            /**
             * 关闭消息提示功能
             */
            cancelCellTip: function(jq){
                return jq.each(function(){
                    var data = $(this).data('datagrid');
                    if (data.tooltip) {
                        data.tooltip.remove();
                        data.tooltip = null;
                        var panel = $(this).datagrid('getPanel').panel('panel');
                        panel.find('.datagrid-body').undelegate('td', 'mouseover').undelegate('td', 'mouseout').undelegate('td', 'mousemove')
                    }
                    if (data.tipDelayTime) {
                        clearTimeout(data.tipDelayTime);
                        data.tipDelayTime = null;
                    }
                });
            }
        });

		
		function doCellTip(){
			$('#table').datagrid('doCellTip',{'max-width':'100px'});
		}
		function cancelCellTip(){
			$('#table').datagrid('cancelCellTip');
		}
		
		function changeTable(v){
			
		//	$('#table').datagrid({singleSelect:(v.value=='')});
			
		}
		function tableONLoad(){
		
			//cancelCellTip();
		//	doCellTip();
			if($("select[name=taskStates]").val()==''){
				$("input[type=checkbox]:eq(0)").css("display","none");		
			}
		};	
		   
	    function reset(){
	    	$('#searchForm')[0].reset();
	    }
</script>

</head>
<body>
	<!-- 查询条件Table -->
	<div style="margin:10px 0;">
	<!--
		<a href="#" onclick="doCellTip()">显示提示消息</a>
		<a href="#" onclick="cancelCellTip()">禁止消息显示</a>
     -->
		<div id="info"></div>
	</div>
	<form id="searchForm"  > 
		<table style="font-size:13px;">
			<tr>
				<td>任务名称:</td>
				<td><input type="text" name=taskName size="18"/></td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>状态:</td>
				<td>
					<select name="taskStates" id="taskStates" style="width:140px;height:22px;" onchange="changeTable(this);">
						<option value=""></option>
						<c:forEach items="${status }" var="s">
							<option value="${s.key }">${s.value }</option>
						</c:forEach>
					</select>	
				</td>
				<td>&nbsp;&nbsp;&nbsp;<a id="btn" href="javascript:void(0)" onclick="searchs()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a></td>
					<td>&nbsp;&nbsp;&nbsp;	<a style="margin-left: 10px;" href="javascript:void(0)" onclick="reset()" class="easyui-linkbutton"  data-options="iconCls:'icon-redo'">重置</a></td>

			</tr>
		<table>
	</form>

	<div id="toolbar">  
	  <span id="view" style="margin-left:15px;">  <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" plain="true" onclick="viewTask()" >查看任务</a></span> 
	    <span id="reset"> <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-reset" plain="true" onclick="resetTask()" >重置任务</a></span>
       <span id="pauser"> <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-pauser" plain="true" onclick="pauseTask()" >暂停</a></span>
	   <span id="restart"> <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-restart" plain="true" onclick="restartTask()" >重启</a></span>
	   <span id="cancel"> <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-undo" plain="true" onclick="cancelTask()" >取消</a></span>
       <span id="delete"> <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteTask()" >删除</a></span>  
     
     
    </div> 

	    
	<!-- 显示列表Table -->
	<table id="table" class="easyui-datagrid"  data-options="rownumbers:true,url:'listMessagesTask',fitColumns:true,loadMsg:'正在载入...',pagination:true,toolbar: '#toolbar',
		pageList:pageList,singleSelect:true,onSelect:function(rowIndex,rowData){checkSelect(rowData.taskId,rowData.taskStates);},
		onLoadSuccess: function(){tableONLoad();}">
	    <thead>  
	        <tr>  
	     
	           <th data-options="field:'taskId', checkbox:true,hidden:true"></th> 
	      
	            <th data-options="field:'taskStates',width:30,formatter:function(v){return getStatus(v)}">任务状态</th>
	            <th data-options="field:'taskName',width:30">任务名称</th>  
	            <th data-options="field:'planSendTime',width:30,formatter:function(v){return dateFormat(v)}">计划发送时间</th>
	            <th data-options="field:'actualSendTime',width:30,formatter:function(v){return dateFormat(v)}">实际发送时间</th>
	            <th data-options="field:'endTime',width:30,formatter:function(v){return dateFormat(v)}">结束时间</th>
	            <th data-options="field:'amount',width:30">总数目</th>
	            <th data-options="field:'successAmount',width:30">成功数目</th>
	            <th data-options="field:'failureAmount',width:30">失败数目</th>
	            <th data-options="field:'notSentAmount',width:30">未发送数目</th>
	        </tr>   
	    </thead>  
	</table> 
	
	<div style="text-align:left;">
  			<br>
  			<!--<button type="button" onclick="viewTask();"  id="view"  >查看任务</button>&nbsp;&nbsp;&nbsp;&nbsp;
  			<button type="button" onclick="pauseTask();" id="pauser">暂停</button>&nbsp;&nbsp;&nbsp;&nbsp;
  			<button type="button" onclick="restartTask();" id="restart">重启</button>&nbsp;&nbsp;&nbsp;&nbsp;
  			<button type="button" onclick="cancelTask();" id="cancel">取消</button>&nbsp;&nbsp;&nbsp;&nbsp;
  		    <button type="button" onclick="resetTask();" id="reset">重置任务</button>&nbsp;&nbsp;&nbsp;&nbsp;
   <button type="button" onclick="deleteTask();" id="delete">删除</button>&nbsp;&nbsp;&nbsp;&nbsp; -->	 
	</div>

<script type="text/javascript">


function searchs(){
	

    //load 加载数据分页从第一页开始, reload 从当前页开始

    $('#table').datagrid('load',getForms("searchForm"));
    $('#table').datagrid({singleSelect:($("#taskStates").val()=='')});
	showbuttow();
}


//pauser,restart,cancel,reset,del(0--disable;1-able)
function checkSelect(id,states){
	
	if(states==3){//暂停----取消、重启
		$("#reset").hide();
		$("#pauser").hide();
		$("#cancel").show();
		$("#delete").hide();
		$("#restart").show();
	}
	if(states==1){//执行中
		$("#restart").hide();
		$("#reset").hide();
		$("#delete").hide();
		
		$("#pauser").show();
		$("#cancel").show();
	}
	if(states==2){//结束
		$("#pauser").hide();
		$("#restart").hide();
		$("#cancel").hide();
		$("#reset").hide();
		$("#delete").show();
	}
	if(states==4){//取消
		$("#pauser").hide();
		$("#restart").hide();
		$("#cancel").hide();
		$("#reset").hide();
		$("#delete").show();
	}
	if(states==5){//创建中
		$("#pauser").hide();
		$("#restart").hide();
		$("#reset").hide();
		$("#delete").hide();
		$("#cancel").show();
		
	}
	if(states==6){//失败
		$("#pauser").hide();
		$("#cancel").hide();
		$("#restart").hide();
		$("#reset").show();
		$("#delete").show();
		
	}
	if(states==7){//未执行
		//$("#pauser").attr("disabled","disabled");
//		$("#restart").attr("disabled","disabled");
	//	$("#reset").attr("disabled","disabled");
		//$("#delete").attr("disabled","disabled");
		//$("#cancel").attr("disabled",false);
		$("#pauser").hide();
		$("#restart").hide();
		$("#reset").hide();
		$("#delete").hide();
		$("#cancel").show();
		
		
	}
}

function showbuttow(){
	$("#pauser").show();
	$("#restart").show();
	$("#reset").show();
	$("#delete").show();
	$("#cancel").show();
}

function viewTask(){
		var checkedObjs = $('input[type=checkbox][name=taskId]:checked');
		if ($(checkedObjs).size() < 1)
		{
			$.messager.alert("提示","请选择任务！","warning");
			return;
		}
		if($(checkedObjs).size() > 1){
			$.messager.alert("提示","查看任务时，只能选择一个！","warning"); 
			return;
		}
		var checkvalue=$(checkedObjs).val();
    parent.addTab('查看任务信息','message/viewTask?taskid='+checkvalue);
         
}
function pauseTask(){
	var checkedObjs = $('input[type=checkbox][name=taskId]:checked');
	if ($(checkedObjs).size() < 1)
	{
	
		$.messager.alert("提示","请选择任务！","warning");
		return;
	}
	 for(var i=0; i<checkedObjs.length; i++){
		 var checkvalue=$(checkedObjs[i]).val();
	
		$.ajax({
			url:'pauseTask',
			type:'post',
			data:'taskId='+checkvalue,
			success: function(data){
				showbuttow();
				$('#table').datagrid('reload');
				
			}
		}); 
	 }
}
function restartTask(){
	var checkedObjs = $('input[type=checkbox][name=taskId]:checked');
	if ($(checkedObjs).size() < 1)
	{
		$.messager.alert("提示","请选择任务！","warning");
	
		return;
	}
	
	 for(var i=0; i<checkedObjs.length; i++){
		 var checkvalue=$(checkedObjs[i]).val();
			$.ajax({
				url:'restartTask',
				type:'post',
				data:'taskid='+checkvalue,
				success: function(data){
					showbuttow();
					$('#table').datagrid('reload');
				}
			});
	 }
}
function cancelTask(){
	var checkedObjs = $('input[type=checkbox][name=taskId]:checked');
	if ($(checkedObjs).size() < 1)
	{
		$.messager.alert("提示","请选择任务！","warning");
		return;
	}
	 for(var i=0; i<checkedObjs.length; i++){
		 var checkvalue=$(checkedObjs[i]).val();
			$.ajax({
				url:'cancelTask',
				type:'post',
				data:'taskid='+checkvalue,
				success: function(data){
					showbuttow();
					$('#table').datagrid('reload');
				}
			}); 
	 }
	
}


//状态为失败的，才可以重置，继续发送失败的号码
function resetTask(){
	var checkedObjs = $('input[type=checkbox][name=taskId]:checked');
	if ($(checkedObjs).size() < 1)
	{
		$.messager.alert("提示","请选择任务！","warning");
		return;
	}
	 for(var i=0; i<checkedObjs.length; i++){
		 var checkvalue=$(checkedObjs[i]).val();
			$.ajax({
				url:'resetTask',
				type:'post',
				data:'taskid='+checkvalue,
				success: function(data){
					showbuttow();
					$('#table').datagrid('reload');
				}
			}); 
	 }
}
//失败、已结束、已取消的才可以删除
function deleteTask(){
	var checkedObjs = $('input[type=checkbox][name=taskId]:checked');
	if ($(checkedObjs).size() < 1)
	{
		$.messager.alert("提示","请选择任务！","warning");
		return;
	}
	$.messager.confirm("任务删除","确认删除该任务?",function(r){
		if(r){
			var dataTask="";
			 for(var i=0; i<checkedObjs.length; i++){
				 var checkvalue=$(checkedObjs[i]).val();
					$.ajax({
						url:'deleteTask',
						type:'post',
						data:'taskid='+checkvalue,
						success: function(data){
							  var d='任务删除成功!';
							if(checkedObjs.length==1){
								d=eval('('+data+')').msg+'任务删除成功!';
							}
								$.messager.show({  
					                title:'任务维护',  
					                msg:d,  
					                timeout:5000,  
					                showType:'slide'  
					            }); 
							showbuttow();
							$('#table').datagrid('reload');
						}
					}); 
		      }
				
		}
	});

	
}
</script>
</body>
</html>