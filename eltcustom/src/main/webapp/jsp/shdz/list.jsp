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
		<script type="text/javascript" src="common/js/jquery.validate.js"></script>	
		<script type="text/javascript" src="common/js/datepicker/WdatePicker.js"></script>	
		<script type="text/javascript" src="common/js/ymPrompt.js"></script>		
		<script type="text/javascript" src="common/js/city.js"></script>	
		<script type="text/javascript" src="common/js/common.js"></script>
		<script type="text/javascript">
			var ymclose = function(){ymPrompt.close();};
			var defaultdz = function(dz,yg){
				var timeParam = Math.round(new Date().getTime()/1000);
				$.getJSON("userj!modifyshdz.do?time="+timeParam, {yg:yg,shdz:dz}, function(data){
					shdzAjax();
				});
			};
			var deldz = function(dz){
				var timeParam = Math.round(new Date().getTime()/1000);
				$.getJSON("shdzj!del.do?time="+timeParam,{param:dz}, function(data){
					shdzAjax();
				});
			};
			var modifydz = function(dz){
				$("#shdzid").val(dz);
				$("#bjshr").val($("#"+dz+" td").eq(0).html());
				$("#province").val($("#"+dz+" span").eq(0).html());
				$("#province").change();
				$("#city").val($("#"+dz+" span").eq(1).html());
				$("#city").change();
				$("#county").val($("#"+dz+" span").eq(2).html());
				$("#bjdz").val($("#"+dz+" span").eq(3).html());
				$("#bjyb").val($("#"+dz+" td").eq(2).html().replace(/&nbsp;/gi,""));
				$("#bjdh").val($("#"+dz+" td").eq(3).html());				
			};
			var shdzAjax = function(){
				$.ajax({
					type : 'POST',datatype : 'json',cache : false,
					url : 'shdzj!all.do',
					data : {param:'<s:property value="userid"/>'},
					success : shdzlist
				});
			};
			var shdzlist = function(data){	
				if(data.rows == undefined) return false;
				$("#dzlist").empty();
				var th = '<tr><th width="45">收货人</th><th width="238">地址</th><th width="78">邮编</th>'
						 +'<th width="132">电话</th><th width="73">&nbsp;</th><th>操作</th></tr>';
				$("#dzlist").append(th);
				$.each(data.rows, function (i, row) {
					var str = '<tr id="'+row.nid+'"><td>'+row.shr+'</td><td><span>'+row.sheng+'</span><span>'+row.shi+'</span><span>'+row.qu+'</span><br /><span>'+row.dz
					+'</span></td><td>'+(row.yb==""?"&nbsp;":row.yb)+'</td><td>'+row.dh+'</td><td>';
					if(row.mr == 1) str += '默认地址';
					else str += '<span class="blue"><a href="#" onclick="defaultdz(\''+row.nid+'\',\''+row.yg+'\');">设为默认</a></span>';
					str += '</td><td><span class="blue"><a href="#" onclick="deldz('+row.nid+')">删除</a></span>&nbsp;&nbsp;'
						+'<span class="blue"><a href="#" onclick="modifydz('+row.nid+')">修改</a></span></td></tr>';
					$("#dzlist").append(str);
				});
			};
			$(function() {
				fillCity();
				if('<s:property value="rs"/>'=='2'){
					ymPrompt.win({message:'<div class=\'popbox\'>保存成功</div>',width:135,height:55,titleBar:false});
					var timeClose = setTimeout(ymclose, 2500);
				}
				shdzAjax();
				$("#form1").validate({
        			rules:{
						"shdzshr":{required:true,mingchen:true},
						"shdz.dz":{required:true},
						"shdz.dh":{required:true,telephone:true},
						"shdz.yb":{number:true},
						"shdz.qu":{required:true}
					},
					messages:{						
						"shdzshr":{required:"收货人为必输项。",mingchen:"支持中英文、数字、“_”。"},
						"shdz.dz":{required:"详细地址为必输项。"},
						"shdz.dh":{required:"电话为必输项。",telephone:"请输入正确的电话号码,例如13012345678。"},						
						"shdz.yb":{number:"请输入正确的邮编格式。"},
						"shdz.qu":{required:"请选择所在地区。"}
					}
				});
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
			<script type="text/javascript">menusel(12);</script>
	        </div>
	        <div class="wrap-right">
	          	<div class="list">
	            	<div class="list-title"><h1>收货地址管理</h1></div>
					<p class="title1">新增收货地址</p>
					<div class="states" style="padding-top:0">
						<form action="shdz!chg.do" id="form1" name="form1" method="post">
						<div class="states-right" style="padding-left:0px; border:none">
							<input id="shdzid" type="hidden" name="shdz.nid"/>
							<p><label class="label"><span class="bisque">*</span>收货人</label>
								<input maxlength="20" id="bjshr" name="shdzshr" value="" class="nameinputbox" /></p>
							<p><label class="label"><span class="bisque">*</span>所在地区</label>
								<select style="width:65px;" id="province" onchange="setCity(this.options[this.selectedIndex].id);" name="shdz.sheng" >
									<option value="" selected="selected">请选择</option> 
								</select>
								<select style="width:65px;" id="city" onchange="setCounty(this.options[this.selectedIndex].id);" name="shdz.shi">
									<option value="" selected="selected">请选择</option> 
								</select>
								<select style="width:65px;" id="county"  name="shdz.qu">
									<option value="" selected="selected">请选择</option> 
								</select></p>
							<p><label class="label"><span class="bisque">*</span>详细地址</label><input id="bjdz" name="shdz.dz" type="text" maxlength="50" value="" class="nameinputbox" /></p>
							<p><label class="label">邮编</label><input id="bjyb"  maxlength="10" name="shdz.yb" type="text" class="nameinputbox" /></p>
							<p><label class="label"><span class="bisque">*</span>电话</label><input  maxlength="20" id="bjdh" name="shdz.dh" type="text" class="nameinputbox" /></p>
						</div>
						<input value="" type="submit" class="savebtn" style="margin:10px 0 0 100px; display:inline" />
						</form>
					</div>
					<div class="old-dz">
						<p class="title1" style="padding-left:0">已经保存的有效地址<span style="float:right;color:#666666;font-weight:normal;">默认地址为积分或福利兑换时的默认收货地址</span></p>
						<div class="old-dz-in">
							<table id="dzlist" width="100%" border="0" cellspacing="0" cellpadding="0" class="old-dz-table">
							</table>	
						</div>
					</div>
				</div>
	        </div>
	      </div>
	     <%@ include file="/jsp/base/bottomnav.jsp" %>
		</div>
	  </div>
	</div>
	<%@ include file="/jsp/base/footer.jsp" %>
	</body>
</html>
