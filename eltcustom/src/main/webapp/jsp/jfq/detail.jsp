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
			var sflq = 1;
			var getJfq = function(){
				var timeParam = Math.round(new Date().getTime()/1000);
				$.getJSON("jfqj!detail.do?time="+timeParam,{param:'<s:property value="jfqmc.nid"/>'}, function(data){
					sflq = data.rows[0].sflq;
					$("#jfqmc").html(data.rows[0].mc);
					if(data.rows[0].zt == '1'){
						$("#jfqzt").html('已使用 （订单号 <span class="blue"><a href="dd!fldetail.do?crddh='+data.rows[0].ddh+'">'+data.rows[0].ddh+'</a></span>）');
						$("#lqfllabel").attr("class", "jfqsp");
						$("#lqfllabel").html('您已领取：'+data.rows[0].spmc);
						$("#jfqsm").html('');
					} else if('<s:date name="jfqmc.yxq" format="yyyyMMdd"/>'<new Date().toformat("")){
						$("#jfqzt").html('<b style="color:red">已过期</b>');
						$("#jfqsm").html('');
					}
					$("#jfqmc").html(data.rows[0].mc);
					getJfqsp();
				});
			};
			var getJfqsp = function(){
				var timeParam = Math.round(new Date().getTime()/1000);
				$.getJSON("spj!jfqsp.do?time="+timeParam,{param:'<s:property value="jfqmc.jfq"/>'}, function(json){
					if(json.rows == undefined) return false;
					$("#jfqsplist").empty();								
					$.each(json.rows, function (i, row) {
						var jfqlist="";
						if('<s:property value="jfqmc.zt"/>'=='0'&&'<s:date name="jfqmc.yxq" format="yyyyMMdd"/>'>=new Date().toformat("")){
							jfqlist = '<li><a class="wrapimg" href="sp!flsp.do?sp='+row.nid+'&jfq=<s:property value="jfqmc.jfq"/>&yxq=<s:date name="jfqmc.yxq" format="yyyy.MM.dd"/>&jfqmcid=<s:property value="jfq"/>&sflq='+sflq+'"><img src=\''+row.lj
							+'146x146.jpg\'/></a><p class="scpro-title"><span class="scpro-title-content">'+row.spmc+'</span></p><a style="cursor:pointer" onclick="nowpay('+row.nid+');" class="flspnowgetbtn"></a></li>';
						} else if ('<s:property value="jfqmc.zt"/>'=='1') {
							jfqlist = '<li><a class="wrapimg" href="dd!fldetail.do?crddh=<s:property value="jfqmc.ddh"/>"><img src=\''+row.lj
							+'146x146.jpg\'/></a><p class="scpro-title"><span class="scpro-title-content">'+row.spmc+'</span></p><div class="flspnowgetbtndisabled"></div></li>';
						} else if ('<s:date name="jfqmc.yxq" format="yyyyMMdd"/>'<new Date().toformat("")) {
							jfqlist = '<li><a class="wrapimgnolink" href="" style="cursor:default" onclick="return false;"><img src=\''+row.lj
							+'146x146.jpg\'/></a><p class="scpro-title"><span class="scpro-title-content">'+row.spmc+'</span></p><div class="flspnowgetbtndisabled"></div></li>';
						}
						$("#jfqsplist").append(jfqlist);
					});
				});				
			};
			var nowpay=function(sp){
				if (sflq == 1) {
					gotoConfirm(sp);
				} else {
					var timeParam = Math.round(new Date().getTime()/1000);
					$.getJSON("jfqj!lq.do?time="+timeParam,{param:<s:property value="jfq"/>}, function(data){
						gotoConfirm(sp);
					});
				}
			};
			var gotoConfirm=function(sp){
				var oldsp = isLqWelfare('<s:property value="jfq"/>');
				if (oldsp != 0) {
					if (!confirm("您已经使用此福利券选择了商品，是否重新选择商品？")) {
						return;
					}
				}
				addWelfareShopCar(sp,1,'jfq<s:property value="jfqmc.jfq"/>','<s:property value="jfq"/>');
				if (isWelfareCoupons()) {
				    window.location="dd!flconfirm.do";
				} else {
					window.location="dd!confirm.do";
				}
			};
			$(function() {
				getJfq();
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
			<script type="text/javascript">menusel(2);</script>
	        </div>
	        <div class="wrap-right">
	          <div class="list">
	            <div class="list-title">
	              <h1>福利详情</h1>
	              </div>
	            <div class="listin">
					<div class="sec-title" id="jfqmc"></div>
					<ul class="fldetail">
						<li><h1>有效期</h1><h2><s:date name="jfqmc.yxq" format="yyyy.MM.dd"/></h2></li>
						<li><h1>来源</h1><h2><s:property value="jfqmc.ffly" /></h2></li>
						<li><h1>数量</h1><h2>1 张</h2></li>
						<li><h1>状态</h1><h2 id="jfqzt">未使用 </h2></li>
						<li><h1>发放理由</h1><h2><s:property value="jfqmc.ffyy" /></h2></li>
					</ul>
					<div style="clear:both;"></div>
					<div id="lqfllabel" class="jfqtitlesp">可领取福利</div><div id="jfqsm" class="jfqtip">您可领取以下福利礼品中任意一个，请选择</div>
	            	<ul id="jfqsplist" class="dhcplist">
	            	</ul>
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
