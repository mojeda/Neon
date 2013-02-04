<script type="text/javascript">
$(document).ready(function() {
	$("#UpdateImage").css({visibility: "hidden"});
	$("#Update").click(function() {
		$("#UpdateImage").css({visibility: "visible"});
		$("#UpdateText").css({visibility: "hidden"});
		$.getJSON("doupdate.php?id=1",function(result){
			$("#Result").html(result.content);
			$("#UpdateImage").css({visibility: "hidden"});
		});
	});
});
</script>
<div align="center" class="UpdateHome">
	{%if Outdated == true}
		<div id="UpdateText" align="center">
			Neon is currently out of date.<br><br><br>
			<a id="Update" class="icon-button"><img src="./templates/blue_default/img/icons/button/download.png" alt="icon" height="18" width="18"><span>Download Updates</span></a>
		</div>
		<div id="UpdateImage" align="center"><img src="./templates/blue_default/img/loading/7.gif" alt="icon" style="margin-right:15px;"><br>Please wait...</div>
		<div id="Result"></div>
	{%/if}
	{%if Outdated == false}
		Neon is up to date.
	{%/if}
</div>