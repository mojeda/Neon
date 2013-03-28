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
			<div style="z-index: 130;" class="titleh">
				<div align="left"><h3>MYSQL Wizard Welcome</h3></div>
				<div style="z-index: 120;" class="shortcuts-icons">
					<a class="shortcut tips" href="#">
						<img src="templates/blue_default/img/icons/shortcut/close.png" alt="icon" height="25" width="25" id="RemoveWelcome">
					</a>
				</div>
			</div>
			<div style="z-index: 110;padding:5px 5px 5px 5px;" class="body" align="left">
				<br>
				The MYSQL Wizard is intended to quickly generate matching databases and users with a random password. As an example if you enter "test" in both boxes bellow it will create a database and a user titled: {%?Username}_test with a randomly generated password. The user is given all permissions to the database. Be sure that you keep the password in a safe place, NEON will not remember it.
				<br><br>
			</div>
		</div>
	{%/if}
	{%if isset|DatabaseReturn == true}
		{%foreach return in DatabaseReturn}
			<div style="z-index: 140;padding-top:10px;" class="simplebox grid740" id="DatabaseReturn">
				<div style="z-index: 130;" class="titleh">
					<div align="left"><h3>MYSQL Wizard Results</h3></div>
					<div style="z-index: 120;" class="shortcuts-icons"></div>
				</div>
				<div style="z-index: 110;padding:5px 5px 5px 5px;" class="body" align="left">
					<br>
					Database: {%?return[databasename]}<br>
					User: {%?return[databaseuser]}<br>
					Password: {%?return[databasepassword]}<br>
					<br><br>
				</div>
			</div>
		{%/foreach}
	{%/if}
	<div class="simplebox grid740">
		<div class="titleh">
			<h3>MYSQL Wizard</h3>
		</div>
		<div class="body">
			<form id="form2" name="form2" method="post" action="mysql.php?view=wizard&action=wizard">
				<div class="st-form-line">	
					<span class="st-labeltext">Mysql Database:</span>	
					{%?Username}_<input name="mysqldatabase" type="text" class="st-forminput" id="mysqldatabase" style="width:100px" /> 
					<div class="clear"></div>
				</div>
				<div class="st-form-line">	
					<span class="st-labeltext">Mysql User:</span>	
					{%?Username}_<input name="mysqluser" type="text" class="st-forminput" id="mysqluser" style="width:100px" /> 
					<div class="clear"></div>
				</div>
				<div class="button-box">
					<input type="submit" name="button" id="button" value="Submit" class="st-button"/>
				</div>
			</form>
		</div>
	</div>
</div>