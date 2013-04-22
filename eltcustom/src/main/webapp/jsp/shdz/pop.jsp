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
		<script type="text/javascript" src="common/js/jquery.validate.js"></script>	
		<script type="text/javascript" src="common/js/common.js"></script>	
		<script type="text/javascript" src="common/js/datepicker/WdatePicker.js"></script>	
		<script type="text/javascript" src="common/js/city.js"></script>	
		<script type="text/javascript">
			$(function() {
				if('<s:property value="rs"/>'=='2'){
					window.parent.handler();
					return false;
				}
				fillCity();
				if('<s:property value="shdz.nid"/>'!=''){
					$("#shdzid").val('<s:property value="shdz.nid"/>');
					$("#province").val(U2A('<s:property value="shdz.sheng"/>'));
					$("#province").change();
					$("#city").val(U2A('<s:property value="shdz.shi"/>'));
					$("#city").change();
					$("#county").val(U2A('<s:property value="shdz.qu"/>'));					
				}
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

	<body style="background-color:#fff">
			<div class="wrap-right" style="float:left">
	          	<div class="list"  style="margin-top:0px">
					<div class="states" style="padding-top:0">
						<form action="shdz!popchg.do" id="form1" name="form1" method="post">
						<div class="states-right" style="padding-left:0px; border:none">
							<input id="shdzid" type="hidden" name="shdz.nid"/>
							<p><label class="label"><span class="bisque">*</span>收货人</label>
								<input maxlength="20" id="bjshr" name="shdzshr" value='<s:property value="shdzshr" />' class="nameinputbox" /></p>
							<p><label class="label"><span class="bisque">*</span>所在地区</label>
								<select style="width:65px;" id="province" onchange="setCity(this.options[this.selectedIndex].id);" name="shdz.sheng" >
									<option value="" selected="selected">请选择</option> 
								</select>
								<select style="width:65px;" id="city" onchange="setCounty(this.options[this.selectedIndex].id);" name="shdz.shi">
									<option value="" selected="selected">请选择</option> 
								</select>
								<select style="width:65px;" id="county"  name="shdz.qu">
									<option value="" selected="selected">请选择</option> 
								</select>
							</p>
							<p><label class="label"><span class="bisque">*</span>详细地址</label><input id="bjdz" name="shdz.dz" type="text" maxlength="50" value='<s:property value="shdz.dz" />' class="nameinputbox" /></p>
							<p><label class="label">邮编</label><input id="bjyb" value='<s:property value="shdz.yb" />' maxlength="10" name="shdz.yb" type="text" class="nameinputbox" /></p>
							<p><label class="label"><span class="bisque">*</span>电话</label><input 
							 value='<s:property value="shdz.dh" />' maxlength="20" id="bjdh" name="shdz.dh" type="text" class="nameinputbox" /></p>
						</div>
						<input value="" type="submit" class="savebtn" style="margin:10px 0 0 85px; display:inline" />
						</form>
					</div>
				</div>
	        </div>	     
	</body>
</html>
