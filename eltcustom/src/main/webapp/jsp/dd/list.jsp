<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>IRewards</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<link type="text/css" rel="stylesheet" href="common/css/style.css">
		<link type="text/css" rel="stylesheet" href="common/css/ymPrompt.css">
		<script type="text/javascript" src="common/js/jquery-1.7.min.js"></script>
		<script type="text/javascript" src="common/js/common.js"></script>
		<script type="text/javascript" src="common/js/jquery.page.js"></script>	
		<script type="text/javascript" src="common/js/ymPrompt.js"></script>			
		<script type="text/javascript">	
			var ddsl = function(){
				var timeParam = Math.round(new Date().getTime()/1000);
				$.getJSON("ddj!ddc.do?time="+timeParam, function(data){
					if(typeof(data.rows[0])!="undefined"){
						$("#dfk").html(data.rows[0].ddc);
						$("#dfk").click(function(){
							$("#state").val("0");
							listzb(10,1);
						});
					}
					if(typeof(data.rows[1])!="undefined"){
						$("#dqrsh").html(data.rows[1].ddc);
						$("#dqrsh").click(function(){
							$("#state").val("2");
							listzb(10,1);
						});
					}
					if(typeof(data.rows[2])!="undefined"){
						$("#dpj").html(data.rows[2].ddc);
						$("#dpj").click(function(){
							$("#state").val("3,4");
							listzb(10,1);
						});
					}
				});
			};
			var ymclose = function(){ymPrompt.close();};
			var pingjia = function(ddh){				
				ymPrompt.win({message:'pj!pop.do?ddh='+ddh,
					width:630,height:500,title:'评价商品',iframe:true});
			}
			var cancel = function(ddh){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("ddj!cancel.do?time="+timeParam,{param:ddh}, function(data){
					ymPrompt.win({message:'<div class=\'popbox\'>'+data.rs+'</div>',width:185,height:55,titleBar:false});
					var timeClose = setTimeout(ymclose, 2500);
					listzb(10,1);
				});					
			}
			var confirm = function(ddh){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("ddj!confirm.do?time="+timeParam,{param:ddh}, function(data){
					ymPrompt.win({message:'<div class=\'popbox\'>'+data.rs+'</div>',width:185,height:55,titleBar:false});
					var timeClose = setTimeout(ymclose, 2500);
					listzb(10,1);
				});					
			}
			var remind = function(ddh){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("ddj!remind.do?time="+timeParam,{param:ddh}, function(data){
					ymPrompt.win({message:'<div class=\'popbox\'>'+data.rs+'</div>',width:205,height:55,titleBar:false});
					var timeClose = setTimeout(ymclose, 2500);
					listzb(10,1);
				});					
			}
			var listzb = function(rp,page,query){				
				ddsl();
				var params = getParams("listin");
				$.ajax({
					type : 'POST',datatype : 'json',cache : false,
					data : {param:params,page:page,rp:rp},
					url : 'ddj!page.do',
					async: false,
					success : function(data){
						var dds = '';
						if(data.rows == undefined) return false;
						$("#ddlist").empty();
						$("#ddhidelist").empty();$(".listpages").empty();
						$.each(data.rows, function (i, row) {
							 var cjzt = '';
							 if(row.jsrq !=''){
								 cjzt = '&nbsp;&nbsp;&nbsp;&nbsp;成交时间：'+row.jsrq;
							 }
							 var zffs ='';
							 if(row.zjf!=''){
								zffs += '<strong class="bisque">'+row.zjf+'</strong> 积分';
							 }
							 if(row.zje!=''){
								zffs += ' + <strong class="bisque">'+row.zje+'</strong> 现金';
							 }
							 var jfqsl = '';
							 if(row.jfqsl!='' && row.jfqsl!=0){
								jfqsl = '<br />积分券<strong class="bisque">'+row.jfqsl+'</strong>张';
							 }
							 var jyzt = '';
							 var cz = '';
							 if(row.state==0){
								 jyzt = '待支付';
								 cz = '<a class="confirm-sh" href="dd!gopay.do?crddh='+row.ddh+'">支付</a><br />'
									 +'<a class="confirm-sh" onclick="cancel(\''+row.ddh+'\')">取消订单</a>';
							 }
							 if(row.state==1){
								 jyzt = '已支付<br /><span class="blue"><a href="dd!detail.do?crddh='+row.ddh+'">订单详情</a></span>';
								// cz = '<a class="confirm-sh" onclick="remind(\''+row.ddh+'\')">提醒发货</a>';
							 } 
							 if(row.state==11){
								 jyzt = '已支付<br /><span class="blue"><a href="dd!detail.do?crddh='+row.ddh+'">订单详情</a></span>';
								// cz = '已提醒发货';
							 } 
							 if(row.state==2){
								 jyzt = '待收货<br /><span class="blue"><a href="dd!detail.do?crddh='+row.ddh+'">订单详情</a></span>';
								 cz = '<a class="confirm-sh" onclick="confirm(\''+row.ddh+'\')">确认收货</a>';
							 }
							 if(row.state==3){
								 jyzt = '待评价<br /><span class="blue"><a href="dd!detail.do?crddh='+row.ddh+'">订单详情</a></span>';
								 cz = '<a class="confirm-sh" onclick="pingjia(\''+row.ddh+'\')">评价</a>';
							 }
							 if(row.state==4){
								 jyzt = '待评价<br /><span class="blue"><a href="dd!detail.do?crddh='+row.ddh+'">订单详情</a></span>';
								 cz = '<a class="confirm-sh" onclick="pingjia(\''+row.ddh+'\')">评价</a>';
							 }
							 if(row.state==5){
								 jyzt = '评价成功<br /><span class="blue"><a href="dd!detail.do?crddh='+row.ddh+'">订单详情</a></span>';
							 }
							 if(row.state==9){
								 jyzt = '已取消';
							 }
							var hidestr = '<tr id="hide'+row.nid
								+'"><td width="120" valign="top">'+zffs+jfqsl+'<br /><label class="gray">(含快递 0现金)</label></td>'
								+'<td width="115" valign="top">'+jyzt+'</td><td valign="top">'+cz+'</td></tr>';
							var str ='<div class="orderlist"><table id="tab'+row.nid+'" width="100%" border="0" cellspacing="1" cellpadding="0" class="orderlist-table">'
								+'<tr><th colspan="4">订单号：'+row.ddh+cjzt+'</th></tr></table></div>';
							$("#ddlist").append(str);
							$("#ddhidelist").append(hidestr);
							dds += row.nid+',';					
						});
						$(".listpages").page({total:data.total,currentpage:data.page,gopage:listzb,pagesize:10});
						if(dds!=''){
							dds = dds.substring(0,dds.length-1);
							$.ajax({
								type : 'POST',datatype : 'json',cache : false,
								data : {param:dds},
								url : 'ddj!listmx.do',
								async: false,
								success : function(da){
									if(da.rows == undefined) return false;
									var rowlength = da.rows.length;
									var trowspan = 1;
									var tzdd = '';
									$.each(da.rows, function (i, row) {
										var tdstr = '';
										var mxzffs = '';
										if(row.jf!=''){
											mxzffs+='<strong class="bisque">'+row.jf+'</strong> 积分';
										}
										if(row.je!=''){
											mxzffs+=' + <strong class="bisque">'+row.je+'</strong> 现金';
										}
										if(row.jfq!=''&&row.jfq!=0){
											mxzffs+=row.mc+'<strong class="bisque">'+row.sl+'</strong>张';
										}
										tdstr = '<tr><td width="367"><div class="order-states"><img src="'+row.lj+'60x60.jpg" /><p class="blue"><a href="sp!detail.do?sp=' +
											 row.sp+'">'+row.spmc+'</a></p><span>'+mxzffs+'</span><h2>'+row.sl+'</h2></div></td></tr>';
										$("#tab"+row.dd).append(tdstr);
										if(tzdd == ''){
											tzdd = row.dd;
										}
										else if(tzdd == row.dd){
											trowspan++;
										}
										else if(tzdd != ''&&tzdd != row.dd){
											$("#hide"+tzdd+" td").attr("rowspan",trowspan);
											$("#tab"+tzdd+" tr").eq(1).append($("#hide"+tzdd).html());
											tzdd = row.dd;
											trowspan = 1;
										}
										if(i==(rowlength-1)){
											$("#hide"+tzdd+" td").attr("rowspan",trowspan);
											$("#tab"+tzdd+" tr").eq(1).append($("#hide"+tzdd).html());
										}
									});
								}
							});
						}
					}
				});
			};
			$(function(){
				listzb(10,1);
			})
		</script>
	<link rel="shortcut icon" href="<%=request.getContextPath() %>/common/images/favicon.ico" type="image/x-icon" /></head>

	<body>
	<%@ include file="/jsp/base/head.jsp" %>
