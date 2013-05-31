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
		<script type="text/javascript" src="common/js/jquery-1.7.min.js"></script>
		<script type="text/javascript" src="common/js/common.js"></script>		
		<script type="text/javascript">			
				var listmx = function(){
					var timeParam = Math.round(new Date().getTime()/1000);				
					$.getJSON("ddj!ddmx.do?time="+timeParam,{param:'<s:property value="ddzb.ddh" />'}, function(data){
						var th = '<tr><th width="146">商品编号</th><th width="430">商品名称</th>'+
							'<th width="127">商品数量</th><th>小计</th></tr>';
						$("#mxlist").append(th);
						var zjfq = 0;
						var zsl = 0;
						var zjf = 0;
						var zje = 0;
						$.each(data.rows, function (i, row) {
							var zffs = ' ';
							if(row.jfq!=''){
								zffs = row.mc+" × "+row.sl;
								zjfq += parseInt(row.sl);
							}
							else {
								zffs = row.jf+'积分';
								zjf += parseInt(row.jf);
								if(row.je!=''){
									zffs +='￥'+row.je
									zje += parseFloat(row.je);
								}
							}
							zsl+= parseInt(row.sl);
							var str = '<tr><td>'+row.spbh+'</td><td><p class="dhl-pro-states"><img style="cursor:pointer" onclick="window.location=\'sp!detail.do?sp='+row.sp+'\'" src="' +
								row.lj +'146x146.jpg" /><span  style="cursor:pointer" onclick="window.location=\'sp!detail.do?sp='+row.sp+'\'">'+row.spmc+'</span></p></td><td>'+row.sl+'</td><td>'+zffs+'</td></tr>';
							$("#mxlist").append(str);
						});
						$("#zsl").html(zsl);
						if (zjf > 0) {
							$("#zjf").html('&nbsp;&nbsp;&nbsp;&nbsp;消耗积分总计：<span>' + zjf + '</span>');
						}
						$("#zjfq").html(zjfq);
						$("#zje").html(zje);
					 });
				}
			$(function(){
				listmx();
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
          <h1 style="margin-top:15px;line-height:40px;">订单号：<span style="color:red;font-size:18px"><s:property value="ddzb.ddh" /></span></h1>
        </div>
        <div class="confirm-states">
			<div class="con-states-title"><h1>收件人信息</h1></div>
			<div class="con-statesin">
				<div class="con-wrap">
					<div class="con-box">
						<p style="padding:3px 0;"><s:property escape="false" value="ddzb.shdzxx" /></p>
					</div>	
				</div>
			</div>
			<div class="con-states-title"><h1>订单备注</h1></div>
			<div class="con-statesin">
				<div class="con-wrap">
					<s:property value="ddzb.ddbz" />
				</div>
			</div>
			<div class="con-states-title"><h1>商品信息</h1></div>
			<div class="con-statesin">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="pro-table">
					<tbody id="mxlist">
					</tbody>
				  </table>
				  <div class="pro-sum">产品数量总计：<span id="zsl">0</span> 件&nbsp;&nbsp;&nbsp;&nbsp;消耗福利券总计：<span id="zjfq">0</span><label id="zjf"></label> &nbsp;&nbsp;&nbsp;&nbsp;商品金额总额：￥<span id="zje">0</span>&nbsp;&nbsp;&nbsp;&nbsp;</div>
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
