<%@ page language="java" contentType="text/html; charset=utf8"
	pageEncoding="utf8"%>
<%@ page import="com.chinarewards.metro.domain.merchandise.MerchandiseStatus" %>		
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link id="easyuiTheme" rel="stylesheet" type="text/css"
	href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css"
	href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<style type="text/css">
	fieldset tr{height: 35px;}
	fieldset{margin-bottom:10px;margin-left:30px;margin-top:10px;}
	.table select{width:140px;height:22px;margin-right:20px;}
	.red{color:red;font-size:12px;}
	form{margin:0; padding:0}
</style>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/common.js"></script>
	<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/ueditor/editor_config.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.json-2.4.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/PCASClass.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/map.js"></script>
	<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/ueditor/editor_all.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<script type="text/javascript">
		var baseURL = '<%=request.getContextPath()%>';
		var editor;
		var shopMap = new Map();
		var categoryMap = new Map();
		var keywordsMap = new Map();
	
	$(function() {
		addStar("star0");
		setTimeout("expandRoot()", 200);
		editor= new UE.ui.Editor();
		editor.render('description');
		editor.ready(function(){
		    //需要ready后执行，否则可能报错
		    editor.setContent('${merchandise.description }');
		}); 
	});
	
	function expandRoot(){
		var root = $('#tt2').tree('getRoot');
		if(root){
			$('#tt2').tree('reload', root.target); 
			$('#tt2').tree('expandAll', root.target);
		}
	}
	
	$(document).ready(function(){
		var saleforms = '${saleforms}';
		if(saleforms){
			saleforms = eval('('+saleforms+')');
			if(saleforms && saleforms.length > 0){
				for(var i = 0, length = saleforms.length; i < length; i++){
					var saleform = saleforms[i];
					if(saleform.unitId == "0"){
						$('#rmb').attr('checked','checked');
						$('#rmbPrice').numberbox('setValue',saleform.price);
						if(saleform.preferentialPrice){
							$('#rmbPreferential').attr('checked','checked');
							$('#rmbPreferentialPrice').numberbox('setValue',saleform.preferentialPrice);
						}
					}else{
						$('#binke').attr('checked','checked');
						$('#binkePrice').numberbox('setValue',saleform.price);
						if(saleform.preferentialPrice){
							$('#binkePreferential').attr('checked','checked');
							$('#binkePreferentialPrice').numberbox('setValue',saleform.preferentialPrice);
						}
					}
				}
			}
		}
		var timeParam = Math.round(new Date().getTime()/1000);
		var categoryVos = '${categoryVos}';
		if(categoryVos){
			categoryVos = eval('('+categoryVos+')');
			if(categoryVos && categoryVos.length > 0){
				$('#selectCategorys').html('<table border="0" id="categoryTable"><tr><td width="auto" align="center">商品类别</td><td width="auto" align="center">上下架</td><td width="auto" align="center">类别排序</td><td width="120px" align="center">上下架时间</td><td width="auto"  align="center">操作</td></tr></table>');
				for(var i = 0, length = categoryVos.length; i < length; i++){
					var displaySort = '<input name="displaySort" type="text" style="width:50px" ';
					
					var categoryVo = categoryVos[i];
					var categoryId = categoryVo.categoryId;
					var delCategoryId = 'categoryKey'+i+timeParam;
					var deleteBut = '<a id='+ delCategoryId +' href="javascript:void(0)" onclick="deleteCategory(this,\''+categoryId+'\')">删除</a>';
					//var deleteBut='<button type="button" onclick="deleteCategory(this,\''+categoryId+'\')">删除</button>';
					categoryMap.put(categoryId, '');
					
					var categId = '<input type="hidden" name="categId" value='+ categoryId +' />';
					var categoryName = categoryVo.fullName;
					var displaySortId = 'displaySort'+timeParam+i;
					displaySort += ' id="' + displaySortId +'"/>';
					var status= '';
					if(categoryVo.status == '<%=MerchandiseStatus.ON.toString()%>'){
						status='<select name="status" style="width:50px" ><option value="ON" selected="selected">上架</option><option value="OFF">下架</option></select>';
					}else if(categoryVo.status == '<%=MerchandiseStatus.OFF.toString()%>'){
						status='<select name="status" style="width:50px" ><option value="ON">上架</option><option value="OFF" selected="selected">下架</option></select>';
					}
					
					var on_offtime = '<input type=text name=on_offTime readonly="readonly" value=\"'+ millisecToString(categoryVo.on_offTime) + '\" />';
					var str = '<tr>';
					str += '<td  width="auto">' + categId +categoryName +'</td><td  width="auto">'+status +'</td><td  width="auto">' + displaySort +'</td><td width="auto">' + on_offtime + '</td></td><td width="auto">'+deleteBut+'</td>';
					str += '</tr>';
					$(str).appendTo($('#categoryTable'));
					$('#'+delCategoryId).linkbutton({
						iconCls: 'icon-remove' 
					});
					$('#' + displaySortId).numberbox({precision:0});
					$('#' + displaySortId).numberbox({min:1});
					$('#' + displaySortId).numberbox('setValue',categoryVo.displaySort);
					$('#' + displaySortId).validatebox({required:true});
				}
			}
		}
		
		var shopVos = '${shopVos}';
		if(shopVos){
			shopVos = eval('('+shopVos+')');
			if(shopVos && shopVos.length > 0){
				$('#selectShops').html('<table border="0" id="shopTable"><tr><td width="auto" align="center">门店中文名&nbsp;&nbsp;&nbsp;&nbsp;</td><td width="auto" align="center">门店英文名&nbsp;&nbsp;&nbsp;&nbsp;</td><td width="auto" align="center">区域&nbsp;&nbsp;&nbsp;&nbsp;</td><td width="auto">排序编号&nbsp;&nbsp;&nbsp;&nbsp;</td><td width="auto" align="center">操作&nbsp;&nbsp;&nbsp;&nbsp;</td></tr></table>');
				for(var i = 0, length = shopVos.length; i < length; i++){
					var shopVo = shopVos[i];
					var delShopId = 'shopKey'+i+timeParam;
					var deleteBut = '<a id='+ delShopId +' href="javascript:void(0)" onclick="deleteShop(this,\''+shopVo.shopId+'\')">删除</a>';
					//var deleteBut='<button type="button" onclick="deleteShop(this,\''+shopVo.shopId+'\')">删除</button>';
					var nameZH = shopVo.shopName;
					var nameEN = shopVo.shopEnName;
					if(!nameZH){
						nameZH = "";
					}
					if(!nameEN){
						nameEN = "";
					}
					var region = shopVo.region;
					var shopId = '<input type="hidden" name="shopId" value='+ shopVo.shopId +' />';
					var sortId = 'sort'+timeParam+i;
					var merShopSort = '<input name="merShopSort" type="text" style="width:50px" maxlength="10" '+'id='+sortId+' />';//商品在门店的排序
					var str = '<tr>';
					str += '<td  width="auto">' + shopId +nameZH +'</td><td  width="auto">'+nameEN +'</td><td  width="auto">' + region +'</td><td width="auto">' + merShopSort + '</td></td><td width="auto">'+deleteBut+'</td>';
					str += '</tr>';
					$(str).appendTo($('#shopTable'));
					
					$('#'+delShopId).linkbutton({
						iconCls: 'icon-remove' 
					});
					$('#' + sortId).numberbox({precision:0});
					$('#' + sortId).numberbox({min:1});
					$('#' + sortId).numberbox('setValue',shopVo.merShopSort);
					$('#' + sortId).validatebox({required:true});
					shopMap.put(shopVo.shopId, '');	
					$('#shopDialog').dialog('close');
				}
			}
		}
		
		var keywords = '${keywords}';
		if(keywords){
			keywords = eval('('+keywords+')');
			if(keywords && keywords.length > 0){
				for(var i=0, length = keywords.length; i < length; i++){
					var str = "";
					var keyword = keywords[i].keywords;
					var encode = encodeURIComponent(keyword);
					var delkeywordId = "keyworldidw"+i+timeParam;
					var deleteBut = '<a id='+ delkeywordId +' href="javascript:void(0)" onclick="deleteKeywords(this,\''+encode+'\')">删除</a>';					
					//var deleteBut='<button type="button" onclick="deleteKeywords(this,\''+encode+'\')">删除</button>';
					keywordsMap.put(keyword,"");
					str += "<span>"+keyword+deleteBut+"&nbsp;&nbsp;&nbsp;&nbsp;</span>";
					$(str).appendTo($('#keywordsContentDiv'));
					$('#'+delkeywordId).linkbutton({
						iconCls: 'icon-remove' 
					});
				}
			}
		}
	});
	
	function doSubmit(){
		
		var str="";
		if(keywordsMap.size() > 0){
			var keywordses =  keywordsMap.keys();
			for(var i=0, length = keywordses.length; i < length; i++ ){
				str +="<input type=hidden name=keywords value=\""+keywordses[i]+"\" />";
			}
		}
		$('#keywords').html(str);
		
		var description2 = editor.getContent();
		if(description2 == ""){
			alert("商品介绍不能为空");
			return;
		}
		$('#description2').val(description2);
		
		if($('#brandId').val()==""){
			alert("请选择品牌");
			return;
		}
		if(categoryMap.size() == 0){
			alert("请至少选择一个商品类别");
			return;
		}
		checkValidate();
		if(!$('#rmb').attr('checked') && !$('#binke').attr('checked')){
			alert("至少选择一种售卖形式");
			return;
		}
		if(!$('#fm').form('validate')){
			return;
		}
		if($('#rmb').attr('checked') && $('#rmbPreferential').attr('checked')){
			if(($('#rmbPrice').numberbox('getValue'))*1 <= ($('#rmbPreferentialPrice').numberbox('getValue'))*1){
				alert("\"优惠价格\"应该比\"正常售卖\"低");
				return;
			}
		}
		if($('#binke').attr('checked') && $('#binkePreferential').attr('checked')){
			if(($('#binkePrice').numberbox('getValue'))*1 <= ($('#binkePreferentialPrice').numberbox('getValue'))*1){
				alert("\"优惠兑换积分\"应该比\"积分兑换\"低");
				return;
			}
		}
		
		$('#fm').form('submit',{
			url: 'create',
			success: function(result){
				result = eval('('+result+')'); 
				if(result.msg){
					// alert(result.msg);
					$.messager.show({
						title:'提示信息',
						msg:result.msg,
						timeout:5000,
						showType:'slide'
					});
					$('#id_').val(result.id);
				}
			},
			error:function(result){
				alert('error');
			}
		});
	}
	function checkValidate(){
		if($('#binke').attr('checked')){
			$('#binkePrice').validatebox({required: true});
		}else{
			$('#binkePrice').validatebox({required: false});
		}
		if($('#rmb').attr('checked')){
			$('#rmbPrice').validatebox({required: true});
		}else{
			$('#rmbPrice').validatebox({required: false});
		}
		if($('#rmbPreferential').attr('checked')){
			$('#rmbPreferentialPrice').validatebox({required: true});
		}else{
			$('#rmbPreferentialPrice').validatebox({required: false});
		}
		if($('#binkePreferential').attr('checked')){
			$('#binkePreferentialPrice').validatebox({required: true});
		}else{
			$('#binkePreferentialPrice').validatebox({required: false});
		}
	}
	function clearForm(){
		$('#binkePrice').validatebox({required: false});
		$('#rmbPrice').validatebox({required: false});
		$('#rmbPreferentialPrice').validatebox({required: false});
		$('#binkePreferentialPrice').validatebox({required: false});
		$('#fm').form('clear');
		categoryMap.clear();
		shopMap.clear();
		$('#showInSite').attr('checked','checked');
		$('#selectShops').html("");
		$('#selectCategorys').html("");
		editor.setContent("");
		$('#brandId').val("");
		$('#brandName').html("");
		deleteAllImage();
		
	}
	function checkCheckbox(obj, priceId){
		if(obj.checked){
			$('#'+priceId).validatebox({required: true});
		}else{
			$('#'+priceId).validatebox({required: false});
		}
	}
	function openDialog(){
		$('#dd').dialog('center');
		$('#dd').dialog('open');
	}
	function selectCategory(){
		var nodes = $('#tt2').tree('getChecked');
		if(nodes){
			if(nodes.length == 0 ){
				alert("请选择一个类别");
			}else{
				if($('#tt2').tree('isLeaf', $('#tt2').tree('getRoot').target)){
					alert("当前还没有类别，请先添加类别");
					return;
				}
				
				var status='<select name="status" style="width:50px"><option value="ON">上架</option><option value="OFF">下架</option></select>';
				var timeParam = Math.round(new Date().getTime()/1000);
				if($('#selectCategorys').html() == ""){
					$('#selectCategorys').html('<table border="0" id="categoryTable"><tr><td width="auto"  align="center">商品类别</td><td width="auto" align="center">上下架</td><td width="auto" align="center">类别排序</td><td width="auto" align="center">上下架时间</td><td width="auto" align="center">操作</td></tr></table>');
				}
				for(var i = 0; i < nodes.length; i++){
					var node = nodes[i];
					if(categoryMap.containsKey(node.id)){
						continue;
					}
					var displaySort = '<input name="displaySort" type="text" style="width:50px" ';
					var categoryId = node.id;
					var delCategoryId = 'categoryKey'+i+timeParam;
					var deleteBut = '<a id='+ delCategoryId +' href="javascript:void(0)" onclick="deleteCategory(this,\''+node.id+'\')">删除</a>';
					//var deleteBut='<button type="button" onclick="deleteCategory(this,\''+node.id+'\')">删除</button>';
					var categId = '<input type="hidden" name="categId" value='+ categoryId +' />';
					var category = getFullCategory(node);
					var displaySortId = 'displaySort'+timeParam+i;
					displaySort += ' id="' + displaySortId +'"/>';
					
					var str = '<tr>';
					str += '<td  width="auto">' + categId +category +'</td><td  width="auto">'+status +'</td><td  width="auto">' + displaySort +'</td><td width="auto"><input type=text name=on_offTime readonly="readonly" value=\"'+getCurrentTime()+'\" /></td><td width="auto">'+deleteBut+'</td>';
					str += '</tr>';
					$(str).appendTo($('#categoryTable'));
					$('#' + displaySortId).numberbox({precision:0});
					$('#' + displaySortId).validatebox({required:true});
					$('#'+delCategoryId).linkbutton({
						iconCls: 'icon-remove' 
					});
					categoryMap.put(node.id);
				}
				$('#dd').dialog('close');
			}
			
		}
	}
	function selectShops(){
		var rows = $('#shops').datagrid('getChecked');
		if(rows && rows != "" && rows.length > 0){
			var timeParam = Math.round(new Date().getTime()/1000);
			if($('#selectShops').html()==""){
				$('#selectShops').html('<table border="0" id="shopTable"><tr><td width="auto" align="center">门店中文名&nbsp;&nbsp;&nbsp;&nbsp;</td><td width="auto" align="center">门店英文名&nbsp;&nbsp;&nbsp;&nbsp;</td><td width="auto" align="center">区域&nbsp;&nbsp;&nbsp;&nbsp;</td><td width="auto">排序编号&nbsp;&nbsp;&nbsp;&nbsp;</td><td width="auto" align="center">操作&nbsp;&nbsp;&nbsp;&nbsp;</td></tr></table>');
			}
			for(var i = 0, length = rows.length; i < length; i++){
				var row = rows[i];
				if(shopMap.containsKey(row.id)){
					continue;
				}
				var delShopId = 'shopKey'+i+timeParam;
				var deleteBut = '<a id='+ delShopId +' href="javascript:void(0)" onclick="deleteShop(this,\''+row.id+'\')">删除</a>';
				//var deleteBut='<button type="button" onclick="deleteShop(this,\''+row.id+'\')">删除</button>';
				var nameZH = row.name;
				var nameEN = row.enName;
				if(!nameEN){
					nameEN = "";
				}
				if(!nameZH){
					nameZH = "";
				}
				var region = getAddress(null, row, null);
				var shopId = '<input type="hidden" name="shopId" value='+ row.id +' />';
				var sortId = 'sort'+timeParam+i;
				var merShopSort = '<input name="merShopSort" type="text" style="width:50px" maxlength="10" '+'id='+sortId+' />';//商品在门店的排序
				var str = '<tr>';
				str += '<td  width="auto">' + shopId +nameZH +'</td><td  width="auto">'+nameEN +'</td><td  width="auto">' + region +'</td><td width="auto">' + merShopSort + '</td></td><td width="auto">'+deleteBut+'</td>';
				str += '</tr>';
				$(str).appendTo($('#shopTable'));
				
				$('#' + sortId).numberbox({precision:0});
				$('#' + sortId).validatebox({required:true});
				$('#'+delShopId).linkbutton({
					iconCls: 'icon-remove' 
				});
				shopMap.put(row.id, '');	
			}
			$('#shopDialog').dialog('close');
		}else{
			alert("请选择一个门店，如不选择门店，请点击\"关闭\"。");
		}
	}
	function deleteShop(butt, shopId){
		shopMap.remove(shopId);
		butt.parentNode.parentNode.parentNode.removeChild(butt.parentNode.parentNode);
		if(shopMap.size() == 0){
			$('#selectShops').html("");
		}
	}
	function getCurrentTime(){
		var currentTime = new Date();
		var year = currentTime.getFullYear();
		var month = currentTime.getMonth() + 1 < 10 ? "0" + (currentTime.getMonth() + 1) : currentTime.getMonth() + 1;
		var date = currentTime.getDate() < 10 ? "0" + currentTime.getDate() : currentTime.getDate();
		var hour = currentTime.getHours()<10?"0"+currentTime.getHours() : currentTime.getHours();
		var minute = currentTime.getMinutes()<10? "0" +currentTime.getMinutes(): currentTime.getMinutes();
		var second = currentTime.getSeconds() <10?"0"+currentTime.getSeconds():currentTime.getSeconds();
		return year+"-"+month+"-"+date+" "+hour+":"+minute+":"+second;
	}
	function deleteCategory(butt, categoryId){
		butt.parentNode.parentNode.parentNode.removeChild(butt.parentNode.parentNode);
		categoryMap.remove(categoryId);
		if(categoryMap.size() == 0){
			$('#selectCategorys').html("");
		}
	}
	//返回完整的类别名称
	function getFullCategory(node){
		var str = "";
		if(node){
			var parent = $('#tt2').tree('getParent', node.target);
			str = node.text;
			while(parent){
				if(parent.id==$('#tt2').tree('getRoot').id){
					break;
				}
				str = parent.text +"/" + str;
				parent = $('#tt2').tree('getParent', parent.target);
			}
			return str;
		}else{
			return str;
		}
	}
	function addBrandDialog(){
		$('#brandDialog').dialog('center');
		$('#brandDialog').dialog('open');
	}
	function selectBrand(){
		var row = $('#tt').datagrid('getSelected');
		if(row){
			$('#brandId').val(row.id);
			$('#brandName').html(row.name);
			$('#brandDialog').dialog('close');
		}else{
			alert("请选择一个品牌");
			return;
		}
	}
	function doSearch(){  
	    $('#tt').datagrid('load',{  
	    	name:$('#brandSearchName').val() 
	    });  
	}
	function getAddress(v,o,i){
        return (o.province == null ? '' : o.province) + 
         	   (o.city == null ? '' : o.city) + 
         	   (o.region == null ? '' : o.region ) + 
         	   (o.address == null ? '' : o.address);
    }
	function millisecToString(millisec){ //根据1970 年 1 月 1 日之后millisec的毫秒数，返回"yyyy-MM-dd hh:mm:ss"
		var someDate = new Date();
		someDate.setTime(millisec);
		var year = someDate.getFullYear();
		var month = (someDate.getMonth() + 1) < 10 ? "0" + (someDate.getMonth() + 1) : (someDate.getMonth() + 1);
		var date = someDate.getDate() < 10 ? "0" + someDate.getDate() : someDate.getDate();
		var hour = someDate.getHours()< 10 ? "0" + someDate.getHours() : someDate.getHours();
		var minute = someDate.getMinutes() < 10 ? "0" + someDate.getMinutes() : someDate.getMinutes();
		var second = someDate.getSeconds() < 10 ? "0" + someDate.getSeconds() : someDate.getSeconds();
		return year+"-"+month+"-"+date+" "+hour+":"+minute+":"+second;
	}
	function changeKeywords(){
		style = "display:none";
		if(document.getElementById('keywordsDiv').style.display == "none"){
			document.getElementById('keywordsDiv').style.display = "";
		}else{
			document.getElementById('keywordsDiv').style.display = "none";
		}
		
	}
	function addKeywords(){
		var str = "";
		var timeParam = Math.round(new Date().getTime()/1000);
		var keywordId1 = 'keyword1'+timeParam;
		var keywordId2 = 'keyword2'+timeParam;
		var keywordId3 = 'keyword3'+timeParam;
		var iskeyone = false;
		var iskeytwo = false;
		var iskeythree = false;
		if($('#keywords1').val().length > 0 && $('#keywords1').val().trim().length == 0){
			alert("关键字不能全是空格，第一个输入框全是空格");
			return;
		}else if($('#keywords1').val().length > 0){
			var content = replaceSomeChar($('#keywords1').val());
			var encode = encodeURIComponent(content);
			var deleteBut = '<a id='+ keywordId1 +' href="javascript:void(0)" onclick="deleteKeywords(this,\''+encode+'\')">删除</a>';
			//var deleteBut='<button type="button" onclick="deleteKeywords(this,\''+encode+'\')">删除</button>';
			if(keywordsMap.containsKey(content)){
				alert("已经有关键字\""+$('#keywords1').val()+"\"");
			}else{
				keywordsMap.put(content,"");
				str += "<span>"+content+deleteBut+"&nbsp;&nbsp;&nbsp;&nbsp;</span>";
				iskeyone = true;
			}
		}
		if($('#keywords2').val().length > 0 && $('#keywords2').val().trim().length == 0){
			alert("关键字不能全是空格，第二个输入框全是空格");
			return;
		}else if($('#keywords2').val().length > 0){
			var content = replaceSomeChar($('#keywords2').val());
			var encode = encodeURIComponent(content);
			var deleteBut = '<a id='+ keywordId2 +' href="javascript:void(0)" onclick="deleteKeywords(this,\''+encode+'\')">删除</a>';
			// var deleteBut='<button type="button" onclick="deleteKeywords(this,\''+encode+'\')">删除</button>';
			if(keywordsMap.containsKey(content)){
				alert("已经有关键字\""+$('#keywords2').val()+"\"");
			}else{
				keywordsMap.put(content,"");
				str += "<span>"+content+deleteBut+"&nbsp;&nbsp;&nbsp;&nbsp;</span>";
				iskeytwo = true;
			}
		}
		if($('#keywords3').val().length > 0 && $('#keywords3').val().trim().length == 0){
			alert("关键字不能全是空格，第三个输入框全是空格");
			return;
		}else if($('#keywords3').val().length > 0){
			var content = replaceSomeChar($('#keywords3').val());
			var encode = encodeURIComponent(content);
			var deleteBut = '<a id='+ keywordId3 +' href="javascript:void(0)" onclick="deleteKeywords(this,\''+encode+'\')">删除</a>';
			// var deleteBut='<button type="button" onclick="deleteKeywords(this,\''+encode+'\')">删除</button>';
			if(keywordsMap.containsKey(content)){
				alert("已经有关键字\""+$('#keywords3').val()+"\"");
			}else{
				keywordsMap.put(content,"");
				str += "<span>"+content+deleteBut+"&nbsp;&nbsp;&nbsp;&nbsp;</span>";
				iskeythree = true;
			}
		}
		
		$(str).appendTo($('#keywordsContentDiv'));
		if(iskeyone){
			$('#'+keywordId1).linkbutton({
				iconCls: 'icon-remove' 
			});
		}
		if(iskeytwo){
			$('#'+keywordId2).linkbutton({
				iconCls: 'icon-remove' 
			});
		}
		if(iskeythree){
			$('#'+keywordId3).linkbutton({
				iconCls: 'icon-remove' 
			});
		}
		$('#keywords1').val("");
		$('#keywords2').val("");
		$('#keywords3').val("");
	}
	function deleteKeywords(butt, encode){
		butt.parentNode.parentNode.removeChild(butt.parentNode);
		keywordsMap.remove(decodeURIComponent(encode));
	}
	function replaceSomeChar(content){
		content = content.replaceAll("'" , "&#39;");
		content = content.replaceAll('"' , "&quot;");
		content = content.replaceAll("<" , "&lt;");
		content = content.replaceAll(">" , "&gt;");
		return content;
	}
	function saveImage(){
		if($('#id_').val() == ""){
			alert("请先保存基本信息");
			return;
		}
		if(!checkupLoadImage("OVERVIEW")){
			alert("请上传基本图片");
			return;
		} 
		$.ajax({
			url:'saveImage',
			data:'imageSessionName='+$('#imageSessionName_dataForm').val()+'&id='+$('#id_').val(),
			dataType:'json',
			async:false,
			success:function(data){
				//alert(data.msg);
				$.messager.show({
					title:'提示信息',
					msg:data.msg,
					timeout:5000,
					showType:'slide'
				});
			}
		});
	}
