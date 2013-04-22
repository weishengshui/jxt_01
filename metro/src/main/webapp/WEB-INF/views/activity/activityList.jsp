<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
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
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<script type="text/javascript">
	function operates(i, o){
		var v ;
		if(stateCompera(v,o,i) == '已取消' || stateCompera(v,o,i) == '已结束'){
			$('#updateAct').hide();
			$('#cancerAct').hide();
			$('#deleteAct').show();
		}else if(stateCompera(v,o,i) == '未开始'){
			$('#updateAct').show();
			$('#cancerAct').show();
			$('#deleteAct').show();
		}else if(stateCompera(v,o,i) == '进行中'){
			$('#deleteAct').hide();
			$('#updateAct').show();
			$('#cancerAct').show();
		}
	} 
	
	function edit(id_,name_){
		var id = id_;
		var name = name_;
		if(id == undefined){
			var row = $('#table').datagrid('getSelected');
			if(row == null){
				alert("请选择要编辑的数据");
				return;
			}
			id = row.id;
			name = decodeURIComponent(row.activityName);
			if(name == 'null'){
				name = row.activityName;
			}
		}
		parent.addTab('维护'+name+'信息','activity/queryActivity?id='+id);
	}
	
	$(document).ready(function(){
		var originalWidth  = document.documentElement.clientWidth;

		window.onresize = function(){
			var changeWidth  = document.documentElement.clientWidth;

		    if(changeWidth <= 830){
		    	$('#table1').datagrid({width:1200});
		    }else{
		    	$('#table1').datagrid({width:changeWidth-18});
		    }
		} 
		
		$('#updateAct').show();
		$('#cancerAct').show();
		$('#deleteAct').show();
		$('#searchbtn').click(function(){
			var actStatus = $('#actStatus').combobox('getValue');
			$('#table1').datagrid({singleSelect:(actStatus=='0')});
			$('#table1').datagrid('load',getForms("searchForm"));
		});
		
		$('#updateAct').click(function(){
			var rows = $('#table1').datagrid('getSelections');
			if(rows.length <= 0 || rows.length > 1){
				$.messager.alert('提示','请选择要修改的活动信息！');
				return false; 	
			}
			parent.addTab('维护活动信息','activity/queryActivity?id='+rows[0].id);
		});
		
		$('#lookAct').click(function(){
			var rows = $('#table1').datagrid('getSelections');
			if(rows.length <= 0 || rows.length > 1){
				$.messager.alert('提示','请选择一条记录进行查看！');
				return false; 	
			}
			parent.addTab('查看活动详情','activity/lookActivity?id='+rows[0].id);
		});
		
		$('#deleteAct').click(function(){
			var data ='';
			var rows = $('#table1').datagrid('getSelections');
			
			for(var i in rows){
				data += rows[i].id+',';
			}
			data = data.substring(0, data.length -1);
			if(rows.length == 0){
				$.messager.alert('提示','请选择要删除的活动信息！');
				return false; 	
			}
			$.messager.confirm('信息','确认是否删除?',function(r){   
				if (r){   
					$.ajax({
			            url:'deleteActivity',
			            type:'post',
			            async: false,
			            data:'ids='+data,
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
		
		$('#cancerAct').click(function(){
			var data ='';
			var rows = $('#table1').datagrid('getSelections');
			for(var i in rows){
				data += rows[i].id+',';
			}
			data = data.substring(0, data.length -1);
			if(rows.length == 0){
				$.messager.alert('提示','请选择要取消的活动信息！');
				return false; 	
			}
			$.messager.confirm('信息','确认是否取消活动?',function(r){   
				if (r){   
					$.ajax({
			            url:'cancerActivity',
			            type:'post',
			            async: false,
			            data:'ids='+data,
			            success:function(data){
			            	$('#table1').datagrid('reload');
			            }
			        });
				}   
			});
			
		});
		
	});
	
	var pD=function(s){
		var dt=s.split(/ /);
		var d=dt[0].split(/-/);
		var t;
		if(dt[1]){
			t=dt[1].split(/:/);
			t.push(0);
			t.push(0);
		}else{
			t=[0,0,0];
		}
		return new Date(d[0],d[1]-1,d[2],t[0],t[1],t[2]);
	};
	var pS=function(d){
		var Y=d.getFullYear();
		var M=d.getMonth()+1;
		(M<10)&&(M='0'+M);
		var D=d.getDate();
		(D<10)&&(D='0'+D);
		var h=d.getHours();
		(h<10)&&(h='0'+h);
		var m=d.getMinutes();
		(m<10)&&(m='0'+m);
		var s=d.getSeconds();
		(s<10)&&(s='0'+s);
		return Y+'-'+M+'-'+D+' '+h+':'+m+':'+s;
	};
	
	function stateCompera(v,o,i){
		//alert(o.tag);
		var date = new Date();
		now = date.getFullYear() + "-";
		now = now + (date.getMonth() + 1) + "-";  //取月的时候取的是当前月-1如果想取当前月+1就可以了
		now = now + date.getDate() + " ";
		now = now + date.getHours() + ":";
		now = now + date.getMinutes() + ":";
		now = now + date.getSeconds() + "";
		var startDate = dateFormat(o.startDate) ;
		var endDate = dateFormat(o.endDate) ;
		var d1=pD(now);
		var d2=pD(startDate);
		var d3=pD(endDate);
		var now_1=pS(d1);
		var startDate_1=pS(d2);
		var endDate_1=pS(d3);
		if(o.tag == 0){
			return "已取消";
		}
		if(now_1<startDate_1){
			return "未开始";
		}else if(now_1>endDate_1){
			return "已结束";
		}else{
			return "进行中";
		}
	}
</script>
</head>
<body>
	<form id="searchForm" method="post" >
		<table width="800px">
			<tr>
				<td>活动名称：</td>
				<td><input style="width: 152px;" id="activityName" name="activityName" type="text"/></td>
				<td style="margin-left: 8px;">状态：</td>
				<td><select name="actStatus" id="actStatus" style="width: 156px;" class="easyui-combobox">
					<option value="0">--请选择--</option>
					<option value="1">已取消</option>
					<option value="2">未开始</option>
					<option value="3">已结束</option>
					<option value="4">进行中</option>
				</select></td>
			</tr>
			<tr>
				<td style="margin-left: 8px;">开始时间：
				</td>
				<td><input id="startDate" name="startDate" type="text" style="width: 156px;" class="easyui-datetimebox" editable="false"/></td>
				<td style="margin-left: 8px;">结束时间：</td>
				<td><input id="endDate" name="endDate" type="text" style="width: 156px;" class="easyui-datetimebox" editable="false"/></td>
				<td >
					<a id="searchbtn" href="javascript:void(0)" onclick="" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
					<a style="margin-left: 20px;" href="javascript:void(0)" data-options="iconCls:'icon-redo'" onclick="javascript:$('#searchForm').form('clear');" class="easyui-linkbutton" >重置</a>
				</td>
				
			</tr>
		</table>
	</form>
	
	<!-- 显示列表Table -->
	
	<table  id="table1"  class="easyui-datagrid" data-options="url:'findActivities',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
				rownumbers:true,pageList:pageList,toolbar: '#toolbar',singleSelect:true,onCheck:function(rowIndex, rowData){operates(rowIndex, rowData)},onDblClickRow:function(rowIndex,rowData){edit(rowData.id,rowData.activityName)}">    
	    <thead>  
	        <tr>  
	        	<th data-options="field:'id',width:20,hidden:true">活动编号</th>
	            <th data-options="field:'activityName',width:80">活动名称</th>  
	            <th data-options="field:'startDate',width:50,formatter:function(v){return dateFormat(v)}">开始时间</th>
	            <th data-options="field:'endDate',width:50,formatter:function(v){return dateFormat(v)}">结束时间</th>
	            <th data-options="field:'status',width:50,formatter:function(v,o,i){ return stateCompera(v,o,i)}">状态</th>
	        </tr>  
	    </thead>  
	</table> 
</div>
<br><br>
<div id="toolbar">
	<a id="updateAct" href="javascript:void(0)" class="easyui-linkbutton" plain="true" iconCls="icon-edit" style="margin-left: 10px;">修改</a>
	<a id="deleteAct" href="javascript:void(0)" class="easyui-linkbutton" plain="true" iconCls="icon-remove" style="margin-left: 10px;">删除</a>
	<a id="cancerAct" href="javascript:void(0)" class="easyui-linkbutton" plain="true" iconCls="icon-cancel" style="margin-left: 10px;">取消</a>
	<a id="lookAct" href="javascript:void(0)" class="easyui-linkbutton" plain="true" iconCls="icon-search" style="margin-left: 10px;">查看</a>
</div>
</body>
</html>