<%@page import="com.chinarewards.metro.core.common.Dictionary"%>
<%@ page language="java" contentType="text/html; charset=utf8" pageEncoding="utf8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link id="easyuiTheme" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>


<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/PCASClass.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/common.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/constant.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/uuid.js"></script>
<style>
	.table select{width:140px;height:22px;margin-right:20px;}
</style>
<script>
var baseURL = '<%=request.getContextPath()%>';
var uuid = new UUID().id;
var timeId;


$(document).ready(function(){
	

	

	
	
	
});
	function operates(v,o,i){
		return '<a href="javascript:void(0)" onclick="view(\''+v+'\')">查看</a>';
	}

	function view(id){

		parent.addTab('查看会员详信息','memberReport/viewMemberPage?id='+id);
	}

	function searchs(){
        //load 加载数据分页从第一页开始, reload 从当前页开始
    	$('#table').datagrid('load',getForms("searchForm"));
    	$('#table').datagrid({
    		url:'findMembersToReport',
    		onLoadSuccess:function(data){
    			$("#g").text(data.getTotalMemeber);
    		}
    	});
    }
	function exportM(){
		window.location.href = "exportMemberData?province="+$("#province").val()+"&createStart="+$("#createStart").datebox('getValue')+
				"&createEnd="+$("#createEnd").datebox('getValue')+
				"&city="+$("#city").val()+"&expenseStart="+$("#expenseStart").val()+
				"&expenseEnd="+$("#expenseEnd").val()+"&area="+$("#area").val()+
				"&sex="+$("#sex").val()+"&status="+$("#status").val()+"&source="+$("#source").val()+
				"&ageStart="+$("#ageStart").val()+"&ageEnd="+$("#ageEnd").val()+'&temp='+(new Date().getTime())+'&uuid='+uuid;
		openProgressDialog();
	}
	function openProgressDialog(){
		$('#progressDialog').dialog('open');
		$('#progressDialog').dialog('center');
		$('#progress').progressbar('setValue', 0);
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
	
	
    function getStatus(v){
        var status = ${statusJson};
        for(var i=0;i<status.length;i++){
            if(v == status[i].key){
            	return status[i].value;
            };
        };
    }
    function getProfession(v){
    	for(var i=0;i<Constant.profession.length;i++){
        	if(v==Constant.profession[i].id){
				return Constant.profession[i].text;	
			};
    	};
    }
    function getSalary(v){
    	for(var i=0;i<Constant.salary.length;i++){
        	if(v==Constant.salary[i].id){
				return Constant.salary[i].text;	
			};
    	};
    }
    function getAddress(v,o,i){

       return (o.province==null?'':o.province) + 
    		   (o.city==null?'':o.city) +
    		   (o.area==null?'':o.area )+ 
    		   (o.address == null?'':o.address);

    }
    function getName(v,o,i){
        return (o.surname==null?'':o.surname)+(o.name==null?'':o.name);
    }
    function getCard(v,o,i){
    	if(v!=null)
    	 return v.cardNumber;
    	else
    	 return '';
    }
    
    function tableONLoad(){
        $("#g").text('${getTotalMemeber}');
     }
    
    function reset(){
    	$('#searchForm')[0].reset();
    	$("#province").combobox('clear');
    	$("#city").combobox('clear');
    	$("#area").combobox('clear');
    	$("#sex").combobox('clear');
    	$("#status").combobox('clear');
    }
</script>
</head>
<body>
	<!-- 查询条件Table -->
	<form id="searchForm"> 
		<table class="table" style="font-size:13px;">
			<tr>
				<td>省:</td>
				<td width="200">
	  				<select name="province" id="province" class="easyui-combobox" style="width:155px;"></select>
	  			</td>
				
				
				<td>注册时间:</td>
				<td><input type="text" name="createStart" id="createStart" style="width:140px" class="easyui-datebox" editable="false"/></td>
				<td>至</td>
				<td><input type="text" name="createEnd"   id="createEnd"   style="width:140px" class="easyui-datebox" editable="false"/></td>
			</tr>
			<tr>
				<td>市:</td>
				<td>
					<select name="city" id="city" class="easyui-combobox" style="width:155px;"></select>
	  			</td>
				<td>消费金额:</td>
				<td><input type="text" name="expenseStart" id="expenseStart" size="18"/></td>
				<td>至</td>
				<td><input type="text" name="expenseEnd" id="expenseEnd" size="18"/></td>
			</tr>
			<tr>
				<td>区:</td>
				<td>
					<select name="area" id="area" class="easyui-combobox" style="width:155px;"></select>		
	  			</td>
				
				<td>年龄:</td>
				<td><input type="text" name="ageStart" id="ageStart" size="18"/></td>
				<td>至</td>
				<td><input type="text" name="ageEnd" id="ageEnd" size="18"/></td>
			</tr>
			<tr>
				<td>性别:</td>
				<td>
			    	<select name="sex" id="sex" style="width:155px;" class="easyui-combobox">
						<option value="0">--请选择--</option>
						<option value="1">男</option>
						<option value="2">女</option>
					</select>
				</td>
				<td>状态:</td>
				<td>
					<select name="status" id="status">
						<option value=""></option>
						<c:forEach items="${status }" var="s">
							<option value="${s.key }">${s.value }</option>
						</c:forEach>
					</select>	
				</td>
				
				<td>注册渠道:</td>
				<td>
					<select name="source" id="source">
					    <option value="0">--请选择--</option>
						<c:forEach items="${source }" var="s">
							<option value="${s.num }">${s.name }</option>
						</c:forEach>
					</select>
				</td>
				
				<td >
					<a id="btn" href="javascript:void(0)" onclick="searchs()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
					<a style="margin-left: 10px;" href="javascript:void(0)" onclick="reset()" class="easyui-linkbutton"  data-options="iconCls:'icon-redo'">重置</a>
				</td>
			</tr>
		</table>
	</form>
	
	<div style="height: 30px;" id="toolbar">
		<span>
			<a id="exportData" href="javascript:void(0)" data-options="iconCls:'icon-download'" onclick="exportM()" plain="true" class="easyui-linkbutton">导出</a>
		</span>
		<span style="margin-left: 30px"><strong>会员总数：</strong><span id="g"></span></span>
	</div>

	<!-- 显示列表Table -->
	<table id="table" class="easyui-datagrid" data-options="url:'',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,toolbar: '#toolbar',
		rownumbers:true,pageList:pageList,singleSelect:true,onDblClickRow:function(rowIndex,rowData){edit(rowData.id,rowData.name);},
		    onLoadSuccess: function(){tableONLoad();}">

	  
	    <thead>  
	        <tr>  
	            <th data-options="field:'name',width:30,formatter:function(v,o,i){return getName(v,o,i);}">姓名</th>  
	            <th data-options="field:'phone',width:30">手机</th>
	            <th data-options="field:'email',width:50">邮箱地址</th>
	            <th data-options="field:'cardNumber',width:50">会员卡号</th>
	            <th data-options="field:'address',width:80,formatter:function(v,o,i){return getAddress(v,o,i)}">会员地址</th>
	            <th data-options="field:'createDate',width:50">注册时间</th>
	         	<th data-options="field:'id',width:10,formatter:function(v,o,i){return operates(v,o,i)}">详细</th>
	        </tr>  
	    </thead>  
	</table> 
	
	<div id="progressDialog" class="easyui-dialog" title="正在准备数据，请稍候。。。"
		style="width: 400px; height: auto;align:center;"
		data-options="resizable:false,modal:true,closed:true,closable:false">
		<div id="progress" class="easyui-progressbar" style="width:380px;"></div>
	</div>
</body>
<script>
new PCAS("province","city","area","","","");
</script>
</html>