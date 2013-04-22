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
		<script type="text/javascript" src="common/js/jquery.page.js"></script>		
		<script type="text/javascript" src="common/js/common.js"></script>
		<script type="text/javascript">	
			var ggseq = '<s:property value="param" />';	
			var gopage = function(rp,page){
				$.ajax({
					type : 'POST',datatype : 'json',cache : false,
					url : 'gbj!page.do',
					data : {param:'<s:property value="qy"/>',page:page,rp:rp},
					success : gblist
				});
			};
			var gblist = function(data){
				if(data.rows == undefined) return false;
				$("#gblist").empty();
				$.each(data.rows, function (i, row) {
					var zy = row.nr.length<30?row.nr:row.nr.substring(0,30);
					var ggin = 'style="color:#2bb1ff;cursor:pointer;"';
					if(row.sfyd==0){
						ggin = 'style="color:red;cursor:pointer;"';
					}
					var str = '<div class="gsgginbox"><dl><dt>'+row.bt+'<span class="fbsj">'+row.fbsj+'</span></dt><dd>'+zy
						+'&nbsp;&nbsp;<span class="blue"><a id="'+row.nid+'" '+ggin+' class="detailbtn">查看详细&gt;&gt;</a></span></dd></dl>'
						+'<p class="gsggdetail" style="display:none">'+row.nr+'</p></div>';
					$("#gblist").append(str);
				});
				for (var i=0;i<$("#gblist .detailbtn").length;i++){
					$("#gblist .detailbtn").eq(i).bind("click",{k:i},
						function(e){
							if($("#gblist .gsggdetail").eq(e.data.k).get(0).style.display=="none"){
								$.ajax({
										type : 'POST',datatype : 'json',cache : false,
										url : 'gbj!idread.do',
										data : {param:$(this).attr("id")},
										async : false,
										success : function(data){
											refreshYgxxCount();
										}
								});
								$(this).css("color","#2bb1ff");
								$("#gblist .gsggdetail").eq(e.data.k).show();
								$("#gblist .detailbtn").eq(e.data.k).html("收起&gt;&gt;");
							}
							else {
								$("#gblist .gsggdetail").eq(e.data.k).hide();
								$("#gblist .detailbtn").eq(e.data.k).html("查看详细&gt;&gt;");								
							}
						}
					);
				}
				if(ggseq!=""){
					$("#gblist .detailbtn").eq('<s:property value="param" />').click();	
					ggseq = "";	
				}
				$(".listpages").page({total:data.total,currentpage:data.page,gopage:gopage,pagesize:5});
			};
			$(function() {
				gopage(5,1);
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
					<%@ include file="/jsp/base/leftlist.jsp" %>
					<script type="text/javascript">menusel(8);</script>
					</div>
					<div class="wrap-right">
						<div class="list">
							<div class="list-title"><h1>公司公告</h1></div>
							<div id="gblist" class="gsggin"></div>
							<div id="listpages" class="listpages"></div>
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
