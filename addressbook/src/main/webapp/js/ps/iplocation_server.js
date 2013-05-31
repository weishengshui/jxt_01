/*##20130301##*/
var locPageHost = pageConfig.FN_getDomain();
/* 图片滚动 */
var scrollVisible_noitem = pageConfig.wideVersion&&pageConfig.compatible ? 5 : 4,
	scrollVisible_itemover = pageConfig.wideVersion&&pageConfig.compatible ? 6 : 4;

(function(a){a.fn.imgScroll=function(b){return this.each(function(){var e=a.extend({evtType:"click",visible:1,showControl:true,showNavItem:false,navItemEvtType:"click",navItemCurrent:"current",showStatus:false,direction:"x",next:".next",prev:".prev",disableClass:"disabled",speed:300,loop:false,step:1,ie6DisableClass:"disableIE6"},b);var l=a(this),q=l.find("ul"),p=q.find("li"),h=e.width||p.outerWidth(),d=e.height||p.outerHeight(),u=p.length,c=e.visible,j=e.step,i=parseInt((u-c)/j),v=0,m=l.css("position")=="absolute"?"absolute":"relative",x=p.css("float")!=="none",t=a('<div class="scroll-nav-wrap"></div>'),f=e.direction=="x"?"left":"top",k=e.direction=="x",r=typeof e.prev=="string"?a(e.prev):e.prev,s=typeof e.next=="string"?a(e.next):e.next,w=a.browser.isIE6?e.ie6DisableClass:"";e.loop=false;function o(){if(!x){p.css("float","left")}q.css({position:"absolute",left:0,top:0});l.css({position:m,width:e.direction=="x"?c*h:p.outerWidth(),height:e.direction=="x"?d:c*d,overflow:"hidden"});r.addClass(e.disableClass+w);if(e.loop){}else{if((u-c)%j!==0&&u>c){var A=j-(u-c)%j;q.append(p.slice(0,A).clone());u=q.find("li").length;i=parseInt((u-c)/j)}}if(k){q.css("width",u*h)}else{q.css("height",u*d)}if(!e.showControl&&u<=c){s.hide();r.hide()}else{s.show();r.show()}if(u<=c){s.addClass(e.disableClass);r.addClass(e.disableClass)}else{r.addClass(e.disableClass);s.removeClass(e.disableClass)}if(e.showNavItem){for(var y=0;y<=i;y++){var z=y==0?e.navItemCurrent:"";t.append('<em class="'+z+'">'+(y+1)+"</em>")}l.after(t);t.find("em").bind(e.navItemEvtType,function(){var B=parseInt(this.innerHTML);g((B-1)*j)})}if(e.showStatus){l.after('<span class="scroll-status">'+1+"/"+(i+1)+"</span>")}}function g(y){if(q.is(":animated")){return false}if(y<0){r.addClass(e.disableClass+w);return false}if(y+c>u){s.addClass(e.disableClass);return false}v=y;q.animate(e.direction=="x"?{left:-((y)*h)}:{top:-((v)*d)},e.speed,function(){if(y>0){r.removeClass(e.disableClass+w)}else{r.addClass(e.disableClass+w)}if(y+c<u){s.removeClass(e.disableClass)}else{s.addClass(e.disableClass)}n(y)})}function n(y){t.find("em").removeClass(e.navItemCurrent).eq(y/j).addClass(e.navItemCurrent);if(e.showStatus){a(".scroll-status").html(((y/j)+1)+"/"+(i+1))}}o();if(u>c){s.click(function(){g(v+j)});r.click(function(){g(v-j)})}})}}(jQuery));


/* ---------- 埋点公用 ---------- */
function log (type1, type2, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10) {
	var data = '';
	for (i = 2; i < arguments.length; i++) {
		data = data + arguments[i] + '|||';
	}
	var pin = decodeURIComponent(escape(getCookie("pin")));
	var loguri = "http://csc.jd.com/log.ashx?type1=$type1$&type2=$type2$&data=$data$&pin=$pin$&referrer=$referrer$&jinfo=$jinfo$&callback=?";
	var url = loguri.replace(/\$type1\$/, escape(type1));
	url = url.replace(/\$type2\$/, escape(type2));
	url = url.replace(/\$data\$/, escape(data));
	url = url.replace(/\$pin\$/, escape(pin));
	url = url.replace(/\$referrer\$/, escape(document.referrer));
	url = url.replace(/\$jinfo\$/, escape(''));
	$.getJSON(url, function() {});
}
/**
 * 新版-点击流统计-页面pv和显示次数
 * wpid 主商品三级分类，没有为空串''
 * psku 主商品sku，没有为空串''，根据它来判断此商品为pop还是非pop
 * markId 推荐位标记，找张斌要
 * op s:显示、p:pv
 */
function clsPVAndShowLog(wpid, psku, markId, op) {
	var key = wpid + "." + markId + "." + skutype(psku) + "." + op;
	log('d', 'o', key);
}
function clsClickLog(wpid, psku, rsku, markId, num, reCookieName) {
	var key = wpid + "." + markId + "." + skutype(psku);
	appendCookie(reCookieName, rsku, key);
	log('d', 'o', key + ".c");
}
function appendCookie(reCookieName, sku, key) {
	var reWidsCookies = eval('(' + getCookie(reCookieName) + ')');
	if (reWidsCookies == null || reWidsCookies == '') {
		reWidsCookies = new Object();
	}
	if (reWidsCookies[key] == null) {
		reWidsCookies[key] = '';
	}
	var pos = reWidsCookies[key].indexOf(sku);
	if (pos < 0) {
		reWidsCookies[key] = reWidsCookies[key] + "," + sku;
	}
	setCookie(reCookieName, $.toJSON(reWidsCookies), 15);
}
function skutype(sku) {
	if (sku) {
		var len = sku.toString().length;
		return len==10 ? 1 : 0;
	}
	return 0;
}
function setCookie(name, value, date) {
	var Days = date;
	var exp = new Date();
	exp.setTime(exp.getTime() + Days * 24 * 60 * 60 * 1000);
	document.cookie = name + "=" + escape(value) + ";expires=" + exp.toGMTString() + ";path=/;domain=."+locPageHost;
}
function getCookie(name) {
	var arr = document.cookie.match(new RegExp("(^| )" + name + "=([^;]*)(;|$)"));
	if (arr != null) return unescape(arr[2]);
	return null;
}
function reClick(type2, pwid, sku, num) {
	name = "reWids" + type2;
	reWids = getCookie(name);
	if (reWids != null) {
		reWids = reWids.toString();
		var pos = reWids.indexOf(sku);
		if (pos < 0) {
			reWids = reWids + "," + sku;
		}
	}
	else {
		reWids = sku;
	}
	setCookie(name, reWids, 15);

	sku = sku.split("#");
	log(3, type2, sku[0]);
	//log('RC', 'CK', type2, pwid, sku[0], num);
}

function readPinCookie(name) {
	//读取cookies函数
	var arr = document.cookie.match(new RegExp("(^| )" + name + "=([^;]*)(;|$)"));
	if (arr != null) return arr[2];
	return '';
}

/**
 * 点击流统计，调用例如：clsLog("3425&special","","174620#988",4,"reWidsBookSpecial")
 * @param type2 三级分类
 * @param pwid  当前商品wid，没有为空串''
 * @param sku   推荐商品wid
 * @param num   位置，从0开始
 * @param reCookieName   cookieName
 */
function clsLog(type2, pwid, sku, num, reCookieName) {
	var reWidsClubCookies = eval('(' + getCookie(reCookieName) + ')');
	if (reWidsClubCookies == null || reWidsClubCookies == '') {
		reWidsClubCookies = new Object();
	}
	if (reWidsClubCookies[type2] == null) {
		reWidsClubCookies[type2] = '';
	}
	var pos = reWidsClubCookies[type2].indexOf(sku);
	if (pos < 0) {
		reWidsClubCookies[type2] = reWidsClubCookies[type2] + "," + sku;
	}
	setCookie(reCookieName, $.toJSON(reWidsClubCookies), 15);
	sku = sku.split("#");
	log(3, type2, sku[0]);
	//log('RC', 'CK', type2, pwid, sku[0], num);
}
function mark(b,a){ log(1,a,b);}

/* ---------- 埋点公用 end ---------- */

