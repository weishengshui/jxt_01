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
		<script type="text/javascript">
		var _bdhmProtocol = (("https:" == document.location.protocol) ? " https://" : " http://");
		document.write(unescape("%3Cscript src='" + _bdhmProtocol + "hm.baidu.com/h.js%3F399d3e1eb0a5e112f309a8b6241d62fe' type='text/javascript'%3E%3C/script%3E"));
		</script>
		<script type="text/javascript" src="common/js/jquery-1.7.min.js"></script>	
		<script type="text/javascript" src="common/js/jquery.page.js"></script>		
		<script type="text/javascript" src="common/js/common.js"></script>		
		<script type="text/javascript">	
			var headnavsel = "";
			var spurl="spj!pagespl.do";
			var dosearch =function(t){
				if(typeof(t)!='undefined'&&t==1){
					$("#order").val("");
				}
				spurl="spj!pagespl.do";
				gopage(16,1);
			}
			var gopageurl = function(rp,page,rurl){	
				$.ajax({
					type : 'POST',datatype : 'json',cache : false,
					url : rurl,
					data : {param:getParams("sccxbox"),page:page,rp:rp},
					success : splist
				});
			}
			var gopage = function(rp,page){
				gopageurl(rp,page,spurl);
			};
			var splist = function(data){
				if(data.rows == undefined) return false;
				$("#splist").empty();
				$.each(data.rows, function (i, row) {
					var dhfs = '';
					if(row.je!=''){
						dhfs = '<p class="scpro-money"><span class="bisque">￥ <strong>'+row.je+'</strong> </span>元 + '+row.jf+' </p>';
					}
					var str='<li><a  href="sp!detail.do?spl='+row.nid+'"><img src="'+row.lj+'210x210.jpg" title=\"'+ row.mc +'\"/></a><p class="scpro-title">'
						+row.mc+'</p>'+dhfs+'<div class="scpro-money2"><label><span class="bisque">'
						+row.qbjf+'</span></label> 积分</div></li>';
					$("#splist").append(str);
				});
				$(".listpages").page({total:data.total,currentpage:data.page,gopage:gopage,pagesize:16});
			};
							
			var zjll = function(){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("lljlj!profile.do?time="+timeParam, function(data){
					if(data.rows == undefined) return false;
					$("#zjlllist").empty();
					$.each(data.rows, function (i, row) {
						/*var dhfs = '';
						if(row.je!='')dhfs = '<p>兑 换 价：<span class="bisque">'+
							row.je+'</span>元 + <span class="bisque">'+row.jf+'</span>积分</p>';
						var str = '<li><a href="sp!detail.do?spl='+row.nid+'"><img src="'+row.lj+'60x60.jpg" /><h1><a target="_blank" href="sp!detail.do?spl='+row.nid+'">'
								+row.mc+'</a></h1>'+ dhfs +'<p><span class="bisque">'+
							row.qbjf+'</span> 积分</p></li>';
						$("#zjlllist").append(str);*/
						var dhfs = '';
						if(row.je!='')dhfs = '<p>兑 换 价：<span class="bisque">'+
							row.je+'</span>元 + <span class="bisque">'+row.jf+'</span> 积分</p>';
						var str = '<li><img onclick="window.location=\'sp!detail.do?spl='+
						row.nid+'\'"  src="'+row.lj+'60x60.jpg" title=\"'+ row.mc +'\" /><h1><a target="_self" href="sp!detail.do?spl='+
							row.nid+'">'+row.mc+'</a></h1>'+dhfs+'<p><span class="bisque">'+
							row.qbjf+'</span> 积分</p></li>';
						$("#zjlllist").append(str);
						
					});
				});
			};	
			
			var rmtj = function(){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("spj!rm.do?time="+timeParam, function(data){
					if(data.rows == undefined) return false;
					$("#rmtjlist").empty();
					$.each(data.rows, function (i, row) {
						var str = '<li><a href="sp!detail.do?spl='+row.nid+'"><img  src="'+row.lj+'210x210.jpg"title=\"'+ row.mc +'\" /></a><span><a href="sp!detail.do?spl='+row.nid+'">'+row.mc+'</a><p><strong>'+row.qbjf
						+'</strong> 积分</p></span></li>';
						$("#rmtjlist").append(str);
					});
				});
			};	
			var splm = function(){
				$.ajax({
					type : 'POST',datatype : 'json',cache : false,
					url : 'spj!splm.do',
					async: false,
					success : function(data){
						$("#lmlist").empty();
						$.each(data.rows, function (i, row) {
							var str = '<li><input id="lb1" rule ="or" type="checkbox" value="'+row.nid+'" />'+row.mc+'</li>';
							$("#lmlist").append(str);
						});
						if('<s:property value="lm"/>'!=''){
							$("#lmlist :checkbox[value='<s:property value="lm"/>']").attr("checked","checked");
						}
					}
				});
			};	
			$(function() {	
				$.ajaxSetup({timeout: 300000});
				splm();
				if('<s:property value="key" />'!=''){
					$("#mc").val(decodeURI(unescape('<s:property value="key" />')));
				}
				spurl = 'spj!page<s:property value="param"/>.do<s:property value="query"/>';
				gopageurl(16,1,spurl);
				rmtj();
				zjll();
				$("#mrpx").click(function(){
					$("#order").val(" t.rq desc ");
					$(".paixu li").removeClass("on");
					$(".paixu li").removeClass("up");
					$(".paixu li").removeClass("down");
					$(this).parent("li").addClass("on");
					dosearch();
				});
				$("#dhlpx").click(function(){
					$("#order").val(" ydsl desc ,t.nid desc ");
					$(".paixu li").removeClass("on");
					$(".paixu li").removeClass("up");
					$(".paixu li").removeClass("down");
					$(this).parent("li").addClass("on");
					dosearch();
				});
				$("#jfpx").toggle(function(){
					$("#order").val(" qbjf desc ");
					$(".paixu li").removeClass("on");
					$(this).parent("li").removeClass("up");
					$(this).parent("li").addClass("on");
					$(this).parent("li").addClass("down");
					dosearch();
				},function(){
					$("#order").val(" qbjf asc ");
					$(".paixu li").removeClass("on");
					$(this).parent("li").removeClass("down");
					$(this).parent("li").addClass("on");
					$(this).parent("li").addClass("up");
					dosearch();
				});
			});
		</script>
	<link rel="shortcut icon" href="<%=request.getContextPath() %>/common/images/favicon.ico" type="image/x-icon" /></head>
