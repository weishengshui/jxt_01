<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>IRewards</title>
		<meta http-equiv="pragma" content="no-cache" />
		<meta http-equiv="cache-control" content="no-cache" />
		<meta http-equiv="expires" content="0" />
		<link type="text/css" rel="stylesheet" href="common/css/style.css" />
		<script type="text/javascript" src="common/js/jquery-1.7.min.js"></script>	
		<script type="text/javascript" src="common/js/jquery.page.js"></script>	
		<script type="text/javascript" src="common/js/common.js"></script>
		<s:if test="%{#session.userQy.zt==1}">
		  <script type="text/javascript" src="common/js/defaultWelfare.js"></script>
		</s:if>	
		
		<script type="text/javascript">
			var jfqsl = function(){
				<s:if test="%{#session.userQy.zt==1}">
// 					var data = defaultWelfare.ylqWelfare('<s:property value="yg"/>');
// 					$("#sdjfq").html(data);
// 					$("#syjfq").html(data);
					var jfqs = defaultWelfare.defaultFL.rows;
					$("#sdjfq").html(jfqs.length);
					var syjfq = jfqs.length;
					for (var i=0; i<jfqs.length; i++) {
						if (jfqs[i].yxq < new Date().toformat("")) { //已过期
							syjfq--;
						}
					}
					$("#syjfq").html(syjfq);
				</s:if>
				<s:else>
					var timeParam = Math.round(new Date().getTime()/1000);
					$.getJSON("jfqj!lqsj.do?time="+timeParam,{param:'<s:property value="yg"/>'}, function(data){
						if(typeof(data.rows[2])!="undefined"&&data.rows[2].jfqsl!=""){
							$("#sdjfq").html(data.rows[2].jfqsl);
						}
						if(typeof(data.rows[1])!="undefined"&&data.rows[1].jfqsl!=""){
							$("#ysyjfq").html(data.rows[1].jfqsl);
						}
						if(typeof(data.rows[0])!="undefined"&&data.rows[0].jfqsl!=""){
							$("#syjfq").html(data.rows[0].jfqsl);
						}
					});
				</s:else>
			};
			var gopage = function(rp,page){
				$.ajax({
					type : 'POST',datatype : 'json',cache : false,
					url : 'jfqj!page.do',
					data : {param:getParams("shanxuan"),page:page,rp:rp},
					success : jfqlist
				});
			};
			var jfqlist = function(data){
				if(data.rows == undefined) return false;
				$("#jfqUdlist").empty();
				var th='<tr><th width="90">时间</th><th width="238">福利名称</th>'
						+'<th width="115">数量</th><th>状态</th></tr>';
				$("#jfqUdlist").append(th);
				var subtotal = 0;
				$.each(data.rows, function (i, row) {
					var str = '<tr><td class="gray">'+row.jssj+'</td><td>'+row.mc+'</td><td>'
						+ row.sl+'张</td><td>已使用（订单号<span class="blue"><a href="dd!detail.do?crddh='+row.ddh+'">'+row.ddh+'</a></span>）</td></tr>';
					subtotal += parseInt(row.sl);
					$("#jfqUdlist").append(str);
				});
				if(subtotal!=0){
					$("#jfqUdlist").append('<tr class="subtotal"><td>&nbsp;</td><td>小计</td><td>'+subtotal+'张</td><td>&nbsp;</td></tr>');
				}
				$(".listpages").page({total:data.total,currentpage:data.page,gopage:gopage,pagesize:20});
			};
			$(function() {
				jfqsl();
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
					<script type="text/javascript">menusel(3);</script>
					</div>
					<div class="wrap-right">
						<div class="list">
							<div class="list-title"><h1>福利使用明细</h1>
								<div class="list-title-r">最近三个月共收到福利券 <span class="bisque"><strong id="sdjfq">0</strong></span>
								张，已经使用 <span class="bisque"><strong id="ysyjfq">0</strong></span>
								张，剩余 <span class="bisque"><strong id="syjfq">0</strong></span>张</div>
							</div>
							<div class="shanxuan">
								<input type="hidden" id="t.yg" rule="eq" value='<s:property value="yg"/>'/>
								福利名称：<input id="mc" rule="like" style="width:120px" />&nbsp;&nbsp;&nbsp;&nbsp;
								时间：<select id="jssj" rule="daylimit" style="width:120px">								
									<option value="">-请选择-</option>
									<option value="7" >近七天</option>
									<option value="30" >近一个月</option>
									<option value="91" selected>近三个月</option>
									<option value="182">近半年</option>
									<option value="365">近一年</option>
								</select>&nbsp;&nbsp;&nbsp;&nbsp;
								<input onclick="gopage('20','1');" value=" " type="button" class="searchbtn2" />
							</div>
							<div class="listin">
								<table id="jfqUdlist" width="100%" border="0" cellspacing="0" cellpadding="0" class="jlbiao">
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
