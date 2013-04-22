<%@page import="com.chinarewards.metro.core.common.Limits"%>
<%@page import="com.chinarewards.metro.core.common.Dictionary"%>
<%@ page language="java" contentType="text/html; charset=utf8" pageEncoding="utf8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link id="easyuiTheme" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/PCASClass.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/common.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/constant.js"></script>
<style>
	.table select{width:100px;height:22px;margin-right:20px;}
</style>
<script>
	function edit(id_,name_){
		var id = id_;
		var name = name_;
		if(id == undefined){
			var row = $('#table').datagrid('getSelected');
			if(row == null){
	    		$.messager.alert('提示','请选择要编辑的数据','warning');
				return;
			}
			id = row.id;
			name = row.surname+row.name;
			if(name == ''){
				name = row.phone;
			}
		}
		parent.addTab('维护'+name+'信息','member/updateMemberPage?id='+id);
	}

	function searchs(){
        //load 加载数据分页从第一页开始, reload 从当前页开始
    	$('#table').datagrid('load',getForms("searchForm"));
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
    	return o.province==null?'':o.province + 
    		   o.city==null?'':o.city +
    		   o.area==null?'':o.area + 
    		   o.address == null?'':o.address;
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
    function getSource(v){
    	 var source = ${sourceJson};
         for(var i=0;i<source.length;i++){
             if(v == source[i].num){
             	return source[i].name;
             };
         };
    }
    function del(){
    	var rows = $('#table').datagrid('getSelections');
		if(rows==''){$.messager.alert('提示','请选择要注销的数据','warning');return;}
		$.messager.confirm('确认框','您确定要注销吗??',function(r){  
			if(r){
				var s = '',n=''; 
				for(var i=0; i<rows.length; i++){
		            if (s != '') { s += ',',n+=",";}  
		            s += rows[i].id;
		            if(rows[i].surname == null){
		            	n += rows[i].phone;
		            }else{
		            	n += rows[i].surname+rows[i].name;
		            }
		            
		        }
		        $.ajax({
		            url:'logoutMember',
		            type:'post',
		            data:'ids='+s+"&names="+encodeURI(n),
		            success:function(){
						$.messager.show({  
			            title:'提示',  
			            msg:'注销成功',
			            showType:'show'  
			        });
						searchs();
		            },
		            error:function(e){
		            	alert('删除失败: ' + e.status);
		            }
		        });						
			}
		});
	}
    function resets(){
    	searchForm.reset();
    	$("#province").combobox('clear');
    	$("#city").combobox('clear');
    	$("#area").combobox('clear');
    	$("#status").combobox('clear');
    }
</script>
</head>
<body>
	<!-- 查询条件Table -->
	<form id="searchForm" name="searchForm">
		<table class="table" style="font-size:13px;">
			<tr>
				<td>省:</td>
				<td><select name="province" id="province" class="easyui-combobox" style="width:110px;"></select></td>
				<td width="35">姓名:</td>
				<td><input type="text" name="name" size="12"/></td>
				<td>手机号:</td>
				<td><input type="text" name="phone" size="12"/></td>
				<td>&nbsp;&nbsp;微信号:</td>
				<td>
					<input type="text" name="weixin" size="12"/>
				</td>
				<td align="right">
					<a id="btn" href="javascript:void(0)" onclick="searchs()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
					<a id="btn" href="javascript:void(0)" onclick="resets()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a>
				</td>
			</tr>
			<tr>
				<td>市:</td>
				<td><select name="city" id="city" class="easyui-combobox" style="width:110px;"></select></td>
				<td>卡号:</td>
				<td><input type="text" name="card.cardNumber" size="12"/></td>
				<td>E-mail:</td>
				<td><input type="text" name="email" size="12"/></td>
			</tr>
			<tr>
				<td>区:</td>
				<td><select name="area" id="area" class="easyui-combobox" style="width:110px;"></select></td>
				<td>状态:</td>
				<td>
					<select name="status" id="status" class="easyui-combobox" style="width:107px;">
						<option value=""> 请选择</option>
						<c:forEach items="${status }" var="s">
							<option value="${s.key }"> ${s.value }</option>
						</c:forEach>
					</select>	
				</td>
				<td>QQ号</td>
				<td>
					<input type="text" name="qq" size="12"/>
				</td>
			</tr>
		</table>
	</form>
	<div id="toolbar">  
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="edit()">修改</a>  
        <%-- <sec:authorize access="<%=Limits.MEMBER_DEL %>"> --%>
        	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="del()">注销</a>
        <%-- </sec:authorize>   --%>
    </div> 
	<!-- 显示列表Table -->
	<table id="table" class="easyui-datagrid" data-options="url:'findMemebers',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,toolbar: '#toolbar',
		rownumbers:true,pageList:pageList,singleSelect:false,onDblClickRow:function(rowIndex,rowData){edit(rowData.id,rowData.name==null?rowData.phone:rowData.surname+rowData.name)}">
	    <thead>  
	        <tr>  
	            <th data-options="field:'name',width:30,formatter:function(v,o,i){return getName(v,o,i);}">会员名</th>  
	            <th data-options="field:'phone',width:30">手机</th>
	            <th data-options="field:'email',width:50">邮箱地址</th>
	            <th data-options="field:'card',width:50,formatter:function(v,o,i){return getCard(v,o,i)}">会员卡号</th>
	            <th data-options="field:'qq',width:50">QQ号</th>
	            <th data-options="field:'weixin',width:50">微信号</th>
	            <th data-options="field:'address',width:80,formatter:function(v,o,i){return getAddress(v,o,i)}">会员地址</th>
	            <th data-options="field:'createDate',width:50">注册时间</th>
	            <th data-options="field:'status',width:20,formatter:function(v){return getStatus(v) }">状态</th>
	            <th data-options="field:'source',width:30,formatter:function(v){return getSource(v) }">来源</th>
	         	<th data-options="field:'id',hidden:true">id</th>
	        </tr>  
	    </thead>  
	</table> 
</body>
<script>
new PCAS("province","city","area","","","");//"天津市","市辖县","宁河县"
</script>
</html>