var noItemOver = {
	// 无货、下柜页面推荐列表
	init: function( type ) {

		this.type = type || 1;	//3c为1、日百为2


		this.outOfStockTPL = '<div class="w"><div id="out-of-stock" class="m m2">'
		+'	<div class="mt">'
		+'		<h2>其它类似商品</h2>'
		+'	</div>'
		+'	<div class="mc">'
		+'		<div id="noitem-related-list"><div class="noitem-related-list"><div class="iloading">正在加载中，请稍候...</div></div>'
		+'	</div>'
		+'</div></div>';

		var isNoItem = $('#product-intro').hasClass('product-intro-noitem'),
			isOver = $('#product-intro').hasClass('product-intro-itemover');

		if ( !isNoItem && !isOver ) {

			$('#out-of-stock,#noitem-related-list,#itemover-related-list,#itemover1-related-list').remove();
			return false;
		}

		if ( isNoItem ) {
			this.noItem();
		}
		if ( isOver ) {
			this.itemOver();
		}

	},
	noItem: function( isItemOver ) {
		var imgStr = isItemOver ? '<img height="100" width="100" src="${pageConfig.FN_GetImageDomain(list.skuId)}n4/${list.imgUrl}">' : '<img height="130" width="130" src="${pageConfig.FN_GetImageDomain(list.skuId)}n3/${list.imgUrl}">';
		// 无货推荐列表[老服务]
		var noItem_TPL_OLD = '{for list in html}'
			+'<li class="fore fore${list_index}">'
			+'	<div class="p-img">'
			+'		<a target="_blank" href="${list.skuId}.html">'+imgStr+'</a>'
			+'	</div>'
			+'	<div class="p-name">'
			+'		<a target="_blank" title="${list.name}" href="${list.skuId}.html">${list.Name}</a>'
			+'	</div>'
			+'	<div class="p-price">'
			+'		<strong><img src="http://jprice.360buyimg.com/price/gp${list.skuId}-1-1-1.png" onerror="this.src=\'http://misc.360buyimg.com/lib/skin/e/i/error-3.gif\'" /></strong>'
			+'	</div>'
			+'</li>'
			+'{/for}';

		//无货页面推荐列表
		//http://d.360buy.com/nostockrecomm/get?productId=104410&callback=jsonp
		// 老服务var url = 'http://pbss.360buy.com/recomm/getRecommProduct.action?'+ pageConfig.product.skuid,
		// http://d.360buy.com/nostockrecomm/get?productId=104410

		var url = 'http://d.360buy.com/nostockrecomm/get?productId=' + pageConfig.product.skuid,
			_this = this,
			isItemOver = isItemOver || false;

		// if ( isItemOver ) {
		// 	log( pageConfig.product.cat[2] + '&RemovedArk', 'Show' );
		// } else {
		// 	log( pageConfig.product.cat[0] + "&SORecPage", 'Show');

		// }
		log( pageConfig.product.cat[0] + "&SORecPage", 'Show');

	
		$.ajax({
			url: url,
			dataType: 'jsonp',
			data: {
				productId: pageConfig.product.skuid
			},
			success: function( data ) {

				if ( data && (typeof data.html !== 'undefined') && data.html !== null && data.html.length > 0 ) {
					
					if ( isItemOver ) {
						if ( $('#noitem-related-list').length < 1 ) {
							$('#choose').after('<div id="noitem-related-list"><p>其它类似商品</p><div class="noitem-related-list"><div class="iloading">正在加载中，请稍候...</div></div>');
						} else {
							$('#itemover-related-list').show();
						}						
					} else {
						if ( $('#out-of-stock').length < 1 ) {
							$('#product-intro').parent().after(_this.outOfStockTPL);
						} else {
							$('#out-of-stock').show();
						}						
					}


					$('#noitem-related-list .noitem-related-list').html( '<a href="javascript:;" class="spec-control disabled" id="noitem-forward"></a><a href="javascript:;" class="spec-control" id="noitem-backward"></a><div id="noitem-list"><ul>' + noItem_TPL_OLD.process( data ) + '</ul></div>' );
					$('#noitem-related-list').attr('loaded', 'true');


					//图片滚动【无货页面】 
					$('#noitem-list').imgScroll({
						visible: scrollVisible_itemover,
						showControl: true,
						speed: 200,
						step: scrollVisible_itemover,
						loop: false,
						prev: '#noitem-forward',
						next: '#noitem-backward',
						disableClass: 'disabled'
					});

				} else if ( !data || data.html == null || data.html.length < 1 ) {
					_this.noItemNoData(isItemOver);
				}
			}
		});
	},
	itemOver: function() {
		// 浏览了 - 还浏览3c
		var listBrosweBroswe_TPL = '<li onclick="reClick(1, '+pageConfig.product.skuid+',\'${wid}#${wmeprice}\', [#]);">'
			+'	<div class="p-img">'
			+'		<a target="_blank" title="${name}" href="${wid}.html"><img height="100" width="100" alt="${name}" src="${pageConfig.FN_GetImageDomain(wid)}n4/${imgurl}"></a>'
			+'	</div>'
			+'	<div class="p-name">'
			+'		<a target="_blank" title="${name}" href="${wid}.html">${name}</a>'
			+'	</div>'
			+'	<div class="p-price">'
			+'		<strong>'
			+'			<img src="http://jprice.360buyimg.com/price/gp${wid}-1-1-1.png" onerror="this.src=\'http://misc.360buyimg.com/lib/skin/e/i/error-3.gif\'" />'
			+'		</strong>'
			+'	</div>'
			+'</li>';

		var urlRelated = 'http://simigoods.jd.com/SoldOutRecJsonData.aspx?ip='+ getCookie("ipLocation") +'&wids='+ pageConfig.product.skuid;
		var urlBroswerBuy = 'http://simigoods.jd.com/ThreeCCombineBuying/ThreeCBroswerBroswerJsonData.aspx?ip=' + getCookie('ipLocation') + '&wids=' + pageConfig.product.skuid;
		var _this = this;

		_this.noItem( true );



		//下柜页看了还买了
		$.ajax({
			url: urlBroswerBuy,
			dataType: 'jsonp',
			success: function(data) {
				var resHTML = [];
				
				//log('RemovedArk', 'Show');
				log('R1','Show');
				
				if ( data == null ) {
					return false;
				}
				for ( var i = 0; i < data.length; i++ ) {
					resHTML.push( listBrosweBroswe_TPL.process(data[i]).replace('[#]', i) );
				}
				$('#itemover1-related-list').show();
				$('#itemover1-related-list .itemover1-related-list').html( '<a href="javascript:;" class="spec-control disabled" id="itemover1-forward"></a><a href="javascript:;" class="spec-control disabled" id="itemover1-backward"></a><div id="itemover1-list"><ul>' + resHTML.join('') + '</ul></div>' );

				//图片滚动【下柜页面-看了还买了】
				$('#itemover1-list').imgScroll({
					visible: scrollVisible_itemover,
					showControl: false,
					speed: 200,
					step: scrollVisible_itemover,
					loop: false,
					prev: '#itemover1-forward',
					next: '#itemover1-backward',
					disableClass: 'disabled',
					width: 130,
					height:165
				});
			}
		});
	},
	noItemNoData: function( isItemOver ) {
		var imgStr = isItemOver ? '<img height="100" width="100" src="${pageConfig.FN_GetImageDomain(list.wid)}n4/${list.imgurl}">' : '<img height="130" width="130" src="${pageConfig.FN_GetImageDomain(list.wid)}n3/${list.imgurl}">';
		// 无货推荐列表[新服务]
		var noItem_TPL = '{for list in MySoldOut}'
			+'<li class="fore fore${list_index}" onclick="reClick2(\''+pageConfig.product.cat[0]+'&SORec\','+pageConfig.product.skuid+', \'${list.wid}#${list.wmeprice}\', ${list_index})">'
			+'	<div class="p-img">'
			+'		<a target="_blank" href="${list.wid}.html">'+imgStr+'</a>'
			+'	</div>'
			+'	<div class="p-name">'
			+'		<a target="_blank" title="${list.name}" href="${list.wid}.html">${list.name}</a>'
			+'	</div>'
			+'	<div class="p-price">'
			+'		<strong><img src="http://jprice.360buyimg.com/price/gp${list.wid}-1-1-1.png" onerror="this.src=\'http://misc.360buyimg.com/lib/skin/e/i/error-3.gif\'" /></strong>'
			+'	</div>'
			+'</li>'
			+'{/for}';

		// 没有推荐数据时调用新数据接口
		var url = 'http://simigoods.jd.com/SoldOutRecJsonData.aspx?ip='+ getCookie("ipLocation") +'&wids='+ pageConfig.product.skuid,
			_this = this;

		$.ajax({
			url: url,
			dataType: 'jsonp',
			success: function(data) {

				if ( data.MySoldOut !== null && data !== null ) {

					if ( isItemOver ) {
						if ( $('#noitem-related-list').length < 1 ) {
							$('#choose').after('<div id="noitem-related-list"><p>其它类似商品</p><div class="noitem-related-list"><div class="iloading">正在加载中，请稍候...</div></div>');
						}
					} else {
						if ( $('#out-of-stock').length < 1 ) {
							$('#product-intro').parent().after(_this.outOfStockTPL);
						} else {
							$('#out-of-stock').show();
						}
					}

					log(pageConfig.product.cat[0] + "&SORec", 'Show');


					$('#noitem-related-list').attr('iplocation', getCookie("ipLocation"));

					if ( isItemOver ) {
						$('#itemover-related-list').show().find('.itemover-related-list').html('<a href="javascript:;" class="spec-control disabled" id="itemover-forward"></a><a href="javascript:;" class="spec-control disabled" id="itemover-backward"></a><div id="itemover-list"><ul>' + noItem_TPL.process(data) + '</ul></div>');

						//图片滚动【下柜页面-其它类似商品】
						$('#itemover-list').imgScroll({
							visible: scrollVisible_itemover,
							showControl: true,
							speed: 200,
							step: scrollVisible_itemover,
							loop: false,
							prev: '#itemover-forward',
							next: '#itemover-backward',
							disableClass: 'disabled',
							width: 130,
							height:165
						});


					} else {
						$('#noitem-related-list .noitem-related-list').html( '<a href="javascript:;" class="spec-control disabled" id="noitem-forward"></a><a href="javascript:;" class="spec-control" id="noitem-backward"></a><div id="noitem-list"><ul>' + noItem_TPL.process(data) + '</ul></div>' );	
						
						//图片滚动【无货页面】
						$('#noitem-list').imgScroll({
							visible: scrollVisible_noitem,
							showControl: true,
							speed: 200,
							step: scrollVisible_noitem,
							loop: false,
							prev: '#noitem-forward',
							next: '#noitem-backward',
							disableClass: 'disabled'
						});
					}
				}		

			}
		});
	}

};
var iplocation = {"北京": { id: "1", root: 0, djd: 1,c:72 },"上海": { id: "2", root: 1, djd: 1,c:78 },"天津": { id: "3", root: 0, djd: 1,c:51035 },"重庆": { id: "4", root: 3, djd: 1,c:113 },"河北": { id: "5", root: 0, djd: 1,c:142 },"山西": { id: "6", root: 0, djd: 1,c:303 },"河南": { id: "7", root: 0, djd: 1,c:412 },"辽宁": { id: "8", root: 0, djd: 1,c:560 },"吉林": { id: "9", root: 0, djd: 1,c:639 },"黑龙江": { id: "10", root: 0, djd: 1,c:698 },"内蒙古": { id: "11", root: 0, djd: 0,c:799 },"江苏": { id: "12", root: 1, djd: 1,c:904 },"山东": { id: "13", root: 0, djd: 1,c:1000 },"安徽": { id: "14", root: 1, djd: 1,c:1116 },"浙江": { id: "15", root: 1, djd: 1,c:1158 },"福建": { id: "16", root: 2, djd: 1,c:1303 },"湖北": { id: "17", root: 0, djd: 1,c:1381 },"湖南": { id: "18", root: 2, djd: 1,c:1482 },"广东": { id: "19", root: 2, djd: 1,c:1601 },"广西": { id: "20", root: 2, djd: 1,c:1715 },"江西": { id: "21", root: 2, djd: 1,c:1827 },"四川": { id: "22", root: 3, djd: 1,c:1930 },"海南": { id: "23", root: 2, djd: 1,c:2121 },"贵州": { id: "24", root: 3, djd: 1,c:2144 },"云南": { id: "25", root: 3, djd: 1,c:2235 },"西藏": { id: "26", root: 3, djd: 0,c:2951 },"陕西": { id: "27", root: 3, djd: 1,c:2376 },"甘肃": { id: "28", root: 3, djd: 1,c:2487 },"青海": { id: "29", root: 3, djd: 0,c:2580 },"宁夏": { id: "30", root: 3, djd: 1,c:2628 },"新疆": { id: "31", root: 3, djd: 0,c:2652 },"台湾": { id: "32", root: 2, djd: 0,c:2768 },"香港": { id: "42", root: 2, djd: 0,c:2754 },"澳门": { id: "43", root: 2, djd: 0,c:2770 },"钓鱼岛": { id: "84", root: 2, djd: 0,c:84 }};
var provinceCityJson = {"1":[{"id":72,"name":"朝阳区"},{"id":2800,"name":"海淀区"},{"id":2801,"name":"西城区"},{"id":2802,"name":"东城区"},{"id":2803,"name":"崇文区"},{"id":2804,"name":"宣武区"},{"id":2805,"name":"丰台区"},{"id":2806,"name":"石景山区"},{"id":2807,"name":"门头沟"},{"id":2808,"name":"房山区"},{"id":2809,"name":"通州区"},{"id":2810,"name":"大兴区"},{"id":2812,"name":"顺义区"},{"id":2814,"name":"怀柔区"},{"id":2816,"name":"密云区"},{"id":2901,"name":"昌平区"},{"id":2953,"name":"平谷区"},{"id":3065,"name":"延庆县"}],"2":[{"id":2811,"name":"卢湾区"},{"id":2813,"name":"徐汇区"},{"id":2815,"name":"长宁区"},{"id":2817,"name":"静安区"},{"id":2820,"name":"闸北区"},{"id":2822,"name":"虹口区"},{"id":2823,"name":"杨浦区"},{"id":2824,"name":"宝山区"},{"id":2825,"name":"闵行区"},{"id":2826,"name":"嘉定区"},{"id":2830,"name":"浦东新区"},{"id":2833,"name":"青浦区"},{"id":2834,"name":"松江区"},{"id":2835,"name":"金山区"},{"id":2836,"name":"南汇区"},{"id":2837,"name":"奉贤区"},{"id":2841,"name":"普陀区"},{"id":2919,"name":"崇明县"},{"id":78,"name":"黄浦区"}],"3":[{"id":51035,"name":"东丽区"},{"id":51036,"name":"和平区"},{"id":51037,"name":"河北区"},{"id":51038,"name":"河东区"},{"id":51039,"name":"河西区"},{"id":51040,"name":"红桥区"},{"id":51041,"name":"蓟县"},{"id":51042,"name":"静海县"},{"id":51043,"name":"南开区"},{"id":51044,"name":"塘沽区"},{"id":51045,"name":"西青区"},{"id":51046,"name":"武清区"},{"id":51047,"name":"津南区"},{"id":51048,"name":"汉沽区"},{"id":51049,"name":"大港区"},{"id":51050,"name":"北辰区"},{"id":51051,"name":"宝坻区"},{"id":51052,"name":"宁河县"}],"4":[{"id":113,"name":"万州区"},{"id":114,"name":"涪陵区"},{"id":115,"name":"梁平县"},{"id":119,"name":"南川区"},{"id":123,"name":"潼南县"},{"id":126,"name":"大足区"},{"id":128,"name":"黔江区"},{"id":129,"name":"武隆县"},{"id":130,"name":"丰都县"},{"id":131,"name":"奉节县"},{"id":132,"name":"开县"},{"id":133,"name":"云阳县"},{"id":134,"name":"忠县"},{"id":135,"name":"巫溪县"},{"id":136,"name":"巫山县"},{"id":137,"name":"石柱县"},{"id":138,"name":"彭水县"},{"id":139,"name":"垫江县"},{"id":140,"name":"酉阳县"},{"id":141,"name":"秀山县"},{"id":48131,"name":"璧山县"},{"id":48132,"name":"荣昌县"},{"id":48133,"name":"铜梁县"},{"id":48201,"name":"合川区"},{"id":48202,"name":"巴南区"},{"id":48203,"name":"北碚区"},{"id":48204,"name":"江津区"},{"id":48205,"name":"渝北区"},{"id":48206,"name":"长寿区"},{"id":48207,"name":"永川区"},{"id":50950,"name":"江北区"},{"id":50951,"name":"南岸区"},{"id":50952,"name":"九龙坡区"},{"id":50953,"name":"沙坪坝区"},{"id":50954,"name":"大渡口区"},{"id":50995,"name":"綦江区"},{"id":51026,"name":"渝中区"},{"id":51027,"name":"高新区"},{"id":51028,"name":"北部新区"},{"id":4164,"name":"城口县"},{"id":3076,"name":"高新区"}],"5":[{"id":142,"name":"石家庄市"},{"id":148,"name":"邯郸市"},{"id":164,"name":"邢台市"},{"id":199,"name":"保定市"},{"id":224,"name":"张家口市"},{"id":239,"name":"承德市"},{"id":248,"name":"秦皇岛市"},{"id":258,"name":"唐山市"},{"id":264,"name":"沧州市"},{"id":274,"name":"廊坊市"},{"id":275,"name":"衡水市"}],"6":[{"id":303,"name":"太原市"},{"id":309,"name":"大同市"},{"id":318,"name":"阳泉市"},{"id":325,"name":"晋城市"},{"id":330,"name":"朔州市"},{"id":336,"name":"晋中市"},{"id":350,"name":"忻州市"},{"id":368,"name":"吕梁市"},{"id":379,"name":"临汾市"},{"id":398,"name":"运城市"},{"id":3074,"name":"长治市"}],"7":[{"id":412,"name":"郑州市"},{"id":420,"name":"开封市"},{"id":427,"name":"洛阳市"},{"id":438,"name":"平顶山市"},{"id":446,"name":"焦作市"},{"id":454,"name":"鹤壁市"},{"id":458,"name":"新乡市"},{"id":468,"name":"安阳市"},{"id":475,"name":"濮阳市"},{"id":482,"name":"许昌市"},{"id":489,"name":"漯河市"},{"id":495,"name":"三门峡市"},{"id":502,"name":"南阳市"},{"id":517,"name":"商丘市"},{"id":527,"name":"周口市"},{"id":538,"name":"驻马店市"},{"id":549,"name":"信阳市"},{"id":2780,"name":"济源市"}],"8":[{"id":560,"name":"沈阳市"},{"id":573,"name":"大连市"},{"id":579,"name":"鞍山市"},{"id":584,"name":"抚顺市"},{"id":589,"name":"本溪市"},{"id":593,"name":"丹东市"},{"id":598,"name":"锦州市"},{"id":604,"name":"葫芦岛市"},{"id":609,"name":"营口市"},{"id":613,"name":"盘锦市"},{"id":617,"name":"阜新市"},{"id":621,"name":"辽阳市"},{"id":632,"name":"朝阳市"},{"id":6858,"name":"铁岭市"}],"9":[{"id":639,"name":"长春市"},{"id":644,"name":"吉林市"},{"id":651,"name":"四平市"},{"id":2992,"name":"辽源市"},{"id":657,"name":"通化市"},{"id":664,"name":"白山市"},{"id":674,"name":"松原市"},{"id":681,"name":"白城市"},{"id":687,"name":"延边州"}],"10":[{"id":727,"name":"鹤岗市"},{"id":731,"name":"双鸭山市"},{"id":737,"name":"鸡西市"},{"id":742,"name":"大庆市"},{"id":753,"name":"伊春市"},{"id":757,"name":"牡丹江市"},{"id":765,"name":"佳木斯市"},{"id":773,"name":"七台河市"},{"id":776,"name":"黑河市"},{"id":782,"name":"绥化市"},{"id":793,"name":"大兴安岭地区"},{"id":698,"name":"哈尔滨市"},{"id":712,"name":"齐齐哈尔市"}],"11":[{"id":799,"name":"呼和浩特市"},{"id":805,"name":"包头市"},{"id":810,"name":"乌海市"},{"id":812,"name":"赤峰市"},{"id":823,"name":"乌兰察布市"},{"id":835,"name":"锡林郭勒盟"},{"id":848,"name":"呼伦贝尔市"},{"id":870,"name":"鄂尔多斯市"},{"id":880,"name":"巴彦淖尔市"},{"id":891,"name":"阿拉善盟"},{"id":895,"name":"兴安盟"},{"id":902,"name":"通辽市"}],"12":[{"id":904,"name":"南京市"},{"id":911,"name":"徐州市"},{"id":919,"name":"连云港市"},{"id":925,"name":"淮安市"},{"id":933,"name":"宿迁市"},{"id":939,"name":"盐城市"},{"id":951,"name":"扬州市"},{"id":959,"name":"泰州市"},{"id":965,"name":"南通市"},{"id":972,"name":"镇江市"},{"id":978,"name":"常州市"},{"id":984,"name":"无锡市"},{"id":988,"name":"苏州市"}],"13":[{"id":2900,"name":"济宁市"},{"id":1000,"name":"济南市"},{"id":1007,"name":"青岛市"},{"id":1016,"name":"淄博市"},{"id":1022,"name":"枣庄市"},{"id":1025,"name":"东营市"},{"id":1032,"name":"潍坊市"},{"id":1042,"name":"烟台市"},{"id":1053,"name":"威海市"},{"id":1058,"name":"莱芜市"},{"id":1060,"name":"德州市"},{"id":1072,"name":"临沂市"},{"id":1081,"name":"聊城市"},{"id":1090,"name":"滨州市"},{"id":1099,"name":"菏泽市"},{"id":1108,"name":"日照市"},{"id":1112,"name":"泰安市"}],"14":[{"id":1151,"name":"黄山市"},{"id":1159,"name":"滁州市"},{"id":1167,"name":"阜阳市"},{"id":1174,"name":"亳州市"},{"id":1180,"name":"宿州市"},{"id":1201,"name":"池州市"},{"id":1206,"name":"六安市"},{"id":2971,"name":"宣城市"},{"id":1114,"name":"铜陵市"},{"id":1116,"name":"合肥市"},{"id":1121,"name":"淮南市"},{"id":1124,"name":"淮北市"},{"id":1127,"name":"芜湖市"},{"id":1132,"name":"蚌埠市"},{"id":1137,"name":"马鞍山市"},{"id":1140,"name":"安庆市"}],"15":[{"id":1158,"name":"宁波市"},{"id":1273,"name":"衢州市"},{"id":1280,"name":"丽水市"},{"id":1290,"name":"台州市"},{"id":1298,"name":"舟山市"},{"id":1213,"name":"杭州市"},{"id":1233,"name":"温州市"},{"id":1243,"name":"嘉兴市"},{"id":1250,"name":"湖州市"},{"id":1255,"name":"绍兴市"},{"id":1262,"name":"金华市"}],"16":[{"id":1303,"name":"福州市"},{"id":1315,"name":"厦门市"},{"id":1317,"name":"三明市"},{"id":1329,"name":"莆田市"},{"id":1332,"name":"泉州市"},{"id":1341,"name":"漳州市"},{"id":1352,"name":"南平市"},{"id":1362,"name":"龙岩市"},{"id":1370,"name":"宁德市"}],"17":[{"id":1432,"name":"孝感市"},{"id":1441,"name":"黄冈市"},{"id":1458,"name":"咸宁市"},{"id":1466,"name":"恩施州"},{"id":1475,"name":"鄂州市"},{"id":1477,"name":"荆门市"},{"id":1479,"name":"随州市"},{"id":3154,"name":"神农架林区"},{"id":1381,"name":"武汉市"},{"id":1387,"name":"黄石市"},{"id":1396,"name":"襄阳市"},{"id":1405,"name":"十堰市"},{"id":1413,"name":"荆州市"},{"id":1421,"name":"宜昌市"},{"id":2922,"name":"潜江市"},{"id":2980,"name":"天门市"},{"id":2983,"name":"仙桃市"}],"18":[{"id":4250,"name":"耒阳市"},{"id":1482,"name":"长沙市"},{"id":1488,"name":"株洲市"},{"id":1495,"name":"湘潭市"},{"id":1499,"name":"韶山市"},{"id":1501,"name":"衡阳市"},{"id":1511,"name":"邵阳市"},{"id":1522,"name":"岳阳市"},{"id":1530,"name":"常德市"},{"id":1540,"name":"张家界市"},{"id":1544,"name":"郴州市"},{"id":1555,"name":"益阳市"},{"id":1560,"name":"永州市"},{"id":1574,"name":"怀化市"},{"id":1586,"name":"娄底市"},{"id":1592,"name":"湘西州"}],"19":[{"id":1601,"name":"广州市"},{"id":1607,"name":"深圳市"},{"id":1609,"name":"珠海市"},{"id":1611,"name":"汕头市"},{"id":1617,"name":"韶关市"},{"id":1627,"name":"河源市"},{"id":1634,"name":"梅州市"},{"id":1709,"name":"揭阳市"},{"id":1643,"name":"惠州市"},{"id":1650,"name":"汕尾市"},{"id":1655,"name":"东莞市"},{"id":1657,"name":"中山市"},{"id":1659,"name":"江门市"},{"id":1666,"name":"佛山市"},{"id":1672,"name":"阳江市"},{"id":1677,"name":"湛江市"},{"id":1684,"name":"茂名市"},{"id":1690,"name":"肇庆市"},{"id":1698,"name":"云浮市"},{"id":1704,"name":"清远市"},{"id":1705,"name":"潮州市"}],"20":[{"id":3168,"name":"崇左市"},{"id":1715,"name":"南宁市"},{"id":1720,"name":"柳州市"},{"id":1726,"name":"桂林市"},{"id":1740,"name":"梧州市"},{"id":1746,"name":"北海市"},{"id":1749,"name":"防城港市"},{"id":1753,"name":"钦州市"},{"id":1757,"name":"贵港市"},{"id":1761,"name":"玉林市"},{"id":1792,"name":"贺州市"},{"id":1806,"name":"百色市"},{"id":1818,"name":"河池市"},{"id":3044,"name":"来宾市"}],"21":[{"id":1827,"name":"南昌市"},{"id":1832,"name":"景德镇市"},{"id":1836,"name":"萍乡市"},{"id":1842,"name":"新余市"},{"id":1845,"name":"九江市"},{"id":1857,"name":"鹰潭市"},{"id":1861,"name":"上饶市"},{"id":1874,"name":"宜春市"},{"id":1885,"name":"抚州市"},{"id":1898,"name":"吉安市"},{"id":1911,"name":"赣州市"}],"22":[{"id":2103,"name":"凉山州"},{"id":1930,"name":"成都市"},{"id":1946,"name":"自贡市"},{"id":1950,"name":"攀枝花市"},{"id":1954,"name":"泸州市"},{"id":1960,"name":"绵阳市"},{"id":1962,"name":"德阳市"},{"id":1977,"name":"广元市"},{"id":1983,"name":"遂宁市"},{"id":1988,"name":"内江市"},{"id":1993,"name":"乐山市"},{"id":2005,"name":"宜宾市"},{"id":2016,"name":"广安市"},{"id":2022,"name":"南充市"},{"id":2033,"name":"达州市"},{"id":2042,"name":"巴中市"},{"id":2047,"name":"雅安市"},{"id":2058,"name":"眉山市"},{"id":2065,"name":"资阳市"},{"id":2070,"name":"阿坝州"},{"id":2084,"name":"甘孜州"}],"23":[{"id":3690,"name":"三亚市"},{"id":3698,"name":"文昌市"},{"id":3699,"name":"五指山市"},{"id":3701,"name":"临高县"},{"id":3702,"name":"澄迈县"},{"id":3703,"name":"定安县"},{"id":3704,"name":"屯昌县"},{"id":3705,"name":"昌江县"},{"id":3706,"name":"白沙县"},{"id":3707,"name":"琼中县"},{"id":3708,"name":"陵水县"},{"id":3709,"name":"保亭县"},{"id":3710,"name":"乐东县"},{"id":3711,"name":"三沙市"},{"id":2121,"name":"海口市"},{"id":3115,"name":"琼海市"},{"id":3137,"name":"万宁市"},{"id":3173,"name":"东方市"},{"id":3034,"name":"儋州市"}],"24":[{"id":2144,"name":"贵阳市"},{"id":2150,"name":"六盘水市"},{"id":2155,"name":"遵义市"},{"id":2169,"name":"铜仁市"},{"id":2180,"name":"毕节市"},{"id":2189,"name":"安顺市"},{"id":2196,"name":"黔西南州"},{"id":2205,"name":"黔东南州"},{"id":2222,"name":"黔南州"}],"25":[{"id":4108,"name":"迪庆州"},{"id":2235,"name":"昆明市"},{"id":2247,"name":"曲靖市"},{"id":2258,"name":"玉溪市"},{"id":2270,"name":"昭通市"},{"id":2281,"name":"普洱市"},{"id":2291,"name":"临沧市"},{"id":2298,"name":"保山市"},{"id":2304,"name":"丽江市"},{"id":2309,"name":"文山州"},{"id":2318,"name":"红河州"},{"id":2332,"name":"西双版纳州"},{"id":2336,"name":"楚雄州"},{"id":2347,"name":"大理州"},{"id":2360,"name":"德宏州"},{"id":2366,"name":"怒江州"}],"26":[{"id":3970,"name":"阿里地区"},{"id":3971,"name":"林芝地区"},{"id":2951,"name":"拉萨市"},{"id":3107,"name":"那曲地区"},{"id":3129,"name":"山南地区"},{"id":3138,"name":"昌都地区"},{"id":3144,"name":"日喀则地区"}],"27":[{"id":2428,"name":"延安市"},{"id":2442,"name":"汉中市"},{"id":2454,"name":"榆林市"},{"id":2468,"name":"商洛市"},{"id":2476,"name":"安康市"},{"id":2376,"name":"西安市"},{"id":2386,"name":"铜川市"},{"id":2390,"name":"宝鸡市"},{"id":2402,"name":"咸阳市"},{"id":2416,"name":"渭南市"}],"28":[{"id":2525,"name":"庆阳市"},{"id":2534,"name":"陇南市"},{"id":2544,"name":"武威市"},{"id":2549,"name":"张掖市"},{"id":2556,"name":"酒泉市"},{"id":2564,"name":"甘南州"},{"id":2573,"name":"临夏州"},{"id":3080,"name":"定西市"},{"id":2487,"name":"兰州市"},{"id":2492,"name":"金昌市"},{"id":2495,"name":"白银市"},{"id":2501,"name":"天水市"},{"id":2509,"name":"嘉峪关市"},{"id":2518,"name":"平凉市"}],"29":[{"id":2580,"name":"西宁市"},{"id":2585,"name":"海东地区"},{"id":2592,"name":"海北州"},{"id":2597,"name":"黄南州"},{"id":2603,"name":"海南州"},{"id":2605,"name":"果洛州"},{"id":2612,"name":"玉树州"},{"id":2620,"name":"海西州"}],"30":[{"id":2628,"name":"银川市"},{"id":2632,"name":"石嘴山市"},{"id":2637,"name":"吴忠市"},{"id":2644,"name":"固原市"},{"id":3071,"name":"中卫市"}],"31":[{"id":4110,"name":"五家渠市"},{"id":4163,"name":"博尔塔拉蒙古自治州阿拉山口口岸"},{"id":15945,"name":"阿拉尔市"},{"id":15946,"name":"图木舒克市"},{"id":2652,"name":"乌鲁木齐市"},{"id":2654,"name":"克拉玛依市"},{"id":2656,"name":"石河子市"},{"id":2658,"name":"吐鲁番地区"},{"id":2662,"name":"哈密地区"},{"id":2666,"name":"和田地区"},{"id":2675,"name":"阿克苏地区"},{"id":2686,"name":"喀什地区"},{"id":2699,"name":"克孜勒苏州"},{"id":2704,"name":"巴音郭楞州"},{"id":2714,"name":"昌吉州"},{"id":2723,"name":"博尔塔拉州"},{"id":2727,"name":"伊犁州"},{"id":2736,"name":"塔城地区"},{"id":2744,"name":"阿勒泰地区"}],"32":[{"id":2768,"name":"台湾市"}],"42":[{"id":2754,"name":"香港特别行政区"}],"43":[{"id":2770,"name":"澳门市"}],"84":[{"id":1310,"name":"钓鱼岛"}]};
var cName = "ipLocation";
var currentLocation = "北京";
var stockServiceDomain = "http://st.3.cn";
try{if(location.href.indexOf("localtest=true")>0)stockServiceDomain = "http://webstock.jd.com";}catch(e){}
//cookie operate
function getCookie(name) {var arr = document.cookie.match(new RegExp("(^| )" + name + "=([^;]*)(;|$)"));if (arr != null) return unescape(arr[2]);return null;}
function setNewCookie(name,value,expires,path,domain,secure){if(!path){path="/"}if(!domain){domain="jd.com"}if(!secure){secure=false}var today=new Date();today.setTime(today.getTime());if(expires){expires=expires*1000*60*60*24}var expires_date=new Date(today.getTime()+(expires));document.cookie=name+'='+escape(value)+((expires)?';expires='+expires_date.toGMTString():'')+((path)?';path='+path:'')+((domain)?';domain='+domain:'')+((secure)?';secure':'')};function deleteCookie(name,path,domain){if(getCookie(name))document.cookie=name+'='+((path)?';path='+path:'')+((domain)?';domain='+domain:'')+';expires=Thu, 01-Jan-1970 00:00:01 GMT'};

