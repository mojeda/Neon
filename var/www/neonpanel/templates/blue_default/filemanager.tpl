<div align="center" id="FileManager" style="margin-top:25px;"></div>
<script type="text/javascript">
	$(document).ready(function() {
		$.getJSON("http://{%?DefaultIP}/neonpanel/filemanager/filemanager.php?key={%?UserKey}&callback=?",function(result){
			$("#FileManager").html(result.content);
			$("#LoadingImage").css({visibility: "hidden"});
		});
	});
</script>