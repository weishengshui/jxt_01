/*
	use:仿百度帖吧的翻页前台代码
	用法--
		$(".pagefooter").page(
			{total:250,		//总条数
			currentpage:15,		//当前页码
			gopage:gopage}	//点击标签后的实现函数，需要外面存在该函数
							//如：
							//	var gopage=function(pagesize,currentpage){
							//		alert(pagesize+"---"+currentpage);
							//	}
							//传入两个参数pagesize(每页显示条数)，currentpage(当前页码)
			
		);
	version:1.0.0
	author:wangchao
*/
;(function($){
	$.fn.page = function (options) {
	return this.each(function () {
		var t = this;
		var defaults = {
			pagesize: 10,
			currentpage: 1,
			cpageclass:"nowpage",
			firstshow: false,
			firstname: "首页",
			prename:"上一页",
			lastname:"末页",
			aftername:"下一页"
		};	
		var p = $.extend(defaults,options);
		var htm ="";
		var g={
			gopage:function(currentpage){						
				if(p.gopage == undefined || typeof(p.gopage)!="function")
					return false;
				else p.gopage(p.pagesize,currentpage);
			}
		};
		if(p.total == undefined || p.total == "0" )
			return false;
		p.total = parseInt(p.total);
		p.currentpage = parseInt(p.currentpage);
		var pagesum = Math.ceil(p.total/p.pagesize);
		if(p.currentpage != 1){
			if(p.firstshow) htm += '<a style="cursor:hand" id="firstpage">'+p.firstname+'</a>';
			htm += '<a style="cursor:hand" id="prepage">'+p.prename+'</a>';
		}
		if(pagesum > 1 && pagesum <11){
			for(var i=1;i<=pagesum;i++){
				if(i==p.currentpage) htm += '<span id="finalcurrentpagenum" class="'+p.cpageclass+'">'+i+'</span>';
				else htm += '<a style="cursor:hand" class="pagenum">'+i+'</a>';				
			}
		}
		if(pagesum >10 ){
			var bottom = 1;
			var top = 10;
			if(p.currentpage>5&&pagesum-p.currentpage>5){
				bottom = p.currentpage - 4;
				top = p.currentpage + 5;
			}
			else if(pagesum-p.currentpage<6){
				bottom = pagesum - 9;
				top = pagesum;				
			}
			for(var i=bottom;i<=top;i++){
				if(i==p.currentpage) htm += '<span id="finalcurrentpagenum" class="'+p.cpageclass+'">'+i+'</span>';
				else htm += '<a style="cursor:hand" class="pagenum">'+i+'</a>';				
			}
		}
		if(p.currentpage != pagesum){
			htm += '<a style="cursor:hand" id="afterpage">'+p.aftername+'</a>';			
			if(p.firstshow)htm += '<a style="cursor:hand" id="lastpage">'+p.lastname+'</a>';
		}
		$(this).empty();
		$(this).append(htm);
		if(p.firstshow) $("#firstpage",t).click(function(){g.gopage(1);});
		$("#prepage",t).click(function(){g.gopage(p.currentpage-1);});
		if(p.firstshow) $("#lastpage",t).click(function(){g.gopage(pagesum);});
		$("#afterpage",t).click(function(){g.gopage(p.currentpage+1);});
		for(var i=0;i<$(".pagenum",t).length;i++){
			var count = $(".pagenum",t).eq(i).html();
			$(".pagenum",t).eq(i).bind("click", {k:count}, function(e){g.gopage(e.data.k)});
		}
	});	
	};
  })(jQuery)