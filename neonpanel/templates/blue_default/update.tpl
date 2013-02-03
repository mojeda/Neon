<div align="center" class="UpdateHome">
	{%if Outdated == true}
		Neon is currently out of date and updates to it's code are available for download. Please click the update button only once if you wish to update.
		<br><br><br>
		<a href="update.php?id=develop" class="icon-button"><img src="img/icons/button/download.png" alt="icon" height="18" width="18"><span>Update To Development Edition</span></a>
	{%/if}
	{%if Outdated == false}
		Neon is up to date.
	{%/if}
</div>