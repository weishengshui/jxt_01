<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="jxt.elt.common.Fun"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%
menun=7;
Fun fun=new Fun();
String spl=request.getParameter("spl");
if (spl==null) spl="";
String sp=request.getParameter("sp");
if (sp==null) sp="";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<link type="text/css" rel="stylesheet" href="css/scstyle.css">		
		<script type="text/javascript" src="js/jquery-1.7.min.js"></script>	
		<script type="text/javascript" src="js/jquery.page.js"></script>	
		<script type="text/javascript" src="js/common2.js"></script>
		<script type="text/javascript" src="js/layer.js"></script>		
		<script type="text/javascript">	
			var uspl="<%=spl%>";
			var usp="<%=sp%>";
			var headnavsel = "";
			var addsptocar=function(){
				addShopCar(usp,$("#num").val(),$("#zffs").val());
				alert("成功添加到购物篮。");
			}
			var nowpay=function(){
				openLayer("<div style=\"background-color: #FFFFFF\"><div>温馨提示：实物类商品不能线上发放给员工</div><div>请选择</div><div><input type='radio' name='buytype' id='buytype' value='1' /> 购买该商品，配送到您的地址</div><div>付款成功后，你能通过物流收到你购买的商品</div><div><input type='radio' name='buytype' id='buytype' value='2' /> 购买能兑换该商品的积分券，方便发放奖励给员工</div><div>付款成功后，你将获得相同数量的，能兑换该商品的积分券</div><div><a href='#' onclick='gopay()'>确认下单</a> <a hef='#' onclick='closeLyayer()'>取消</a></div></div>");
				
			}
			
			var gopay=function(){
				addShopCar(usp,$("#num").val(),$("#zffs").val());
				
				window.location="ddcomfirm.jsp?buytype="+$(":radio:checked").val();
			}
			var createxjtp = function(num){
				var xjtp = "";
				for(var i=0;i<num;i++){
					xjtp += '<img src="scimages/star1.jpg" />';
				}
				return xjtp;
			}
			var addsp = function(){
				var numsp = parseInt($("#num").val());
				var maxsp = parseInt($("#wcdsl").html());
				if(numsp<maxsp){
					$("#num").val(numsp+1);
				}
			}
			var subsp = function(){
				var numsp = parseInt($("#num").val());
				if(numsp>1){
					$("#num").val(numsp-1);
				}
			}
			
			
			var splinfo = function(){
			
				var timeParam = Math.round(new Date().getTime()/1000);
				$.getJSON("ajax_sp.jsp?t=splinfo&time="+timeParam,{param:uspl}, function(data){
				
						var row = data.rows[0];
						headnavsel = 'headnav'+row.lb1;
						$("#lbmc1").html(row.lb1mc);
						$("#lbmc2").html(row.lb2mc);
						$("#lbmc3").html(row.lb3mc);
						$("#blbmc2").html(row.lb2mc);
						$("#ydsl").html(row.ydsl);
						$("#cpjs").html(decodeURIComponent(row.cpjs).replace(/\+/g,' '));
						$("#shfw").html(decodeURIComponent(row.shfw).replace(/\+/g,' '));				
						var timeParam = Math.round(new Date().getTime()/1000);
						$.getJSON("ajax_sp.jsp?t=tlxsl&time="+timeParam,{param:row.lb3}, function(data){
							if(data.rows == undefined) return false;
							$("#tlblist").empty();
							$.each(data.rows, function (i, row) {
								var str = '<li><img src="'+row.lj+'60x60.jpg" /><a href="prodetail.jsp?spl='+row.nid+'">'+row.mc+'</a></li>';
								$("#tlblist").append(str);
							});
						});	
					
				});
			};			
			var spinfo = function(){
				var timeParam = Math.round(new Date().getTime()/1000);	
				$.getJSON("ajax_sp.jsp?t=spinfo&time="+timeParam,{param:usp}, function(data){
					
					var row = data.rows[0];
					$("#spbh").html(row.spbh);
					$("#spmc").html(row.spmc);
					$("#qbjf").html(row.qbjf);
					
					$("#spnr").append(decodeURIComponent(row.spnr).replace(/\+/g,' '));
					
					if(row.cxjf!=''&&row.csjf!=0){
						$("#cxjf").html('<strong class="bisque">'+row.cxjf+'</strong>积分');
					}
					$("#wcdsl").html(row.wcdsl);
					$("#prostates2").html(row.shfw);
					var sl = document.getElementById("zffs");
					sl.options[sl.length] = new Option(row.qbjf+" 积分", row.qbjf);
					var timeParam = Math.round(new Date().getTime()/1000);
									
				});
			};								
							
			var sptp = function(){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("ajax_sp.jsp?t=sptp&time="+timeParam,{param:usp}, function(data){
					if(data.rows == undefined) return false;
					$("#headpic").empty();
					$("#smallpic").empty();
					$.each(data.rows, function (i, row) {
						var on = '';
						var disp = 'style="display:none"';
						if(row.zstp!=""){
							on = 'class="on"';
							disp ='';
						}
						var hdpic = '<div class="big-pic" '+disp+'><img alt="'+row.tpmc+'" src="'+row.lj+'335x335.jpg" /></div>';
						var smpic = '<li '+on+'><a><img src="'+row.lj+'60x60.jpg" /></a></li>';
						$("#headpic").append(hdpic);
						$("#smallpic").append(smpic);
						for (var i=0;i<$("#smallpic li").length;i++){
							$("#smallpic li").eq(i).bind("mouseover",{k:i},function(e){
								$("#smallpic li").removeClass("on");
								$(this).addClass("on");
								$("#headpic .big-pic").hide();
								$("#headpic .big-pic").eq(e.data.k).show();
							});
						}
					});
				});
			};			
			var spbyspl = function(){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("ajax_sp.jsp?t=spbyspl&time="+timeParam,{param:uspl}, function(data){
					if(data.rows == undefined) return false;
					$("#splsp").empty();
					$.each(data.rows, function (i, row) {
						var str = '<a href="prodetail.jsp?sp='+row.nid+'" class="tb-color"><img src="'+row.lj+'60x60.jpg" alt="'+row.spmc+'"/></a>';
						$("#splsp").append(str);
					});
				});
			};	
			var pjtj = function(){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("ajax_sp.jsp?t=pjsum&time="+timeParam,{param:uspl}, function(data){
					if(data.total == undefined) return false;
					$("#xjtp").empty();
					var sumpj = parseInt(data.total[0].totalcount);
					if(sumpj==0)return false;
					var xj = parseFloat(data.total[0].sumxj)/sumpj;					
					$("#pjsl").html(data.total[0].totalcount);		
					$("#xjtp").html(createxjtp(parseInt(xj)));		
					$("#ztpf").html(parseInt(xj*10)/10);					
					if(data.lx == undefined) return false;
					$.each(data.lx, function (i, l) {
							if(l.pj==1)$("#hping").html(l.countxj);
							if(l.pj==2)$("#zping").html(l.countxj);
							if(l.pj==3)$("#cping").html(l.countxj);
					});				
					if(data.xj == undefined) return false;
					$.each(data.xj, function (i, x) {
						var widthperc = Math.round(x.countxj*100/sumpj)+"%";
						if(x.pjxj==5){
							$("#bar5").css("width",widthperc);
							$("#tbar5").html(widthperc);
						}
						if(x.pjxj==4){
							$("#bar4").css("width",widthperc);
							$("#tbar4").html(widthperc);
						}
						if(x.pjxj==3){
							$("#bar3").css("width",widthperc);
							$("#tbar3").html(widthperc);
						}
						if(x.pjxj==2){
							$("#bar2").css("width",widthperc);
							$("#tbar2").html(widthperc);
						}
						if(x.pjxj==1){
							$("#bar1").css("width",widthperc);
							$("#tbar1").html(widthperc);
						}
						if(x.pjxj==0){
							$("#bar0").css("width",widthperc);
							$("#tbar0").html(widthperc);
						}
					});
				});
			};		
			var tsmsp = function(){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("ajax_sp.jsp?t=tsmsp&time="+timeParam, function(data){
					if(data.rows == undefined) return false;
					$("#tshdlist").empty();
					$.each(data.rows, function (i, row) {
						var str = '<li><a href="prodetail.jsp?spl='+row.nid+'">'+row.mc+'</a></li>';
						$("#tshdlist").append(str);
					});
				});
			};		
			var zjll = function(){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("ajax_sp.jsp?t=profile&time="+timeParam, function(data){
					if(data.rows == undefined) return false;
					$("#lljllist").empty();
					$.each(data.rows, function (i, row) {
						var str = '<li><img src="'+row.lj+'60x60.jpg" /><h1><a href="prodetail.jsp?spl='+row.nid+'">'+row.mc+'</a></h1>'
							+'<label>全额兑换：<span class="bisque">'+row.qbjf+'</span></label></li>';
						$("#lljllist").append(str);
					});
				});
			};	
			var pjsearch =function(){				
				pjpage(6,1);
			}
			
			var savelljl=function(){		
				var timeParam = Math.round(new Date().getTime()/1000);
				$.ajaxSettings.async=false;
				$.getJSON("ajax_sp.jsp?t=slljl&time="+timeParam,{param:uspl,query:usp}, function(data){
					uspl=data.spl;
					usp=data.sp;
				});
			}
			
			$(function() {
				savelljl();
				splinfo();
				spinfo();
				spbyspl();
				sptp();
				for (var i=0;i<$(".prostates-title li").length;i++){
					$(".prostates-title li").eq(i).bind("click",{k:i},function(e){
						$(".prostates-title li").removeClass("hover2");
						$(this).addClass("hover2");
						$(".prostatesbox .prostatesin").hide();
						$(".prostatesbox .prostatesin").eq(e.data.k).show();
					});
				}
				
			});
		</script>
	<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<div id="bodybackdiv" style="display:none"></div>
