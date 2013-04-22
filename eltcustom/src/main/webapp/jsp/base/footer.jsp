<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
$(function() {
	$.getJSON("bzzxj!list.do?time="+Math.round(new Date().getTime()/1000),function(data){
		if(data.rows == undefined) return false;
		$("#footercd").empty();
		$.each(data.rows, function (i, row) {
			if(row.upid == 5){
				var split =(i==0)?"":" - ";
				var str = split+'<a href="bzzx!detail.do?bzid='+row.nid+'">'+row.bt+'</a>';
				$("#footercd").append(str);
			}
		});
	});
});
</script>
<div style="height:0px; overflow:hidden; clear:both;"></div>
<div class="footerwrap">
	<div class="footer">
		<h1 id="footercd">
		</h1>
		<span></sapn>
	</div>
</div>