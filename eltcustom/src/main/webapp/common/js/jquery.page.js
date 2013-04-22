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
			if(p.firstshow) htm += '<a style="cursor:pointer" id="firstpage">'+p.firstname+'</a>';
			htm += '<a style="cursor:pointer" id="prepage">'+p.prename+'</a>';
		}
		if(pagesum > 1 && pagesum <11){
			for(var i=1;i<=pagesum;i++){
				if(i==p.currentpage) htm += '<span id="finalcurrentpagenum" class="'+p.cpageclass+'">'+i+'</span>';
				else htm += '<a style="cursor:pointer" class="pagenum">'+i+'</a>';				
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
				else htm += '<a style="cursor:pointer" class="pagenum">'+i+'</a>';				
			}
		}
		if(p.currentpage != pagesum){
			htm += '<a style="cursor:pointer" id="afterpage">'+p.aftername+'</a>';			
			if(p.firstshow)htm += '<a style="cursor:pointer" id="lastpage">'+p.lastname+'</a>';
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