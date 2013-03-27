<br><br><div class="MysqlDatabaseUsersHome">
<script type="text/javascript">
	$(document).ready(function() {
		$("#ConfirmRemove").click(function() {
			var user = $("#RemoveUser").text();
			var database = $("#RemoveDatabase").text();
			$.modal.close();
			$("#LoadingImage").css({visibility: "visible"});
			$.getJSON("mysql.php?action=removeuser&view=databaseusers&name=" + user + "&database=" + database + "&format=1",function(result){
				$("#MysqlManager").html(result.content);
				$("#LoadingImage").css({visibility: "hidden"});
			});
		});
		$("#CancelRemove").click(function() {
			$.modal.close();
		});
		$(".RemoveUser").click(function() {
			var user = $(this).attr('rel');
			var database = $(this).attr('id');
			$("#RemoveUser").html(user);
			$("#RemoveDatabase").html(database);
			$("#RemoveFormTitle").html("<h3>Remove User From Database</h3>");
			$("#RemoveForm").modal({containerCss:{width:"400", height:"200"}});
		});
		$('.noEnterSubmit').keypress(function(e){
    		if ( e.which == 13 ) e.preventDefault();
		});
	});
</script>
	<div class="simplebox grid740">
		<div class="titleh">
			<h3>Mysql Database Users</h3>
			<div class="shortcuts-icons">
			</div>
		</div>
		<table id="DatabaseTable" class="tablesorter"> 
			<thead> 
				<tr> 
					<th style="width:50%">Database Name</th>
					<th style="width:50%">Database Users</th>
				</tr> 
			</thead> 
			<tbody>
				{%if isempty|DatabaseList == true}
					<tr>
						<td colspan="2">
							<div align="center">You currently have no databases.</div>
						</td>
					</tr>
				{%/if}
				{%if isempty|DatabaseList == false}
					{%foreach database in DatabaseList}
						<tr>
							<td{%if isempty|database[number] == false} rowspan="{%?database[number]}"{%/if} style="border:solid 1px #3399FF;">{%?database[name]}</td>
							{%if isempty|database[number] == true}
								<td></td>
							{%/if}
						</tr>
						{%if isempty|database[users] == false}
							{%foreach user in database[users]}
								<tr><td valign="top">
									<div height="15"><div style="width:100px;float:left;">{%?user}</div><div style="width:70px;float:right;text-align:right;"><a original-title="RemoveUser" class="icon-button tips RemoveUser" style="padding-left:5px;padding-right:5px;cursor:pointer;" rel="{%?user}" id="{%?database[name]}"><img src="./templates/blue_default/img/icons/32x32/stop32.png" alt="icon" height="16" width="16"></a></div></div>
								</td></tr>
							{%/foreach}
						{%/if}
					{%/foreach}
				{%/if}
			</tbody> 
		</table>
	</div>
