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
		<link type="text/css" rel="stylesheet" href="common/css/style.css"></link>
		<script type="text/javascript" src="common/js/jquery-1.7.min.js"></script>		
		<script type="text/javascript" src="common/js/common.js"></script>
		<script type="text/javascript">			
			var hpjfqlq = function(jfqid){
				var timeParam = Math.round(new Date().getTime()/1000);
				$.getJSON("jfqj!lq.do?time="+timeParam,{param:jfqid}, function(data){
					window.location="jfq!detail.do?jfq="+jfqid;
				});
			};
			var hpjflq = function(jfid){
				var timeParam = Math.round(new Date().getTime()/1000);
				$.getJSON("jfj!lq.do?time="+timeParam,{param:jfid}, function(data){
					jfAjax();
					refreshygjf();
				});
			};
			var jfqAjax = function(){
				$.ajax({
					type : 'POST',datatype : 'json',cache : false,
					url : 'jfqj!profile.do',
					data : {param:'<s:property value="user.nid"/>'},
					success : jfqlist,
					async: true
				});
			};
			var jfqlist = function(data){
				if(data.rows == undefined) return false;
				$("#jfqhp").empty();
				$.each(data.rows, function (i, row) {
					var lq = '未使用';
					if (row.yxq < new Date().toformat("")){
						lq ='已过期';
					}
					else {
						if(row.sflq == 0){
							lq = '<a onclick="hpjfqlq(\''+row.nid+'\')" href="#">立即领取</a>';
						}
						else if(row.zt == 1){
							lq = '已使用';
						}
					}
					var str = '<li><span class="btn">'+lq+'</span><h1>'+row.ffsj+'</h1><a href="jfq!detail.do?jfq='+row.nid+'" class="clip">'+row.mc+'</a></li>';
					$("#jfqhp").append(str);
				});
			};
			var jfAjax = function(){
				$.ajax({
					type : 'POST',datatype : 'json',cache : false,
					url : 'jfj!profile.do',
					data : {param:'<s:property value="user.nid"/>'},
					success : jflist,
					async: true
				});
			};
			var jflist = function(data){	
				if(data.rows == undefined) return false;
				$("#jfhp").empty();
				$.each(data.rows, function (i, row) {					
					var lq = '<a style="width:41px;color:#666666;text-decoration:none">已领取</a>';
					var jfimg = "ico-jfh.jpg";
					if(row.sflq == 0){
						jfimg = "ico-jf.jpg";
						lq = '<a onclick="hpjflq(\''+row.nid+'\')" href="#">领取</a>';
					}
					var str = '<li><div class="indexjf-top">'+lq
							+'<img src="common/images/'+jfimg+'" /><h1>'+row.ffjf
							+'</h1>分</div><h2>'+row.mm+'</h2></li>';
					$("#jfhp").append(str);
				});
			};
			var tszhAjax = function(){
				$.ajax({
					type : 'POST',datatype : 'json',cache : false,
					url : 'ddj!tsmsp.do',
					data : {param:'<s:property value="user.nid"/>',qybm:'<s:property value="user.qy"/>'},
					success : tszhlist,
					async: true
				});
			};
			var tszhlist = function(data){		
				if(data.rows == undefined) return false;
				$("#tszh").empty();
				$.each(data.rows, function (i, row) {
					var dhfs = '';
					if(row.je!='')dhfs = '<p>兑换价：<span class="bisque">'+
						row.je+'</span>元+<span class="bisque">'+row.jf+'</span>积分</p>';
					var str = '<li><img onclick="window.location=\'sp!detail.do?spl='+
						row.nid+'\'" src="'+row.lj+'60x60.jpg" title=\"'+ row.mc +'\"   /><h1><a href="sp!detail.do?spl='+
						row.nid+'">'+row.mc+'</a></h1>'+dhfs+'<p><span class="bisque">'+
						row.qbjf+'</span> 积分</p></li>';
					$("#tszh").append(str);
				});
			};
			var zjljAjax = function(){
				$.ajax({
					type : 'POST',datatype : 'json',cache : false,
					url : 'lljlj!profile.do',
					data : {param:'<s:property value="user.nid"/>'},
					success : zjljlist,
					async: true
				});
			};
			var zjljlist = function(data){	
				if(data.rows == undefined) return false;
				$("#ygzjll").empty();
				$.each(data.rows, function (i, row) {
					var dhfs = '';
					if(row.je!='')dhfs = '<p>兑换价：<span class="bisque">'+
						row.je+'</span>元+<span class="bisque">'+row.jf+'</span>积分</p>';
					var str = '<li><img onclick="window.location=\'sp!detail.do?spl='+
						row.nid+'\'" src="'+row.lj+'60x60.jpg" title=\"'+ row.mc +'\" /><h1><a href="sp!detail.do?spl='+
						row.nid+'">'+row.mc+'</a></h1>'+dhfs+'<p><span class="bisque">'+
						row.qbjf+'</span> 积分</p></li>';
					$("#ygzjll").append(str);
				});
			};
			var gsggAjax = function(){
				$.ajax({
					type : 'POST',datatype : 'json',cache : false,
					url : 'gbj!profile.do',
					data : {param:'<s:property value="user.qy"/>'},
					success : gsgglist,
					async: true
				});
			};
			var gsgglist = function(data){	
				if(data.rows == undefined) return false;
				$("#gsgg").empty();
				$.each(data.rows, function (i, row) {
					var on = "";
					if(row.sfyd == 0) on='class="on"';
					var str = '<li '+on+' style="cursor:pointer;" onclick="window.location=\'gb!list.do?param='+i+'\';"><h1><a>'+row.bt+'</a></h1><span>'
						+row.fbsj+'</span></li>';
					$("#gsgg").append(str);
				});
			};
			var tjcpAjax = function(){
				$.ajax({
					type : 'POST',datatype : 'json',cache : false,
					url : 'spj!tj.do',
					data : {param:'<s:property value="user.jf"/>'},
					success : tjcplist,					
					async: true
				});
			};
			var tjcplist = function(data){	
				if(data.rows == undefined) return false;
				$("#tjcp").empty();
				$.each(data.rows, function (i, row) {
					var str = '<li><a href="sp!detail.do?spl='+row.nid+'"><img src="'+row.lj+'146x146.jpg" title=\"'+ row.mc +'\" /></a><h2>'+row.mc+'</h2><h1><span>'
					+row.qbjf+'</span> 积分</h1></li>';
					$("#tjcp").append(str);
				});
			};
			var jfqlqjlAjax = function(){
				$.ajax({
					type : 'POST',datatype : 'json',cache : false,
					url : 'ddj!jfqdhjl.do',
					data : {param:'<s:property value="user.nid"/>'},
					success : jfqlqjllist,					
					async: true
				});
			};
			var jfqlqjllist = function(data){	
				if(data.rows == undefined) return false;
				$("#jfqlqjl").empty();
				var th = '<tr><th width="68">使用时间</th><th width="266">领取的商品'
					+'</th><th width="176">使用的积分券</th><th width="106">状态</th><th>操作</th></tr>';
				$("#jfqlqjl").append(th);
				$.each(data.rows, function (i, row) {
					var str = '<tr><td class="gray">'+row.jsrq+'</td><td class="blue"><a class="clip" href="sp!detail.do?sp='+row.sp+'">'
						+row.spmc+'</a></td><td><span class="clip2">'+row.mc+'</span></td><td>'+'交易成功'+'</td><td class="blue">'
						+'<a href="dd!detail.do?crddh='+row.ddh+'">详情</a></td></tr>';
					$("#jfqlqjl").append(str);
				});
			};
			var jfdhjlAjax = function(){
				$.ajax({
					type : 'POST',datatype : 'json',cache : false,
					url : 'ddj!jfdhjl.do',
					data : {param:'<s:property value="user.nid"/>'},
					success : jfdhjllist,					
					async: true
				});
			};
			var jfdhjllist = function(data){	
				if(data.rows == undefined) return false;
				$("#jfdhjl").empty();
				var th = '<tr><th width="68">使用时间</th><th width="266">领取的商品</th><th width="176">积分值'
						+'</th><th width="106">状态</th><th>操作</th></tr>';
				$("#jfdhjl").append(th);
				$.each(data.rows, function (i, row) {
					var str = '<tr><td class="gray">'+row.jsrq+'</td><td class="blue"><a class="clip" href="sp!detail.do?sp='+row.sp+'">'+row.spmc+
					'</a></td><td><span class="bisque"><strong>'+row.jf+'</strong></span> 积分';
					if(row.je != '') str+='&nbsp;+&nbsp;<strong class="bisque">'+row.je+'</strong>元';
					str += '</td><td>'+'交易成功'+'</td><td class="blue"><a href="dd!detail.do?crddh='+row.ddh+'">详情</a></td></tr>';
					$("#jfdhjl").append(str);
				});
			};
			var rmdhAjax = function(){
				$.ajax({
					type : 'POST',datatype : 'json',cache : false,
					url : 'spj!rm.do',
					success : rmdhlist,					
					async: true
				});
			};
			var rmdhlist = function(data){		
				if(data.rows == undefined) return false;
				$("#rmdh").empty();
				$.each(data.rows, function (i, row) {
					var str = '<li class="rmdh-last"><a href="sp!detail.do?spl='+row.nid+'"><img src="'+row.lj
						+'146x146.jpg" title=\"'+ row.mc +'\" /></a><h1>'+row.mc+'</h1><h2><span class="bisque"><strong>'
						+row.qbjf+'</strong></span> 积分</h2></li>';
					$("#rmdh").append(str);
				});
			};
			$(function() {
				$.ajaxSetup({timeout: 300000});
				var timeParam = Math.round(new Date().getTime()/1000);
				$("#yglphoto").attr("src","photo/"+'<s:property value="user.nid" />'+"/little.jpg?time="+timeParam);
					/*$.ajax({
						url:'<%=request.getContextPath() %>/' + 'photo/' + '<s:property value="user.nid" />' + '/normal.jpg?time='+timeParam,
						type:'GET',
						async:false,
						success:function(data){
							$("#yglphoto").attr("src","photo/"+'<s:property value="user.nid" />'+"/normal.jpg?time="+timeParam);		
						},
						error:function(data){
							$("#yglphoto").attr("src",'<%=request.getContextPath() %>/common/images/default_headPortrait.png?time='+timeParam);
						}
					});*/	
					
				jfqAjax();
				jfAjax();
				tszhAjax();
				zjljAjax();
				gsggAjax();
				tjcpAjax();
				jfqlqjlAjax();
				jfdhjlAjax();
				rmdhAjax();
			});
			function ssss(){
				$("#yglphoto").attr("src",'<%=request.getContextPath() %>/common/images/default_headPortrait.png');
			}
		</script>
	<link rel="shortcut icon" href="<%=request.getContextPath() %>/common/images/favicon.ico" type="image/x-icon"></link>