$.pbuyurl="";
$.haveShow=0;$._ptload=false;$._ptloadcon="";$.easybuy_button=$("#choose-btn-easybuy");$.divide_button=$("#choose-btn-divide");$.notice_button=$("#choose-btn-notice");$.append_button=$("#choose-btn-append .btn-append");
$.getShopUrl=function(r){if(r.url)return r.url;return "http://mall.jd.com/index-"+r.id+".html";};
var openCheck = pageConfig.product.cat[2]==798||pageConfig.product.cat[2]==878||pageConfig.product.cat[2]==880;
$.getDeliver = function(p){
	var r=p.D;
	if(pageConfig.product.skuid<1000000000){
		$("#summary-service").html("").show();
		if (p.PopType==999){
			$("<div class='dt'>服\u3000\u3000务：</div><div class='dd'>由厂家提供和配送。</div>").appendTo("#summary-service");
		}else{
			var upenCheckStr = "";
			if (p.code==1&&openCheck){
				upenCheckStr = "，支持货到付款、开箱验机";
			}
			$("<div class='dt'>服\u3000\u3000务：</div><div class='dd'>由 京东商城 发货并提供售后服务"+upenCheckStr+"。</div>").appendTo("#summary-service");
		}
	}
	if (pageConfig.product.skuid>1000000000){	
		if (pageConfig.product.isChangeSku||($.haveShow==0&&!currentVenderInfoJson)){
			$.haveShow=1;
			$.getJSONP(stockServiceDomain+"/gvi.html?callback=showVenderServiceInfo&type=popdeliver&skuid="+pageConfig.product.skuid);
		}
		else{
			showVenderServiceInfo(currentVenderInfoJson);
		}
	}
};
function getDeliveCash(r){
	if(r){
		if(r.dtype == 0&&new Number(r.dcash)>0){
			$("#store-prompt span").html("，运费："+r.dcash);
		}
		else if(r.dtype == 1&&new Number(r.dcash)>0&&new Number(r.ordermin)>0){
			$("#store-prompt span").html("，店铺单笔订单不满"+r.ordermin+"，收运费："+r.dcash);
		}
	}
}
function showVenderServiceInfo(r){		
	if (r){
		if(!r.deliver)r.deliver=r.vender;
		currentVenderInfoJson = r;
		var unshowtypes = "0,1,2,4,5";
		if (unshowtypes.indexOf(r.type) != -1){
				if($("#summary-service").length==0){$("<li id='summary-service'></li>").insertAfter("#summary-stock");}
				$("#summary-service").html("");
				var key=r.id+"_"+r.type;
				var dfinfo=(r.vid.length!=7&&r.df&&r.df!="null")?("从 "+r.df+" "):"负责";
				if(r.type==0){
					$.getJSONP("http://rms.shop.jd.com/json/pop/dcash.action?venderID="+r.vid+"&areaID="+currentAreaInfo.currentProvinceId+"&callback=getDeliveCash");
					$("<div class='dt'>服\u3000\u3000务：</div><div class='dd'>由<a href='"+$.getShopUrl(r)+"' target='_blank' clstag='shangpin|keycount|product|bbtn' class='hl_red'>"+r.vender+"</a>"+dfinfo+"发货"
					+"，并提供售后服务。</div>").appendTo("#summary-service");
				}
				else if(r.type==1){
					$("<div class='dt'>服\u3000\u3000务：</div><div class='dd'>由 京东商城 发货并提供售后服务。</div>").appendTo("#summary-service");
				}
				else if(r.type==2){
					$("<div class='dt'>服\u3000\u3000务：</div><div class='dd'>由<a href='"+$.getShopUrl(r)+"' target='_blank' clstag='shangpin|keycount|product|bbtn' class='hl_red'>"+r.vender+"</a>"+dfinfo+"发货，京东商城提供售后服务。</div>").appendTo("#summary-service");
				}
				else if(r.type==5){
					$("<div class='dt'>服\u3000\u3000务：</div><div class='dd'>由<a href='"+$.getShopUrl(r)+"' target='_blank' clstag='shangpin|keycount|product|bbtn' class='hl_red'>"+r.vender+"</a>"+dfinfo+"发货，并提供售后服务。</div>").appendTo("#summary-service");
				}
				if(pageConfig.product.yfinfo&&pageConfig.product.yfinfo.service){
					$("<div class='dt'>\u3000\u3000</div><div class='dd'>"+pageConfig.product.yfinfo.service+"</div>").appendTo("#summary-service");
				}
				if(r.type!=4){
					$("#summary-service").show();
					if($("#product-intro .itemover-title button").length==0&&$("#product-intro .itemover-title h3").length>0)$("<button type='button' clstag='shangpin|keycount|product|bbtn'>进入卖家店铺</button>").appendTo("#product-intro .itemover-title h3");
					$("#product-intro .itemover-title button").unbind("click").click(function(){window.location=$.getShopUrl(r);});
				}
		}
	}
}
var areaSurportDelive = true;
function getStockDescWords(state,isPurchase,skuid,skukey,arrivalDate,isNotice,ext,provinceId,rn){
	if (state == -1){
		areaSurportDelive = false;
        pageConfig.product.havestock = false;
		return "<strong>该地区暂不支持配送</strong>";
	}
	var text = "";
	var yfInfo = "";
	areaSurportDelive = true;
	if (skuid<1000000000&&(provinceId==26||provinceId==31)&&(state!=0&&state!=34)&&ext&&ext.indexOf("PianYuanYunFei")>-1)
		yfInfo = "，<span title='钻石级别以上用户不用付运费' style='cursor:pointer'>单件运费：￥10.00</span>";
	if (state == 33){
        pageConfig.product.havestock = true;
			
		if (rn&&rn>0){
			text = "<strong>有货</strong>，仅剩"+rn+"件<span></span>";	
		}
		else{
			text = "<strong>有货</strong><span>，下单后立即发货</span>";		
		}
	}
	else if (state == 34 || state == 0){
        pageConfig.product.havestock = false;
		text = "<strong>无货</strong>，此商品暂时售完"+(isNotice?"，<a href='#none' id='notify-stock' target='_blank'>到货通知</a>":"");
		if (skuid&&skuid.length == 8 && !isPurchase){
			text = "<strong>无货</strong>，此商品不再销售，欢迎选购其它商品";
		}
	}
	else if (state == 39 || state == 40){
        pageConfig.product.havestock = true;
		text = "<strong>有货</strong>，下单后2-6天发货<span></span>";
	}
	else if (state == 36){
        pageConfig.product.havestock = true;
		text = "<strong>预订</strong>，"+(arrivalDate?"预计"+arrivalDate+"日后有货，现在可下单":"商品到货后发货，现在可下单")+"<span></span>";
	}
	text += yfInfo;
	return text;
}
//NO Stock
var reCookieName = "reWidsSORec";
function reClick2(type2, pwid, sku, num) {
	var reWidsClubCookies = eval('(' + getCookie(reCookieName) + ')');
	if (reWidsClubCookies == null || reWidsClubCookies == '') reWidsClubCookies = new Object();
	if (reWidsClubCookies[type2] == null) reWidsClubCookies[type2] = '';
	var pos = reWidsClubCookies[type2].indexOf(sku);
	if (pos < 0) reWidsClubCookies[type2] = reWidsClubCookies[type2] + "," + sku;
	if(!!JSON&&JSON.stringify)setNewCookie(reCookieName, JSON.stringify(reWidsClubCookies), 2, "/", locPageHost, false);
	sku = sku.split("#");
	if (window.log){log(3, type2, sku[0]);log('RC', 'CK', type2, pwid, sku[0], num);}
}
//Notify
function getBuyUrl(skuId){
	var count = $("#buy-num").val();
	if(!count)count=1;
	if(eleSkuIdKey) return "http://gate.jd.com/InitCart.aspx?pid="+skuId+"&pcount="+count+"&ptype=1";
	if($.pbuyurl)return $.pbuyurl;
	if($.append_button.attr("href")!="#none")return $.append_button.attr("href");
	if (pageConfig.product.cat[2] == 4833) return "http://chongzhi.jd.com/order/order_place.action?skuId=" + skuId + "";
	if (pageConfig.product.cat[2] == 4835 || pageConfig.product.cat[2] == 4836) return "http://card.jd.com/order/order_place.action?skuId=" + skuId + "";
	return "http://gate.jd.com/InitCart.aspx?pid="+skuId+"&pcount="+count+"&ptype=1";
}

