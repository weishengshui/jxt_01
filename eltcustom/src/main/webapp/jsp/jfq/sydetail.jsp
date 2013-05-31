<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<title>IRewards</title>
		<meta http-equiv="pragma" content="no-cache"/>
		<meta http-equiv="cache-control" content="no-cache"/>
		<meta http-equiv="expires" content="0"/>
		<link type="text/css" rel="stylesheet" href="common/css/style.css"/>
		<script type="text/javascript" src="common/js/jquery-1.7.min.js"></script>	
		<script type="text/javascript" src="common/js/common.js"></script>
        <script type="text/javascript" src="common/js/defaultWelfare.js"></script>
		
		<script type="text/javascript">
			var getJfq = function(){
				var data = defaultWelfare.getWelfare('<s:property value="jfq"/>');
				$("#jfqmc").html(data.rows[0].mc);
				if(data.rows[0].yxq < new Date().toformat("")) {
					$("#jfqzt").html('<b style="color:red">已过期</b>');
					$("#jfqsm").html('');
					$("#jfqsplist>li div").removeClass("flspnowgetbtn").addClass("flspnowgetbtndisabled");
					$("#jfqsplist>li a").removeClass("wrapimg").addClass("wrapimgnolink");
				} else {
					$("#jfqsplist>li div").css("cursor", "pointer");
				}
				$("#jfqmc").html(data.rows[0].mc);
				var yxq = data.rows[0].yxq;
				if (yxq.length == 8) {
				    var yyyy = yxq.substring(0, 4);
					var mm = yxq.substring(4, 6);
					var dd = yxq.substring(6, 8);
					yxq = yyyy + "." + mm + "." + dd;
				}
				$("#jfqyxq").html(yxq);
				$("#jfqffly").html(data.rows[0].ffly);
				$("#jfqffyy").html(data.rows[0].ffyy);
			};
			$(function() {
				getJfq();
				$(".wrapimg").click(doclick);
				$(".flspnowgetbtn").click(doclick);
				function doclick() {
					alert("抱歉，您现在是试用账户,请联系我司客服转成正式账户！");
				}
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
						<li><h1>有效期</h1><h2 id="jfqyxq"></h2></li>
						<li><h1>来源</h1><h2 id="jfqffly"></h2></li>
						<li><h1>数量</h1><h2>1 张</h2></li>
						<li><h1>状态</h1><h2 id="jfqzt">未使用 </h2></li>
						<li><h1>发放理由</h1><h2 id="jfqffyy"></h2></li>
					</ul>
					<div style="clear:both;"></div>
					<div id="lqfllabel" class="jfqtitlesp">可领取福利</div><div id="jfqsm" class="jfqtip">您可领取以下福利礼品中任意一个，请选择</div>
	            	<ul id="jfqsplist" class="dhcplist">
	            	    <li>
	            	    	<a class="wrapimg" href="javascript:void(0);">
	            	    		<img src="common/images/defaultspimg/sp1.jpg" />
	            	        </a>
	            	        <h1></h1><br/>
	            	        <div class="flspnowgetbtn"></div>
	            	    </li>
	            	    <li>
	            	    	<a class="wrapimg" href="javascript:void(0);">
	            	    		<img src="common/images/defaultspimg/sp2.jpg" />
	            	    	</a>
	            	    	<h1></h1><br/>
	            	    	<div class="flspnowgetbtn"></div>
	            	    </li>
	            	    <li>
	            	    	<a class="wrapimg" href="javascript:void(0);">
	            	    		<img src="common/images/defaultspimg/sp3.jpg" />
	            	    	</a>
	            	    	<h1></h1><br/>
	            	    	<div class="flspnowgetbtn"></div>
	            	    </li>
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