</head>

	<body>
		<%@ include file="head.jsp" %>
		<div id="main">
			<div class="main2">
				<div class="box">
					<div class="centertop">
						<div class="grxx">
							<h1>
								个人信息
							</h1>
							<div class="grxx-m">
								<img id="yglphoto" style="width:67px;height:67px" src='<%=request.getContextPath() %>/photo/<s:property value="user.nid" />/little.jpg' onerror="ssss()"/>
								<span class="name"><s:property value="user.ygxm"/></span>
								<span class="email"><s:property value="user.email"/></span>
								<a href="user!list.do">修改信息</a>
							</div>
							<h2 style="padding-top:5px;">
								您可用积分
							</h2>
							<h3 id="hpyygjf" style="font-size:18px;color:#ff6600;padding-left:10px; float:left;line-height:30px;">
							</h3>
						</div>
						<div class="newfl">
							<div class="newfl-title">
								<a href="jfq!source.do">更多&gt;&gt;</a>最新福利
							</div>
							<ul id="jfqhp">
							</ul>
						</div>
						<div class="indexjf">
							<div class="indexjf-title">
								你获得的积分<a class="center" href="sp!base.do">去商城看看>></a><a class="right" href="jf!source.do">更多&gt;&gt;</a>
							</div>
							<ul id="jfhp">
							</ul>
						</div>
					</div>
					<div class="wrap">
						<div class="wrap-left">
							<%@ include file="leftlist.jsp" %>
							<div class="indexzjll">
								<div class="zjll-title">
									同事们正在兑换
								</div>
								<ul id="tszh">
								</ul>
								<a href="sp!list.do?param=tszd" class="more">查看更多</a>
							</div>
							<div class="indexzjll">
								<div class="zjll-title">
									最近浏览
								</div>
								<ul id="ygzjll">
								</ul>
								<a href="sp!list.do?param=zjll" class="more">查看更多</a>
							</div>
						</div>
						<div class="wrap-right">
							<div class="gsgg">
								<div class="gsgg-title">
									<a href="gb!list.do" style="height:35px">更多&gt;&gt;</a>公司公告
								</div>
								<ul id="gsgg">
								</ul>
							</div>
							<div class="tjcp">
								<div class="tjcp-title">
									<a href="sp!list.do?param=tjsp">更多&gt;&gt;</a>推荐兑换商品
								</div>
								<ul class="tjcplist" id="tjcp">
								</ul>
							</div>
							<div class="indexjl">
								<div class="tjcp-title">
									<a href="jfq!list.do">详细记录&gt;&gt;</a>最近福利领取记录
								</div>
								<div class="jlbox">
									<table id="jfqlqjl" width="100%" border="0" cellspacing="0" cellpadding="0"
										class="jlbiao">
									</table>
								</div>
							</div>
							<div class="indexjl">
								<div class="tjcp-title">
									<a href="jf!list.do">详细记录&gt;&gt;</a>最近积分兑换记录
								</div>
								<div class="jlbox">
									<table id="jfdhjl" width="100%" border="0" cellspacing="0" cellpadding="0"
										class="jlbiao">
									</table>
								</div>
							</div>
							<div class="rmdh">
								<div class="tjcp-title">
									<a href="sp!list.do?param=rmdh">更多&gt;&gt;</a>热门兑换
								</div>
								<ul id="rmdh">
								</ul>
							</div>
						</div>
					</div>					
					<%@ include file="bottomnav.jsp" %>
					</div>
			</div>
		</div>
		<%@ include file="footer.jsp" %>
	</body>
</html>
