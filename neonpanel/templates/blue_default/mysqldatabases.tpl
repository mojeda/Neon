<br><br><div align="center" class="MysqlDatabasesHome">
<script type="text/javascript">
	$(document).ready(function() {
		$("#NewDatabaseOpen").click(function(){
			$("#NewDatabaseForm").modal({containerCss:{width:"400", height:"200"}});
		});
		$('#SubmitDatabase').click(function() {
			var dbname = $("#DatabaseName").val();
			$('#FormSubmitDatabase').html('<a class="button-blue" name="SubmitDatabase" />Please Wait...</a>');
			$.modal.close();
			$("#LoadingImage").css({visibility: "visible"});
			$.getJSON("mysql.php?action=createdatabase&view=databases&name=" + dbname + "&format=1",function(result){
				$("#MysqlManager").html(result.content);
				$("#LoadingImage").css({visibility: "hidden"});
			});
		});
		$("#ConfirmDelete").click(function() {
			var deletedb = $("#DeleteFormValue").text();
			$.modal.close();
			$("#LoadingImage").css({visibility: "visible"});
			$.getJSON("mysql.php?action=deletedatabase&view=databases&name=" + deletedb + "&format=1",function(result){
				$("#MysqlManager").html(result.content);
				$("#LoadingImage").css({visibility: "hidden"});
			});
		});
		$("#CancelDelete").click(function() {
			$.modal.close();
		});
		$(".DeleteDatabase").click(function() {
			var database = $(this).attr('rel');
			$("#DeleteFormType").html("database");
			$("#DeleteFormValue").html(database);
			$("#DeleteFormTitle").html("<h3>Delete Database</h3>");
			$("#DeleteForm").modal({containerCss:{width:"400", height:"200"}});
		});
		$('.noEnterSubmit').keypress(function(e){
    		if ( e.which == 13 ) e.preventDefault();
		});
	});
</script>
	<div class="simplebox grid740">
		<div class="titleh">
			<h3>Mysql Databases</h3>
			<div class="shortcuts-icons">
				<a class="shortcut tips" id="NewDatabaseOpen" title="Add Database"><img src="./templates/blue_default/img/icons/shortcut/addfile.png" width="25" height="25" alt="icon" /></a>
			</div>
		</div>
		<table id="DatabaseTable" class="tablesorter"> 
			<thead> 
				<tr> 
					<th style="width:85%">Database Name</th> 
					<th>Actions</th> 
				</tr> 
			</thead> 
			<tbody>
				{%if isempty|DatabaseList == true}
					<tr>
						<td colspan="2">
							<div align="center">You currently have no databases</div>
						</td>
					</tr>
				{%/if}
				{%if isempty|DatabaseList == false}
					{%foreach database in DatabaseList}
						<tr> 
							<td>{%?database}</td> 
							<td>
								<div align="center">
									<a original-title="Delete" class="icon-button tips DeleteDatabase" style="padding-left:5px;padding-right:5px;cursor:pointer;" rel="{%?database}"><img src="./templates/blue_default/img/icons/32x32/stop32.png" alt="icon" height="16" width="16"></a>
								</div>
							</td> 
						</tr>
					{%/foreach}
				{%/if}
			</tbody> 
		</table>
	</div>
</div>
<div id="NewDatabaseForm" style="display:none;height:145px;" align="center">
	<div style="z-index: 610;" class="simplebox">
        <div style="z-index: 600;" class="titleh" align="center"><h3>Add Database</h3></div>
		<div style="z-index: 590;" class="body padding10">
			<div style="height:120px;">
				<form id="form2" name="form2" class="SubmitDatabase noEnterSubmit">	
						Database Name: {%?Username}_<input name="databasename" class="st-forminput" id="DatabaseName" style="width:150px" value="" type="text"> 
						<div style="padding:12px;"></div>
					<div align="center" style="margin-bottom:5px;" id="FormSubmitFile"><a class="button-blue" style="cursor:pointer;" id="SubmitDatabase">Create Database</a></div>
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