function chooseType() {
	var shoppingselect = $('#choose-type .item'),
		amount = $('#choose-amount'),
		buyLink = $('#choose-btn-append .btn-append'),
		selectItem = $('#choose-type .selected').eq(0);
	
	if ( !selectItem.attr('data') ) {
		return false;
	}
		
	if ( shoppingselect.length > 0 ) {
		amount.hide();
	}

	shoppingselect.bind('click', function (i) {

		if ( $('#choose-btn-append').hasClass('disabled') ) {
			return false;
		}

		var data = $(this).attr('data').split('|'),
			link = buyLink.attr( 'href' );


		var newlink = data[1].replace(/wid=\d{6,}/, 'wid=' + pageConfig.product.skuid );		

		shoppingselect.removeClass('selected');

		$(this).addClass('selected');
		$('#choose .result').html(data[0]);

		amount.addClass(data[2]);
		buyLink.attr('href', newlink);

	});

	if ( selectItem.length > 0 ) {
		var data = selectItem.attr('data').split('|'),
			newlink = data[1].replace(/wid=\d{6,}/, 'wid=' + pageConfig.product.skuid );
		buyLink.attr('href', newlink);
	}
	if ( shoppingselect.length == 1 && selectItem.length < 1 ) {
		shoppingselect.addClass('selected');
		buyLink.attr( 'href', shoppingselect.attr('data').split('|')[1].replace(/wid=\d{6,}/, 'wid=' + pageConfig.product.skuid ) );
	}
}
function SetNotifyByNoneStock(stockstatus) {
	if (stockstatus!=34&&stockstatus!=0&&warestatus==1){
		if(pageConfig&&pageConfig.product)pageConfig.product.isStock=true;
		$("#choose-btn-append").removeClass("disabled");
		if($("#choose-btn-subsidy .btn-subsidies").length>0)$("#choose-btn-append").addClass("choose-btn-append-lite");
		$("#product-intro").attr("class","");
		$('#out-of-stock,#noitem-related-list').remove();
		if($("#choose-noresult").length>0){$("#choose-noresult").remove();}
		$.easybuy_button.show();
		$.divide_button.show();
		if(pageConfig.product.skuid<1000000000){$.notice_button.hide()}
		if($.append_button.length>0){
			if( $('#choose-type .item').length>0){		
				chooseType();
				$.append_button.attr("onclick","").attr("title","").unbind("click").click(function() {  mark(pageConfig.product.skuid, 2) }); //购物车	
			}
			else{
				$.append_button.attr("href",getBuyUrl(pageConfig.product.skuid)).attr("onclick","").attr("title","").unbind("click").click(function() { /*BuyUrl(pageConfig.product.skuid);*/ mark(pageConfig.product.skuid, 2) }); //购物车
			}
		}
		if($(".nav-minicart-btn").length>0)$(".nav-minicart-btn").show(); //mini购物车
		$("#choose-btn-subsidy").show();
		if(window.noItemOver)noItemOver.init();
		return;
	}
	if(pageConfig&&pageConfig.product)pageConfig.product.isStock=false;
	$("#choose-btn-append").addClass("disabled").removeClass('choose-btn-append-lite');
	$("#product-intro").attr("class","product-intro-noitem");
	if($("#choose-noresult").length==0&&areaSurportDelive){$("<li id='choose-noresult'><div class='dd'><strong>所选地区该商品暂时无货，非常抱歉！</strong></div></li>").insertAfter("#choose-result");}
	else if(!areaSurportDelive){$("#choose-noresult").remove();}
	$.easybuy_button.hide();
	$.divide_button.hide();
	if(pageConfig.product.skuid<1000000000){$.notice_button.show()}else{$.notice_button.hide()}
	if($.append_button.length>0){if($.append_button.attr("href")!="#none"){$.pbuyurl=$.append_button.attr("href")}$.append_button.attr("href","#none").attr("onclick","").attr("title","商品已无货").unbind("click"); }//购物车
	if($(".nav-minicart-btn").length>0)$(".nav-minicart-btn").hide(); //mini购物车
	$("#choose-btn-subsidy").hide();
	if($.notice_button.length==0&&pageConfig.product.skuid<1000000000&&areaSurportDelive){
		$("<div id='choose-btn-notice' class='btn'><a id='notify-btn' class='btn-notice' href='http://notify.home.jd.com/email.action?type=2&id=" + pageConfig.product.skuid + "&key=" + pageConfig.product.skuidkey + "' target='_blank'>到货通知<b></b></a></div>").insertAfter("#choose-btn-append");
		$.notice_button=$("#choose-btn-notice");
	}
	if(window.noItemOver)noItemOver.init(pageConfig.product.type);
};
//stock callback
var currentVenderInfoJson = null;
function cleanKuohao(str){
	if(str&&str.indexOf("(")>0){
		str = str.substring(0,str.indexOf("("));
	}
	if(str&&str.indexOf("（")>0){
		str = str.substring(0,str.indexOf("（"));
	}
	return str;
}
function getProvinceStockCallback(result) {
	var setSer = false;
	if (currentPageLoad.notSet&&currentPageLoad.isLoad){
		setSer = true;
	}
	else if (!currentPageLoad.isLoad){
		setSer = true;
	}
	setCommonCookies(currentAreaInfo.currentProvinceId,currentLocation,currentAreaInfo.currentCityId,currentAreaInfo.currentAreaId,currentAreaInfo.currentTownId,setSer);
	if (currentPageLoad.isLoad)currentPageLoad.isLoad=false;
    pageConfig.product.havestock = true;
	var stockdesc="<strong>现货</strong>";
	if (result.stock) {		
		if(result.stock.D&&result.stock.D.id){
			pageConfig.product.popInfo = result;
		}
		stockdesc = (result.stock.StockStateName=="统计中"|| result.stock.StockStateName=="无货")?"<strong class='store-over'>无货</strong>":("<strong>"+result.stock.StockStateName+"</strong>");
		var address = currentAreaInfo.currentProvinceName+currentAreaInfo.currentCityName+currentAreaInfo.currentAreaName+currentAreaInfo.currentTownName;
		$("#store-selector .text div").html(currentAreaInfo.currentProvinceName+cleanKuohao(currentAreaInfo.currentCityName)+cleanKuohao(currentAreaInfo.currentAreaName)+cleanKuohao(currentAreaInfo.currentTownName)).attr("title",address);
		pageConfig.product.yfinfo={};
		if(result.stock.D&&result.stock.D.prompt){
			var proarray=result.stock.D.prompt.split("|");
			if (proarray[0]&&new Number(proarray[0])>0){
				pageConfig.product.yfinfo={nofree:true,cash:proarray[0]};
			}
			if(proarray[1]){
				pageConfig.product.yfinfo.service=proarray[1];
			}
		}
		$("#store-prompt").html(getStockDescWords(result.stock.code==2?-1:result.stock.StockState,true,pageConfig.product.skuid,pageConfig.product.skuidkey,result.stock.ArrivalDate,true,result.stock.Ext,currentAreaInfo.currentProvinceId,result.stock.rn)
			+(pageConfig.product.yfinfo.nofree?"，<span style='cursor:pointer' title='一个店铺购买多件商品，只收取一次运费'>运费：<span style='color:#f00;'>￥"+pageConfig.product.yfinfo.cash+"</span><span>":""));
		$.getDeliver(result.stock);
		if ( typeof pageConfig.product.onAreaChange === 'function' ) {
			pageConfig.product.onAreaChange(currentAreaInfo.currentProvinceId);
		}
		SetNotifyByNoneStock(result.stock.StockState);
	}
	if (pageConfig.product.skuid>1000000000){
			if(!$._ptload){
				$._ptload=true;
				window._showPopTemplete=function(r){
					if(result.stock.StockState==36){
						if(r&&r.reserveDeliveryDay){
							$._ptloadcon=r.reserveDeliveryDay;
							$("#store-prompt").html(stockdesc+"，"+"此商品为预订商品，下单后在"+$._ptloadcon);
						}
					}
					if(r&&r.wareTemplateContent)$("<div>"+r.wareTemplateContent+"</div>").insertBefore("#product-detail-1 .detail-content:first");
					if(r&&r.wareTemplateBottomContent)$("<div>"+r.wareTemplateBottomContent+"</div>").insertAfter("#product-detail-1 .detail-content:last");
				};
				$.getJSONP("http://rms.shop.jd.com/json/wareTemplate/queryWareTemplateContent.action?skuId="+pageConfig.product.skuid+"&jsoncallback=_showPopTemplete",_showPopTemplete);
			}else{
				if($._ptloadcon)$("#store-prompt").html(stockdesc+"，"+"此商品为预订商品，下单后在"+$._ptloadcon);
			}
	}
}
/**
新地址列表数据及时间绑定
**/
function getAreaList(result,idName,level){
	if (idName && level){
		$("#"+idName).html("");
		var html = "<ul class='area-list'>";
		var longhtml = "";
		var longerhtml = "";
		if (result&&result.length > 0){
			for (var i=0,j=result.length;i<j ;i++ ){
				result[i].name = result[i].name.replace(" ","");
				if(result[i].name.length > 12){
					longerhtml += "<li class='longer-area'><a href='#none' data-value='"+result[i].id+"'>"+result[i].name+"</a></li>";
				}
				else if(result[i].name.length > 5){
					longhtml += "<li class='long-area'><a href='#none' data-value='"+result[i].id+"'>"+result[i].name+"</a></li>";
				}
				else{
					html += "<li><a href='#none' data-value='"+result[i].id+"'>"+result[i].name+"</a></li>";
				}
			}
		}
		else{
			html += "<li><a href='#none' data-value='"+currentAreaInfo.currentFid+"'> </a></li>";
		}
		html +=longhtml+longerhtml+"</ul>";
		$("#"+idName).html(html);
		$("#"+idName).find("a").click(function(){
			resetBindMouseEvent();
			var areaId = $(this).attr("data-value");
			var areaName = $(this).html();
			var level = $(this).parent().parent().parent().attr("data-area");
			JdStockTabs.eq(level).find("a").attr("title",areaName).find("em").html(areaName.length>6?areaName.substring(0,6):areaName);
			level = new Number(level)+1;
			if (level=="2"){
				currentAreaInfo.currentCityId = areaId;
				currentAreaInfo.currentCityName = areaName;
				currentAreaInfo.currentAreaId = 0;
				currentAreaInfo.currentAreaName = "";
				currentAreaInfo.currentTownId = 0;
				currentAreaInfo.currentTownName = "";
			}
			else if (level=="3"){
				if (requestLevel == 4 && currentAreaInfo.currentAreaId != areaId){
					requestLevel = 3;
				}
				currentAreaInfo.currentAreaId = areaId;
				currentAreaInfo.currentAreaName = areaName;
				currentAreaInfo.currentTownId = 0;
				currentAreaInfo.currentTownName = "";
			}
			else if (level=="4"){
				currentAreaInfo.currentTownId = areaId;
				currentAreaInfo.currentTownName = areaName;
			}
			currentLocation = currentAreaInfo.currentProvinceName;
			GetStockInfoOrNextAreas(pageConfig.product.skuidkey,currentAreaInfo.currentProvinceId,currentAreaInfo.currentCityId,currentAreaInfo.currentAreaId,currentAreaInfo.currentTownId,pageConfig .product.cat[2],level);
		});
		//页面初次加载
		if (currentPageLoad.isLoad){
			var tempDom = $("#"+idName+" a[data-value='"+currentPageLoad.areaCookie[level-1]+"']");
			if(currentPageLoad.areaCookie&&currentPageLoad.areaCookie[level-1]&&currentPageLoad.areaCookie[level-1]>0&&tempDom.length>0){
				//本地cookie有该级地区ID
				tempDom.click();
			}
			else{
				$("#"+idName+" a:first").click();
			}
		}
	}
}
/**
下级地址回调方法
**/
function getAreaList_callback(result){
	var level = currentAreaInfo.currentLevel;
	getAreaList(result,getIdNameByLevel(level),level);
}
/**
根据父地址及地址等级获取下级地址列表
**/
function getChildAreaHtml(fid,level){
	var idName = getIdNameByLevel(level);
	if (idName){
		$("#stock_province_item,#stock_city_item,#stock_area_item,#stock_town_item").hide();
		$("#"+idName).show().html("<div class='iloading'>正在加载中，请稍候...</div>");
		JdStockTabs.show().removeClass("curr").eq(level-1).addClass("curr").find("em").html("请选择");
		for (var i=level,j=JdStockTabs.length;i<j ;i++ ){
			JdStockTabs.eq(i).hide();
		}
		currentAreaInfo.currentLevel = level;
		if(level == 2 && provinceCityJson[fid+""]){
			getAreaList_callback(provinceCityJson[fid+""]);
		}
		else{
			currentAreaInfo.currentFid = fid;
			$.getJSONP("http://d.360buy.com/area/get?fid="+fid+"&callback=getAreaList_callback");
		}
	}
}
function getIdNameByLevel(level){
	var idName = "";
	if (level == 1){
		idName = "stock_province_item";
	}
	else if (level == 2){
		idName = "stock_city_item";
	}
	else if (level == 3){
		idName = "stock_area_item";
	}
	else if (level == 4){
		idName = "stock_town_item";
	}
	return idName;
}
//需要的地址层级
var requestLevel = 1;
//是否分区商品
var isAreaProduct = false;
if(!eleRegion) var eleRegion=null;
if(!eleSkuIdKey) var eleSkuIdKey=null;
function initrequestLevel(){
	requestLevel = 3;
	isAreaProduct = false;
	if(eleSkuIdKey){
		requestLevel = 3;
		isAreaProduct = true;
	}
}
//当前地域信息
var currentAreaInfo;
//初始化当前地域信息
function CurrentAreaInfoInit(){
	currentAreaInfo =  {"currentLevel": 1,"currentProvinceId": 1,"currentProvinceName":"北京","currentCityId": 0,"currentCityName":"","currentAreaId": 0,"currentAreaName":"","currentTownId":0,"currentTownName":""};
}
//回调方法
function getStockCallback(result){
	if (result.stock&&(result.stock.code==3||result.stock.code==4)&&result.stock.level>1){
		//需要进一步计算，且需要地区层级大于1
		requestLevel = result.stock.level;
		if (currentAreaInfo.currentRequestLevel<result.stock.level){
			GetStockInfoOrNextAreas(pageConfig.product.skuidkey,currentAreaInfo.currentProvinceId,currentAreaInfo.currentCityId,currentAreaInfo.currentAreaId,currentAreaInfo.currentTownId,pageConfig .product.cat[2],currentAreaInfo.currentRequestLevel);
		}
	}
	else{
		reBindStockEvent();
		for (var i=currentAreaInfo.currentRequestLevel,j=JdStockTabs.length;i<j;i++){
			JdStockTabs.eq(i).hide();
			JdStockContents.eq(i).hide();
		}
		getProvinceStockCallback(result);
	}
}
//设置sku价格
function cnp(r){
	var price = "";
	if (r&&r.length>0){
		if (new Number(r[0].p)>0){	
			price = "￥"+r[0].p;
		}
	}
	if (!price){
		price = "暂无报价";
	}
	$("#summary-price .p-price").html(price);
}
function setPriceData(skuid) {
	$.getJSONP("http://p.3.cn/prices/get?skuid=J_"+skuid+"&type=1&callback=cnp");
}
function getAreaSkuState(skuid){
	if(!eleSkuIdKey) return warestatus;
	for (var i=0,j=eleSkuIdKey.length;i<j;i++){
		if (eleSkuIdKey[i].SkuId == skuid && eleSkuIdKey[i].state != undefined){
			return eleSkuIdKey[i].state;
		}
	}
	return 1;
}
//根据地区变换sku及相应信息
function getSkuId_new(cid,aid){
	if(eleSkuIdKey&&eleSkuIdKey.length>0){
		var areas = null;
		for (var i=0,j=eleSkuIdKey.length;i<j ;i++ ){
			if(eleSkuIdKey[i].area&&eleSkuIdKey[i].area[cid+""]){
				areas = eleSkuIdKey[i].area[cid+""];
				if (areas.length==0||areas[0]+""=="0"){
					return eleSkuIdKey[i].SkuId;
				}
				else if (areas.length>0){
					for(var a=0,b=areas.length;a<b;a++){
						if(areas[a]+""==aid+""){
							return eleSkuIdKey[i].SkuId;
						}
					}
				}
			}
		}
	}
	return 0;
}
function chooseSkuToArea(provinceId,cityId,areaId){
	var currentSkuId = pageConfig.product.skuid;
	var currentSkuKey = pageConfig.product.skuidkey;
	if (isAreaProduct && provinceId > 0 && cityId > 0 && areaId > 0){
		currentSkuId = 0;
		currentSkuKey = "";
		if(eleRegion){
			var provinceCitys = eleRegion[provinceId+""];
			if (provinceCitys && provinceCitys.citys && provinceCitys.citys.length>0){
				for (var i=0,j=provinceCitys.citys.length; i<j; i++){
					if (provinceCitys.citys[i].IdCity == cityId){
						currentSkuId = provinceCitys.citys[i].SkuId;
						break;
					}
				}
			}
		}
		else{
			currentSkuId = getSkuId_new(cityId,areaId);
		}
		if (eleSkuIdKey&&eleSkuIdKey.length>0){
			for (var i=0,j=eleSkuIdKey.length;i<j;i++){
				if (eleSkuIdKey[i].SkuId == currentSkuId){
					currentSkuKey = eleSkuIdKey[i].Key;
					break;
				}
			}
		}
	}
	if (currentSkuId && currentSkuKey){
		if (currentSkuId == pageConfig.product.skuid){
			pageConfig.product.isChangeSku = false;
		}
		else{
			//变换地区后sku不同
			pageConfig.product.isChangeSku = true;
		}
	}
	//设定该商品上下柜状态
	warestatus = getAreaSkuState(currentSkuId);
	//上一次选择的sku
	pageConfig.product.prevSku = pageConfig.product.skuid;
	//变换到对应分区的sku
	pageConfig.product.skuid = currentSkuId;
	pageConfig.product.skuidkey = currentSkuKey;
	//变换sku需要变化广告词及相关信息
	if (pageConfig.product.isChangeSku){
		setPriceData(pageConfig.product.skuid); //改变价格
		setCXAdvertisement(pageConfig.product.skuid,pageConfig.product.skuidkey);//广告词
		initEasyBuy(); //轻松购
		try {
			if(window.Promotions){$("#choose-btn-subsidy").remove();Promotions.init(pageConfig.product.skuid);} //促销信息
			if(window.fq_init)fq_init();
			if($("#Tip_apply").length>0&&fq_serverSite)$("#Tip_apply").attr("href",fq_serverSite + "ShoppingCart_fqInit.aspx?skuId=" + pageConfig.product.skuid + "&skuCount=1");//分期	
			$("#choose-btn-divide").html("");
			if(window.setIM)setIM();
		} catch (e) {
		}
	}	
	return currentSkuKey;
}
//获取配送库存信息或下一级地址
function GetStockInfoOrNextAreas(skuKey,provinceId,cityId,areaId,townId,sortId,curLevel){
		try{
			pageConfig.product.currentProvinceId = provinceId;
			currentAreaInfo.currentProvinceId = provinceId;
			currentAreaInfo.currentCityId = cityId;
			currentAreaInfo.currentAreaId = areaId;
			currentAreaInfo.currentTownId = townId;
			curLevel = new Number(curLevel);
			if (curLevel == requestLevel){
				currentAreaInfo.currentLevel = curLevel; //
				currentAreaInfo.currentRequestLevel = curLevel;  //	
				//分区商品需要找到分区对应的sku
				if (areaId > 0&&townId<=0){
					skuKey = chooseSkuToArea(provinceId,cityId,areaId);
				}
				pageConfig.product.skuidkey = skuKey;
				JdStockTabs.removeClass("curr").eq(curLevel-1).addClass("curr");
				JdStockTabs.find("a").removeClass("hover").eq(curLevel-1).addClass("hover");
				if (skuKey&&provinceId!=84&&warestatus==1){			
					$.getJSONP(stockServiceDomain+"/gds.html?callback=getStockCallback&skuid="+skuKey+"&provinceid="+provinceId+"&cityid="+cityId+"&areaid="+areaId+"&townid="
						+townId+"&sortid1="+pageConfig .product.cat[0]+"&sortid2="+pageConfig .product.cat[1]+"&sortid3="+pageConfig .product.cat[2]+"&cd=1_1_1");			
				}
				else{
					getStockCallback({"stock":{"IsPurchase":false,"ArrivalDate":null,"Ext":"","PopType":0,"StockStateName":"无货","code":1,"StockState":0}});
				}
			}
			else if (curLevel < requestLevel){ //还需要获取下级地址
				currentAreaInfo.currentLevel = curLevel +1;
				JdStockTabs.removeClass("curr").eq(curLevel).addClass("curr");
				JdStockTabs.find("a").removeClass("hover").eq(curLevel).addClass("hover");
				getChildAreaHtml(arguments[curLevel],curLevel +1);
			}
		}catch(err){
		}
}
function setCommonCookies(provinceId,provinceName,cityId,areaId,townId,isWriteAdds){
	setNewCookie("ipLocation", provinceName, 30, "/", locPageHost, false);
	var adds = provinceId+"-"+cityId+"-"+areaId+"-"+townId;
	setNewCookie("ipLoc-djd", adds, 30, "/", locPageHost, false);
	if (!isUseServiceLoc||!isWriteAdds){
	}
	else{
		$.ajax({url:"http://uprofile.jd.com/u/setadds",type:"get",dataType:"jsonp",data:{adds:adds}});
	}
}
//根据省份ID获取名称
function getNameById(provinceId){
	for(var o in iplocation){
		if (iplocation[o]&&iplocation[o].id==provinceId){
			return o;
		}
	}
	return "北京";
}
//初始化
var currentPageLoad = {"isLoad":true,"areaCookie":[1,72,0,0]};
//切换标签控件
var JdStockTabs = null;
var JdStockContents = null;
var provinceHtml = '<div data-widget="tabs" class="m JD-stock" id="JD-stock">'
								+'<div class="mt">'
								+'    <ul class="tab">'
								+'        <li data-index="0" data-widget="tab-item" class="curr"><a href="#none" class="hover"><em>请选择</em><i></i></a></li>'
								+'        <li data-index="1" data-widget="tab-item" style="display:none;"><a href="#none" class=""><em>请选择</em><i></i></a></li>'
								+'        <li data-index="2" data-widget="tab-item" style="display:none;"><a href="#none" class=""><em>请选择</em><i></i></a></li>'
								+'        <li data-index="3" data-widget="tab-item" style="display:none;"><a href="#none" class=""><em>请选择</em><i></i></a></li>'
								+'    </ul>'
								+'    <div class="stock-line"></div>'
								+'</div>'
								+'<div class="mc" data-area="0" data-widget="tab-content" id="stock_province_item">'
								+'    <ul class="area-list">'
								+'       <li><a href="#none" data-value="1">北京</a></li><li><a href="#none" data-value="2">上海</a></li><li><a href="#none" data-value="3">天津</a></li><li><a href="#none" data-value="4">重庆</a></li><li><a href="#none" data-value="5">河北</a></li><li><a href="#none" data-value="6">山西</a></li><li><a href="#none" data-value="7">河南</a></li><li><a href="#none" data-value="8">辽宁</a></li><li><a href="#none" data-value="9">吉林</a></li><li><a href="#none" data-value="10">黑龙江</a></li><li><a href="#none" data-value="11">内蒙古</a></li><li><a href="#none" data-value="12">江苏</a></li><li><a href="#none" data-value="13">山东</a></li><li><a href="#none" data-value="14">安徽</a></li><li><a href="#none" data-value="15">浙江</a></li><li><a href="#none" data-value="16">福建</a></li><li><a href="#none" data-value="17">湖北</a></li><li><a href="#none" data-value="18">湖南</a></li><li><a href="#none" data-value="19">广东</a></li><li><a href="#none" data-value="20">广西</a></li><li><a href="#none" data-value="21">江西</a></li><li><a href="#none" data-value="22">四川</a></li><li><a href="#none" data-value="23">海南</a></li><li><a href="#none" data-value="24">贵州</a></li><li><a href="#none" data-value="25">云南</a></li><li><a href="#none" data-value="26">西藏</a></li><li><a href="#none" data-value="27">陕西</a></li><li><a href="#none" data-value="28">甘肃</a></li><li><a href="#none" data-value="29">青海</a></li><li><a href="#none" data-value="30">宁夏</a></li><li><a href="#none" data-value="31">新疆</a></li><li><a href="#none" data-value="32">台湾</a></li><li><a href="#none" data-value="42">香港</a></li><li><a href="#none" data-value="43">澳门</a></li><li><a href="#none" data-value="84">钓鱼岛</a></li>'
								+'    </ul>'
								+'</div>'
								+'<div class="mc" data-area="1" data-widget="tab-content" id="stock_city_item"></div>'
								+'<div class="mc" data-area="2" data-widget="tab-content" id="stock_area_item"></div>'
								+'<div class="mc" data-area="3" data-widget="tab-content" id="stock_town_item"></div>'
								+'</div>';
