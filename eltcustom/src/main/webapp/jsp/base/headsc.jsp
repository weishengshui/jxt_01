<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %> 
<%@ taglib uri="/struts-tags" prefix="s"%>
<style>
<!--
	#headnavlist .level1 {
		position: relative;
		z-index: 100;
	}
	#headnavlist .level2 {
	    background-color: #F3F3F3;
	    display: none;
		position: absolute;
	    top: 50px;
	    left: 0;
	    z-index: 101;
	    width: 630px;
	    min-height: 100px;
	    border: 3px solid #B6E4FF;
	}
	#headnavlist .level2 li h1 {
		color: black;
	    text-align: right;
	    width: 80px;
	    padding: 5px;
	    font-weight: 600px;
	    font-size: 13px;
	}
	#headnavlist .level1 li {
	    display: inline-block;
	    float: left;
	    position: relative;
	    margin: 1px 0;
	}
	#headnavlist .level2 li a {
	    height: 30px;
	}
	#headnavlist .level3 {
	    float: left;
	    width: 500px;
	}
	#headnavlist .level3 li {
		border-left: 1px solid #CCCCCC;
	}
	#headnavlist .level2 .level3 li a h1 {
	    text-align: center;
	    width: auto;
	    font-weight: normal;
	    font-size: 12px;
	}
-->
</style>
<script type="text/javascript">
	var logout = function(){
		var timeParam = Math.round(new Date().getTime()/1000);
		$.getJSON("loginj!logout.do?time="+timeParam, function(){
			window.location = "login.action";
		});
	};
	var login = function(){
		window.location = "login.action";
	};
	var refreshygjf = function(){
		var timeParam = Math.round(new Date().getTime()/1000);
		$.getJSON("userj!getjf.do?time="+timeParam, function(data){
			var myjf = data.rs.jf;
			formatjf(myjf);
			$("#hpyygjf").html(myjf);
		});		
	};
	var formatjf = function(myjf){
		$("#myjf").empty();
		myjf = myjf.toString();
		if(myjf.length <5){
			for(var i=0;i<5-myjf.length;i++){
				$("#myjf").append("<li>0</li>");
			}
		}
		for(var j=0;j<myjf.length;j++){
			$("#myjf").append("<li>"+myjf.substring(j,j+1)+"</li>");
		}
	};
	var refreshYgxxCount = function(){
		var timeParam = Math.round(new Date().getTime()/1000);
		$.getJSON("gbj!wdsl.do?time="+timeParam, function(data){
			var wdsl = data.count;
			$("#headxxtotal").html(wdsl);
		});
	};
	var headsearch =function(){
		var key = encodeURI(escape($("#headkey").val()));
		window.location="sp!list.do?key="+key;
	};
	var setSubnav = function(){
		var timeParam = Math.round(new Date().getTime()/1000);				
		/* $.getJSON("spj!splm.do?time="+timeParam, function(data){
			if(data.rows == undefined) return false;
			$("#headnavlist").empty();
			var hp = '<a href="sp!base.do"><span><img src="common/images/subnav-ico1.png" /></span><h1>商城首页</h1></a>';
			$("#headnavlist").append(hp);
			$.each(data.rows, function (i, row) {
				var str = '<a id="headnav'+row.nid+'" href="sp!list.do?lm='+row.nid+'"><span><img src="'+row.lmtp+'" /></span><h1>'+row.mc+'</h1></a>';
				$("#headnavlist").append(str);
			});
			if(typeof(headnavsel) != "undefined" && headnavsel!=""){				
				$("#"+headnavsel).addClass("on");
			}
		}); */
		$.getJSON("spj!splmList.do?time="+timeParam, function(data) {
			if (data) {
				var $headnavlist = $("#headnavlist");
				$headnavlist.empty();
				var tmpArr = new Array();
				tmpArr.push('<ul class="level1">');
				tmpArr.push('<li><a href="sp!base.do"><span><img src="common/images/subnav-ico1.png" /></span><h1>商城首页</h1></a></li>');
				var lm1Len = data.length;
				for (var i=0; i<lm1Len; i++) {
					var lm1 = data[i];
					tmpArr.push('<li><a id="headnav'+lm1.nid+'" href="sp!list.do?lm='+lm1.nid+'"><span><img src="'+lm1.lmtp+'" /></span><h1>'+lm1.mc+'</h1></a>');
					if (lm1.children) {
						tmpArr.push('<ul class="level2">');
						var lm2Len = lm1.children.length;
						for (var j=0; j<lm2Len; j++) {
							var lm2 = lm1.children[j];
							tmpArr.push('<li><a id="headnav'+lm2.nid+'" href="sp!list.do?lm='+lm2.nid+'"><h1>'+lm2.mc+'</h1></a>');
							if (lm2.children) {
								tmpArr.push('<ul class="level3">');
								var lm3Len = lm2.children.length;
								for (var k=0; k<lm3Len; k++) {
									var lm3 = lm2.children[k];
									tmpArr.push('<li><a id="headnav'+lm3.nid+'" href="sp!list.do?lm='+lm3.nid+'"><h1>'+lm3.mc+'</h1></a></li>');
								}
								tmpArr.push('</ul>');
							}
							tmpArr.push('</li>');
						}
						tmpArr.push('</ul>');
					}
					tmpArr.push('</li>');
				}
				$headnavlist.append(tmpArr.join(''));
				eventHandle();
			}
		});
	};
	
	var eventHandle = function() {
		var lis = $("#headnavlist").find(".level1 > li");
		var lisLen = lis.length;
		var firstLiWidth = lis[0].offsetWidth;
		var moveableAreaWidth = lis[lisLen-1].offsetLeft + lis[lisLen-1].offsetWidth - firstLiWidth;
		$("#headnavlist .level1 li").die();
		$("#headnavlist .level1 li").live({
			mouseover: function() {
				var $this = $(this);
				var $level2 = $this.find(".level2");
				var content = $level2.html();
				if (!content)
					return;
				var level2Width = $level2.width();
				var myOffsetLeft = $this.get(0).offsetLeft;
				
				if (moveableAreaWidth < level2Width) {
					$level2.css("left", firstLiWidth - myOffsetLeft);
				} else {
					var tmp = moveableAreaWidth - (myOffsetLeft - firstLiWidth + level2Width);
					if (tmp > 0) {
						$level2.css("left", 0);
					} else {
						$level2.css("left", tmp);
					}
				}
				$level2.show();
			},
			mouseout: function() {
				$(this).find(".level2").hide();
			}
		});
	};
	
	var initqyinfo = function(){
		/* var timeParam = Math.round(new Date().getTime()/1000);	
		$.getJSON("userj!getqy.do?time="+timeParam, function(data){
			if(data.rs == undefined) return false;
			$("#qylogo").attr("src",data.rs[0].log);
		}); */
		$.ajax({
			url:'userj!getqy.do',
			type:'GET',
			async:false,
			success:function(data){
				if(data.rs == undefined || data.rs[0].log == ""){
					$("#qylogo").attr("src",'<%=request.getContextPath() %>/common/images/IReward-logo-white2.jpg');
				}else{
					$("#qylogo").attr("src",data.rs[0].log);
				}
				if (data.rs != undefined && data.rs[0].qymc != "") {
					$("#qymc").html(data.rs[0].qymc);
				}
			},
			error:function(data){
			}
		});	
	};
	var markit = function(){
	  
	   if (document.all){
	      window.external.addFavorite('http://www.irewards.cn','IRewards');
	   }
	   else if (window.sidebar){
	      window.sidebar.addPanel('IRewards', 'http://www.irewards.cn', "");
	   }
	   else {
		   alert("加入收藏失败，请使用Ctrl+D进行添加");
	   }
	    
	};
	$(function() {
		initqyinfo();
		refreshygjf();
		refreshHeadDhlCount();
		refreshYgxxCount();
		setSubnav();
	});
