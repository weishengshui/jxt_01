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
			var tiphide = function(){$("#ddtip").hide();};
			var submitform = function(){
				var spstr = getCookie("sp");
				if(spstr=="") return false;				
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
				var zjfstr = $("#alljf").html();
				if($(":radio:checked").length!=1){			
					$("#ddtip").html("请选择收货地址。");
					$("#ddtip").show();
					var tiptime = setTimeout(tiphide,2000);
					return false;
				}
				$.ajax({
					type : 'POST',datatype : 'json',cache : false,
					url : 'ddj!verify.do',
					async:false,
					data : {dhlist:dhstr,sllist:numstr,zjf:zjfstr},
					success :function(data){
						if(data.rs!="success"){
							$("#ddtip").html(data.rs);
							$("#ddtip").show();
							var tiptime = setTimeout(tiphide,2000);
							return false;
						}
						else{
							$("#fsplist").val(spstr);
							$("#fdhlist").val(dhstr);
							$("#fsllist").val(numstr);
							$("#bzedit").val($("#bzedit").val().substring(0,100));							
							$("#fshdz").val($(":radio:checked").val());
							$("#form1").submit();
						}
					}
				});				
			};
			var updatedhfs = function(){
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
			};
			var scflq = function() {
				//可更改员工端兑换篮中用福利券兑换的商品为使用积分兑换
				updatedhfs();
				window.location = 'jfq!scflq.do';
			};
			var handler = function(){
				ymPrompt.close();
				refreshshdz();
			};
			var shdzedit = function(dzid){
				ymPrompt.win({message:'shdz!pop.do?nid='+dzid,
					width:750,height:340,title:'收货地址修改',iframe:true});
			};
			var shdzadd = function(){
				ymPrompt.win({message:'shdz!pop.do',
					width:750,height:340,title:'收货地址增加',iframe:true});		
			};
			var refreshshdz = function(){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("shdzj!all.do?time="+timeParam,{param:'<s:property value="#session.hrygid"/>'}, function(data){
					if(data.rows == undefined) return false;
					$("#shdzlist").empty();
					$.each(data.rows, function (i, row) {
						var mr =(row.mr == 1)?"checked":"";
						var str ='<p style="padding:3px 0;"><input name="shdz" type="radio" '+mr+' value="'
							+row.nid+'" /><strong>'+row.shr+'</strong>'+" "+row.sheng+" "+row.shi+" "+row.qu+" "+row.dz+" "+row.yb+" "
							+'<span class="blue"><a onclick="shdzedit(\''+row.nid+'\')" style="cursor:pointer">修改</a></span></p>';
						$("#shdzlist").append(str);
					});
				});
			};
			var bzsubmit = function(){
				if($("#bzedit").val().length>100){
					$("#bztip").show();
					return false;
				}
				$("#bztip").hide();
				$("#bzread").show();
				$("#bzeditbtn").show();
				$("#bzedit").hide();
				$("#bzreadbtn").hide();
				$("#bzread").html($("#bzedit").val());
			};
			var lengthvertify = function(){
				if($("#bzedit").val().length>100){
					$("#bztip").show();
					return false;
				}
				else{
					$("#bztip").hide();
				}				
			};
			var bzmodify = function(){
				$("#bzread").hide();
				$("#bzeditbtn").hide();
				$("#bzedit").show();
				$("#bzreadbtn").show();
			};
			var returndhl = function(){
				if(getCookie("sp")!=""){
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
				}
				window.location = 'dhl!hrlist.do';
			};
			var addsp = function(sp){
				var numsp = parseInt($("#num"+sp).val());
				var maxsp = parseInt($("#max"+sp).html());
				if(numsp<maxsp){
					$("#num"+sp).val(numsp+1);
					subtotal(sp);
					total();
				}
			};
			var subsp = function(sp){
				var numsp = parseInt($("#num"+sp).val());
				if(numsp>1){
					$("#num"+sp).val(numsp-1);
					subtotal(sp);
					total();
				}
			};
			
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
			};
			
			var selchange = function(sp){
				subtotal(sp);
				total();				
			};
			var total = function(){
				var $dh = $("#dhllist :input[id^='sel']");
				var $num = $("#dhllist :input[id^='num']");
				var totaljf = 0;
				var totalje = 0;
				var totaljfq = 0;
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
					else if($dh.eq(i).val().indexOf("jfq")!=-1){
						totaljfq += tnum;
					}
				}
				$("#totalsp").html(totalcount);
				$("#totaljf").html(totaljf);
				$("#totalje").html("￥"+totalje);
				
				$("#allsp").html(totalcount);
				$("#alljf").html(totaljf);
				$("#alljfq").html(totaljfq);
				$("#allje").html("￥"+totalje);
				$("#alljeyf").html("￥"+totalje);
				
				$("#fzjf").val(totaljf);
				$("#fzjfqsl").val(totaljfq);
				$("#fzje").val(totalje);
			};
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
					$("#xj"+sp).html(subtotaljf+"积分 + "+subtotalje+"元");
				}
				else $("#xj"+sp).html("福利券 × "+subtotaljfq);
			};
			var listdhl = function(sps){
				var timeParam = Math.round(new Date().getTime()/1000);				
				$.getJSON("spj!spbysps.do?time="+timeParam,{param:sps}, function(data){
					if(data.rows == undefined) return false;
					$("#dhllist").empty();
					var th = '<tr><th width="96">商品编号</th><th width="330">商品名称</th>'+
						'<th width="168">兑换价</th><th width="127">商品数量</th><th>小计</th></tr>';
					$("#dhllist").append(th);
					var spstr = "";
					$.each(data.rows, function (i, row) {
						var spjf = row.qbjf;
						if(row.cxjf!=""&&row.cxjf!=0)spjf=row.cxjf;
						var str = '<tr><td>'+row.spbh+'</td><td><p style="cursor:pointer" onclick="window.location=\'sp!detail.do?sp='+row.nid+'\'" class="dhl-pro-states"><img src="'+row.lj+'146x146.jpg" /><span>'+row.spmc+'</span></p></td><td><select id="sel'+row.nid+
							'" style="width:120px"><option value="'+spjf+'">'+spjf+'积分</option></select></td><td>'+
							'<a style="cursor:pointer" id="subicon'+row.nid+'"><img src="common/images/icon-sub.jpg" /></a><input id="num'+row.nid+
							'" type="text" maxlength="3" onkeyup="checkspnum(\''+row.nid+'\')" value="1" class="dhl-pro-num" /><a  style="cursor:pointer" id="addicon'+row.nid+'"><span style="display:none" id="max'+row.nid+'">'
							+row.wcdsl+'</span><img src="common/images/icon-add.jpg" /></a></td>'
							 +'<td><span id="xj'+row.nid+'">0积分 </span></td></tr>';
						$("#dhllist").append(str);
						spstr+=row.nid+",";
					});
					setCookie("sp",spstr.substring(0,spstr.length-1),10);
					
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
			};
			var refreshdhl = function(){
				var strSps = getCookie("sp");
				if(strSps=="")return false;
				listdhl(strSps);
			};
			$(function(){
				refreshshdz();
				refreshdhl();
			});
		</script>
	<link rel="shortcut icon" href="<%=request.getContextPath() %>/common/images/favicon.ico" type="image/x-icon" /></head>

	<body>
	<%@ include file="/jsp/base/hrhead.jsp" %>
<div id="main">
  <div class="main2">
    <div class="box2">
      <div class="wrap2">
        <div class="local">
          <h1><img src="common/images/local-title-confirml.jpg" width="150" height="49" /></h1>
          <ul>
            <li>
              <h1>1.我的兑换篮</h1>
              <span><img src="common/images/local-iconb2.jpg" /></span></li>
            <li>
              <h1  class="local-nowone">2.确定订单</h1>
              <span><img src="common/images/local-iconb1.jpg" /></span></li>
            <li>
              <h1>3.下单完成</h1>
            </li>
          </ul>
        </div>
        <div class="confirm-states">
			<div class="con-states-title"><h1>收件人信息</h1></div>
			<div class="con-statesin">
				<div class="con-wrap">
					<div id="shdzlist" class="con-box">
					</div>	
					<p class="con-box2"><span class="blue"><a style="cursor:pointer" onclick="shdzadd();">+新增收货地址</a></span></p>
				</div>
			</div>
			<div class="con-states-title"><h1>订单备注</h1><span id="bzbtn" class="blue"><a id="bzeditbtn" onclick="bzmodify();" style="display:none;cursor:pointer">【修改】</a></span></div>
			<div class="con-statesin">
				<div class="con-wrap">
					<span id="bzread" style="display:none"></span>
					<form action="dd!hrcreate.do" id="form1" name="form1" method="post">
						<textarea onmouseout="lengthvertify();" name="bz" rows="3" cols="75" id="bzedit"></textarea>
						<input type="hidden" id="fsplist" name="splist" value=""/>
						<input type="hidden" id="fdhlist" name="dhlist" value=""/>
						<input type="hidden" id="fsllist" name="sllist" value=""/>
						<input type="hidden" id="fzjf" name="zjf" value=""/>
						<input type="hidden" id="fzje" name="zje" value=""/>
						<input type="hidden" id="fzjfqsl" name="zjfqsl" value=""/>
						<input type="hidden" id="fshdz" name="ddshdz" value=""/>
					</form>
					<p style="display:none" id="bztip"><label style="color:red" class="error">备注最大长度为100个汉字,请减少备注字数。</label></p>
					<%--<p  id="bzreadbtn"><input class="savebtn" value="" onclick="bzsubmit();" type="submit"/></p>
				--%></div>
			</div>
			<div class="con-states-title"><h1>商品信息</h1><span class="blue"><a href="#" onclick="returndhl();">【返回购物车修改】</a></span></div>
			<div class="con-statesin">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="pro-table">
					<tbody id="dhllist">
					</tbody>
				 </table>
				 <div class="pro-sum">产品数量总计：<span id="totalsp">0</span> 件&nbsp;&nbsp;&nbsp;&nbsp;
				   使用积分总计：<span id="totaljf">100</span> &nbsp;&nbsp;&nbsp;&nbsp;商品金额总额：<span  id="totalje">￥0</span>&nbsp;&nbsp;&nbsp;&nbsp;</div>
			</div>
			<div class="con-states-title"><h1>结算信息</h1></div>
			<div class="con-statesin">
				<div class="con-wrap">
					<div class="con-box">
						<div class="sum-states">
						使用积分：<strong class="bisque" id="alljf">0</strong><br />
						商品金额：<strong class="bisque" id="allje">￥0</strong><br />
						使用福利券：<strong class="bisque" id="alljfq">0</strong><br />
						运　　费：<strong class="bisque">￥0</strong><br /><br />
						<strong>使用现金：</strong><strong class="bisque"  id="alljeyf">￥0</strong>
						</div>
					</div>
					<p id="ddtip" style="display:none;clear:both;width:600px;float:left;color:red;font-size:15px">
					</p>
					<p class="con-box2" style="clear:both;">
						<input type="button" onclick="submitform();" value=""  class="submit" />
						<input type="button" onclick="scflq();" value=""  class="scflq" />
					</p>
				</div>
			</div>
		</div>
      </div>	  
      <div class="wrap2"><%@ include file="/jsp/base/bottomnav.jsp" %></div>
    </div>
  </div>
</div>
	<%@ include file="/jsp/base/footer.jsp" %>
	</body>
</html>
