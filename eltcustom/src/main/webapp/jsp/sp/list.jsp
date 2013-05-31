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
		<style type="text/css">
			#lmlist .level2 {
				display: none;
			    position: absolute;
			    left: 0px;
			    width: 100px;
			    background-color: #F3F3F3;
				padding: 5px 5px 5px 15px;
				overflow: hidden;
				border: 1px solid #DEDEDE;
				border-top: medium none;
			}
			#lmlist .selected {
				position:relative;
				background-color: #F3F3F3;
			}
			#lmlist .selected .level2 {
				display: block;
			}
			#lmlist .showsublm {
			    background: url("common/images/ico7.jpg") no-repeat scroll center center transparent;
			    float: none !important;
				display: inline-block;
				width: 9px;
				height:9px;
			    margin-left: 5px;
			    cursor: pointer;
			}
			#lmlist .hidesublm {
			    background: url("common/images/ico8.jpg") no-repeat scroll center center transparent;
			    float: none !important;
				display: inline-block;
				width: 9px;
				height:9px;
			    margin-left: 5px;
			    cursor: pointer;
			}
			#lmlist .level3 {
				margin-left: 15px;
				display: none;
			}
			.sccx dl dt .jifenginput {
				width: 60px;
			}
		</style>
		<script type="text/javascript">	
			var headnavsel = "";
			var spurl="spj!pagespl.do";
			var dosearch =function(t){
				$("#lmlist .selected").find(".hidesublm").removeClass("hidesublm").addClass("showsublm");
				$("#lmlist .selected").removeClass("selected");
				
				if(typeof(t)!='undefined'&&t==1){
					$("#order").val(" t.xswz desc ,t.rq desc ");
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
					var str='<li><a  href="sp!detail.do?spl='+row.nid+'"><img src="'+row.lj+'210x210.jpg" title=\"'+ row.mc +'\"/></a><p class="scpro-title"><span class="scpro-title-content">'
						+row.mc+'</span></p>'+dhfs+'<div class="scpro-money2"><label><span class="bisque">'
						+row.qbjf+'</span></label> 积分</div></li>';
					$("#splist").append(str);
				});
				$(".listpages").page({total:data.total,currentpage:data.page,gopage:gopage,pagesize:16});
			};
			<s:if test="%{#session.user.nid!=0}">
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
			</s:if>
			var rmtj = function(){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("spj!rm3.do?time="+timeParam, function(data){
					if(data.rows == undefined) return false;
					$("#rmtjlist").empty();
					$.each(data.rows, function (i, row) {
						var str = '<li><a href="sp!detail.do?spl='+row.nid+'"><img  src="'+row.lj+'210x210.jpg"title=\"'+ row.mc +'\" /></a><span><a href="sp!detail.do?spl='+row.nid+'">'+row.mc+'</a><p><strong>'+row.qbjf
						+'</strong> 积分</p></span></li>';
						$("#rmtjlist").append(str);
					});
				});
			};	
			/*var splm = function(){
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
			}; */
			var splm = function() {
				$.ajax({
					type: 'POST', datatype: 'json', cache: false,
					 url: 'spj!splmList.do',
					 async: false,
					 success: splmprocess
				});
			};
			var splmprocess = function(data) {
				$("#lmlist").empty();
				var tmpArr = new Array();
				$.each(data, function(i, lm1) {
					tmpArr.push('<li><input id="lb1" rule ="or" type="checkbox" value="'+lm1.nid+'" />'+lm1.mc);
					if (lm1.children.length > 0) {
						tmpArr.push('<span class="showsublm"></span>');
						tmpArr.push('<ul class="level2">');
						$.each(lm1.children, function(j, lm2) {
							tmpArr.push('<li style="width: 100%;"><input id="lb2" rule ="or" type="checkbox" value="'+lm2.nid+'" />'+lm2.mc);
							tmpArr.push('<ul class="level3">');
							if (lm2.children.length > 0) {
								$.each(lm2.children, function(k, lm3) {
									tmpArr.push('<li><input id="lb3" rule ="or" type="checkbox" value="'+lm3.nid+'" />'+lm3.mc+'</li>');
								});
							}
							tmpArr.push('</ul>');
							tmpArr.push('</li>');
						});
						tmpArr.push('</ul></li>');
					}
				});
				$("#lmlist").append(tmpArr.join(''));
				if('<s:property value="lm"/>'!=''){
					$("#lmlist :checkbox[value='<s:property value="lm"/>']").attr("checked","checked");
					$("#lmlist input:checked").parent().find(":checkbox").attr("checked","checked");
				}
			};
			$(function() {
				$.ajaxSetup({timeout: 300000});
				splm();
				if('<s:property value="key" />'!=''){
					$("#mc").val(decodeURI(unescape('<s:property value="key" />')));
				}
				$("#order").val(" t.xswz desc ,t.rq desc ");
				spurl = 'spj!page<s:property value="param"/>.do<s:property value="query"/>';
				gopageurl(16,1,spurl);
				rmtj();
				<s:if test="%{#session.user.nid!=0}">
				  zjll();
				</s:if>
				$("#mrpx").click(function(){
					$("#order").val(" t.xswz desc ,t.rq desc ");
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
				
				$("#lmlist").find(".showsublm").live('click', function() {
					$("#lmlist").find(".selected").removeClass("selected");
					$("#lmlist").find(".hidesublm").removeClass("hidesublm").addClass("showsublm");					
					var $this = $(this);
					$this.removeClass("showsublm").addClass("hidesublm");
					$this.parent().find(".level2").css("top", $this.parent().height());
					$this.parent().addClass("selected");
				});
				$("#lmlist").find(".hidesublm").live('click', function() {
					var $this = $(this);
					$this.parent().removeClass("selected");
					$this.removeClass("hidesublm").addClass("showsublm");
				});
				$("#lmlist :checkbox").live('click', function() {
					var $this = $(this);
					if ($this.attr("checked")) {
						$this.parent().find(":checkbox").attr("checked", true);
					} else {
						$this.attr("checked", false);
						$this.parent().find(":checkbox").attr("checked", false);
						if (!$this.parent().parent().hasClass("level1")) {
							unselectedParent($this);
						}
					}
				});
				function unselectedParent($obj) {
					var $li = $obj.parent().parent().parent();
					$obj = $li.find("input:first");
					$obj.attr("checked", false);
					if ($li.hasClass("selected")) {
						return;
					}
					unselectedParent($obj);
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
									<ul class="fenglei level1" id="lmlist">
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
					<s:if test="%{#session.user.nid!=0}">
					  <div class="zthd">
						<div class="zthd-title"><h1>&nbsp;&nbsp;最近浏览</h1></div> 
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