</div>
<br><br>
{%if isempty|DatabaseList == false}
	{%if isempty|UserList == false}
		<div class="simplebox grid740">
			<div class="titleh">
				<h3>Add User To Database</h3>
			</div>
			<div class="body">
				<form id="form2" name="form2" method="post" action="mysql.php?view=databaseusers&action=adduser">
					<div class="st-form-line">
						<span class="st-labeltext">Mysql User</span>	
						<select name="mysqluser" id="mysqluser" class="uniform">
							{%foreach user in UserList}
								<option value="{%?user}">{%?user}</option>
							{%/foreach}
						</select>
						<div class="clear"></div> 
					</div>
					<div class="st-form-line">
						<span class="st-labeltext">Mysql Database</span>	
						<select name="mysqldatabase" id="mysqldatabase" class="uniform">
							{%foreach database in DatabaseList}
								<option value="{%?database[name]}">{%?database[name]}</option>
							{%/foreach}
						</select>
						<div class="clear"></div> 
					</div>
					<div class="st-form-line">	
						<span class="st-labeltext">Privledges</span>
						<div align="center">
							<table width="90%">
								<tr>
									<td><label class="margin-right10"><input type="checkbox" name="ALTER" id="ALTER" class="uniform" checked="checked"/> ALTER</label></td>
									<td><label class="margin-right10"><input type="checkbox" name="CREATE" id="CREATE" class="uniform" checked="checked"/> CREATE</label></td>
								</tr>
								<tr>
									<td><label class="margin-right10"><input type="checkbox" name="CREATE ROUTINE" id="CREATE ROUTINE" class="uniform" checked="checked"/> CREATE ROUTINE</label></td>
									<td><label class="margin-right10"><input type="checkbox" name="CREATE TEMPORARY TABLES" id="CREATE TEMPORARY TABLES" class="uniform" checked="checked"/> CREATE TEMPORARY TABLES</label></td>
								</tr>
								<tr>
									<td><label class="margin-right10"><input type="checkbox" name="CREATE VIEW" id="CREATE VIEW" class="uniform" checked="checked"/> CREATE VIEW</label></td>
									<td><label class="margin-right10"><input type="checkbox" name="DELETE" id="DELETE" class="uniform" checked="checked"/> DELETE</label></td>
								</tr>
								<tr>
									<td><label class="margin-right10"><input type="checkbox" name="DROP" id="DROP" class="uniform" checked="checked"/> DROP</label></td>
									<td><label class="margin-right10"><input type="checkbox" name="EXECUTE" id="EXECUTE" class="uniform" checked="checked"/> EXECUTE</label></td>
								</tr>
								<tr>
									<td><label class="margin-right10"><input type="checkbox" name="INDEX" id="INDEX" class="uniform" checked="checked"/> INDEX</label></td>
									<td><label class="margin-right10"><input type="checkbox" name="INSERT" id="INSERT" class="uniform" checked="checked"/> INSERT</label></td>
								</tr>
								<tr>
									<td><label class="margin-right10"><input type="checkbox" name="LOCK TABLES" id="LOCK TABLES" class="uniform" checked="checked"/> LOCK TABLES</label></td>
									<td><label class="margin-right10"><input type="checkbox" name="REFERENCES" id="REFERENCES" class="uniform" checked="checked"/> REFERENCES</label></td>
								</tr>
								<tr>
									<td><label class="margin-right10"><input type="checkbox" name="SELECT" id="SELECT" class="uniform" checked="checked"/> SELECT</label></td>
									<td><label class="margin-right10"><input type="checkbox" name="SHOW" id="SHOW" class="uniform" checked="checked"/> SHOW</label></td>
								</tr>
								<tr>
									<td><label class="margin-right10"><input type="checkbox" name="VIEW" id="VIEW" class="uniform" checked="checked"/> VIEW</label></td>
									<td><label class="margin-right10"><input type="checkbox" name="TRIGGER" id="TRIGGER" class="uniform" checked="checked"/> TRIGGER</label></td>
								<tr>
									<td><label class="margin-right10"><input type="checkbox" name="UPDATE" id="UPDATE" class="uniform" checked="checked"/> UPDATE</label></td>
									<td></td>
								</tr>
							</table>
						</div>
						<div class="clear"></div> 
					</div>
					<div class="button-box">
						<input type="submit" name="button" id="button" value="Submit" class="st-button"/>
						<input type="reset" name="button" id="button2" value="Reset" class="st-clear"/>
					</div>
				</form>
			</div>
		</div>
	{%/if}
{%/if}
<div id="RemoveForm" style="display:none;height:130px;" align="center">
	<div style="z-index: 610;" class="simplebox">
        <div style="z-index: 600;" class="titleh" align="center" id="RemoveFormTitle"></div>
		<div style="z-index: 590;" class="body padding10">
			<div style="height:120px;">
				<form id="form3" name="form3" class="Remove noEnterSubmit">	
						Do you want to remove the user <a style="color:#737F89;" id="RemoveUser"></a> from <a style="color:#737F89;" id="RemoveDatabase"></a>?
						<div style="padding:12px;"></div>
					<div align="center" style="margin-bottom:5px;" id="FormRemove"><a class="button-blue" style="cursor:pointer;" id="ConfirmRemove">Yes</a> <a class="button-blue" style="cursor:pointer;" id="CancelRemove">No</a></div>
				</form>
			</div>
		</div>
	</div>
</div>