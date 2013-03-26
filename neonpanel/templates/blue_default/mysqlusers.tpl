<br><br><div align="center" class="MysqlUsersHome">
<script type="text/javascript">
	$(document).ready(function() {
		$("#NewUserOpen").click(function(){
			$("#NewUserForm").modal({containerCss:{width:"400", height:"200"}});
		});
		$('#SubmitUser').click(function() {
			var mysqlusername = $("#MysqlUsername").val();
			var mysqlpassword = $("#MysqlPassword").val();
			$('#FormSubmitUser').html('<a class="button-blue" name="SubmitUser" />Please Wait...</a>');
			$.modal.close();
			$("#LoadingImage").css({visibility: "visible"});
			$.getJSON("mysql.php?action=createuser&view=users&name=" + mysqlusername + "&password=" + mysqlpassword + "&format=1",function(result){
				$("#MysqlManager").html(result.content);
				$("#LoadingImage").css({visibility: "hidden"});
			});
		});
		$("#ConfirmDelete").click(function() {
			var deleteuser = $("#DeleteFormValue").text();
			$.modal.close();
			$("#LoadingImage").css({visibility: "visible"});
			$.getJSON("mysql.php?action=deleteuser&view=users&name=" + deleteuser + "&format=1",function(result){
				$("#MysqlManager").html(result.content);
				$("#LoadingImage").css({visibility: "hidden"});
			});
		});
		$("#CancelDelete").click(function() {
			$.modal.close();
		});
		$(".DeleteUser").click(function() {
			var user = $(this).attr('rel');
			$("#DeleteFormType").html("mysql user");
			$("#DeleteFormValue").html(user);
			$("#DeleteFormTitle").html("<h3>Delete Mysql User</h3>");
			$("#DeleteForm").modal({containerCss:{width:"400", height:"200"}});
		});
		$('.noEnterSubmit').keypress(function(e){
    		if ( e.which == 13 ) e.preventDefault();
		});
	});
</script>
	<div class="simplebox grid740">
		<div class="titleh">
			<h3>Mysql Users</h3>
			<div class="shortcuts-icons">
				<a class="shortcut tips" id="NewUserOpen" title="Add User"><img src="./templates/blue_default/img/icons/shortcut/addfile.png" width="25" height="25" alt="icon" /></a>
			</div>
		</div>
		<table id="UserTable" class="tablesorter"> 
			<thead> 
				<tr> 
					<th style="width:85%">Username</th> 
					<th>Actions</th> 
				</tr> 
			</thead> 
			<tbody>
				{%if isempty|UserList == true}
					<tr>
						<td colspan="2">
							<div align="center">You currently have no users.</div>
						</td>
					</tr>
				{%/if}
				{%if isempty|UserList == false}
					{%foreach user in UserList}
						<tr> 
							<td>{%?user}</td> 
							<td>
								<div align="center">
									<a original-title="Delete" class="icon-button tips DeleteUser" style="padding-left:5px;padding-right:5px;cursor:pointer;" rel="{%?user}"><img src="./templates/blue_default/img/icons/32x32/stop32.png" alt="icon" height="16" width="16"></a>
								</div>
							</td> 
						</tr>
					{%/foreach}
				{%/if}
			</tbody> 
		</table>
	</div>
</div>
<div id="NewUserForm" style="display:none;height:145px;" align="center">
	<div style="z-index: 610;" class="simplebox">
        <div style="z-index: 600;" class="titleh" align="center"><h3>Add Mysql User</h3></div>
		<div style="z-index: 590;" class="body padding10">
			<div style="height:120px;">
				<form id="form2" name="form2" class="SubmitUser noEnterSubmit">	
						Mysql Username: {%?Username}_<input name="mysqlusername" class="st-forminput" id="MysqlUsername" style="width:150px" value="" type="text"><br>
						Mysql Password: <input name="mysqlpassword" class="st-forminput" id="MysqlPassword" style="width:150px" value="" type="password">
						<div style="padding:12px;"></div>
					<div align="center" style="margin-bottom:5px;" id="FormSubmitUser"><a class="button-blue" style="cursor:pointer;" id="SubmitUser">Create Mysql User</a></div>
				</form>
			</div>
		</div>
	</div>
</div>
<div id="DeleteForm" style="display:none;height:130px;" align="center">
	<div style="z-index: 610;" class="simplebox">
        <div style="z-index: 600;" class="titleh" align="center" id="DeleteFormTitle"></div>
		<div style="z-index: 590;" class="body padding10">
			<div style="height:120px;">
				<form id="form3" name="form3" class="Delete noEnterSubmit">	
						Do you want to delete the <a style="color:#737F89;" id="DeleteFormType"></a> <a style="color:#737F89;" id="DeleteFormValue"></a>?
						<div style="padding:12px;"></div>
					<div align="center" style="margin-bottom:5px;" id="FormDelete"><a class="button-blue" style="cursor:pointer;" id="ConfirmDelete">Yes</a> <a class="button-blue" style="cursor:pointer;" id="CancelDelete">No</a></div>
				</form>
			</div>
		</div>
	</div>
</div>