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
		<link type="text/css" rel="stylesheet" href="common/css/ymPrompt.css">
		<script type="text/javascript" src="common/js/ymPrompt.js"></script>		
		<script type="text/javascript" src="common/js/jquery-1.7.min.js"></script>
		<script type="text/javascript" src="common/js/common.js"></script>		
		<script type="text/javascript">
			var ymclose = function(){ymPrompt.close();};
			var rm5 =function(){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("spj!rm5.do?time="+timeParam, function(data){
					if(data.rows == undefined) return false;
					$("#rm5list").empty();
					$.each(data.rows, function (i, row) {											
						var str = '<li><a href="sp!detail.do?spl='+row.nid+'"><img src="'+row.lj+'146x146.jpg" /></a><h1>'+
							row.mc+'</h1><h2><strong class="bisque">'+row.qbjf+'</strong> 积分</h2></li>';
						$("#rm5list").append(str);	
					});
				});
			}
			var gmbysps =function(){
				var sps = '<s:property value="splist"/>';
				if(sps=="")return false;;
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("spj!gmbysps.do?time="+timeParam,{param:sps}, function(data){
					if(data.rows == undefined) return false;
					$("#hgmlist").empty();
					var spstr = "";
					$.each(data.rows, function (i, row) {
						var str = '<li><h2>'+row.spmc+'</h2><img src="'+row.lj+'146x146.jpg" /><p><strong class="bisque" style="font-size:18px">'
							+row.qbjf+'</strong> 积分</p><a style="cursor:pointer" onclick="addsptocar(\''+row.nid+'\',\''+row.qbjf+'\')" class="adddhl"></a></li>';
						$("#hgmlist").append(str);
					});
				});
			}
			var addsptocar=function(sp,jf){
				addShopCar(sp,1,jf);
				ymPrompt.win({message:'<div class=\'popbox\'>成功添加到兑换篮。</div>',width:175,height:55,titleBar:false});
				var timeClose = setTimeout(ymclose, 1500);
			}
			$(function(){
				rm5();
				gmbysps();
			})
		</script>
	<link rel="shortcut icon" href="<%=request.getContextPath() %>/common/images/favicon.ico" type="image/x-icon" /></head>

	<body>
	<%@ include file="/jsp/base/head.jsp" %>
	
<div id="main">
  <div class="main2">
    <div class="box2">
      <div class="wrap2">
        <div class="local">
          <h1><img src="common/images/local-title-pay.jpg" width="123" height="54" /></h1>
          <ul>
            <li>
              <h1>1.我的兑换篮</h1>
              <span><img src="common/images/local-icon3.jpg" /></span></li>
            <li>
              <h1>2.确定订单</h1>
              <span><img src="common/images/local-iconb2.jpg" /></span></li>
            <li>
              <h1 class="local-nowone">3.下单完成</h1>
            </li>
          </ul>
        </div>
		<div class="paysucess">
			<h1>您的订单 <strong class="blue"><a href="dd!detail.do?crddh=<s:property value='crddh'/>"><s:property value="crddh"/></a></strong><s:property value="payrs"/></h1>
			<h2><a href="sp!base.do">继续兑换&gt;&gt;</a></h2>
		</div>
		<div class="rmdh2">
			<div class="rmdh2-title"><a href="sp!list.do?param=rmdh">更多&gt;&gt;</a>热门兑换</div>
				<ul id="rm5list"></ul>
		</div>
        <div class="dhl-other" style="margin-top:10px">
			<h1>购买了同商品的同事还购买了</h1>
			<ul class="dhl-other-list" id="hgmlist">
			</ul>
		</div>
      </div>
      <div class="wrap2">
		<%@ include file="/jsp/base/bottomnav.jsp" %>
	  </div>
    </div>
  </div>
</div>
	<%@ include file="/jsp/base/footer.jsp" %>
	</body>
</html>
