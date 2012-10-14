<div class="simplebox grid740">
	<div class="titleh">
		<h3>File Manager</h3>
		{%if AllowBack == true}
			<div class="shortcuts-down">
				<a class="shortcut tips" href="#" id="UpDirectory" title="Back Directory"><img src="./templates/blue_default/img/icons/shortcut/back.png" width="25" height="25" alt="icon" /></a>
			</div>
		{%/if}
		<div class="shortcuts-icons">
			<a class="shortcut tips" href="#" title="Upload"><img src="./templates/blue_default/img/icons/shortcut/upload.png" width="25" height="25" alt="icon" /></a>
			<a class="shortcut tips" id="NewFolderOpen" title="Add Folder"><img src="./templates/blue_default/img/icons/shortcut/addfolder.png" width="25" height="25" alt="icon" /></a>
			<a class="shortcut tips" id="NewFileOpen" title="Add File"><img src="./templates/blue_default/img/icons/shortcut/addfile.png" width="25" height="25" alt="icon" /></a>
			<a class="shortcut tips" href="#" id="ReloadFileManager" title="Refresh File Manager"><img src="./templates/blue_default/img/icons/shortcut/refresh.png" width="25" height="25" alt="icon" /></a>
		</div>
	</div>
<!-- Start Data Tables Initialisation code -->
	<script type="text/javascript" charset="utf-8">
		$(document).ready(function() {
			oTable = $('#filemanager').dataTable({
				"bJQueryUI": true,
				"sPaginationType": "full_numbers",
				"aaSorting": [[ 0, "asc" ]],
				"aLengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
				"iDisplayLength": {%?MaxListFiles},
				"oLanguage": {
				"sEmptyTable": "Directory Empty"
				}
			});
			$("#ReloadFileManager").click(function() {
				$("#FileManager").html('<img src="./templates/blue_default/img/loading/7.gif">');
				$(".tipsy").remove();
				$.getJSON("filemanager.php?ajax=1",function(result){
					$("#FileManager").html(result.content);
				});
			});
			$.post('ajax/test.html', function(result) {
				$('.result').html(result);
			});
			$(".directory").click(function() {
				var directory = $(this).attr("value");
				$("#FileManager").html('<img src="./templates/blue_default/img/loading/7.gif">');
				$.getJSON("filemanager.php?ajax=1&up=" + directory + "",function(result){
					$("#FileManager").html(result.content);
				});
			});
			$("#UpDirectory").click(function() {
				$("#FileManager").html('<img src="./templates/blue_default/img/loading/7.gif">');
				$.getJSON("filemanager.php?ajax=1&back=1",function(result){
					$("#FileManager").html(result.content);
				});
			});
			$("#NewFolderOpen").click(function(){
				$("#NewFolderForm").modal({containerCss:{width:"290", height:"155"}});
			});
			$('#SubmitFolder').click(function() {
				var folder = $("#FolderName").val();
				$('#FormSubmitFolder').html('<a class="button-blue" name="SubmitFolder" />Please Wait...</a>');
				if(!folder){
					$('#FormSubmitFolder').html('<a class="button-blue" name="SubmitFolder" id="SubmitFolder" />Add Folder</a>');
				}
				else {
					$.modal.close();
					$("#FileManager").html('<img src="./templates/blue_default/img/loading/7.gif">');
					$.getJSON("filemanager.php?ajax=1&add_folder=" + folder + "",function(result){
						$("#FileManager").html(result.content);
					});
				}
			});
			$("#NewFileOpen").click(function(){
				$("#NewFileForm").modal({containerCss:{width:"290", height:"155"}});
			});
			$('#SubmitFile').click(function() {
				var file = $("#FileName").val();
				$('#FormSubmitFile').html('<a class="button-blue" name="SubmitFile" />Please Wait...</a>');
				if(!file){
					$('#FormSubmitFile').html('<a class="button-blue" name="SubmitFile" id="SubmitFile" />Add Folder</a>');
				}
				else {
					$.modal.close();
					$("#FileManager").html('<img src="./templates/blue_default/img/loading/7.gif">');
					$.getJSON("filemanager.php?ajax=1&add_file=" + file + "",function(result){
						$("#FileManager").html(result.content);
					});
				}
			});
			$(".SubmitFolder").keypress(function(e) {
				if (e.which == 13) {
					var folder = $("#FolderName").val();
					$('#FormSubmitFolder').html('<a class="button-blue" name="SubmitFolder" />Please Wait...</a>');
					if(!folder){
						$('#FormSubmitFolder').html('<a class="button-blue" name="SubmitFolder" id="SubmitFolder" />Add Folder</a>');
					}
					else {
						$.modal.close();
						$("#FileManager").html('<img src="./templates/blue_default/img/loading/7.gif">');
						$.getJSON("filemanager.php?ajax=1&add_folder=" + folder + "",function(result){
							$("#FileManager").html(result.content);
						});
					}
					return false;
				}
			});
			$(".SubmitFile").keypress(function(e) {
				if (e.which == 13) {
					var file = $("#FileName").val();
					$('#FormSubmitFile').html('<a class="button-blue" name="SubmitFile" />Please Wait...</a>');
					if(!file){
						$('#FormSubmitFile').html('<a class="button-blue" name="SubmitFile" id="SubmitFile" />Add Folder</a>');
					}
					else {
						$.modal.close();
						$("#FileManager").html('<img src="./templates/blue_default/img/loading/7.gif">');
						$.getJSON("filemanager.php?ajax=1&add_file=" + file + "",function(result){
							$("#FileManager").html(result.content);
						});
					}
					return false;
				}
			});
		});
	</script>
