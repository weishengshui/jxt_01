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
		<script type="text/javascript" src="common/js/ymPrompt.js"></script>		
		<script type="text/javascript">
			var ymclose = function(){ymPrompt.close();};
			var submitdhl = function(){
				if(getCookie("sp")=="")return false;
				var $dh = $("#dhllist :input[id^='sel']");
				var $num = $("#dhllist :input[id^='num']");
				var dhstr = "";
				var numstr = "";
				for(var i=0;i<$dh.length;i++){
					dhstr += $dh.eq(i).val()+",";
					numstr += $num.eq(i).val()+",";
				}
				dhstr = dhstr.substring(0,dhstr.length-1);
				numstr = numstr.substring(0,numstr.length-1);
				setCookie("dhfs",dhstr,10);
				setCookie("spcount",numstr,10);
				window.location = 'dd!confirm.do';
			}
			var clearsp = function(sp){
				delShopCar(sp);
				refreshdhl();
				total();
			}
			var addsp = function(sp){
				var numsp = parseInt($("#num"+sp).val());
				var maxsp = parseInt($("#max"+sp).html());
				if(numsp<maxsp){
					$("#num"+sp).val(numsp+1);
					subtotal(sp);
					total();
				}
			}
			var checkspnum = function(sp){
				var numsp = $("#num"+sp).val();
				var maxsp = parseInt($("#max"+sp).html());
				numsp = numsp.replace(/[^0-9]*/gi,"");
				if(numsp==""){
					numsp = 1;
				}
				else{
					numsp = parseInt(numsp);
				}
				if(numsp>maxsp){
					$("#num"+sp).val(maxsp);
				}
				else if(numsp<1){
					$("#num"+sp).val(1);
				}
				else $("#num"+sp).val(numsp);
				subtotal(sp);
				total();
			}
			var subsp = function(sp){
				var numsp = parseInt($("#num"+sp).val());
				if(numsp>1){
					$("#num"+sp).val(numsp-1);
					subtotal(sp);
					total();
				}
			}
			var selchange = function(sp){
				subtotal(sp);
				total();				
			}
			var total = function(){
				var $dh = $("#dhllist :input[id^='sel']");
				var $num = $("#dhllist :input[id^='num']");
				var totaljf = 0;
				var totalje = 0;
				var totalcount = 0;
				for(var i = 0;i<$dh.length;i++){
					var tnum = parseInt($num.eq(i).val());
					totalcount += tnum;
					if($dh.eq(i).val().indexOf("_")!=-1){
						var pos = $dh.eq(i).val().indexOf("_");
						var tjf = $dh.eq(i).val().substring(0,pos);
						var tje = $dh.eq(i).val().substring(pos+1,$dh.eq(i).val().length);
						totaljf += parseInt(tjf)*tnum;
						totalje += parseFloat(tje)*tnum;
					}
					else if($dh.eq(i).val().indexOf("jfq")==-1){
						totaljf += parseInt($dh.eq(i).val())*tnum;
					}
				}
				$("#totalsp").html(totalcount);
				$("#totaljf").html(totaljf);
				$("#totalje").html("￥"+totalje);
			}
			var subtotal = function(sp){
				var subtotaljf = 0;
				var subtotalje = 0;
				var subtotaljfq = 0;
				var tnum = parseInt($("#num"+sp).val());
				if($("#sel"+sp).val().indexOf("_")!=-1){
					var pos = $("#sel"+sp).val().indexOf("_");
					var tjf = $("#sel"+sp).val().substring(0,pos);
					var tje = $("#sel"+sp).val().substring(pos+1,$("#sel"+sp).val().length);
					subtotaljf += parseInt(tjf)*tnum;
					subtotalje += parseFloat(tje)*tnum;
				}
				else if($("#sel"+sp).val().indexOf("jfq")==-1){
					subtotaljf += parseInt($("#sel"+sp).val())*tnum;
				}
				else if($("#sel"+sp).val().indexOf("jfq")!=-1){
					subtotaljfq +=tnum;
				}
				if(subtotaljfq == 0){					
					$("#xj"+sp).html("积分："+subtotaljf+"<br />现金：￥"+subtotalje);
				}
				else $("#xj"+sp).html("积分券 × "+subtotaljfq);
			}
			var listdhl = function(sps){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("spj!spbysps.do?time="+timeParam,{param:sps}, function(data){
					if(data.rows == undefined) return false;
					$("#dhllist").empty();
					var th = '<tr><th width="96">商品编号</th><th width="330">商品名称</th>'+
						'<th width="168">兑换价</th><th width="127">商品数量</th><th width="115">小计</th><th>操作</th></tr>';
					$("#dhllist").append(th);
					var spstr = "";
					$.each(data.rows, function (i, row) {
						var spjf = row.qbjf;
						if(row.cxjf!=""&&row.cxjf!=0)spjf=row.cxjf;
						var str = '<tr><td>'+row.spbh+'</td><td><p class="dhl-pro-states"><img style="cursor:pointer" onclick="window.location=\'sp!detail.do?sp='+
						row.nid+'\'" src="'+row.lj+'146x146.jpg" /><span style="cursor:pointer" onclick="window.location=\'sp!detail.do?sp='+
						row.nid+'\'" >'+row.spmc+'</span></p></td><td><select id="sel'+row.nid+
							'" style="width:120px"><option value="'+spjf+'">'+spjf+'积分</option></select></td><td>'+
							'<a style="cursor:pointer" id="subicon'+row.nid+'"><img src="common/images/icon-sub.jpg" /></a><input id="num'+row.nid+
							'" type="text" maxlength="3" onkeyup="checkspnum(\''+row.nid+'\')" value="1" class="dhl-pro-num" /><a style="cursor:pointer" id="addicon'+row.nid+'"><span style="display:none" id="max'+row.nid+'">'+
							 +row.wcdsl+'</span><img src="common/images/icon-add.jpg" /></a></td>'+
							'<td><span id="xj'+row.nid+'">积分：0<br />现金：￥0</span></td><td><span class="blue"><a onclick="clearsp(\''+row.nid+'\')" style="cursor:pointer" >删除</a></span></td></tr>';
						$("#dhllist").append(str);
						spstr+=row.nid+",";
					});
					setCookie("sp",spstr.substring(0,spstr.length-1),10);
					$.getJSON("jfqj!spsjfq.do?time="+timeParam,{param:sps}, function(data){
						if(data.rows == undefined) return false;
						if(jfqjson.rows == undefined) return false;
						$.each(data.rows, function (i, row) {
							var sl = document.getElementById("sel"+row.sp);
							$.each(jfqjson.rows, function (j, r) {
									if(r.jfq==row.jfq){
										sl.options[sl.length] = new Option(row.jfqmc, "jfq"+row.jfq);
									}
							});
						});
						$.getJSON("spj!spsdhfs.do?time="+timeParam,{param:sps}, function(data){
							if(data.rows == undefined) return false;
							$.each(data.rows, function (i, row) {
								var sl = document.getElementById("sel"+row.sp);
								sl.options[sl.length] = new Option(row.jf+"积分 + "+row.je+"元", row.jf+"_"+row.je);
							});
							var dhlsps = getShopCarSplist();
							for(var j=0;j<dhlsps.length;j++){
								$("#num"+dhlsps[j].sp).val(dhlsps[j].sl);
								$("#sel"+dhlsps[j].sp).val(dhlsps[j].dh);
							}
							$("#dhllist :input[id^='sel']").change(function(){
								var sp = $(this).attr("id").substring(3,$(this).attr("id").length);
								selchange(sp);
							});
							$("#dhllist :input[id^='sel']").change();
							$("#dhllist a[id^='subicon']").click(function(){
								var sp = $(this).attr("id").substring(7,$(this).attr("id").length);
								subsp(sp);
							});
							$("#dhllist a[id^='addicon']").click(function(){
								var sp = $(this).attr("id").substring(7,$(this).attr("id").length);
								addsp(sp);
							});
						});
					});
				});
			};
			var refreshdhl = function(){
				var strSps = getCookie("sp");
				if(strSps==""){
					$("#dhllist").empty();
					return false;
				}
				listdhl(strSps);
			}
			var gmbysps =function(){
				var sps = getCookie("sp");
				if(sps=="")return false;;
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("spj!gmbysps.do?time="+timeParam,{param:sps}, function(data){
					if(data.rows == undefined) return false;
					$("#gmlist").empty();
					var spstr = "";
					$.each(data.rows, function (i, row) {
						var str = '<li><h2>'+row.spmc+'</h2><img src="'+row.lj+'146x146.jpg" /><p><strong class="bisque" style="font-size:18px">'
						+row.qbjf+'</strong> 积分</p><a style="cursor:pointer" onclick="addsptocar(\''+row.nid+'\',\''+row.qbjf+'\')" class="adddhl"></a></li>';
						$("#gmlist").append(str);

					});
				});
			}
			var addsptocar=function(sp,jf){
				addShopCar(sp,1,jf);
				ymPrompt.win({message:'<div class=\'popbox\'>成功添加到兑换篮。</div>',width:175,height:55,titleBar:false});
				var timeClose = setTimeout(ymclose, 1500);
				refreshdhl();
			}
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
			$(function(){
				initygjfqs();
				refreshdhl();
				gmbysps();
			})
		</script>
	<link rel="shortcut icon" href="<%=request.getContextPath() %>/common/images/favicon.ico" type="image/x-icon" /></head>

	<body>
	<%@ include file="/jsp/base/head.jsp" %>
	<div id="main">
	  <div class="main2">
	    <div class="box2">
	      <div class="wrap2">
	        <div class="local">
	          <h1><img src="common/images/local-title-dhl.jpg" /></h1>
	          <ul>
	            <li>
	              <h1 class="local-nowone">1.我的兑换篮</h1>
	              <span><img src="common/images/local-iconb1.jpg" /></span></li>
	            <li>
	              <h1>2.确定订单</h1>
	              <span><img src="common/images/local-icon2.jpg" /></span></li>
	            <li>
	              <h1>3.下单完成</h1>
	            </li>
	          </ul>
	        </div>
	        <div class="dhl-pro">
	          <table width="100%" border="0" cellspacing="0" cellpadding="0" class="dhl-pro-table">
	            <tbody id="dhllist">
	            </tbody>
	          </table>
	        </div>
			<div class="dhl-pro-sum">产品数量总计：<span id="totalsp">0</span> 件&nbsp;&nbsp;&nbsp;&nbsp;
				消耗积分总计：<span id="totaljf">0</span> &nbsp;&nbsp;&nbsp;&nbsp;商品金额总额：<span  id="totalje">￥0</span>&nbsp;&nbsp;&nbsp;&nbsp;</div>
	      </div>
		  <div class="dhl-btn-area"><a href="sp!base.do" class="gobuy" style="margin-left:10px; display:inline; float:left"></a>
		   <a href="#" class="gopay" onclick="submitdhl()" style="margin-right:10px; display:inline; float:right"></a></div>
		  <div class="wrap2">
		  	<div class="dhl-other">
				<h1>购买了同商品的同事还购买了</h1>
				<ul class="dhl-other-list" id="gmlist">
				</ul>
			</div>
		  </div>
	      <div class="wrap2">     	
			<%@ include file="/jsp/base/bottomnav.jsp" %>
	      </div>
	    </div>
	  </div>
	</div>
	<%@ include file="/jsp/base/footer.jsp" %>
	</body>
</html>
