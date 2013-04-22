<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %> 
<%@ taglib uri="/struts-tags" prefix="s"%>
<script type="text/javascript">
	var logout = function(){
		var timeParam = Math.round(new Date().getTime()/1000);
		$.getJSON("loginj!logout.do?time="+timeParam, function(){
			window.location = "login.action";
		});
	}
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
	}
	var refreshYgxxCount = function(){
		var timeParam = Math.round(new Date().getTime()/1000);
		$.getJSON("gbj!wdsl.do?time="+timeParam, function(data){
			var wdsl = data.count;
			$("#headxxtotal").html(wdsl);
		});
	}
	var initqylogo = function(){
		var timeParam = Math.round(new Date().getTime()/1000);	
		$.getJSON("userj!getqy.do?time="+timeParam, function(data){
			if(data.rs == undefined) return false;
			$("#qylogo").attr("src",data.rs[0].log);
		});
	}
	var markit = function(){
	   if (document.all){
	      window.external.addFavorite('http://www.irewards.cn','IRewards');
	   }
	   else if (window.sidebar){
	      window.sidebar.addPanel('IRewards', 'http://www.irewards.cn', "");
	   }
	}
	$(function() {
		initqylogo();
		refreshygjf();
		refreshHeadDhlCount();
		refreshYgxxCount();
	});
</script>
<div class="headmain">
		<div class="head" style="padding-bottom:2px">
			<div class="top">
				<p>你好，<a href="user!list.do">${sessionScope.user.ygxm}</a>！欢迎来到员工积分平台！【<a onclick="logout()" href="#">退出</a>】</p>
				<div class="top-right">
					<span><img src="common/images/ico2.jpg" /></span>
					<h1>兑换篮（<label class="bisque"><a id="headhdltotal" href="dhl!list.do">0</a></label>）</h1>
					<span><img src="common/images/ico-mail.jpg" /></span>
					<h1>消息：（<label class="blue"><a id="headxxtotal" href="gb!list.do">0</a></label>）</h1>
					<span><img src="common/images/ico1.jpg" /></span>
					<h1>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</h1>
					<span><img src="common/images/ico2.jpg" /></span>
					<h1><a href="#" onclick="markit()">收藏本站</a></h1>
				</div>
			</div>	
			<div class="logo">
				<img id="qylogo" style="width:180px;height:75px;border:0px" />
				<img src="common/images/logo3.jpg" />
				<img src="common/images/logo2.jpg" />
				<div class="myjf">
					<h1>我的<br />积分</h1>
					<ul id="myjf">
					</ul>
				</div>
			</div>		
		</div>
	</div>