var mouseEventChange = false;
function resetBindMouseEvent(){
	if (!mouseEventChange&&!currentPageLoad.isLoad){
		mouseEventChange = true;
		$("#store-selector").unbind("mouseout");
		$("#store-selector").unbind("mouseover").bind("mouseover",function(){
			$("#store-selector").addClass("hover");
		});
	}
}
function reBindStockEvent(){
	$("#store-selector").removeClass("hover");
	//mouseEventChange = false;
	/*$("#store-selector").unbind("mouseout").bind("mouseout",function(){
		$("#store-selector").removeClass("hover");
	});*/
}
function getStockInfoByArea(ipLoc){//获取地区库存
	if(!ipLoc){
		ipLoc = getCookie("ipLoc-djd");
	}
	currentPageLoad.notSet = false;
	if (!ipLoc) {
		currentPageLoad.notSet = true;
	}
	ipLoc = ipLoc?ipLoc.split("-"):[1,72,0,0];
	currentPageLoad.areaCookie = ipLoc;
	currentAreaInfo.currentProvinceName = getNameById(ipLoc[0]);
	currentLocation = currentAreaInfo.currentProvinceName;
	var province = iplocation[currentLocation];
	province = province?province:{ id: "1", root: 0, djd: 1,c:72 };
	currentAreaInfo.currentProvinceId = province.id;
	JdStockTabs.eq(0).find("em").html(currentAreaInfo.currentProvinceName);
	GetStockInfoOrNextAreas(pageConfig.product.skuidkey,province.id,0,0,0,pageConfig .product.cat[2],1);
	//setCommonCookies(ipLoc[0],currentLocation,ipLoc[1],ipLoc[2],ipLoc[3],noSet);
}
var isUseServiceLoc = true; //是否默认使用服务端地址
(function(){
	CurrentAreaInfoInit();
	initrequestLevel();
	//if (pageConfig.product.cat[0]!=737&&pageConfig.product.cat[0]!=652&&pageConfig.product.cat[0]!=9987&&pageConfig.product.cat[0]!=670){
	//isUseServiceLoc = true;
	//}
	$(provinceHtml).insertBefore("#store-selector .content .clr");
	$("#store-selector").mouseover(function(){$(this).addClass("hover");}).mouseout(function(){$(this).removeClass("hover");}); 
	JdStockTabs = $("#JD-stock .tab li");
	JdStockContents = $("#JD-stock div[data-widget='tab-content']");
	JdStockTabs.bind('click',function(){
		var level = $(this).attr("data-index");
		level = new Number(level);
		JdStockTabs.removeClass("curr").eq(level).addClass("curr");
		JdStockTabs.find("a").removeClass("hover").eq(level).addClass("hover");
		JdStockContents.hide().eq(level).show();
	});
	if (isUseServiceLoc){
		try{
			$.ajax({
				url:"http://uprofile.jd.com/u/getadds",
				type:"get",
				dataType:"jsonp",
				timeout:500,
				success:function(r){
					getStockInfoByArea(r.adds&&r.adds!="null"?r.adds:null);
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
					getStockInfoByArea(null);
				}
			});
		}catch(e){getStockInfoByArea(null);}
	}
	else{
		getStockInfoByArea(null);
	}
	/*JdStockTabs.eq(0).find("em").html(currentAreaInfo.currentProvinceName);
	GetStockInfoOrNextAreas(pageConfig.product.skuidkey,province.id,0,0,0,pageConfig .product.cat[2],1);*/
	$("#stock_province_item a").unbind("click").click(function() {
		currentPageLoad.isLoad = false;
		resetBindMouseEvent();
		try{
			CurrentAreaInfoInit();
			currentAreaInfo.currentProvinceId = $(this).attr("data-value");
			currentAreaInfo.currentProvinceName = $(this).html();
			currentLocation = currentAreaInfo.currentProvinceName;
			JdStockTabs.eq(0).find("em").html(currentAreaInfo.currentProvinceName);
			initrequestLevel();
			GetStockInfoOrNextAreas(pageConfig.product.skuidkey,currentAreaInfo.currentProvinceId,0,0,0,pageConfig .product.cat[2],1);
		}
		catch (err){
		}
	}).end();
	$("#store-selector .close").unbind("click").bind("click",function(){
		reBindStockEvent();
	});
	//服务信息
})();
/*#$%#@!%*/
(function(iplocation){
	var serializeUrlCommon=function(url) {
		var sep = url.indexOf('?'),
			link = url.substr( 0, sep),
			params = url.substr( sep+1 ),
			paramArr = params.split('&'),
			len = paramArr.length,i,
			res = {},curr,key,val;

		for ( i=0; i<len; i++) {
			curr = paramArr[i].split('=');
			key = curr[0];
			val = curr[1];

			res[key] = val;
		}

		return {
			url: link,
			param: res
		}
	};
	if ( /storeAddressId/.test(location.href)) {
			// 拿url上storeAddressId的值，写入cookie
			var url=serializeUrlCommon(location.href);
			if (url.param['storeAddressId']){
				var pca=url.param['storeAddressId'].split('_');
				if(pca){
					var proname="";
					var area="";
					if(pca[0] && parseInt(pca[0]) == pca[0]) {
						for(var o in iplocation){
							if(iplocation[o].id==pca[0]){
								proname=o;
								area=pca[0];
								break;
							}
						}
					}
					if(pca[1] && parseInt(pca[1]) == pca[1] && parseInt(pca[1])>0) {
						area += "-"+pca[1];
					}
					else if(area){
						area += "-0";
					}
					if(pca[2] && parseInt(pca[2]) == pca[2] && parseInt(pca[2])>0) {
						area += "-"+pca[2];
					}
					else if(area){
						area += "-0";
					}
					if(proname){
						setNewCookie("ipLocation", proname, 30, "/", locPageHost, false);
					}
					if(area){
						setNewCookie("ipLoc-djd", area, 30, "/", locPageHost, false);
					}
				}
			}
	}
})(iplocation);
// 标题广告词
function setproductadwords(r){
	if (r&&r.AdWordList&&r.AdWordList.length>0&&r.AdWordList[0]){
		$("#name strong").html(r.AdWordList[0].waretitle?r.AdWordList[0].waretitle:"");
	}
}
function setCXAdvertisement(skuid, skuidkey) {	
	$("#name strong").html("");
	$.getJSONP("http://jprice.jd.com/adslogan/"+skuid+"-setproductadwords.ad");
}
setCXAdvertisement(pageConfig.product.skuid, pageConfig.product.skuidkey);
var DoOrder = function (pid) {

		$.login({
			modal: true,
			complete: function (result) {
				if (result != null && result.IsAuthenticated != null && result.IsAuthenticated) {
					var num = $.trim($("#buy-num").val());
					$.ajax({
						url: "http://buy.jd.com/purchase/flows/easybuy/FlowService.ashx",
						type: "get",
						data: {
							action: "SubmitOrderByDefaultTemplate",
							skuId: pid || pageConfig.product.skuid,
							num: $("#buy-num").val()
						},
						dataType: "jsonp",
						success: function (r) {
							if (r.Flag) {
								window.location = r.Obj;
							}
							else {
								$.easybuy_button.show();
								if (r.Message != null) {
									alert(r.Message);
								}
								else {
									alert("暂时无法提交,请您稍后重试!");
								}
							}
						}
					})
				}
				else {
					$.easybuy_button.show();
				}
			}
		})
	};
