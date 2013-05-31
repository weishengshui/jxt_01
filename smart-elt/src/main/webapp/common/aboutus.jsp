<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工弹性福利，忠诚度奖励平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=request.getContextPath() %>/css/loginstyle.css" type="text/css" rel="stylesheet" />
<script type="text/javascript">
var _bdhmProtocol = (("https:" == document.location.protocol) ? " https://" : " http://");
document.write(unescape("%3Cscript src='" + _bdhmProtocol + "hm.baidu.com/h.js%3F399d3e1eb0a5e112f309a8b6241d62fe' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript" src="<%=request.getContextPath() %>/gl/js/common.js"></script>
<style type="text/css">
	
	.aboutmain {
	    background: none repeat scroll 0 0 #279CD9;
	    background-size:100% 100%;
	    height: 100%-150px;
	    margin: 0 auto;
	    width: 100%;
	    height: 1070px;
	}
	
	.about{width:999px; height:100%; margin:0 auto;}
	.aboutleft{float: left;width: 140px;height: 100%;margin-top: 10px;}	

	.leftnav li {
	    float: left;
	    line-height: 25px;
	    padding-bottom: 5px;
	    padding-left: 10px;
	    text-align: left;
	    width: 120px;
	}
	.leftnav li a {
	    background-color: #616161;
	    color: white;
	    display: block;
	    font-size: 12px;
	    height: 21px;
	    padding: 5px;
	    width: 110px;
		   
	}
	.leftnav li a:hover {
			text-decoration: none;
			color:#35B5FF;
	}
	
	.abouttop{border-color:#C7C7C7;border-left-style: solid;float: left;width: 830px;border-right-style: solid;background-color: #EDEDED;height: 30px;border-width: 1px;border-bottom-style: solid;margin-top: 10px;
		padding-left: 10px;line-height: 30px;
	}
	.aboutContent{border-left-style: solid;float: left;width: 833px;border-bottom-style: solid; border-color: #807D7D;border-width: 1px;padding-left: 10px;
		font-size: 14px;padding: 10px;
	}
	
	.aboutContent .item{
		border-bottom-style: solid;width: 830px;height: 245px;border-color: #DEF4FF;padding-top: 20px;
	}
	.aboutContent .item h3{
		padding-right: 220px;padding-bottom: 10px;
	}
	.aboutContent .item ul{
		padding-top: 20px;
	}
	.aboutContent .item ul li{
		list-style-type: disc;list-style-position: inside;
	}
</style>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
	<div class="head">
		<div class="logo"><img src="../images/IReward-logo-black.jpg" /></div>
	</div>	
	<div class="aboutmain">
		<div class="about" style="background-color: white;">
			<div class="aboutleft">
				<ul class="leftnav">
				    <li>
						<a href="../index.jsp">首页</a>
					</li>
					<li>
						<a href="aboutus.jsp">关于我们</a>
					</li>
					<li>
						<a href="joinus.jsp">商户加盟</a>
					</li>
					<li>
						<a href="recruit.jsp">招纳贤士</a>
					</li>
					<li>
						<a href="contactus.jsp">联系我们</a>
					</li>
				</ul>
			</div>
			<div class="abouttop">
				<h3>关于我们</h3>
			</div>
			<div class="aboutContent">
				<p>
					&nbsp;&nbsp;&nbsp;&nbsp;IRewards致力为企事业单位打造专属的员工奖励，弹性福利管理平台，通过对员工群体福利需求、工作模式的分析，通过自主研发的弹性福利和奖励平台IRewards，提高员工与企业、员工与员工之间的关系，提升员工忠诚度。
				</p>		
				<div class="item">
					<h3 align="right">企业管理者登陆</h3> 
					<div style="float: left;height: 203px;width: 360px;padding-left: 15px;">
						<ul>
							<li>HR及行政管理人员可随时购买奖励积分和福利产品</li>
							<li>及时将积分和福利产品分发放到指定员工账号</li>
							<div align="left" style="padding-top: 50px;padding-left: 60px;">
								<a href="../register.jsp?t=1"><img src="../images/aboutelt/aboutus02.jpg"/></a>
							</div>
						</ul>
					</div>
					<div style="float:left;">
						<img width="360px" src="../images/aboutelt/aboutus01.jpg"></img>
					</div>
					<div style="float: right;height: 168px;padding-right: 10px;padding-top: 35px;">
						<ul>
							<li>购买积分</li>
							<li>发放积分</li>
							<li>购买福利</li>
							<li>发放福利</li>
						</ul>
					</div>
				</div>
				
				<div class="item">
					<h3 align="left" style="padding-left: 130px">员工个人登陆</h3> 
					<div style="float: left;height: 203px;width: 360px;">
						<img width="360px" src="../images/aboutelt/aboutus03.jpg"></img>
					</div>

					<div style="float: left;width:80px; height: 168px;margin-left: 20px;padding-top: 23px;">
						<ul>
							<li>领取积分</li>
							<li>兑换积分</li>
							<li>领取福利</li>
							<li>兑换福利</li>
						</ul>
					</div>
										
					<div style="float: left;height: 203px;width: 355px;padding-left: 15px;">
						<ul>
							<li>员工可方便领取适合自己的奖励积分和福利产品</li>
							<li>员工可自由选取心仪的福利产品以及兑换奖励品</li>
							<div align="left" style="padding-top: 50px;padding-left: 50px;">
								<a href="../register.jsp?t=2"><img src="../images/aboutelt/aboutus04.jpg"/></a>
							</div>
						</ul>						
					</div>
				</div>
				
				<div class="item">
					<h3 align="right" style="padding-right: 243px">福利商城</h3> 
					<div style="float: left;height: 203px;width: 360px;padding-left: 15px;">
						<ul>
							<li>IRewards平台拥有丰富的商品供企业及其员工选择
								<p>
									<ol style="padding-left: 40px;">
										<li>百种服务类商品</li>
										<li>数千种实物类商品</li>
									</ol>
								</p>
							</li>
							<li>企业可通过IRewards平台将各类型商品进行任意组合</li>
							<li>IRewards平台能够降低企业福利采购成本、运营成本</br>和时间成本</li>
							<div align="left" style="padding-top: 10px;padding-left: 60px;">
								<a href="/eltcustom/sp!base.do"><img src="../images/aboutelt/aboutus07.jpg"/></a>
							</div>
						</ul>
					</div>
					<div>
						<div style="float:left;padding: 15px 15px 0 5px;">
							<img src="../images/aboutelt/aboutus05.jpg"></img>
						</div>
						<div style="float: left;padding: 15px 0 0 15px;">
							<img src="../images/aboutelt/aboutus06.jpg"></img>
						</div>
					</div>
				</div>
				</br>
				<p> 
					&nbsp;&nbsp;&nbsp;&nbsp;IRewards是国内领先的专注于员工忠诚度管理的专业服务公司。公司由一支专业的、长期从事员工忠诚度及薪酬福利管理的资深人士组成，公司为金融、IT及咨询、零售快消、能源医药等多个行业的企事业客户，提供员工弹性福利管理及忠诚度奖励方面的专业服务，积累了丰富的经验。公司总部位于上海，凭借快速发展，目前公司已在深圳设立分公司。
				</p>
				
				<table style="font-size: 14px;margin-top: 25px;">
					<tr>
						<td>公司地址：</td> 
						<td>上海市复兴中路1号申能国际大厦1409室&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>联系电话：</td>
						<td>021-33765505*206   </td>
					</tr>
					<tr>
						<td>公司网址：</td>
						<td>www.irewards.cn</td>
						<td>Email：</td>
						<td>client@irewards.cn</td>
					</tr>
				</table>
			</div>
		</div>
	</div>

	<div class="bottom">
	  <div style="margin:0 auto;width:860px;overflow:hidden;">
	    <div style="width:440px; margin:0px 30px;float:left;">
			<a target="_blank"  href="aboutus.jsp">关于我们</a><a target="_blank" href="joinus.jsp">商户加盟</a><a target="_blank" href="recruit.jsp">招贤纳士</a><a target="_blank" href="contactus.jsp">联系我们</a><a target="_blank" href="http://blog.IRewards.cn">Blog</a>
			<div style="margin-top:10px;"><a target="_blank" href="http://www.miibeian.gov.cn">沪ICP备12045301号</a></div>
	    </div>
	    <div style="text-align:left;line-height:0;margin:0px 30px;float:left;width:300px;">
	        <a target="_blank" href="http://blog.IRewards.cn" style="text-decoration:underline;position:relative;top:-33px;"></a>
	    	<span style="height:78px;float:left;width:78px;">
	    		<a target="_blank" href="http://weibo.com/yuangongfuli" style="padding:0px;float:left;height:15px;line-height:16px;margin-bottom:5px;">新浪微博</a>
		    	<a target="_blank" href="http://weibo.com/yuangongfuli" style="float:left;padding:0px;"><img src="../images/weibo-sina2.jpg" style="height:55px;width:55px;" /></a>
	    	</span>
	    	<span style="height: 78px; float: left; width: 78px;">
	    		<a target="_blank" href="http://t.qq.com/tanxingfuli" style="padding:0px;float:left;height:15px;line-height:16px;margin-bottom:5px;">腾讯微博</a>
		    	<a target="_blank" href="http://t.qq.com/tanxingfuli" style="float: left;padding:0px;"><img src="../images/weibo-qq2.jpg" style="height:55px;width:55px;" /></a>
	    	</span>
	    	<img src="../images/weixing.jpg" style="width:78px;height:78px;float:left;" />
	    </div>
	  </div>
	</div>
</body>
</html>