<!-- End Data Tables Initialisation code -->
	<table cellpadding="0" cellspacing="0" border="0" class="display data-table" id="filemanager">
		<thead>
			<tr>
				<th width="5%"></th>
				<th width="63%">File Name</th>
				<th width="10%">Size</th>
				<th width="27%">Actions</th>
			</tr>
		</thead>
		<tbody>
			{%foreach directory in Directories}
				<tr class="gradeA">
					<td width="10" class="directory" value="{%?directory[name]}"><a href="#"><img src="./templates/blue_default/img/icons/shortcut/folder.png" alt="Directory"></img></a><a style="display:none;">Directory</a></td>
					<td>{%?directory[name]}</td>
					<td>{%?directory[size]}</td>
					<td>
						<a original-title="Delete" href="#" class="icon-button tips" style="padding-left:5px;padding-right:5px;" id="DeleteFolder" value="{%?directory[name]}"><img src="./templates/blue_default/img/icons/32x32/stop32.png" alt="icon" height="16" width="16"></a>
						<a original-title="Permissions" href="#" class="icon-button tips" style="padding-left:5px;padding-right:5px;"  id="PermissionsFolder" value="{%?directory[name]}"><img src="./templates/blue_default/img/icons/32x32/lock32.png" alt="icon" height="16" width="16"></a>
						<a original-title="Download" href="#" class="icon-button tips" style="padding-left:5px;padding-right:5px;"  id="DownloadFolder" value="{%?directory[name]}"><img src="./templates/blue_default/img/icons/32x32/boxdownload32.png" alt="icon" height="16" width="16"></a>
					</td>
				</tr>
			{%/foreach}
			{%foreach file in Files}
				<tr class="gradeA">
					<td><img src="./templates/blue_default/img/icons/shortcut/file.png" alt="File"></img><a style="display:none;">File</a></td>
					<td>{%?file[name]}</td>
					<td>{%?file[size]}</td>
					<td>
						<a original-title="Delete" href="#" class="icon-button tips" style="padding-left:5px;padding-right:5px;" id="DeleteFile" value="{%?file[name]}"><img src="./templates/blue_default/img/icons/32x32/stop32.png" alt="icon" height="16" width="16"></a>
						<a original-title="Permissions" href="#" class="icon-button tips" style="padding-left:5px;padding-right:5px;" id="PermissionsFile" value="{%?file[name]}"><img src="./templates/blue_default/img/icons/32x32/lock32.png" alt="icon" height="16" width="16"></a>
						<a original-title="Download" href="#" class="icon-button tips" style="padding-left:5px;padding-right:5px;" id="DownloadFile" value="{%?file[name]}"><img src="./templates/blue_default/img/icons/32x32/boxdownload32.png" alt="icon" height="16" width="16"></a>
						<a original-title="Edit" href="filemanager.php?editor=1&file={%?FilePath}{%?file[name]}" target="_blank" class="icon-button tips" style="padding-left:5px;padding-right:5px;"><img src="./templates/blue_default/img/icons/32x32/pencil32.png" alt="icon" height="16" width="16"></a>
					</td>
				</tr>
			{%/foreach}
		</tbody>
	</table>
</div>
<div id="NewFolderForm" style="display:none;height:145px;" align="center">
	<div style="z-index: 610;" class="simplebox">
        <div style="z-index: 600;" class="titleh" align="center"><h3>Add Folder</h3></div>
		<div style="z-index: 590;" class="body padding10">
			<form id="form1" name="form1" class="SubmitFolder">	
                    Folder Name: <input name="folder" class="st-forminput" id="FolderName" style="width:150px" value="" type="text"> 
					<div style="padding:12px;"></div>
				<div align="center" style="margin-bottom:5px;" id="FormSubmitFolder"><a class="button-blue" style="cursor:pointer;" id="SubmitFolder">Submit</a></div>
			</form>
		</div>
	</div>
</div>
<div id="NewFileForm" style="display:none;height:145px;" align="center">
	<div style="z-index: 610;" class="simplebox">
        <div style="z-index: 600;" class="titleh" align="center"><h3>Add File</h3></div>
		<div style="z-index: 590;" class="body padding10">
			<form id="form2" name="form2" class="SubmitFile">	
                    File Name: <input name="file" class="st-forminput" id="FileName" style="width:150px" value="" type="text"> 
					<div style="padding:12px;"></div>
				<div align="center" style="margin-bottom:5px;" id="FormSubmitFile"><a class="button-blue" style="cursor:pointer;" id="SubmitFile">Submit</a></div>
			</form>
		</div>
	</div>
</div>