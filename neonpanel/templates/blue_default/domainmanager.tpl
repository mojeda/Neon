<div align="center" class="DomainManagerHome">
	<script type="text/javascript">
		$(document).ready(function() {
			$("#NewDomainOpen").click(function(){
				$("#NewDomainForm").modal({containerCss:{width:"400", height:"200"}});
			});
			$('#SubmitDomain').click(function() {
				var domain = $("#DomainName").val();
				$('#FormSubmitDomain').html('<a class="button-blue" name="SubmitDomain" />Please Wait...</a>');
				if(!domain){
					$('#FormSubmitFolder').html('<a class="button-blue" name="SubmitDomain" id="SubmitDomain" />Add Domain</a>');
				}
				else {
					$.modal.close();
					$("#LoadingImage").css({visibility: "visible"});
					$.getJSON("domainmanager.php?action=adddomain&name=" + domain + "&format=1",function(result){
						$("#DomainManager").html(result.content);
						$("#LoadingImage").css({visibility: "hidden"});
					});
				}
			});	
			$(".DeleteDomain").click(function() {
				var domain = $(this).attr('rel');
				$("#DeleteFormType").html("domain");
				$("#DeleteFormValue").html(domain);
				$("#DeleteFormTitle").html("<h3>Delete Domain</h3>");
				$("#DeleteForm").modal({containerCss:{width:"400", height:"200"}});
			});
			$("#ConfirmDelete").click(function() {
				var domain = $("#DeleteFormValue").text();
				$.modal.close();
				$("#LoadingImage").css({visibility: "visible"});
				$.getJSON("domainmanager.php?action=removedomain&name=" + domain + "&format=1",function(result){
					$("#DomainManager").html(result.content);
					$("#LoadingImage").css({visibility: "hidden"});
				});
			});
			$("#CancelDelete").click(function() {
				$.modal.close();
			});
			$('.noEnterSubmit').keypress(function(e){
    				if ( e.which == 13 ) e.preventDefault();
			});
		});
	</script>
	<div class="simplebox grid740">
		<div class="titleh">
			<h3>Domain Management</h3>
			<div class="shortcuts-icons">
				<a class="shortcut tips" id="NewDomainOpen" title="Add New Item"><img src="./templates/blue_default/img/icons/shortcut/plus.png" width="25" height="25" alt="icon" /></a>
			</div>
		</div>
		<table id="Domains" class="tablesorter"> 
			<thead> 
				<tr> 
					<th width="90%">Domain</th> 
					<th>Actions</th>
				</tr> 
			</thead> 
			<tbody>
				{%if isset|Domains == true}
					{%foreach domain in Domains}
						<tr> 
							<td>{%?domain[domain]}</td> 
							<td><div align="center"><a original-title="Delete" class="icon-button tips DeleteDomain" style="padding-left:5px;padding-right:5px;cursor:pointer;" rel="{%?domain[domain]}"><img src="./templates/blue_default/img/icons/32x32/stop32.png" alt="icon" height="16" width="16"></a></div></td> 
						</tr> 
					{%/foreach}
				{%/if}
				{%if isset|Domains == false}
					<tr>
						<td colspan="2"><div align="center">You currently have no domains</div></td>
					</tr>
				{%/if}
			</tbody> 
		</table>
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
<div id="NewDomainForm" style="display:none;height:145px;" align="center">
	<div style="z-index: 610;" class="simplebox">
        <div style="z-index: 600;" class="titleh" align="center"><h3>Add Domain</h3></div>
		<div style="z-index: 590;" class="body padding10">
			<div style="height:120px;">
				<form id="form2" name="form2" class="SubmitDomain noEnterSubmit">	
						Domain (without http:// or www.): <input name="domain" class="st-forminput" id="DomainName" style="width:150px" value="" type="text"> 
						<div style="padding:12px;"></div>
					<div align="center" style="margin-bottom:5px;" id="FormSubmitDomain"><a class="button-blue" style="cursor:pointer;" id="SubmitDomain">Add Domain</a></div>
				</form>
			</div>
		</div>
	</div>
</div>