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
		<script type="text/javascript" src="common/js/jquery.stars.js"></script>	
		<script type="text/javascript" src="common/js/common.js"></script>			
		<script type="text/javascript">
			var spllength = 0;
			var wrapfun = function(){
				window.parent.ymPrompt.close();
			}
			var submit1 = function(){
				if(!validate())return false;
				var pjlist = "";
				for(var i=0;i<$(".pjselect :checked").length;i++){
					pjlist+=$(".pjselect :checked").eq(i).val()+",";
				}
				$("#pjhide").val(pjlist.substring(0,pjlist.length-1));				
				for(var i=0;i<$(".pjnyinput").length;i++){
					var htm = $(".pjnyinput").eq(i).val().replace(/,/g,"，");
					$(".pjnyinput").eq(i).val(htm);
				}
				$("#form1").submit();
			}
			var close1 = function(){
				window.parent.ymPrompt.close();
			}
			var tiphide = function(){$("#pjtip").hide()}
			var showtip = function(msg){
				$("#pjtip").html(msg);
				$("#pjtip").show();
				var tiptime = setTimeout(tiphide,2000);
			}
			var validate = function(){
				if($(".pjselect :checked").length <spllength){
					showtip("请完成评价后提交。");
					return false;
				}
				for(var i=0;i<$(".starpf").length;i++){
					if($(".starpf").eq(i).val()==0){
						showtip("请完成评价后提交。");
						return false;
					}					
				}
				for(var i=0;i<$(".pjnyinput").length;i++){
					if($(".pjnyinput").eq(i).val().length>100){
						showtip("评价内容不得大于100字。");
						return false;
					}					
				}
				return true;
			}
			var gospl = function(ddh){
				window.parent.location = "sp!detail.do?spl="+ddh;
			}
			var ddspl = function(){
				var timeParam = Math.round(new Date().getTime()/1000);
				$.getJSON("ddj!mxspl.do?time="+timeParam,{param:'<s:property value="ddh"/>'}, function(data){
					if(data.rows == undefined) return false;
					$("#splist").empty();
					spllength = data.rows.length;
					$.each(data.rows, function (i, row) {
						var str = '<div class="pingjiapro"><input name="spl" value="'+row.spl+'" type="hidden" /><div class="pingjiapro-states"><img src="'+row.lj+'60x60.jpg" /><span class="blue"><a style="cursor:pointer" onclick="gospl(\''
						     +row.spl+'\')">'+row.mc+'</a></span></div><ul class="pjselect"><li><label><input name="pj'+row.spl+'" type="radio" value="1" /></label><span>好评</span></li>'
							 +'<li><label><input name="pj'+row.spl+'" type="radio" value="2" /></label><span>中评</span></li><li><label><input name="pj'+row.spl+'" type="radio" value="3" />'
							 +'</label><span>差评</span></li></ul><ul class="dafeng"><li><span>服务态度：</span><input name="fwpf" value="0" class="starpf" type="hidden" />'
							 +'</li><li><span>发货速度：</span><input name="fhpf" value="0" class="starpf"  type="hidden" /></li><li><span>物流速度：'
							 +'</span><input name="wlpf" value="0" class="starpf" type="hidden" /></li></ul><div class="pjny"><label>评价内容：</label>'
							 +'<textarea name="pjnr" cols="" rows="" class="pjnyinput"></textarea></div></div>';
						$("#splist").append(str);
					});					
					$(".starpf").stars();
					$("#submitbtn").click(function(){submit1();});
				});
			};
			$(function() {
				if('<s:property value="pjrs"/>'!=''){
					window.parent.ymPrompt.close();
					alert(U2A('<s:property value="pjrs"/>'));
					window.parent.listzb(10,1);					
				}
				else ddspl();
			});
		</script>
	<link rel="shortcut icon" href="<%=request.getContextPath() %>/common/images/favicon.ico" type="image/x-icon" /></head>

	<body style="background-color:#fff">	
	<div class="pingjia">
	<form action="pj!add.do" id="form1" name="form1" method="post">
		<input name="ddh" value='<s:property value="ddh"/>' type="hidden" />
		<input name="pj" id="pjhide" type="hidden" />
		<div id="splist">
		</div>		
		<div id="pjtip" style="display:none;padding-left:10px;width:570px;color:red;font-size:15px">
		</div>
		<div class="pjbtnbox">
			<input type="button" id="submitbtn" value="" class="pinglun" />
			<input type="button" onclick="close1();" value="" class="nextpinglun" />
		</div>
	</form>
	</div>
	</body>
</html>
