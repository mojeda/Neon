{%if WizardClosed == false}
	<script type="text/javascript">
		$(document).ready(function(){
			$("#RemoveWelcome").click(function(){
				$("#Welcome").remove();
				$.post("post_settings.php?id=WizardClosed");
			});
		});
	</script>
{%/if}
<div align="center" class="Wizard">
{%if WizardClosed == false}
	<div style="z-index: 140;padding-top:10px;" class="simplebox grid740" id="Welcome">
       <div style="z-index: 130;" class="titleh"><div align="left"><h3>MYSQL Wizard Welcome</h3></div>
            <div style="z-index: 120;" class="shortcuts-icons">
				<a class="shortcut tips" href="#">
					<img src="templates/blue_default/img/icons/shortcut/close.png" alt="icon" height="25" width="25" id="RemoveWelcome">
				</a>
			</div>
        </div>
        <div style="z-index: 110;padding:5px 5px 5px 5px;" class="body" align="left">
			<br>
			The MYSQL Wizard is intended to quickly generate matching databases and users with a random password. As an example if you enter "test" bellow it will create a database and a user titled: {%?Username}_test with a randomly generated password. The user is given all permissions to the database.
			<br><br>
		</div>
    </div>
{%/if}
</div>