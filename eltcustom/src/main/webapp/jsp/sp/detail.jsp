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
		<link type="text/css" rel="stylesheet" href="common/css/ymPrompt.css"></link>
		<script type="text/javascript">
		var _bdhmProtocol = (("https:" == document.location.protocol) ? " https://" : " http://");
		document.write(unescape("%3Cscript src='" + _bdhmProtocol + "hm.baidu.com/h.js%3F399d3e1eb0a5e112f309a8b6241d62fe' type='text/javascript'%3E%3C/script%3E"));
		</script>
		<script type="text/javascript" src="common/js/ymPrompt.js"></script>	
		<script type="text/javascript" src="common/js/jquery-1.7.min.js"></script>	
		<script type="text/javascript" src="common/js/jquery.page.js"></script>		
		<script type="text/javascript" src="common/js/common.js"></script>		
		<script type="text/javascript">	
			var ymclose = function(){ymPrompt.close();};
			var headnavsel = "";
			var addsptocar=function(){
				addShopCar('<s:property value="sp"/>',$("#num").val(),$("#zffs").val());
				ymPrompt.win({message:'<div class=\'popbox\'>成功添加到兑换篮。</div>',width:175,height:55,titleBar:false});
				var timeClose = setTimeout(ymclose, 1500);				
			};
			var nowpay=function(){
				addShopCar('<s:property value="sp"/>',$("#num").val(),$("#zffs").val());
				window.location="dd!confirm.do";
			};
			var hrnowpay=function(){
				addShopCar('<s:property value="sp"/>',$("#num").val(),$("#zffs").val());
				window.location="dd!hrconfirm.do";
			};
			var toLogin = function() {
				if (confirm("您未登录，请回到登录页登录后再操作!")) {
					window.location = "login.action";
				}
			};
			var createxjtp = function(num){
				var xjtp = "";
				for(var i=0;i<num;i++){
					xjtp += '<img src="common/images/star1.jpg" />';
				}
				return xjtp;
			};
			var addsp = function(){
				var numsp = parseInt($("#num").val());
				var maxsp = parseInt($("#wcdsl").html());
				if(numsp<maxsp){
					$("#num").val(numsp+1);
				}
			};
			var subsp = function(){
				var numsp = parseInt($("#num").val());
				if(numsp>1){
					$("#num").val(numsp-1);
				}
			};
			
			var checkspnum = function(){
				var numsp = $("#num").val();
				var maxsp = parseInt($("#wcdsl").html());
				numsp = numsp.replace(/[^0-9]*/gi,"");
				if(numsp==""){
					numsp = 1;
				}
				else{
					numsp = parseInt(numsp);
				}
				if(numsp>maxsp){
					$("#num").val(maxsp);
				}
				else if(numsp<1){
					$("#num").val(1);
				}
				else $("#num").val(numsp);
			}
			
			var pjpage = function(rp,page){
				$.ajax({
					type : 'POST',datatype : 'json',cache : false,
					url : 'pjj!page.do',
					data : {param:getParams("yhpj-type")+' AND t.spl = '+'<s:property value="spl"/>',page:page,rp:rp},
					success : pjlist
				});
			};
			
			var pjlist = function(data){
				if(data.rows == undefined) return false;
				$("#pjlist").empty();
				$.each(data.rows, function (i, row) {
					var str = '<li><div class="yhpjlist-left"><span class="star-'+parseInt(row.zpf)+'"></span><p>'
					+row.pjnr+'</p><h1>'+row.pjrq+'</h1></div><div class="yhpjlist-user"><img src="photo/'
					+row.yg+'/little.jpg" /><div>'+row.nc+'</div></div></li>';
					$("#pjlist").append(str);
				});
				$(".listpages").page({total:data.total,currentpage:data.page,gopage:pjpage,pagesize:6});
			};
			
			var splinfo = function(){
				$.ajax({
					type : 'POST',datatype : 'json',cache : false,
					url : 'spj!splinfo.do',
					data : {param:'<s:property value="spl"/>'},
					async: false,
					success : function(data){
						var row = data.rows[0];
						headnavsel = 'headnav'+row.lb1;
						$("#lbmc1").html(row.lb1mc);
						$("#lbmc2").html(row.lb2mc);
						$("#lbmc3").html(row.lb3mc);
						$("#blbmc2").html(row.lb2mc);
						$("#ydsl").html(row.ydsl);
						$("#cpjsspl").html(row.cpjs);
						$("#shfw").html(row.shfw);						
						var timeParam = Math.round(new Date().getTime()/1000);		
						$.getJSON("spj!tlxsl.do?time="+timeParam,{param:row.lb3}, function(data){
							if(data.rows == undefined) return false;
							$("#tlblist").empty();
							$.each(data.rows, function (i, row) {
								var str = '<li><img style="cursor:pointer" onclick="window.location=\'sp!detail.do?spl='+row.nid+'\'" src="'+row.lj+'60x60.jpg" title=\"'+ row.mc +'\" /><a href="sp!detail.do?spl='+row.nid+'">'+row.mc+'</a></li>';
								$("#tlblist").append(str);
							});
						});	
						$("#phb2").bind("click",{k:row.lb3},function(e){
							var timeParam1 = Math.round(new Date().getTime()/1000);
							$.getJSON("spj!tltjw.do?time="+timeParam1,{param:e.data.k,query:$("#qbjf").html()}, function(data){
								if(data.rows == undefined) return false;
								$("#tjwlist").empty();
								$.each(data.rows, function (i, row) {
									var str = '<li><img style="cursor:pointer" onclick="window.location=\'sp!detail.do?spl='+row.nid+'\'" src="'+row.lj+'60x60.jpg" title=\"'+ row.mc +'\" /><a href="sp!detail.do?spl='+row.nid+'">'+row.mc+'</a></li>';
									$("#tjwlist").append(str);
								});
							});	
							$("#tjwlist").show();
							$("#tlblist").hide();
							$("#phb2").addClass("hover");
							$("#phb1").removeClass("hover");
						});	
						$("#phb1").click(function(){
							$("#tjwlist").hide();
							$("#tlblist").show();
							$("#phb1").addClass("hover");
							$("#phb2").removeClass("hover");
						});	
					}
				});
			};			
			var spinfo = function(){
				$.ajax({
					type : 'POST',datatype : 'json',cache : false,
					url : 'spj!spinfo.do',
					data : {param:'<s:property value="sp"/>'},
					async: false,
					success : function(data){
						var row = data.rows[0];
						var spjf = row.qbjf;
						$("#spbh").html(row.spbh);
						$("#spmc").html(row.spmc);
						$("#qbjf").html(row.qbjf);
						$("#cpjssp").html(row.spnr);
						if(row.cxjf!=''&&row.cxjf!=0){
							$("#cxjf").html('<strong class="bisque">'+row.cxjf+'</strong>积分');
							spjf = row.cxjf;
						}
						if(row.kcyj!=""&&row.kcyj>row.wcdsl){
							$("#wcdsl").html(0);
							$("#canbuy").hide();
							$("#cannotbuy").show();
							$("#kcjg").show();
						}
						else $("#wcdsl").html(row.wcdsl);
						$("#prostates2").html(row.shfw);
						checkInQyList();
						var sl = document.getElementById("zffs");
						sl.options[sl.length] = new Option(spjf+" 积分", spjf);
						var timeParam = Math.round(new Date().getTime()/1000);		
						$.getJSON("jfqj!spsjfq.do?time="+timeParam,{param:'<s:property value="sp"/>'}, function(da){
							if(da.rows == undefined) return false;
							if(jfqjson.rows == undefined) return false;
							$.each(da.rows, function (i, row) {
								$.each(jfqjson.rows, function (j, r) {
									if(r.jfq==row.jfq){
										sl.options[sl.length] = new Option(row.jfqmc, "jfq"+row.jfq);
										if(row.jfq=='<s:property value="jfq"/>'){
											sl.value="jfq"+row.jfq;
										}
									}
								});
							});
							$.getJSON("spj!dhfs.do?time="+timeParam,{param:'<s:property value="sp"/>'}, function(d){
								if(d.rows == undefined) return false;
								$("#dhfslist").empty();
								$.each(d.rows, function (i, row) {
									sl.options[sl.length] = new Option(row.jf+"积分 + "+row.je+"元", row.jf+"_"+row.je);
								});
							});
						});
						}
					});
			};
			
			var checkInQyList=function(){
				$.ajax({
					type : 'POST',datatype : 'json',cache : false,
					url : 'spj!checkInQyList.do',
					data : {param:'<s:property value="sp"/>'},
					async: false,
					success : function(data){
							var isIn = data.result;
							if (!isIn) {
								$("#canbuy").hide();
								$("#cannotbuy").hide();
							}
						}
					});
			};
							
			var sptp = function(){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("spj!sptp.do?time="+timeParam,{param:'<s:property value="sp"/>'}, function(data){
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
				$.getJSON("spj!spbyspl.do?time="+timeParam,{param:'<s:property value="spl"/>'}, function(data){
					if(data.rows == undefined) return false;
					$("#splsp").empty();
					$.each(data.rows, function (i, row) {
						var on = "";
						if(row.nid =='<s:property value="sp"/>') on = " on";
						var str = '<a href="sp!detail.do?sp='+row.nid+'" class="tb-color'+on+'"><img src="'+row.lj+'60x60.jpg" alt="'+row.spmc+'"/></a>';
						$("#splsp").append(str);
					});
				});
			};	
			var pjtj = function(){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("pjj!sum.do?time="+timeParam,{param:'<s:property value="spl"/>'}, function(data){
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
						}
					});
				});
			};		
			var tsmsp = function(){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("ddj!tsmsp.do?time="+timeParam, function(data){
					if(data.rows == undefined) return false;
					$("#tshdlist").empty();
					$.each(data.rows, function (i, row) {
						var str = '<li><a href="sp!detail.do?spl='+row.nid+'">'+row.mc+'</a></li>';
						$("#tshdlist").append(str);
					});
				});
			};		
			var zjll = function(){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("lljlj!profile.do?time="+timeParam, function(data){
					if(data.rows == undefined) return false;
					/*$("#lljllist").empty();
					$.each(data.rows, function (i, row) {
						var str = '<li><a target="_blank" href="sp!detail.do?spl='+row.nid+'"><img src="'+row.lj+'60x60.jpg" /><h1><a target="_blank" href="sp!detail.do?spl='+row.nid+'">'+row.mc+'</a></h1>'
							+'<label><span class="bisque">'+row.qbjf+'</span> 积分</label></a></li>';
						$("#lljllist").append(str);
					});*/
					
					/* $.each(data.rows, function (i, row) {
						var dhfs ='';
						if(row.je!=''&&row.je>0) dhfs = '<p class="scpro-money"><span class="bisque">￥ <strong>'
							+row.je+'</strong> </span>元+ '+row.jf+' </p>';
						var str = '<li><a href="sp!detail.do?spl='+row.nid+'"><img src="'+row.lj+'210x210.jpg" title=\"'+ row.mc +'\" /></a>'
							+'<p class="scpro-title">'+row.mc+'</p>'+dhfs+'<div class="scpro-money2">'
							+'<label><span class="bisque">'+row.qbjf+'</span> 积分</label></div></li>';
					  	$("#ffqdlist").append(str);
					}); */
					
					$("#lljllist").empty();
					$.each(data.rows, function (i, row) {
						var dhfs = '';
						if(row.je!='')dhfs = '<p>兑 换 价：<span class="bisque">'+
							row.je+'</span>元 + <span class="bisque">'+row.jf+'</span> 积分</p>';
							// href="sp!detail.do?spl='+	row.nid+'">'+row.mc+'</a>
						var str = '<li><img onclick="openNewSp(\''+row.nid+'\')" src="'+row.lj+'60x60.jpg" title=\"'+ row.mc +
							'\" /><h1><a onclick="openNewSp(\''+row.nid+'\')" href="javascript:void(0)">'+row.mc+'</a></h1>'+dhfs+'<p><span class="bisque">'+
								row.qbjf+'</span> 积分</p></li>';
						/*var str = '<li><a target="_blank" href="sp!detail.do?spl='+row.nid+'"><img src="'+row.lj+'60x60.jpg" /><h1><a target="_blank" href="sp!detail.do?spl='
								+row.nid+'">'+row.mc+'</a></h1>'+ dhfs +'<p><span class="bisque">'+
							row.qbjf+'</span> 积分</p></li>';*/
						$("#lljllist").append(str);
					});
				});
			};	
			
			function openNewSp(spl){
				/*var params = window.location.search;
				var n = params.split("=");
				if(n[1] != undefined && n[1]==spl){
					window.location='sp!detail.do?spl='+spl;
				}else{
					window.open('sp!detail.do?spl='+spl);	
				}*/
				window.open('sp!detail.do?spl='+spl);
			}
			var pjsearch =function(){				
				pjpage(6,1);
			};
			var jfqjson = {};
			var initygjfqs = function(){
				$.ajax({
					type : 'POST',datatype : 'json',cache : false,
					url : 'jfqj!userjfqs.do',
					async: false,
					success : function(data){
						jfqjson = data;
					}
				});
			}
			$(function() {
				initygjfqs();
				splinfo();
				spinfo();
				pjpage(6,1);
				spbyspl();
				sptp();
				pjtj();
				tsmsp();
				zjll();
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
	<link rel="shortcut icon" href="<%=request.getContextPath() %>/common/images/favicon.ico" type="image/x-icon" /></head>
<body>
	<div id="main">
		<div class="main2">
			<s:if test="#session.hrqyjf!=null"><%@ include file="/jsp/base/hrheadsc.jsp" %></s:if>
			<s:else><%@ include file="/jsp/base/headsc.jsp" %></s:else>
			<div id="wrap">
				<div id="wrap-left">
					<div class="local">您正在看：福利商城 &gt; <span id="lbmc1"></span>&gt; <span id="lbmc2"></span>&gt; <span id="lbmc3"></span> </div>
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
							<li><label>全额积分：</label><span id="qbjf"></span>积分</li>
							<li><label>促　　销：</label><span id="cxjf">无</span></li>
							<li><label>运　　费：</label>免运费</li>
							<li><label>已兑换量：</label><span id="ydsl"></span>份</li>
							<li><label>用户评分：</label><span style="margin-top:8px" id="xjtp"></span></li>
							<li><label>款　　式：</label>
								<span id="splsp"></span>
							</li>
							<li><label>支付方式：</label>
								<select id="zffs" style="width:160px"></select>
							</li>
							<li><label>数　　量：</label>
								<a id="subicon" onclick="subsp();" style="cursor:pointer"><img src="common/images/icon-sub.jpg" /></a> 
									<input id="num"  maxlength="3" onkeyup="checkspnum()" type="text" value="1" class="tb-pro-num" /> 
								<a id="addicon" onclick="addsp();" style="cursor:pointer"><img src="common/images/icon-add.jpg" /></a></li>
							<li><label>剩余数量：</label><span id="wcdsl"></span>&nbsp;&nbsp;&nbsp;<span style="display:none" id="kcjg">抱歉，该商品已缺货。</span></li>
							<li id="canbuy">
								<a style="cursor:pointer" onclick="<s:if test='%{#session.user.nid!=0}'>nowpay();</s:if><s:elseif test="#session.hrqyjf!=null">hrnowpay();</s:elseif><s:else>toLogin();</s:else>" class="nowbuy"></a>
								<a style="cursor:pointer" onclick="<s:if test='%{#session.user.nid!=0}'>addsptocar();</s:if><s:elseif test="#session.hrqyjf!=null">addsptocar();</s:elseif><s:else>toLogin();</s:else>" class="takein"></a>
							</li>
							<li id="cannotbuy" style="display:none"><a class="nonowbuy"></a><a class="notakein"></a></li>
						</ul>
					</div>
					<div class="prostates" style="overflow: inherit;">
						<ul class="prostates-title">
							<li class="hover2">产品介绍</li>
							<li>售后服务</li>
							<li>用户评价（<span id="pjsl">0</span>）</li>
						</ul>
						<div class="prostatesbox">
							<div class="prostatesin" id="cpjs">
								<div id="cpjssp" style="word-break:break-all;"></div>
								<div id="cpjsspl"></div>
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
					<div class="zthd">
						<div class="zthd-title"><h1>&nbsp;&nbsp;你的同事还兑换了</h1></div>
						<div class="zthdin">
							<ul id="tshdlist">
							</ul>
						</div>
					</div>
					<div class="phb">
						<h1 class="phb-title"><span id="blbmc2" style="font-size:14px"></span>销售排行榜</h1>
						<ul class="phbleibie">
							<li id="phb1" class="hover">同类别</li>
							<li id="phb2" >同价位</li>
						</ul>
						<div class="phbin">
							<ul id="tlblist"></ul>
							<ul id="tjwlist" style="display:none">
							</ul>
						</div>						
					</div>
				    <s:if test="%{#session.user.nid!=0}">
					  <div class="zthd">
						<div class="zthd-title"><img src="common/images/title-icon2.gif" width="27" height="25" />
					    <h1>最近浏览</h1></div> 
						<ul class="zjllin" id="lljllist">
						</ul>
					  </div>
					</s:if>
				</div>
			</div>
			<%@ include file="/jsp/base/bottomnav.jsp" %>
			<%@ include file="/jsp/base/footer.jsp" %>
		</div>
	</div>
</body>
</html>
