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
		<script type="text/javascript" src="common/js/jquery-1.7.min.js"></script>	
		<script type="text/javascript" src="common/js/ymPrompt.js"></script>
		<script type="text/javascript" src="common/js/common.js"></script>		
		<script type="text/javascript">
			var ymclose = function(){ymPrompt.close();};
			var pay =function(){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("ddj!ddv.do?time="+timeParam,{param:'<s:property value="crddh"/>'}, function(data){
					if(data.rs!="success"){
						ymPrompt.win({message:'<div class=\'poperror\'>'+data.rs+'</div>',width:235,height:55,titleBar:false});
						var timeClose = setTimeout(ymclose, 2500);
						return false;
					}
					else{						
						var zje = parseFloat('<s:property value="zje"/>');
						if(zje>0){
							ymPrompt.win({message:'<div class=\'zfbpay\'><div>请在新打开的浏览器窗口，完成付款。</div><input type="button" class="success" onclick="gopay();" value="支付成功"/>'
								+'<input type="button" onclick="retry();" class="failed" value="支付失败，重试" /></div>',
								width:330,height:130,title:"现金支付"});
							$("#alipayment").submit();
						}
						else gopay(); 
					}
				});
			}
			var retry = function(){
				$("#alipayment").submit();
			}
			var gopay = function(){
				$("#form1").submit();
			}
			var changePromptInfo = function() {
				$("#zfdd").hide();
				$("#qrdd").show();
				$("#confirmpay").removeClass("gopay2");
				$("#confirmpay").addClass("confirmbtn");
			}
			$(function(){
				var zjf = parseInt('<s:property value="zjf"/>');
				var zjfqsl = parseInt('<s:property value="zjfqsl"/>');
				var zje = parseFloat('<s:property value="zje"/>');
				var zjfhtml = "";
				if(zjf>0)zjfhtml+='<span>使用积分账户余额支付 <strong class="bisque">'+zjf+'</strong> 积分</span>';
				if(zjfqsl>0)zjfhtml+='<span>使用福利券 <strong class="bisque">'+zjfqsl+'</strong> 张</span>';
				$("#jfqjf").html(zjfhtml);
				if(zje>0){
					$("#je").html(zje+"元");
					$("#zfdiv").show();
				}
				if(zjf<=0&&zje<=0&&zjfqsl>0){
					changePromptInfo();
				}
				
				if('<s:property value="crdid"/>'!='0'){
					removeShopCar();
					var timeParam = Math.round(new Date().getTime()/1000);				
					$.getJSON("ddj!xdsp.do?time="+timeParam,{param:'<s:property value="crdid"/>'}, function(data){
						if(data.rows == undefined) return false;
						$("#ddsplist").empty();
						$.each(data.rows, function (i, row) {
							var dhfs = '';
							if(row.jf!='')dhfs+=row.jf+' 积分';
							if(row.je!='')dhfs+=' + '+row.je+' 元';
							if(row.jfq!='')dhfs+='福利券 '+row.sl+' 张';
							var str='<p><h2>'+dhfs+'</h2><h1>'+row.sl+'份</h1>'+row.spmc+'</p>';
							$("#ddsplist").append(str);
						});
					});			
				}
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
        <div id="ddsplist" class="pay-states">
		</div>
		<div class="order">
			<h1 id="zfdd" class="order-title">您的订单 <span class="blue"><s:property value="crddh"/></span> 已经生成，请即时支付</h1>
			<h1 id="qrdd" style="display:none" class="order-title">您的福利券订单号为 <span class="blue"><s:property value="crddh"/></span> ，请确认</h1>
			<div class="orderin">
				<h1 id="jfqjf" class="yu-e">
				</h1>
				<div id="zfdiv" style="display:none" class="zhifu">
					<h1 class="zhifu-txt">您还需要支付 <strong class="bisque" id="je">0元</strong> 现金</h1>
					<h1 class="zhifu-txt">请选择支付方式</h1>
					<div class="bankselect">
						<!-- <h1>请选择支付平台</h1> -->
						<ul class="banklist">
							<li><span><input name="zftype" type="radio" checked value="zhifubao" /></span><img src="common/images/zhifubao.jpg" /></li>
						</ul>
					</div>
				</div>
				<form id="form1" name="form1" action="dd!pay.do" method="post">
					<input name="crddh" type="hidden" value='<s:property value="crddh"/>' />
				</form>
				<form id="alipayment" name="alipayment" action="jsp/dd/alipayto.jsp" method="post" target="_blank">
					<input name=tradeno type="hidden" value='<s:property value="crddh"/>' />
					<input name="subject" type="hidden" value='积分商城现金支付' />
					<input name="alibody" type="hidden" value='积分商城现金支付' />
					<input name="total_fee" type="hidden" value='<s:property value="zje"/>' />
				</form>
				<a id="confirmpay" onclick="pay();" style="margin-top:12px" href="#" class="gopay2"></a>
			</div>
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
