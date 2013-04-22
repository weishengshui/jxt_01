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
	var headsearch =function(){
		var key = encodeURI(escape($("#headkey").val()));
		window.location="sp!list.do?key="+key;
	}
	var setSubnav = function(){
		var timeParam = Math.round(new Date().getTime()/1000);				
		$.getJSON("spj!splm.do?time="+timeParam, function(data){
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
		});
	};
	var initqylogo = function(){
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
					$("#qylogo").attr("src",'<%=request.getContextPath() %>/common/images/IReward_LOGO-black.jpg');
				}else{
					$("#qylogo").attr("src",data.rs[0].log);
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
	    
	};
	$(function() {
		initqylogo();
		refreshygjf();
		refreshHeadDhlCount();
		refreshYgxxCount();
		setSubnav();
	});
</script>
<div id="headmain">
		<div class="head">
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
				<img id="qylogo" style="width:180px;height:75px;border:0px"/>
				<img src="common/images/logo3.jpg" />
				<img src="common/images/logo2.jpg" />
				<div class="myjf">
					<h1>我的<br />积分</h1>
					<ul id="myjf">
					</ul>
				</div>
			</div>
			<div class="nav">
				<ul>
					<li><a href="login!list.do">我的首页</a></li>
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