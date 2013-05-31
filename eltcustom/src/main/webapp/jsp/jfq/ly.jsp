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
		<s:if test="%{#session.userQy.zt==1}">
		  <script type="text/javascript" src="common/js/defaultWelfare.js"></script>
		</s:if>		
		<script type="text/javascript">		
			var jfqlq = function(jfqid){
				var timeParam = Math.round(new Date().getTime()/1000);
				$.getJSON("jfqj!lq.do?time="+timeParam,{param:jfqid}, function(data){
					jfqsl();
					gopage(20,1);
				});
			};
			var gotojfq = function(jfq){
				window.location = "jfq!detail.do?jfq="+jfq;
			};
			var jfqsl = function(){
				var timeParam = Math.round(new Date().getTime()/1000);
				<s:if test="%{#session.userQy.zt==1}">
// 					$("#jfqwlq").html(defaultWelfare.wlqWelfare('<s:property value="yg"/>'));
					$.getJSON("jfqj!syqylqjl.do?time="+timeParam, {param:'<s:property value="yg"/>'}, function(data){
						var wlqjfq = 0;
						var jfqs = defaultWelfare.defaultFL.rows;
						for (var i=0; i<jfqs.length; i++) {
							if (jfqs[i].yxq < new Date().toformat(""))
								continue;
							wlqjfq++;
						}
						if (data) {
							wlqjfq = wlqjfq - data.length;
						}
						$("#jfqwlq").html(wlqjfq);
					});
				</s:if>
				<s:else>
					$.getJSON("jfqj!lqsj.do?time="+timeParam,{param:'<s:property value="yg"/>'}, function(data){
						var wlqjfq = "0";
						if(typeof(data.rows[3])!="undefined"&&data.rows[3].jfqsl != ""){
							wlqjfq = data.rows[3].jfqsl;
						}
						$("#jfqwlq").html(wlqjfq);
					});
				</s:else>
			};
			var gopage = function(rp,page){
				<s:if test="%{#session.userQy.zt==1}">
// 					jfqlist(defaultWelfare.pagelyFl('<s:property value="yg"/>', rp, page));
					var timeParam = Math.round(new Date().getTime()/1000);
					$.getJSON("jfqj!syqylqjl.do?time="+timeParam, {param:'<s:property value="yg"/>'}, function(data){
						var jfqs = defaultWelfare.defaultFL.rows;
						for (var i=0; i<jfqs.length; i++) {
							if (data) {
								for (var j=0; j<data.length; j++) {
									if (jfqs[i].nid == data[j].jfq) {
										jfqs[i].sflq = 1;
									}
								}
							}
						}
						jfqlist({"rows": jfqs});
					});
				</s:if>
				<s:else>
					$.ajax({
						type : 'POST',datatype : 'json',cache : false,
						url : 'jfqj!pagely.do',
						data : {param:getParams("shanxuan"),page:page,rp:rp},
						success : jfqlist
					});
				</s:else>
			};
			var jfqlist = function(data){
				if(data.rows == undefined) return false;
				$("#jfqlqlist").empty();
				var th='<tr><th width="90">时间</th><th width="120">来源</th>'
					+'<th width="170">福利名称</th><th width="120">发放理由</th><th width="80">状态</th></tr>';
				$("#jfqlqlist").append(th);		
				$.each(data.rows, function (i, row) {
					var str = '<tr><td class="gray">'+row.ffsj+'</td><td>'+row.ffly+'</td><td><span class="blue">'
						+'<a href="#" onclick="gotojfq(\''+row.nid+'\')">'+row.mc+'</a></span></td><td>'+row.ffyy+'</td><td>';
					if (row.sflq=='0' && row.yxq >= new Date().toformat("")) str +='<span class="blue"><a onclick="jfqlq(\''+row.nid+'\')" href="#">立即领取</a></span>';
					else if(row.sflq=='1' && row.zt=='0' && row.yxq >= new Date().toformat("")) str +='未使用';
					else if(row.zt=='1') str +='已使用';
					else if(row.yxq < new Date().toformat("")) str +='已过期';
					else str +='已使用';
					str +='</td></tr>';
					$("#jfqlqlist").append(str);
				});
				$(".listpages").page({total:data.total,currentpage:data.page,gopage:gopage,pagesize:20});
			};
			$(function() {
				jfqsl();
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
					<script type="text/javascript">menusel(2);</script>
					</div>
					<div class="wrap-right">
						<div class="list">
							<div class="list-title"><h1>福利详情</h1>
								<span class="tishi1"></span><span class="tishi2">您有<span id="jfqwlq">0</span>条福利未领取</span>
							</div>
							<div class="shanxuan">
								<input type="hidden" id="t.qyyg" rule="eq" value='<s:property value="yg"/>'/>
								福利名称：<input id="mc" rule="like" style="width:120px" />&nbsp;&nbsp;&nbsp;&nbsp;
								时间：<select id="ffsj" rule="daylimit" style="width:120px">								
									<option value="">-请选择-</option>
									<option value="7" >近七天</option>
									<option value="30" >近一个月</option>
									<option value="91" selected>近三个月</option>
									<option value="182">近半年</option>
									<option value="365">近一年</option>
								</select>&nbsp;&nbsp;&nbsp;&nbsp;
								状态：<select id="t.zt" rule="eq">								
									<option value="">-请选择-</option>
									<option value="0" >未使用</option>
									<option value="1" >已使用</option>
								</select>&nbsp;&nbsp;&nbsp;&nbsp;
								<input onclick="gopage('20','1');" value=" " type="button" class="searchbtn2" />
							</div>
							<div class="listin">
								<table id="jfqlqlist" width="100%" border="0" cellspacing="0" cellpadding="0" class="jlbiao">
								</table>
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
