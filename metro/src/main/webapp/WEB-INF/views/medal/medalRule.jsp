<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css"
	href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<style type="text/css">
body {
	font-family: 黑体、宋体、Arial;
	font-size: 12px;
}

</style>
<link id="easyuiTheme" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/common.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/ueditor/editor_config.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/ueditor/editor_all.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
	<script type="text/javascript">
	var editor;
	
	var baseURL = '<%=request.getContextPath()%>';
	
	$(function() {
		editor = new UE.ui.Editor();
		editor.render('rule1');
		editor.ready(function() {
			//需要ready后执行，否则可能报错
			editor.setContent('${medalRule.rule }');
		});
		
		 $('#addMedalRule').click(function(){
			$('#rule').val(editor.getContent());
			var rule = $('#rule').val();
			if(rule.length > 65535){
				$.messager.alert('提示',"规则长度不能超过65535个字符！");
				return;
			}
			$.ajax({
				url:'addMedalRule',
				data:{
	            	rule:rule
	            },
	            type:'post',
				async:false,
				success:function(data){
					$.messager.show({  
		    			title:'提示信息',  
		    			msg:'保存成功！',  
		    			timeout:5000,  
		    			showType:'slide'  
		    		});
				}
			}); 
		}); 
		
	});
</script>
</head>
<body>
	<div title="基本规则" style="padding: 10px;">
			<div>
				<form action="">
					<textarea name="rule1" id="rule1"></textarea>
					<input type="hidden" name="rule" id="rule" value="<c:out value='${medalRule.rule }'></c:out>">
				</form>
			</div><br>
			<div align="left">
				<a id="addMedalRule" href="javascript:void(0)" onclick=""
					class="easyui-linkbutton">保存</a> 
			</div>
		</div>
</body>
</html>