function initEasyBuy() {
	var productId = null;
	if ($.append_button.css("display") != "none") {
		productId = parseInt( pageConfig.product.skuid );
		var eb = readCookie("eb");
		if (eb == 1 || eb == null || eb == undefined) {
			$.ajax({
				url: "http://buy.jd.com/purchase/flows/easybuy/FlowService.ashx",
				type: "get",
				data: {
					action: "CanBuy",
					skuId: productId
				},
				dataType: "jsonp",
				success: function (r) {
					$.easybuy_button.html("");
					if (r.Flag) {
						$.easybuy_button.html("<a class='btn-easybuy' href='#'>轻松购<b></b></a>");
						$("#choose-btn-easybuy .btn-easybuy").click(function () {
							$.easybuy_button.hide();
							$.extend(jdModelCallCenter.settings, {
								clstag1: 0,
								clstag2: 0,
								id: productId,
								fn: function () {
									DoOrder(this.id);
								}
							});
							jdModelCallCenter.settings.fn()
						})
					}
				}
			})
		}
	}
};	
initEasyBuy();
//颜色尺码
var choose_color=$("#choose-color a");var choose_colori=$("#choose-color .item");
var choose_version=$("#choose-version .item");
var alert_choose_version=$("#choose-version .dt").html();alert_choose_version=alert_choose_version?alert_choose_version.replace("：",""):"";
var alert_choose_color=$("#choose-color .dt").html();alert_choose_color=alert_choose_color?alert_choose_color.replace("：",""):"";
var alert_choose="所选"+alert_choose_color.replace("选择","")+"该"+alert_choose_version.replace("选择","")+"商品无货";
var csobj={};var scobj={};
if(choose_color.length>0&&choose_version.length>0){
	if(ColorSize&&ColorSize .length>0){
		var cs=null;
		for (var i=0,j=ColorSize.length;i<j;i++){
			cs=ColorSize[i];
			if(!csobj[cs.Color])csobj[cs.Color]={};
			csobj[cs.Color][cs.Size]=cs.SkuId;
			if(!scobj[cs.Size])scobj[cs.Size]={};
			scobj[cs.Size][cs.Color]=cs.SkuId;
		}
	}
	function checkColorSize(c,s){
		if(csobj[c]&&csobj[c][s])
			return csobj[c][s];
		return 0;
	}
	function changeColorSize(flag){
		var cur_color=$("#choose-color .selected a").attr("title");
		if(cur_color&&csobj[cur_color]){
			var version=null;
			var choose_version_obj=null;
			for(var i=0,j=choose_version.length;i<j;i++){
				choose_version_obj=$($(choose_version[i]).find("a")[0]);
				version=choose_version_obj.html();
				if(!(version&&csobj[cur_color][version])){
					$(choose_version[i]).attr("class","item disabled");
					$(choose_version[i]).find("b").hide();
					choose_version_obj.css("cursor","not-allowed").attr("title",alert_choose);
				}
				else{
					if($(choose_version[i]).attr("class")=="item disabled")$(choose_version[i]).attr("class","item");
					$(choose_version[i]).find("b").show();
					choose_version_obj.css("cursor","pointer").attr("title",choose_version_obj.html());
				}
				$(choose_version[i]).find("i").remove();
			}
		}
		var cur_version = $("#choose-version .selected a").html();
		if(cur_version&&scobj[cur_version]){
			var color=null;
			for(var i=0,j=choose_colori.length;i<j;i++){
				color=$($(choose_colori[i]).find("a")[0]).attr("title");
				if(!(color&&scobj[cur_version][color])){
					$(choose_colori[i]).attr("class","item disabled");
					$(choose_colori[i]).find("b").hide();
				}
				else{
					if($(choose_colori[i]).attr("class")=="item disabled")$(choose_colori[i]).attr("class","item");
					$(choose_colori[i]).find("b").show();
				}
			}
		}
		else{
			$("#choose-color .disabled").attr("class","item");
		}
		$("<i></i>").insertBefore("#choose-version .disabled a");
		if(!flag){
			$("#choose-result .dd").html("<em>已选择</em>"+(cur_color?"<strong>“"+cur_color+"”</strong>":"")+(cur_color&&cur_version?"，":"")+(cur_version?"<strong>“"+cur_version+"”</strong>":"")
				+(cur_color?"":"<span class='item-warnning'><s></s>请"+alert_choose_color+"</span>")+(cur_version?"":"<span class='item-warnning'><s></s>请"+alert_choose_version+"</span>"));
			$("#choose-color").attr("class",cur_color?"":"item-hl-bg");
			$("#choose-version").attr("class",cur_version?"":"item-hl-bg");
			if($("#choose-noresult").length>0){$("#choose-noresult").remove();}
			$.easybuy_button.hide();
			$.divide_button.hide();
			$.notice_button.hide();
			if($.append_button.length>0)$.append_button.attr("href","#none").attr("onclick","").unbind("click"); //购物车
			if($(".nav-minicart-btn").length>0)$(".nav-minicart-btn").hide(); //mini购物车
			$("#choose-btn-subsidy").hide();
		}
	}
	changeColorSize(true);
	$("#choose-color a").attr("href","#none").unbind("click").click(function(){
		$("#choose-color .selected").attr("class","item");
		$($(this).parent()).attr("class","item selected");
		var c=$(this).attr("title");
		var s=$("#choose-version .selected a");
		if(s.length>0){s=s.html()}else{s=null}
		var sid=0;
		sid=checkColorSize(c,s);
		if(sid>0){window.location=sid+".html";}else{
			changeColorSize();
		}
	});
	$("#choose-version a").attr("href","#none").unbind("click").click(function(){
		if($($(this).parent()).attr("class")=="item disabled")return;
		var s=$(this).html();
		var c=$("#choose-color .selected a");
		if(c.length>0){c=c.attr("title")}else{c=null}
		var sid=0;
		sid=checkColorSize(c,s);
		if(sid>0){window.location=sid+".html";}else{
			changeColorSize();
		}
	});
}
/******************/
if(true&&pageConfig.product.cat[0]==1316){
var spuServiceUrl = "http://spu.jd.com/json.html?cond=";
var spuPageUrl = "http://spu.jd.com/"+pageConfig.product.skuid+".html";
function showProvinceStockDeliver(r){
	if(!r)return;
	$('<div id="ypds-info"><a href="'+spuPageUrl+'" class="hl_blue" target="_blank">'+r.totalCount+'个卖家在售</a><span class="hl_red">\u3000￥'+(r.minPrice+"")+'</span> 起</div>').insertAfter("#choose"); 
	var spuVenderInfos = '<div class="m fr" id="ypds-list"><div class="mt"><span class="fl">在售卖家</span><span class="extra"><a href="'
										+spuPageUrl+'" class="hl_blue" target="_blank">查看全部</a></span></div><div class="mc"><ul>';
	var topCount = 0;
	for (var i=0,j=r.skuStockVenders.length;i<j;i++){
		if (pageConfig.product.skuid+"" != r.skuStockVenders[i].skuId && topCount < 3){
			spuVenderInfos += '<li id="J_'+r.skuStockVenders[i].skuId+'"><div class="fl"><a href="http://item.jd.com/'+r.skuStockVenders[i].skuId+'.html" target="_blank">'+((r.skuStockVenders[i].venderId&&(r.skuStockVenders[i].skuId+"").length==10)?r.skuStockVenders[i].venderName:'京东商城')+'</a></div><div class="lh hl_red"></div></li>';
			topCount ++;
		}
	}
	spuVenderInfos += '</ul></div></div>';
	if ($("#brand-bar-pop").length > 0){
		$(spuVenderInfos).appendTo("#brand-bar-pop");
	}
	else{
		$(spuVenderInfos).appendTo("#brand-bar");
	}
	var sellerArray = $("#ypds-list li");
	for (var i=0,j=sellerArray.length;i<j;i++){
		$.ajax({
				url:"http://p.3.cn/prices/get?callback=?",
				data:{skuid:sellerArray.eq(i).attr("id"),type:1},
				dataType:"jsonp",
				success:function(r){
					if(r&&r.length>0){
						$("#"+r[0].id+" .hl_red").html(new Number(r[0].p)>0?("￥"+r[0].p):"暂无报价");
					}
				}
			});
	}
}
(function(){
	$.getJSONP(spuServiceUrl+"1_4_1_0_0_0_"+pageConfig.product.skuid+"_1&callback=showProvinceStockDeliver");
})();
}