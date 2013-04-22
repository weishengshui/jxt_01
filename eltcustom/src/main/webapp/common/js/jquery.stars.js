;(function($){
	$.fn.stars = function (options) {
	return this.each(function () {
		var t = this;
		var defaults = {
			stars: 5
		};	
		var p = $.extend(defaults,options);
		var span = document.createElement("span");
		span.className="pjxj";		
		for(var i=0;i<p.stars;i++){
			$(span).append("<span></span>");
		}
		$(t).after(span);
		for(var j=0;j<$("span",span).length;j++){
			$("span",span).eq(j).bind("mouseover",{k:j,m:p.stars},function(e){
				for(var l=0;l<e.data.k+1;l++){
					if(!$("span",span).eq(l).hasClass("yellow")){
						$("span",span).eq(l).addClass("hover");
					}				
				}
				for(var b=e.data.k+1;b<e.data.m;b++){
					if($("span",span).eq(b).hasClass("yellow")){
						$("span",span).eq(b).removeClass("yellow");
						$("span",span).eq(b).addClass("grey");
					}				
				}
			});
			$("span",span).eq(j).bind("mouseout",{k:j,m:p.stars},function(e){				
				for(var n=0;n<e.data.m;n++){
					$("span",span).eq(n).removeClass("yellow");
					$("span",span).eq(n).removeClass("hover");
					$("span",span).eq(n).removeClass("grey");
				}
				var checkval = $(t).val();
				if(checkval>0){					
					for(var l=0;l<checkval;l++){
						$("span",span).eq(l).addClass("yellow");
					}
				}
			});
			$("span",span).eq(j).bind("click",{k:j,m:p.stars},function(e){
				for(var n=0;n<e.data.m;n++){
					$("span",span).eq(n).removeClass("yellow");
					$("span",span).eq(n).removeClass("hover");
					$("span",span).eq(n).removeClass("grey");
				}
				for(var l=0;l<e.data.k+1;l++){
					$("span",span).eq(l).addClass("yellow");
				}
				$(t).val(e.data.k+1);
			});
		}
	});	
	};
  })(jQuery)