</script>

</head>
<body>
	<div class="easyui-tabs" style="width:1350px;">
	    <div title="商品基本信息" style="padding:20px;">
			<form action="create" method="post" id="fm">
				<table border="0">
					<tr>
						<td width="1300px">
							<fieldset style="font-size: 14px;width:1200px;height:auto;">
								<legend style="color: blue;">商品信息</legend>
									<table border="0">
										<colgroup>
											<col width="100px" align="left" />
											<col width="150px" align="left" />
											<col width="100px" align="left" />
											<col width="150px" align="left" />
											<col width="650px" align="left" />
										</colgroup>
										<tr>
											<td><span style="color: red;">*&nbsp;</span>商品编号：</td>
											<td>
												<input name="id" type="hidden" id="id_" value="${merchandise.id }">
												<input type="hidden" name="imageSessionName" id="imageSessionName_dataForm" value="${imageSessionName }" />
												<input id="code" name="code" value='<c:out value="${merchandise.code }"></c:out>' type="text" style="width:150px" class="easyui-validatebox" data-options="required:true" maxlength="20"/> 
											</td>
											<td><span style="color: red;">*&nbsp;</span>商品名称：</td>
											<td>
												<input id="name" name="name" value='<c:out value="${merchandise.name }"></c:out>' type="text" style="width:150px" class="easyui-validatebox" data-options="required:true" maxlength="20"> 
											</td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td><span style="color: red;">*&nbsp;</span>型号：</td>
											<td>
												<input id="model" name="model" value='<c:out value="${merchandise.model }"></c:out>' type="text" style="width:150px" class="easyui-validatebox" data-options="required:true"  maxlength="20"> 
											</td>
											<td><span style="color: red;">*&nbsp;</span>采购价：</td>
											<td>
												<input type="hidden" name="parent.id" id="parentId"> 
												<input id="purchasePrice" name="purchasePrice" value='<c:out value="${merchandise.purchasePrice }"></c:out>' type="text" style="width:150px" class="easyui-numberbox" data-options="min:0.01,precision:2,required:true"  maxlength="20"> 
											</td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td><span style="color: red;">*&nbsp;</span>运费：</td>
											<td>
												<input id="freight" name="freight" value='<c:out value="${merchandise.freight }"></c:out>' type="text" style="width:150px" class="easyui-numberbox" data-options="min:0,precision:2,required:true" maxlength="10">  
											</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td valign="top"><span style="color: red;">*&nbsp;</span>商品介绍：</td>
											<td align="left" colspan="4">
												<textarea id="description"></textarea>
												<input type="hidden" name="description" id="description2">
											</td>
										</tr>
									</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td width="1300px">
							<fieldset style="font-size: 14px;width:1200px;height:auto;">
								<legend style="color: blue;" onclick="changeKeywords()" ><span style="color:red;"></span>商品标签</legend>
								<div id="keywordsDiv">
									<table border="0">
										<tr>
											<td>添加关键字</td>
										</tr>
										<tr>
											<td>
												<input id="keywords1" type="text" style="width:150px" maxlength="20">&nbsp;&nbsp;&nbsp;&nbsp;<input id="keywords2" type="text" style="width:150px" maxlength="20">&nbsp;&nbsp;&nbsp;&nbsp;<input id="keywords3" type="text" style="width:150px" maxlength="20">&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="addKeywords()" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">确定</a>
											</td>
										</tr>
										<tr>
											<td>
												<div id="keywordsContentDiv"></div>
											</td>
											<td>
												<div id="keywords"></div>
											</td>
										</tr>
									</table>
								</div>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td width="1300px">
							<fieldset style="font-size: 14px;width:1200px;height:auto;">
								<legend style="color: blue;"><span style="color:red;">*&nbsp;</span>售卖形式</legend>
								<table border="0">
									<tr>
										<td width="20px"><input type="checkbox" name="rmb" id="rmb" onclick="checkCheckbox(this, 'rmbPrice')"/></td>
										<td width="80px">正常售卖：</td>
										<td width="200px">
												<input id="rmbPrice" name="rmbPrice" type="text" style="width:150px" class="easyui-numberbox" data-options="min:0.01,precision:2" maxlength="10">&nbsp;元<input type="hidden" name="rmbUnitId" value="0"> 
										</td>
										<td width="20px"></td>
										<td width="20px"><input type="checkbox" name="rmbPreferential" id="rmbPreferential" onclick="checkCheckbox(this,'rmbPreferentialPrice')" /></td>
										<td width="120px">优惠价格：</td>
										<td width="200px">
												<input id="rmbPreferentialPrice" name="rmbPreferentialPrice" type="text" style="width:150px" class="easyui-numberbox" data-options="min:0.01,precision:2" maxlength="10">&nbsp;元 
										</td>
									</tr>
									<tr>
										<td width="20px"><input type="checkbox" name="binke" id="binke" onclick="checkCheckbox(this,'binkePrice')"/></td>
										<td width="80px">积分兑换：</td>
										<td width="200px">
												<input id="binkePrice" name="binkePrice" type="text" style="width:150px" class="easyui-numberbox" data-options="min:0.01,precision:2" maxlength="10">&nbsp;缤刻<input type="hidden" name="binkeUnitId" value="1"> 
										</td>
										<td width="20px"></td>
										<td width="20px"><input type="checkbox" name="binkePreferential" id="binkePreferential" onclick="checkCheckbox(this,'binkePreferentialPrice')" /></td>
										<td width="120px">优惠兑换积分：</td>
										<td width="200px">
												<input id="binkePreferentialPrice" name="binkePreferentialPrice" type="text" style="width:150px" class="easyui-numberbox" data-options="min:0.01,precision:2" maxlength="10">&nbsp;缤刻
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td width="1300px">
							<fieldset style="font-size: 14px;width:1200px;height:auto;">
								<legend style="color: blue;"><span style="color:red;">*&nbsp;</span>商品类别选择</legend>
								<table border="0">
									<tr>
										<td width="20px"></td>
										<td>
										<a href="javascript:void(0)" onclick="openDialog()" class="easyui-linkbutton" data-options="iconCls:'icon-add'">选择类别</a>
										<c:choose>
											<c:when test="${empty merchandise }">
												&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" checked="checked" name="showInSite" id="showInSite"/>是否网站显示
											</c:when>
											<c:otherwise>
												<c:choose>
													<c:when test="${merchandise.showInSite }">
														&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" checked="checked" name="showInSite" id="showInSite"/>是否网站显示
													</c:when>
													<c:otherwise>
														&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="showInSite" id="showInSite"/>是否网站显示
													</c:otherwise>
												</c:choose>
											</c:otherwise>
										</c:choose>
										</td>
									</tr>
									<tr>
										<td width="20px"></td>
										<td>
											<div id="selectCategorys"></div>
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td width="1300px">
							<fieldset style="font-size: 14px;width:1200px;height:auto;">
								<legend style="color: blue;"><span style="color:red;">*&nbsp;</span>所属品牌</legend>
								<table border="0">
									<tr>
										<td width="20px"></td>
										<td width="100px">品牌名称：</td>
										<td width="150px" align="left">
											<input id="brandId" name="brand.id" type="hidden" value="${merchandise.brand.id }">
											<span id="brandName" ><c:out value="${merchandise.brand.name }"></c:out> </span>
										</td>
										<td>
											<a href="javascript:void(0)" onclick="addBrandDialog()" class="easyui-linkbutton" data-options="iconCls:'icon-add'">选择品牌</a>
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td width="1300px">
							<fieldset style="font-size: 14px;width:1200px;height:auto;">
								<legend style="color: blue;">所属门店</legend>
								<table border="0">
									<tr>
										<td width="20px"></td>
										<td>
											<a href="javascript:void(0)" onclick="javascript:$('#shopDialog').dialog('center');$('#shopDialog').dialog('open');" class="easyui-linkbutton" data-options="iconCls:'icon-add'">选择门店</a>
										</td>
									</tr>
									<tr>
										<td width="20px"></td>
										<td>
											<div id="selectShops"></div>
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td align="center">
							<a href="javascript:void(0)" onclick="doSubmit()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
						</td>
					</tr>
				</table>
			</form>
	    </div>
	    <!-- 图片临时目录 -->
	    <!-- 图片正式目录 -->
	    <jsp:include page="../image/imageUpload.jsp">
	    	<jsp:param value="MERCHANDISE_IMAGE_BUFFER" name="tempPath"></jsp:param>
	    	<jsp:param value="MERCHANDISE_IMAGE_DIR" name="formalPath"></jsp:param>
	    </jsp:include>
	    </div>
	<div id="brandDialog" class="easyui-dialog" title="新增商品-品牌选择" style="width:560px;height:460px;"  
        data-options="resizable:false,modal:true,closed:true">  
        <form action="" >
			<table border="0">
				<tr>
					<td>品牌名称：</td>
					<td align="left">
						<input id="brandSearchName" type="text" style="width:150px"/> 
					</td>
					<td>
						<a href="javascript:void(0)" onclick="doSearch()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
					</td>
				</tr>
			</table>
		</form>
		<table id="tt" class="easyui-datagrid" width="100%" height="100%" 
       				url="<%=request.getContextPath()%>/brand/list" rownumbers="true" pagination="true" singleSelect="true">   
   					<thead>  
       				<tr>  
        				<th field="id" checkbox="true"></th> 
             		<th data-options="field:'name',width:150">品牌名称</th>
             		<th data-options="field:'companyName',width:200">公司名称</th>
             		<th data-options="field:'createdAt',width:120,formatter:function(v,r,i){return dateFormat(v);}" >创建时间</th>
          	</tr>  
       	</thead>  
  		</table>
  		<table align="right">
  			<tr align="right">
  				<td align="right">
			  		<a href="javascript:void(0)" onclick="selectBrand()" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">确定</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="javascript:$('#brandDialog').dialog('close');" class="easyui-linkbutton" data-options="iconCls:'icon-back'">关闭</a>
  				</td>
  			</tr>
  		</table>
	</div> 
	<div id="dd" class="easyui-dialog" title="选择商品类别" style="width:400px;height:400px;"  
        data-options="resizable:false,modal:true,closed:true">  
        <ul id="tt2" class="easyui-tree" style="margin-top:10px;margin-left:20px;" data-options="url:'<%=request.getContextPath()%>/category/get_tree_nodes2',checkbox:true,onlyLeafCheck:true"></ul>
        <div style="position: absolute;top: 350px;left:200px;text-align:right;">
        	<a href="javascript:void(0)" onclick="selectCategory()" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">确定</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="javascript:$('#dd').dialog('close');" class="easyui-linkbutton" data-options="iconCls:'icon-back'">关闭</a>
        </div>
	</div> 
	<div id="shopDialog" class="easyui-dialog" title="新增商品-门店选择" style="width:705px;height:510px;" data-options="resizable:false,modal:true,closed:true"> 
		<form action="#" id="shopForm">
			<table>
				<tr>
					<td>总店编号:</td>
					<td><input type="text" id="shopNum" name="num" style="width:100px;"/></td>
					<td>门店中文名称:</td>
					<td><input type="text" id="shopName" name="name" style="width:100px;"/></td>
				</tr>
				<tr>
					<td>区域:</td>
					<td colspan="3">
						<select id="shopProvince" name="province" style="width:100px;"></select>
		  				<select id="shopCity" name="city" style="width:100px;"></select>
		  				<select id="shopRegion" name="region" style="width:100px;"></select>
					</td>
				</tr>
				<tr>
					<td>门店英文名称:</td>
					<td><input type="text" id="shopEnName"  name="enName" style="width:100px;"/></td>
					<td><a href="javascript:void(0);" onclick="javascript:$('#shops').datagrid('load',{
						num: $('#shopNum').val(),
						name: $('#shopName').val(),
						province: $('#shopProvince').val(),
						city: $('#shopCity').val(),
						region: $('#shopRegion').val(),
						enName: $('#shopEnName').val()			
					});" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a></td>
					<td>
						<a href="javascript:void(0)" onclick="javascript: $('#shopForm').form('clear');" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a>
					</td>
				</tr>
			</table>
		</form>
		<table id="shops" class="easyui-datagrid" data-options="url:'<%=request.getContextPath()%>/line/findShopList',pagination:true,rownumbers:true">
		    <thead>  
		        <tr> 
		        	<th field="id" checkbox="true"></th> 
		        	<th data-options="field:'num',width:130">总店编号</th>
		            <th data-options="field:'name',width:130">门店中文名</th>
		            <th data-options="field:'enName',width:130">门店英文名</th>
		            <th data-options="field:'region',width:200,formatter:function(v,o,i){return getAddress(v,o,i) }">区域</th>  
		        </tr>  
		    </thead>  
		</table>
		<table align="right">
			<tr align="right">
				<td align="right">
					<a href="javascript:void(0)" onclick="selectShops()" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">确定</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="javascript:$('#shopDialog').dialog('close');" class="easyui-linkbutton" data-options="iconCls:'icon-back'">关闭</a>
				</td>
			</tr>
		</table>
<!-- 		<table> -->
<!-- 			<tr> -->
<!-- 				<td> -->
<!-- 					<fieldset style="font-size: 14px;width:670px;height:auto;margin-top:0px;margin-bottom:0px;margin-left:20px;"> -->
<!-- 						<legend style="color: blue;">查询条件</legend> -->
<!-- 					</fieldset> -->
<!-- 				</td> -->
<!-- 			</tr>	 -->
<!-- 			<tr> -->
<!-- 				<td> -->
<!-- 					<fieldset style="font-size: 14px;width:670px;height:auto;margin-top:0px;margin-bottom:0px;margin-left:20px;"> -->
<!-- 						<legend style="color: blue;">查询结果</legend> -->
<!-- 					</fieldset> -->
<!-- 				</td> -->
<!-- 			</tr>		 -->
<!-- 			<tr> -->
<!-- 				<td align="right"> -->
<!-- 				</td> -->
<!-- 			</tr> -->
<!-- 		</table>  -->
	</div>
</body>
<script type="text/javascript">
new PCAS("province","city","region","${shop.province}","${shop.city}","${shop.region}");
</script>
</html>