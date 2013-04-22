<%@page import="com.chinarewards.metro.core.common.Dictionary"%>
<%@ page language="java" contentType="text/html; charset=utf8" pageEncoding="utf8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link id="easyuiTheme" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/extend-easyui-validate.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/common.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/json2.js"></script>
<style type="text/css">
</style>
<script type="text/javascript">
	function validateCount(v){
		if(v==null)
			return 0;
		else
			return v;
	}
	function viewoperation(v,o,i){
		return "<a href='javascript:void(0)' onclick='showDetail(\""+o.activeDate+"\")'>查看详细</a>";
	}
	function showDetail(date){
		parent.parent.dialog("详细信息","line/shopPromoCodeDetail?importDate="+date,600,500);
	}
	function refresh(){
		$('#dg').datagrid('load',{shopId_:parent.getId()});
	}
	
</script>
</head>
<body>
	<a id="btn" href="javascript:void(0)" onclick="refresh()" class="easyui-linkbutton" data-options="iconCls:'icon-reload'">刷新</a>
	<form style="font-size:14px;margin-top: 5px;">
	  	<table id="dg" class="easyui-datagrid" style="height:auto"  
		            data-options="  
		                singleSelect: false,  
		                url: 'findShopPromoCode?shopId=${shopId }',
		                height:400,
		                rownumbers:true,
		                pagination:true,
		                fitColumns:true
		            ">
        <thead>
            <tr>
            	<th data-options="field:'id',hidden:true,width:10">id</th>
                <th data-options="field:'activeDate',width:80,align:'left'">导入时间</th>          
                <th data-options="field:'note',width:80">说明</th>
                <th data-options="field:'allCount',width:80">总数</th>
                <th data-options="field:'validateCount',width:80,formatter:function(v){return validateCount(v);}">已领用数</th>  
                <th data-options="field:'op',align:'center',width:50,formatter:function(v,o,i){return viewoperation(v,o,i);}">操作</th>
            </tr>
      	  </thead>
    	</table>
    </form>
</body>
</html>