<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></meta>
		<title>IRewards</title>
		<meta http-equiv="pragma" content="no-cache"></meta>
		<meta http-equiv="cache-control" content="no-cache"></meta>
		<meta http-equiv="expires" content="0"></meta>
		<link type="text/css" rel="stylesheet" href="common/css/scstyle.css"></link>
		<script type="text/javascript" src="common/js/jquery-1.7.min.js"></script>		
		<script type="text/javascript" src="common/js/common.js"></script>
		<script type="text/javascript">
			
			function showPics(index,sWidth) {
				var nowLeft = -index*sWidth;
				$("#focus ul").stop(true,false).animate({"left":nowLeft},20);//300
				$("#focus .btn span").removeClass("on").eq(index).addClass("on"); 
			}
			function addbannermovie(){
				var sWidth = $("#focus").width();
				var len = $("#focus ul li").length;
				var picTimer;
				$("#focus ul").css("width",sWidth * (len));	
				var index = 0;		
				var btn = "<div class='btnBg'></div><div class='btn'>";
				for(var i=0; i < len; i++) {
					btn += "<span></span>";
				}
				btn += "</div><div class='preNext pre'></div><div class='preNext next'></div>";
				$("#focus").append(btn);
		
				$("#focus .btn span").mouseover(function() {
					index = $("#focus .btn span").index(this);
					showPics(index,sWidth);
				}).eq(0).trigger("mouseover");
		
				$("#focus .pre").click(function() {
					if(--index == -1){index = len - 1;}
					showPics(index,sWidth);
				});
		
				$("#focus .next").click(function() {
					if(++index == len) {index = 0;}
					showPics(index,sWidth);
				});
				
				$('#focus').hover(function(){
					clearInterval(picTimer);
				},function(){
					picTimer = setInterval(function(){
						if(++index == len) {index = 0;}
						showPics(index,sWidth);	
					},5000); 
				}).trigger("mouseleave");
				/*setInterval(function(){
					if(++index == len) {index = 0;}
					showPics(index,sWidth);	
				},5000);*/
			}
			var manlike = function(){
				$("#hotpro1").addClass("manon");
				$("#hotpro2").addClass("womenoff");
				$("#hotpro1").removeClass("manoff");
				$("#hotpro2").removeClass("womenon");
				$("#mandiv").show();
				$("#womandiv").hide();
			}
			var womanlike = function(){
				$("#hotpro1").addClass("manoff");
				$("#hotpro2").addClass("womenon");
				$("#hotpro1").removeClass("manon");
				$("#hotpro2").removeClass("womenoff");
				$("#mandiv").hide();
				$("#womandiv").show();
			};	
			var gocx = function(hdid,sp){
				if(sp!=undefined&&sp!=0){
					// window.location="sp!detail.do?sp="+sp;
					window.open("sp!detail.do?sp="+sp);
				}
				else{
					// window.location="cxhd!detail.do?hdid="+hdid;
					window.open("cxhd!detail.do?hdid="+hdid);
				}
			};	
			var cxhd = function(){
				var timeParam = Math.round(new Date().getTime()/1000);
				$.getJSON("cxhdj!profile.do?time="+timeParam, function(data){
					if(data.rows == undefined) return false;
					$("#cxhdlist").empty();
					$.each(data.rows, function (i, row) {						
						var str = '<li><a onclick="gocx(\''+row.nid+'\',\''+row.sp+'\')" style="cursor:pointer">'+row.bt+'</a></li>';;
						$("#cxhdlist").append(str);
					});
				});
			};			
			var cxhdimg = function(){
				var timeParam = Math.round(new Date().getTime()/1000);
				$.getJSON("cxhdj!img.do?time="+timeParam, function(data){
					if(data.rows == undefined) return false;
					$("#cxhdimglist").empty();
					$.each(data.rows, function (i, row) {
						var str = '<li><a onclick="gocx(\''+row.nid+'\',\''+row.sp+'\')" style="cursor:pointer"><img src="'+row.tplj+'"/></a></li>';;
						$("#cxhdimglist").append(str);
					});					
					addbannermovie();
				});
			};				
			var ffqd = function(lm){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("spj!ffqd.do?time="+timeParam,{param:lm}, function(data){
					if(data.rows == undefined) return false;
					$("#ffqdlist").empty();
					$.each(data.rows, function (i, row) {
						var dhfs ='';
						if(row.je!=''&&row.je>0) dhfs = '<p class="scpro-money"><span class="bisque">￥ <strong>'
							+row.je+'</strong> </span>元+ '+row.jf+' </p>';
						var str = '<li><a href="sp!detail.do?spl='+row.nid+'"><img src="'+row.lj+'210x210.jpg" title=\"'+ row.mc +'\" /></a>'
							+'<p class="scpro-title">'+'<span class="scpro-title-content">'+row.mc+'</span></p>'+dhfs+'<div class="scpro-money2">'
							+'<label><span class="bisque">'+row.qbjf+'</span> 积分</label></div></li>';
					  	$("#ffqdlist").append(str);
					});
				});
			};					
			var zxsj = function(lm){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("spj!zxsj.do?time="+timeParam,{param:lm},function(data){
					if(data.rows == undefined) return false;
					$("#zxsjlist").empty();
					$.each(data.rows, function (i, row) {
						var dhfs ='';
						if(row.je!=''&&row.je>0) dhfs = '<p class="scpro-money"><span class="bisque">￥ <strong>'
							+row.je+'</strong> </span>元+ '+row.jf+' </p>';
						var str = '<li><a href="sp!detail.do?spl='+row.nid+'"><img src="'+row.lj+'210x210.jpg" title=\"'+ row.mc +'\"/></a>'
							+'<p class="scpro-title">'+'<span class="scpro-title-content">'+row.mc+'</span></p>'+dhfs+'<div class="scpro-money2">'
							+'<label><span class="bisque">'+row.qbjf+'</span> 积分</label></div></li>';
					  	$("#zxsjlist").append(str);
					});
				});
			};					
			var zshy = function(){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("spj!zshy.do?time="+timeParam,{param:1},function(data){
					if(data.rows == undefined) return false;
					$("#manlikelist").empty();
					$.each(data.rows, function (i, row) {
						var str = '<li><h2>'+(i+1)+'</h2><img onclick="window.location=\'sp!detail.do?spl='+
						row.nid+'\'" src="'+row.lj+'60x60.jpg" title=\"'+ row.mc +'\"/><span><a href= "sp!detail.do?spl='+
						row.nid+'">'+row.mc+'</a></span><label class="bisque">'+row.qbjf+'</label>积分</li>';
						$("#manlikelist").append(str);
					});
				});				
				$.getJSON("spj!zshy.do?time="+timeParam,{param:2},function(data){
					if(data.rows == undefined) return false;
					$("#womanlikelist").empty();
					$.each(data.rows, function (i, row) {
						var str = '<li><h2>'+(i+1)+'</h2><img onclick="window.location=\'sp!detail.do?spl='+
						row.nid+'\'"  src="'+row.lj+'60x60.jpg" title=\"'+ row.mc +'\" /><span><a href= "sp!detail.do?spl='+
						row.nid+'">'+row.mc+'</a></span><label class="bisque">'+row.qbjf+'</label>积分</li>';
						$("#womanlikelist").append(str);
					});
				});
			};		
			<s:if test="%{#session.user.nid!=0}">
			var tszk = function(){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("spj!tszk.do?time="+timeParam,function(data){
					if(data.rows == undefined) return false;
					$("#tszklist").empty();
					$.each(data.rows, function (i, row) {
						var str = '<li><h2>'+(i+1)+'</h2><img onclick="window.location=\'sp!detail.do?spl='+
						row.nid+'\'"  src="'+row.lj+'60x60.jpg" title=\"'+ row.mc +'\" /><span><a href="sp!detail.do?spl='+
						row.nid+'">'+row.mc+'</a></span><label class="bisque">'+row.qbjf+'</label> 积分</li>';
						$("#tszklist").append(str);
					});
				});
			};	
			
			var zjll = function(){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("lljlj!profile.do?time="+timeParam, function(data){
					if(data.rows == undefined) return false;
					$("#zjlllist").empty();
					$.each(data.rows, function (i, row) {
						var dhfs = '';
						if(row.je!='')dhfs = '<p>兑 换 价：<span class="bisque">'+
							row.je+'</span>元 + <span class="bisque">'+row.jf+'</span> 积分</p>';
						var str = '<li><img onclick="window.location=\'sp!detail.do?spl='+
						row.nid+'\'"  src="'+row.lj+'60x60.jpg" title=\"'+ row.mc +'\" /><h1><a href="sp!detail.do?spl='+
							row.nid+'">'+row.mc+'</a></h1>'+dhfs+'<p><span class="bisque">'+
							row.qbjf+'</span> 积分</p></li>';
						$("#zjlllist").append(str);
					});
				});
			};
			</s:if>
			var splm = function(){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("spj!splm.do?time="+timeParam, function(data){
					if(data.rows == undefined) return false;
					$("#fklmlist").empty();
					$("#newlmlist").empty();
					$.each(data.rows, function (i, row) {
						var str = '<li lmid="'+row.nid+'">'+row.mc+'</li>';
						$("#fklmlist").append(str);
						$("#newlmlist").append(str);
					});
					for( var i=0;i<$("#fklmlist li").length;i++){
						$("#fklmlist li").eq(i).bind("click",{k:i},function(e){
							$("#fklmlist li").removeClass("hover");
							$(this).addClass("hover");
							ffqd($(this).attr("lmid"));
						});
						$("#newlmlist li").eq(i).bind("click",{k:i},function(e){
							$("#newlmlist li").removeClass("hover");
							$(this).addClass("hover");
							zxsj($(this).attr("lmid"));
						});
					}
					$("#newlmlist li").eq(0).click();
					$("#fklmlist li").eq(0).click();
				});
			};	
			$(function() {
				$.ajaxSetup({timeout: 300000});
				cxhd();
				cxhdimg();
				splm();
				zshy();
				<s:if test="%{#session.user.nid!=0}">
				tszk();
				zjll();
				</s:if>
			});
		</script>
	<link rel="shortcut icon" href="<%=request.getContextPath() %>/common/images/favicon.ico" type="image/x-icon" /></head>