<div id="main">
		<div class="main2">
			<div class="box">
				<div class="wrap">
					<div class="wrap-left">					
					<%@ include file="/jsp/base/leftlist.jsp" %>					
					<script type="text/javascript">menusel(7);</script>
					</div>
					<div class="wrap-right">
						<div class="list">
							<div class="list-title"><h1>我的订单</h1>
								<div class="l-headsl">
									待支付 （<strong id="dfk" style="cursor:pointer" class="bisque">0</strong>）
									待确认收货（<strong id="dqrsh" style="cursor:pointer" class="bisque">0</strong>）
									待评价（<strong id="dpj" style="cursor:pointer" class="bisque">0</strong>）
								</div>
							</div>
							<div class="listin">
								<div class="ordercx">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
									  <tr>
										<td width="52"><label>订单号：</label></td>
										<td width="140"><input id="ddh" rule="like" type="text" maxlength="40" class="ordercxbox" /></td>
										<td width="38"><label>时间：</label></td>
										<td width="168"><select id="cjrq"  rule="daylimit" style="width:120px">								
											<option value="">-请选择-</option>
											<option value="7" >近七天</option>
											<option value="30" >近一个月</option>
											<option value="91" selected>近三个月</option>
											<option value="182">近半年</option>
											<option value="365">近一年</option>
										</select></td>
										<input id="yg" rule="eq" type="hidden" value='<s:property value="user.nid" />' />
										<td><input value=" " onclick="listzb(10,1);" type="button" class="searchbtn2" /></td>
									  </tr>
									</table>
								</div>	
								<div class="orderhead">
									<table width="100%" border="0" cellspacing="0" cellpadding="0" class="orderhead-table">
									  <tr>
										<th width="190">商品信息</th>
										<th width="110">兑换价</th>
										<th width="47">数量</th>
										<th width="120">合计</th>
										<th width="115">
										  <select id="state" onchange="listzb(10,1);" rule="in" style="width:100px">
										    <option value="">交易状态</option>
										    <option value="0">待支付</option>
										    <option value="1,11">已支付</option>
										    <option value="2">待收货</option>
										    <option value="3,4">待评价</option>
										    <option value="5">评价成功</option>
										    <option value="9">已取消</option>
									      </select>
										</th>
										<th>操作</th>
									  </tr>
									</table>
								</div>
							</div>							
						</div>
						<table id="ddhidelist" style="display:none">
						</table>								
						<div id="ddlist">
					 	</div>	
						<div class="listpages"></div>					
					</div>
				</div>
				<%@ include file="/jsp/base/bottomnav.jsp" %>
			</div>
		</div>
	</div>
	<%@ include file="/jsp/base/footer.jsp" %>
	</body>
</html>
