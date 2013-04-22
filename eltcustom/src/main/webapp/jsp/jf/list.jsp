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
			var jfsl = function(){
				var timeParam = Math.round(new Date().getTime()/1000);
				$.getJSON("jfj!lqsj.do?time="+timeParam,{param:'<s:property value="yg"/>'}, function(data){
					if(typeof(data.rows[0])!="undefined"&&data.rows[0].jfsl!=""){
						$("#sdjf").html(data.rows[0].jfsl);
					}
					if(typeof(data.rows[1])!="undefined"&&data.rows[1].jfsl!=""){
						$("#ysyjf").html(data.rows[1].jfsl);
					}
					if(typeof(data.rows[2])!="undefined"&&data.rows[2].jfsl!=""){
						$("#syjf").html(data.rows[2].jfsl);
					}
				});
			};
			var gopage = function(rp,page){
				$.ajax({
					type : 'POST',datatype : 'json',cache : false,
					url : 'jfj!page.do',
					data : {param:getParams("shanxuan"),page:page,rp:rp},
					success : jflist
				});
			};
			var jflist = function(data){
				if(data.rows == undefined) return false;
				$("#jflist").empty();
				var th='<tr><th width="90">时间</th><th width="200">兑换商品</th><th width="120">消耗积分</th>' +
						'<th width="35">数量</th><th>状态</th></tr><tr>';
				$("#jflist").append(th);
				var subtotal = 0;	
				var subtotalje = 0;
				var subtotaljf = 0;
				$.each(data.rows, function (i, row) {
					var str = '<tr><td class="gray">'+row.jssj+'</td><td>'+row.spmc+'</td><td><span class="bisque"><strong>'+row.jf+'</strong></span> 积分';
					if(row.je != '') {
						str+='&nbsp;+&nbsp;<strong class="bisque">'+row.je+'</strong>元';
						subtotalje += parseFloat(row.je);
					}
					str+='</td><td>'+row.sl+'</td><td>已兑换 （订单号<span class="blue"><a href="dd!detail.do?crddh='+row.ddh+'">'+row.ddh+'</a></span>）</td></tr>';
					subtotal += parseInt(row.sl);
					subtotaljf += parseInt(row.jf);
					$("#jflist").append(str);
				});
				if(subtotal!=0){
					var tf ='<tr class="subtotal"><td>&nbsp;</td><td>小计</td><td><span class="bisque"><strong>'+subtotaljf+'</strong></span> 积分';
					if(subtotalje!=0){
						tf+='&nbsp;+&nbsp;<strong class="bisque">'+row.je+'</strong>元';
					}
					tf += '</td><td>'+subtotal+'</td><td>&nbsp;</td></tr>';
					$("#jflist").append(tf);
				}
				$(".listpages").page({total:data.total,currentpage:data.page,gopage:gopage,pagesize:20});
			};
			$(function() {
				jfsl();
				gopage(20,1);
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
					<script type="text/javascript">menusel(6);</script>
					</div>
					<div class="wrap-right">
						<div class="list">
							<div class="list-title"><h1>积分兑换明细</h1>
								<div class="list-title-r">最近三个月共收到积分 <span class="bisque"><strong id="sdjf"></strong></span>
								，已经使用 <span class="bisque"><strong id="ysyjf"></strong></span>
								 <span class="bisque" style="display:none"><strong id="syjf"></strong></span>分</div>
							</div>
							<div class="shanxuan">
								<input type="hidden" id="t.yg" rule="eq" value='<s:property value="yg"/>'/>
								兑换商品：<input id="spmc" rule="like" style="width:100px" />&nbsp;&nbsp;&nbsp;&nbsp;
								时间：<select id="jssj" rule="daylimit" style="width:100px">								
									<option value="">-请选择-</option>
									<option value="7" >近七天</option>
									<option value="30" >近一个月</option>
									<option value="91" selected>近三个月</option>
									<option value="182">近半年</option>
									<option value="365">近一年</option>
								</select>&nbsp;&nbsp;&nbsp;&nbsp;
								金额：<input id="start_t.jf" rule="ge" class="jingerbox" /> - 
									<input id="end_t.jf" rule="le" class="jingerbox" /> 积分&nbsp;&nbsp;&nbsp;&nbsp;
								<input onclick="gopage('20','1');" value=" " type="button" class="searchbtn2" />
							</div>
							<div class="listin">
								<table id="jflist" width="100%" border="0" cellspacing="0" cellpadding="0" class="jlbiao">
								</table>
							</div>
							<div class="listpages"></div>
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