<body>
	<div id="main">
		<div class="main2">
			<s:if test="#session.hrqyjf!=null"><%@ include file="/jsp/base/hrheadsc.jsp" %></s:if>
			<s:else><%@ include file="/jsp/base/headsc.jsp" %></s:else>
			<div id="wrap">
				<div id="wrap-left">
					<div class="banner">
						<div id="focus">
							<ul id="cxhdimglist">
							</ul>
						</div>
					</div>
					<div class="fkjd">
						<div class="fkjd-title"><h1>热门推荐</h1><a href="sp!list.do?param=fkqd">更多&gt;&gt;</a></div>
						<ul class="leibie" id="fklmlist">
						</ul>
						<div style="float:left">
							<ul class="scpro" id="ffqdlist">
							</ul>							
						</div>
					</div>
					<div class="fkjd">
						<div class="fkjd-title"><h1>新品上架</h1><a href="sp!list.do?param=zxsj">更多&gt;&gt;</a></div>
						<ul class="leibie" id="newlmlist">
						</ul>
						<div style="float:left">
							<ul class="scpro" id=zxsjlist>
							</ul>							
						</div>
					</div>
					<div class="box">
						<div class="hotpro">
							<div class="hotpro-title"><h1>最受欢迎的产品</h1>
								<ul class="hotpro-kind">
									<li id="hotpro1" onmouseover="manlike();" class="manon"></li>
									<li id="hotpro2" onmouseover="womanlike();" class="womenoff"></li>
								</ul>
							</div>
							<div id="mandiv">
								<ul class="hotproin" id="manlikelist"></ul>
								<a href="sp!list.do?param=zshy&query=1" class="hotmore">更多&gt;&gt;</a>
							</div>
							<div id="womandiv" style="display:none">
								<ul class="hotproin" id="womanlikelist"></ul>
								<a href="sp!list.do?param=zshy&query=2" class="hotmore">更多&gt;&gt;</a>
							</div>
						</div>
						<div class="hotpro" style="float:right">
							<div class="hotpro-title"><h1>您的同事正在看...</h1></div>
							<s:if test="%{#session.user.nid!=0}">
							  <ul class="hotproin" id="tszklist"></ul>
							</s:if>
							<a href="sp!list.do?param=tszk" class="hotmore">更多&gt;&gt;</a>
						</div>
					</div>
				</div>
				<div id="wrap-right">
					<div class="zthd">
						<div class="zthd-title"><img src="common/images/title-icon1.jpg" /><h1>主题促销活动</h1></div>
						<div class="zthdin">
							<ul id="cxhdlist">
							</ul>
						</div>
					</div>
				    <s:if test="%{#session.user.nid!=0}">
					  <div class="zthd">
						<div class="zthd-title"><img src="common/images/title-icon2.gif" width="27" height="25" />
					    <h1>最近浏览</h1></div> 
						<ul class="zjllin" id="zjlllist"></ul>
					  </div>
				    </s:if>
				</div>
			</div>
			<%@ include file="/jsp/base/footer.jsp" %>
		</div>
	</div>
</body>
</html>
