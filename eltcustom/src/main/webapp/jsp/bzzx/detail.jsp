<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>IRewards</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<link type="text/css" rel="stylesheet" href="common/css/style.css">
		<script type="text/javascript" src="common/js/jquery-1.7.min.js"></script>	
		<script type="text/javascript" src="common/js/common.js"></script>			
		<script type="text/javascript">		
			var listbzcd = function(){
				var timeParam = Math.round(new Date().getTime()/1000);
				$.getJSON("bzzxj!list.do?time="+timeParam,function(data){
					if(data.rows == undefined) return false;
					$("#cdlist").empty();
					$.each(data.rows, function (i, row) {
						if(row.upid == 0){
							var str = '<li><span class="list1"><a>'+row.bt+'</a></span><div style="display:none" id="up'+row.nid+'"></div></li>';
							$("#cdlist").append(str);
						}
						else{
							var substr = '<span class="list2"><a id="sub'+row.nid+'" href="bzzx!detail.do?bzid='+row.nid+'">'+row.bt+'</a></span>';
							$("#up"+row.upid).append(substr);
						}
					});
					$("#cdlist .list1").toggle(function(){$(this).next("div").show()},function(){$(this).next("div").hide()});
					$('#sub<s:property value="bz.nid" />').css("color","#2bb1ff");
					$('#sub<s:property value="bz.nid" />').parent("span").parent("div").show();
				});
			};
			$(function() {
				listbzcd();
			});
		</script>
	<link rel="shortcut icon" href="<%=request.getContextPath() %>/common/images/favicon.ico" type="image/x-icon" /></head>

	<body>
	<%@ include file="/jsp/base/head.jsp" %>
	<div id="main">
		<div class="main2">
			<div class="box">
				<div class="wrap">
					<div class="wrap-left">
						<ul class="leftlist" id="cdlist">
						</ul>
					</div>
					<div class="wrap-right">
						<div class="list">
							<div class="list-title"><h1><s:property value="bz.bt" /></h1></div>
							<div class="listin">
								<s:property value="bz.nr" escape="false"/>							
							</div>
						</div>
					</div>
				</div>
				<%@ include file="/jsp/base/bottomnav.jsp" %>
			</div>
		</div>
	</div>
	<%@ include file="/jsp/base/footer.jsp" %>
	</body>
</html>