</script>
<div id="headmain">
		<div class="head">
			<div class="top">
				<p>你好，<a href="user!list.do">${sessionScope.user.ygxm}</a><s:if test="%{#session.user.nid!=0}">！</s:if>欢迎来到<s:if test="%{#session.user.nid!=0}"><span id="qymc" style="font-weight: bold;"></span></s:if><s:else><span style="font-weight: bold;">IRewards</span></s:else>弹性福利与奖励平台！【<s:if test="%{#session.user.nid!=0}"><a onclick="logout()" href="#">退出</a></s:if><s:else><a onclick="login()" href="#">登录</a></s:else>】</p>
				<div class="top-right">
				  <s:if test="%{#session.user.nid!=0}">
					<span><img src="common/images/ico2.jpg" /></span>
					<h1>兑换篮（<label class="bisque"><a id="headhdltotal" href="dhl!list.do">0</a></label>）</h1>
					<span><img src="common/images/ico-mail.jpg" /></span>
					<h1>消息：（<label class="blue"><a id="headxxtotal" href="gb!list.do">0</a></label>）</h1>
					<span><img src="common/images/ico1.jpg" /></span>
					<h1>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</h1>
				  </s:if>
					<span><img src="common/images/markit.gif" /></span>
					<h1><a href="#" onclick="markit()">收藏本站</a></h1>
				</div>
			</div>	
			<div class="logo">
				<img id="qylogo"  src="/eltcustom/common/images/IReward-logo-white2.jpg" style="width:180px;height:75px;border:0px"/>
				<img src="common/images/logo3.jpg" />
				<img src="common/images/logo2.jpg" />
				<!--  
				<div class="myjf">
					<h1>我的<br />积分</h1>
					<ul id="myjf">
					</ul>
				</div>
				-->
			</div>
			<div class="nav">
				<ul>
				  <s:if test="%{#session.user.nid!=0}">
					<li><a href="login!list.do">我的首页</a></li>
				  </s:if>
					<li><a href="sp!base.do" class="nowone">福利商城</a></li>
				</ul>
				<div class="search">
					<input id="headkey" type="text" class="searchinput"/>
					<input onclick="headsearch();" type="button" class="searchbtn" />
				</div>
			</div>			
			<div class="subnav" id="headnavlist">
			</div>	
		</div>
	</div>