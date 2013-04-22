<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
	var menusel = function(num){
		if(num==8){
			$(".leftlist a").eq(num).css("background-color","#2BB1FF");
		}
		if(num==2||num==3){
			$("#menu1sub").show();
			$("#menu2sub").show();
			$(".leftlist a").eq(num).css("color","#2bb1ff");
		}
		if(num==5||num==6){
			$("#menu1sub").show();
			$("#menu3sub").show();
			$(".leftlist a").eq(num).css("color","#2bb1ff");
		}
		if(num==7){
			$("#menu1sub").show();
			$(".leftlist a").eq(num).css("color","#2bb1ff");
		}
		if(num==10||num==11||num==12){
			$("#menu4sub").show();
			$(".leftlist a").eq(num).css("color","#2bb1ff");
		}
	};
	$(function(){
		$(".leftlist a[id^='menu']").toggle(
			function(){
				$("#"+$(this).attr("id")+"sub").show();
				if($(this).attr("id")=="menu2"||$(this).attr("id")=="menu3"){
					$(this).addClass("leftbanon");
					$(this).removeClass("leftbanoff");
				}
			},
			function(){
				$("#"+$(this).attr("id")+"sub").hide();
				if($(this).attr("id")=="menu2"||$(this).attr("id")=="menu3"){
					$(this).addClass("leftbanoff");
					$(this).removeClass("leftbanon");
				}
			}
		);
	});
</script>
<ul class="leftlist">
	<li>
		<span class="list1"><a id="menu1" href="#">我的福利和积分</a></span>
		<div id="menu1sub" style="display:none">
			<span class="list4"><a href="#" class="leftbanoff" id="menu2">我的福利</a></span> 
			<dl id="menu2sub"  style="display:none">
				<dd><a href="jfq!source.do">福利详情</a></dd>
				<dd><a href="jfq!list.do">使用明细</a></dd>
			</dl>
			<span class="list4"><a href="#" class="leftbanoff" id="menu3">我的积分</a></span>
			<dl id="menu3sub" style="display:none">
				<dd><a href="jf!source.do">积分来源</a></dd>
				<dd><a href="jf!list.do">兑换明细</a></dd>
			</dl>
			<span class="list2"><a href="dd!list.do">我的订单</a></span>
		</div>
	</li>
	<li>
		<span class="list1"><a href="gb!list.do">公司公告</a></span>
	</li>
	<li>
		<span class="list1"><a id="menu4" href="#">个人设置</a></span>
		<div id="menu4sub"  style="display:none">
			<span class="list2"><a href="user!list.do">基本信息</a></span>
			<span class="list2"><a href="user!pwd.do">密码修改</a></span>
			<span class="list2"><a href="shdz!list.do">收货地址管理</a></span>
		</div>
	</li>
</ul>