<body>
	<div id="main">
		<div class="main2">
		<%@ include file="/jsp/base/headsc.jsp" %>
			<div id="wrap">
				<div id="wrap-left">
					<div class="sccxbox">
						<div class="sccx">
							<dl>
								<dt>
									<label>关键字：</label>
									<input id="mc" rule="like" type="text" class="keyinput" value="" />
									<label>积分：</label>
									<input id="start_qbjf" rule="ge" type="text" maxlength="10" class="jifenginput" /><label>&nbsp;-&nbsp;</label>
									<input id="end_qbjf" rule="le" type="text" maxlength="10" class="jifenginput" />
									<input id="order" rule="order" value='<s:property value="order" />' type="hidden" />
								</dt>
								<dd>
									<span>分　类：</span>
									<ul class="fenglei" id="lmlist">
									</ul>
								</dd>
							</dl>
							<input onclick="dosearch(1)" type="button" value=" "  class="queding"/>
						</div>
					</div>
					<ul class="paixu">
						<li><a style="cursor:pointer" class="moren" id="mrpx">默认排序</a></li>
						<li><a style="cursor:pointer"  id="dhlpx" class="by-num">兑换量</a></li>
						<li><a style="cursor:pointer"  id="jfpx" class="by-jifeng">积分</a></li>
					</ul>
					<ul class="scpro2" id="splist">
					</ul>	
					
					<div id="listpages" class="listpages"></div>
				</div>
				<div id="wrap-right">
					<div class="zthd">
						<div class="zthd-title"><h1>&nbsp;&nbsp;热门兑换</h1></div>
						<ul class="rmtj" id="rmtjlist">
						</ul>
					</div>
					<div class="zthd">
						<div class="zthd-title"><h1>&nbsp;&nbsp;最近浏览</h1></div> 
						<ul class="zjllin" id="zjlllist"></ul>
					</div>
				</div>
			</div>
			<%@ include file="/jsp/base/footer.jsp" %>
		</div>
	</div>
	</body>
</html>
