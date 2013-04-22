<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
$(function() {
	$.getJSON("bzzxj!list.do?time="+Math.round(new Date().getTime()/1000),function(data){
		if(data.rows == undefined) return false;
		$("#bottomcdlist").empty();
		$.each(data.rows, function (i, row) {
			if(row.upid == 0 && row.nid != 5){
				var str = '<dl id="bottomup'+row.nid+'"><dt>'+row.bt+'</dt></dl>';
				$("#bottomcdlist").append(str);
			}
			else if(row.upid != 5){
				var substr = '<dd><a href="bzzx!detail.do?bzid='+row.nid+'">'+row.bt+'</a></dd>';
				$("#bottomup"+row.upid).append(substr);
			}
		});
	});
});
</script>
<div class="bottomnav" id="bottomcdlist"></div>