<div id="logdiv" style="display:none"></div>

	<div id="main">
		<div class="main2">
			
			<div id="wrap">
				<div id="wrap-left">
					
					<div class="scprotop">
						<h1 class="scpro-title" id="spmc"></h1>
						<div class="scprotopbox">
							<div class="head-pic">
								<div id="headpic">
								</div>
								<ul class="small-pic" id="smallpic">
								</ul>					
							</div>									
						</div>
						<ul class="scpro-property">
							<li><label>商品编号：</label><span id="spbh"></span></li>
							<li><label>全额红包：</label><span id="qbjf"></span>积分</li>
							<li><label>促　　销：</label><span id="cxjf">无</span></li>
							<li><label>运　　费：</label>免运费</li>
							<li><label>已兑换量：</label><span id="ydsl"></span>份</li>
							<li style="display: none;"><label>用户评分：</label><span style="margin-top:8px" id="xjtp"></span></li>
							<li style="display: none;"><label>款　　式：</label>
								<span id="splsp"></span>
							</li>
							<li style="display: none;"><label>支付方式：</label>
								<select id="zffs" style="width:160px"></select>
							</li>
							<li style="display: none;"><label>数　　量：</label>
								<a id="subicon" onclick="subsp();" style="cursor:hand"><img src="scimages/icon-sub.jpg" /></a> 
									<input id="num" type="text" value="1" class="tb-pro-num" /> 
								<a id="addicon" onclick="addsp();" style="cursor:hand"><img src="scimages/icon-add.jpg" /></a></li>
							<li><label>剩余数量：</label><span id="wcdsl"></span></li>
							<li></li>
						</ul>
					</div>
					<div class="prostates">
						<ul class="prostates-title">
							<li class="hover2">产品介绍</li>
							<li>售后服务</li>
							
						</ul>
						<div class="prostatesbox">
							
							
							<div class="prostatesin">
								<div id="spnr">
								</div>
								<div id="cpjs">
								</div>
							</div>
							<div class="prostatesin" id="shfw" style="display:none">
							</div>
							<div class="prostatesin" style="display:none">
								<div class="yhpj">
									<div class="yhpj-sum">
										<h1 class="yhpj-title">总体评分<strong class="bisque" id="ztpf">(0)</strong></h1>
										<ul class="yhpj-bf">
											<li><span class="star-5"></span><span class="pecent"><label id="bar5" class="pecenthover" style="width:0%"></label></span><label id="tbar5">0%</label></li>
											<li><span class="star-4"></span><span class="pecent"><label id="bar4" class="pecenthover" style="width:0%"></label></span><label id="tbar4">0%</label></li>
											<li><span class="star-3"></span><span class="pecent"><label id="bar3" class="pecenthover" style="width:0%"></label></span><label id="tbar3">0%</label></li>
											<li><span class="star-2"></span><span class="pecent"><label id="bar2" class="pecenthover" style="width:0%"></label></span><label id="tbar2">0%</label></li>
											<li><span class="star-1"></span><span class="pecent"><label id="bar1" class="pecenthover" style="width:0%"></label></span><label id="tbar1">0%</label></li>
											<li><span class="star-0"></span><span class="pecent"><label id="bar0" class="pecenthover" style="width:0%"></label></span><label id="tbar0">0%</label></li>
										</ul>
									</div>
									<ul class="yhpj-type">
										<li><input id="pj" rule="eq" name="pjdj" onclick="pjsearch();" checked  type="radio" value="1" />好评(<span id="hping">0</span>)</li>
										<li><input id="pj" rule="eq" name="pjdj" onclick="pjsearch();" type="radio" value="2" />中评(<span id="zping">0</span>)</li>
										<li><input id="pj" rule="eq" name="pjdj" onclick="pjsearch();" type="radio" value="3" />差评(<span id="cping">0</span>)</li>
									</ul>
									<ul class="yhpjlist" id="pjlist">
									</ul>
									<div id="listpages" class="listpages"></div>
									<div class="clear"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div id="wrap-right">
					
				</div>
			</div>
			
		</div>
	</div>
</body>
</html>
