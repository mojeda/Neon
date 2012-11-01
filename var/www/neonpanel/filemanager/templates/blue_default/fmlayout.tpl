<div class="simplebox grid740" style="margin-top:10px;">
	<div class="titleh">
		<h3>File Manager</h3>
		{%if AllowBack == true}
			<div class="shortcuts-down">
				<a class="shortcut tips" href="#" id="UpDirectory" title="Back Directory"><img src="./templates/blue_default/img/icons/shortcut/back.png" width="25" height="25" alt="icon" /></a>
			</div>
		{%/if}
		<div class="shortcuts-icons">
			<a class="shortcut tips" href="#" title="Upload" id="Upload"><img src="./templates/blue_default/img/icons/shortcut/upload.png" width="25" height="25" alt="icon" /></a>
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
				"aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
				"iDisplayLength": {%?MaxListFiles},
				"bStateSave": true,
				"oLanguage": {
				"sEmptyTable": "Directory Empty"
				}
			});
			$("#ReloadFileManager").click(function() {
				$("#LoadingImage").css({visibility: "visible"});
				$(".tipsy").remove();
				$.getJSON("filemanager.php?ajax=1",function(result){
					$("#FileManager").html(result.content);
					$("#LoadingImage").css({visibility: "hidden"});
				});
			});
			$.post('ajax/test.html', function(result) {
				$('.result').html(result);
			});
			$(".directory").click(function() {
				var directory = $(this).attr("value");
				$("#LoadingImage").css({visibility: "visible"});
				$.getJSON("filemanager.php?ajax=1&up=" + directory + "",function(result){
					$("#FileManager").html(result.content);
					$("#LoadingImage").css({visibility: "hidden"});
				});
			});
			$("#UpDirectory").click(function() {
				$("#LoadingImage").css({visibility: "visible"});
				$.getJSON("filemanager.php?ajax=1&back=1",function(result){
					$("#FileManager").html(result.content);
					$("#LoadingImage").css({visibility: "hidden"});
				});
			});
			$("#NewFolderOpen").click(function(){
				$("#NewFolderForm").modal({containerCss:{width:"400", height:"200"}});
			});
			$('#SubmitFolder').click(function() {
				var folder = $("#FolderName").val();
				$('#FormSubmitFolder').html('<a class="button-blue" name="SubmitFolder" />Please Wait...</a>');
				if(!folder){
					$('#FormSubmitFolder').html('<a class="button-blue" name="SubmitFolder" id="SubmitFolder" />Add Folder</a>');
				}
				else {
					$.modal.close();
					$("#LoadingImage").css({visibility: "visible"});
					$('#filemanager').dataTable().fnAddData( [
						'<a href="#" class="directory" value="' + folder + '"><img src="./templates/blue_default/img/icons/shortcut/folder.png" alt="Directory"></img></a><a style="display:none;">Directory</a>',
						folder,
						'4.0K',
						'',
					]);
					$.getJSON("filemanager.php?ajax=1&add_folder=" + folder + "",function(result){
						$("#FileManager").html(result.content);
						$("#LoadingImage").css({visibility: "hidden"});
					});
				}
			});
			$("#NewFileOpen").click(function(){
				$("#NewFileForm").modal({containerCss:{width:"400", height:"200"}});
			});
			$('#SubmitFile').click(function() {
				var file = $("#FileName").val();
				$('#FormSubmitFile').html('<a class="button-blue" name="SubmitFile" />Please Wait...</a>');
				if(!file){
					$('#FormSubmitFile').html('<a class="button-blue" name="SubmitFile" id="SubmitFile" />Add Folder</a>');
				}
				else {
					$.modal.close();
					$("#LoadingImage").css({visibility: "visible"});
					$('#filemanager').dataTable().fnAddData( [
						'<img src="./templates/blue_default/img/icons/shortcut/file.png" alt="File"></img><a style="display:none;">File</a>',
						file,
						'1.0B',
						'<a original-title="Edit" href="filemanager.php?editor=1&file={%?FilePath}' + file + '" target="_blank" class="icon-button tips" style="padding-left:5px;padding-right:5px;"><img src="./templates/blue_default/img/icons/32x32/pencil32.png" alt="icon" height="16" width="16"></a>',
					]);
					$.getJSON("filemanager.php?ajax=1&add_file=" + file + "",function(result){
						$("#FileManager").html(result.content);
						$("#LoadingImage").css({visibility: "hidden"});
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
						$("#LoadingImage").css({visibility: "visible"});
						$('#filemanager').dataTable().fnAddData( [
							'<a href="#" class="directory" value="' + folder + '"><img src="./templates/blue_default/img/icons/shortcut/folder.png" alt="Directory"></img></a><a style="display:none;">Directory</a>',
							folder,
							'4.0K',
							'',
						]);
						$.getJSON("filemanager.php?ajax=1&add_folder=" + folder + "",function(result){
							$("#FileManager").html(result.content);
							$("#LoadingImage").css({visibility: "hidden"});
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
						$("#LoadingImage").css({visibility: "visible"});
						$('#filemanager').dataTable().fnAddData( [
							'<img src="./templates/blue_default/img/icons/shortcut/file.png" alt="File"></img><a style="display:none;">File</a>',
							file,
							'1.0B',
							'<a original-title="Edit" href="filemanager.php?editor=1&file={%?FilePath}' + file + '" target="_blank" class="icon-button tips" style="padding-left:5px;padding-right:5px;"><img src="./templates/blue_default/img/icons/32x32/pencil32.png" alt="icon" height="16" width="16"></a>',
						]);
						$.getJSON("filemanager.php?ajax=1&add_file=" + file + "",function(result){
							$("#FileManager").html(result.content);
							$("#LoadingImage").css({visibility: "hidden"});
						});
					}
					return false;
				}
			});
			$(".DeleteFolder").click(function() {
				var folder = $(this).attr('rel');
				$("#DeleteFormType").html("folder");
				$("#DeleteFormValue").html(folder);
				$("#DeleteFormTitle").html("<h3>Delete Folder</h3>");
				$("#DeleteForm").modal({containerCss:{width:"400", height:"200"}});
			});
			$(".DeleteFile").click(function() {
				var file = $(this).attr('rel');
				$("#DeleteFormType").html("file");
				$("#DeleteFormValue").html(file);
				$("#DeleteFormTitle").html("<h3>Delete File</h3>");
				$("#DeleteForm").modal({containerCss:{width:"400", height:"200"}});
			});
			$("#ConfirmDelete").click(function() {
				var deletefile = $("#DeleteFormValue").text();
				$.modal.close();
				$("#LoadingImage").css({visibility: "visible"});
				$.getJSON("filemanager.php?ajax=1&delete=" + deletefile + "",function(result){
					$("#FileManager").html(result.content);
					$("#LoadingImage").css({visibility: "hidden"});
				});
			});
			$("#CancelDelete").click(function() {
				$.modal.close();
			});
			$("#Upload").click(function() {
				$("#UploadForm").modal({containerCss:{width:"500", height:"500"},
					onClose: function (dialog) {
						$("#LoadingImage").css({visibility: "visible"});
						$.getJSON("filemanager.php?ajax=1",function(result){
							$("#FileManager").html(result.content);
							$("#LoadingImage").css({visibility: "hidden"});
						});
						$.modal.close();
					}
				});
			});
			$(function() {
				var uploader = new plupload.Uploader({
					runtimes : 'html5,flash',
					browse_button : 'SelectFiles',
					container : 'UploadContainer',
					max_file_size : '{%?MaxPanelUploadSize}',
					url : 'filemanager.php?upload=1',
					flash_swf_url : 'templates/blue_default/img/plupload.flash.swf',
					resize : {width : 320, height : 240, quality : 90}
				});
				uploader.bind('Init', function(up, params) {});
				$('#UploadFiles').click(function(e) {
					uploader.start();
					e.preventDefault();
				});
				uploader.init();
				uploader.bind('FilesAdded', function(up, files) {
					$('#InstructionsUpload').remove();
					$.each(files, function(i, file) {
						$('#FileList').append(
						'<div id="' + file.id + '" style="z-index:630;width:65%;" class="albox dialogbox">' +
						file.name + ' (' + plupload.formatSize(file.size) + ') <b></b>' +
						'</div>');
					});
					up.refresh();
				});
				uploader.bind('UploadProgress', function(up, file) {
					$('#' + file.id + " b").html(file.percent + "%");
					$('#' + file.id).removeClass('albox dialogbox').addClass('albox warningbox');
				});
				uploader.bind('Error', function(up, err) {
					$('#FileList').append("<div>Error: " + err.code +
						", Message: " + err.message +
						(err.file ? ", File: " + err.file.name : "") +
						"</div>"
					);
					up.refresh();
				});
				uploader.bind('FileUploaded', function(up, file) {
					$('#' + file.id + " b").html("100%");
					$('#' + file.id).removeClass('albox dialogbox').addClass('albox succesbox');
				});
			});
		});
	</script>
<!-- End Data Tables Initialisation code -->
	<table cellpadding="0" cellspacing="0" border="0" class="display data-table" id="filemanager">
		<thead>
			<tr>
				<th width="5%"></th>
				<th width="58%">File Name</th>
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
						<a original-title="Delete" class="icon-button tips DeleteFolder" style="padding-left:5px;padding-right:5px;cursor:pointer;" rel="{%?directory[name]}"><img src="./templates/blue_default/img/icons/32x32/stop32.png" alt="icon" height="16" width="16"></a>
						<a original-title="Permissions" class="icon-button tips PermissionsFolder" style="padding-left:5px;padding-right:5px;cursor:pointer;" rel="{%?directory[name]}"><img src="./templates/blue_default/img/icons/32x32/lock32.png" alt="icon" height="16" width="16"></a>
						<a original-title="Rename / Move / Copy" class="icon-button tips MultiToolFolder" style="padding-left:5px;padding-right:5px;cursor:pointer;" rel="{%?directory[name]}"><img src="./templates/blue_default/img/icons/32x32/paperpencil32.png" alt="icon" height="16" width="16"></a>
						<a original-title="Download" href="filemanager.php?download_folder={%?FilePath}{%?directory[name]}" target="_blank" class="icon-button tips" style="padding-left:5px;padding-right:5px;"><img src="./templates/blue_default/img/icons/32x32/boxdownload32.png" alt="icon" height="16" width="16"></a>
					</td>
				</tr>
			{%/foreach}
			{%foreach file in Files}
				<tr class="gradeA">
					<td><img src="./templates/blue_default/img/icons/shortcut/file.png" alt="File"></img><a style="display:none;">File</a></td>
					<td>{%?file[name]}</td>
					<td>{%?file[size]}</td>
					<td>
						<a original-title="Delete" class="icon-button tips DeleteFile" style="padding-left:5px;padding-right:5px;cursor:pointer;" rel="{%?file[name]}"><img src="./templates/blue_default/img/icons/32x32/stop32.png" alt="icon" height="16" width="16"></a>
						<a original-title="Permissions" class="icon-button tips PermissionsFile" style="padding-left:5px;padding-right:5px;cursor:pointer;" rel="{%?file[name]}"><img src="./templates/blue_default/img/icons/32x32/lock32.png" alt="icon" height="16" width="16"></a>
						<a original-title="Rename / Move / Copy" class="icon-button tips MultiToolFile" style="padding-left:5px;padding-right:5px;cursor:pointer;" rel="{%?file[name]}"><img src="./templates/blue_default/img/icons/32x32/paperpencil32.png" alt="icon" height="16" width="16"></a>
						<a original-title="Download" href="filemanager.php?download_file={%?FilePath}{%?file[name]}" target="_blank"  class="icon-button tips" style="padding-left:5px;padding-right:5px;cursor:pointer;"><img src="./templates/blue_default/img/icons/32x32/boxdownload32.png" alt="icon" height="16" width="16"></a>
						<a original-title="Edit" href="filemanager.php?editor=1&file={%?FilePath}{%?file[name]}" target="_blank" class="icon-button tips" style="padding-left:5px;padding-right:5px;"><img src="./templates/blue_default/img/icons/32x32/pencil32.png" alt="icon" height="16" width="16"></a>
					</td>
				</tr>
			{%/foreach}
		</tbody>
	</table>
</div>
<div id="NewFolderForm" style="display:none;" align="center">
	<div style="z-index: 610;" class="simplebox">
        <div style="z-index: 600;" class="titleh" align="center"><h3>Add Folder</h3></div>
		<div style="z-index: 590;" class="body padding10">
			<div style="height:120px;">
				<form id="form1" name="form1" class="SubmitFolder">	
                    Folder Name: <input name="folder" class="st-forminput" id="FolderName" style="width:150px" value="" type="text"> 
					<div style="padding:12px;"></div>
					<div align="center" style="margin-bottom:5px;" id="FormSubmitFolder"><a class="button-blue" style="cursor:pointer;" id="SubmitFolder">Submit</a></div>
				</form>
			</div>
		</div>
	</div>
</div>
<div id="NewFileForm" style="display:none;height:145px;" align="center">
	<div style="z-index: 610;" class="simplebox">
        <div style="z-index: 600;" class="titleh" align="center"><h3>Add File</h3></div>
		<div style="z-index: 590;" class="body padding10">
			<div style="height:120px;">
				<form id="form2" name="form2" class="SubmitFile">	
						File Name: <input name="file" class="st-forminput" id="FileName" style="width:150px" value="" type="text"> 
						<div style="padding:12px;"></div>
					<div align="center" style="margin-bottom:5px;" id="FormSubmitFile"><a class="button-blue" style="cursor:pointer;" id="SubmitFile">Submit</a></div>
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
				<form id="form3" name="form3" class="Delete">	
						Do you want to delete the <a style="color:#737F89;" id="DeleteFormType"></a> <a style="color:#737F89;" id="DeleteFormValue"></a>?
						<div style="padding:12px;"></div>
					<div align="center" style="margin-bottom:5px;" id="FormDelete"><a class="button-blue" style="cursor:pointer;" id="ConfirmDelete">Yes</a> <a class="button-blue" style="cursor:pointer;" id="CancelDelete">No</a></div>
				</form>
			</div>
		</div>
	</div>
</div>
<div id="UploadForm" style="display:none;" align="center">
	<div style="z-index: 610;" class="simplebox">
        <div style="z-index: 600;" class="titleh" align="center" id="UploadFormTitle"><h3>Upload File</h3></div>
		<div style="z-index: 590;" class="body padding10">
			<form id="form4" name="form4" class="Upload">	
				<div id="UploadContainer" style="height:395px;max-height:395px;">
					<div id="InstructionsUpload" align="center">Use Select Files to select all of the files you wish to upload, then press Upload Files. Wait until every file listed has finished uploading, then close this window.</div>
					<div id="FileList" style="overflow:auto;max-height:350px;" align="center"></div>
					<br />
					<div style="position:absolute;left:25px;right:25px;bottom:0;">
							<a class="button-blue" style="cursor:pointer;" id="SelectFiles">Select Files</a>
							<a class="button-blue" style="cursor:pointer;" id="UploadFiles">Upload Files</a>
					</div>
				</div>
				<div style="padding:12px;"></div>
			</form>
		</div>
	</div>
</div>