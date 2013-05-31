<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<title>IRewards</title>
		<meta http-equiv="pragma" content="no-cache"/>
		<meta http-equiv="cache-control" content="no-cache"/>
		<meta http-equiv="expires" content="0"/>
		<link type="text/css" rel="stylesheet" href="common/css/style.css"/>
		<script type="text/javascript" src="common/js/jquery-1.7.min.js"></script>	
		<script type="text/javascript" src="common/js/jquery.page.js"></script>	
		<script type="text/javascript" src="common/js/common.js"></script>			
		<script type="text/javascript">		
			var jflq = function(jfid){
				var timeParam = Math.round(new Date().getTime()/1000);
				$.getJSON("jfj!lq.do?time="+timeParam,{param:jfid}, function(data){
					gopage(20,1);
					refreshygjf();
					jfsl();
				});
			};
			var jfsl = function(){
				var timeParam = Math.round(new Date().getTime()/1000);
				$.getJSON("jfj!lqsj.do?time="+timeParam,{param:'<s:property value="yg"/>'}, function(data){
					var wlqjf = "0";
					if(typeof(data.rows[3])!="undefined"&&typeof(data.rows[3].jfsl)!="undefined"&&data.rows[3].jfsl != ""){
						wlqjf = data.rows[3].jfsl;
					}
					$("#jfwlq").html(wlqjf);
				});
			};
			var gopage = function(rp,page){
				$.ajax({
					type : 'POST',datatype : 'json',cache : false,
					url : 'jfj!pagely.do',
					data : {param:getParams("shanxuan"),page:page,rp:rp},
					success : jflist
				});
			};
			var jflist = function(data){
				if(data.rows == undefined) return false;
				$("#jflqlist").empty();
				var th='<tr><th width="90">时间</th><th width="90">来源</th><th width="80">金额</th>'
					+'<th width="110">奖励理由</th><th width="140">备注</th><th width="70">状态</th></tr>';
				$("#jflqlist").append(th);		
				$.each(data.rows, function (i, row) {
					var str = '<tr><td class="gray">'+row.ffsj+'</td><td>'+row.ffly+'</td><td><span class=bisque><strong>';
					<s:if test="%{#session.userQy.zt==1}">
						str += row.jf;
					</s:if>
					<s:else>
					    str += row.ffjf;
					</s:else>
					str += '</strong>分</span></td><td>'+row.mm+'</td><td>'+row.bz+'</td><td>';
					if (row.sflq!='1') {
						str +='<span class="blue"><a onclick="jflq(\''+row.nid+'\')" href="#">立即领取</a></span>';
					} else {
						str +='已领取';
					}
					str +='</td></tr>';
					$("#jflqlist").append(str);
				});
				$(".listpages").page({total:data.total,currentpage:data.page,gopage:gopage,pagesize:20});
			};
			$(function() {
				jfsl();
				gopage(20,1);
			});
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
					<script type="text/javascript">menusel(5);</script>
					</div>
					<div class="wrap-right">
						<div class="list">
							<div class="list-title"><h1>积分来源</h1>
								<span class="tishi1"></span><span class="tishi2">您有<span id="jfwlq">0</span>积分未领取</span>
							</div>
							<div class="shanxuan">
							    <s:if test="%{#session.userQy.zt==1}">
							        <input type="hidden" id="t.yg" rule="eq" value='<s:property value="yg"/>'/>
								    <!-- 来源：<input id="ffly" rule="like" style="width:100px"/>&nbsp;&nbsp;&nbsp;&nbsp; -->
								          时间：<select id="t.zjsj" rule="daylimit" style="width:100px">
									<option value="">-请选择-</option>
									<option value="7" >近七天</option>
									<option value="30" >近一个月</option>
									<option value="91" selected>近三个月</option>
									<option value="182">近半年</option>
									<option value="365">近一年</option>
								    </select>&nbsp;&nbsp;&nbsp;&nbsp;
								          金额：<input id="start_t.jf" rule="ge" class="jingerbox" /> - 
									<input id="end_t.jf" rule="le" class="jingerbox" /> 积分&nbsp;&nbsp;&nbsp;&nbsp;
							    </s:if>
							    <s:else>
									<input type="hidden" id="t.hqr" rule="eq" value='<s:property value="yg"/>'/>
									来源：<input id="ffly" rule="like" style="width:100px"/>&nbsp;&nbsp;&nbsp;&nbsp;
									时间：<select id="ffsj" rule="daylimit" style="width:100px">								
									<option value="">-请选择-</option>
									<option value="7" >近七天</option>
									<option value="30" >近一个月</option>
									<option value="91" selected>近三个月</option>
									<option value="182">近半年</option>
									<option value="365">近一年</option>
									</select>&nbsp;&nbsp;&nbsp;&nbsp;
									金额：<input id="start_t.ffjf" rule="ge" class="jingerbox" /> - 
									<input id="end_t.ffjf" rule="le" class="jingerbox" /> 积分&nbsp;&nbsp;&nbsp;&nbsp;
								</s:else>
								<input onclick="gopage('20','1');" value=" " type="button" class="searchbtn2" />
							</div>
							<div class="listin">
								<table id="jflqlist" width="100%" border="0" cellspacing="0" cellpadding="0" class="jlbiao">
								</table>
							</div>
							<div class="listpages"></div>
						</div>
					</div>
				<%@ include file="/jsp/base/bottomnav.jsp" %>
			</div>
		</div>
	</div>
	</div>
	<%@ include file="/jsp/base/footer.jsp" %>
	</body>
</html>
