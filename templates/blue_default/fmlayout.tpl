<div class="simplebox grid740">
	<div class="titleh">
		<h3>File Manager</h3>
		<div class="shortcuts-down">
		<a class="shortcut tips" href="#" title="Info About This Widget"><img src="./templates/blue_default/img/icons/shortcut/question.png" width="25" height="25" alt="icon" /></a>
		</div>
		<div class="shortcuts-icons">
		<a class="shortcut tips" href="#" title="Info About This Widget"><img src="./templates/blue_default/img/icons/shortcut/question.png" width="25" height="25" alt="icon" /></a>
		<a class="shortcut tips" href="#" title="Add Folder"><img src="./templates/blue_default/img/icons/shortcut/addfolder.png" width="25" height="25" alt="icon" /></a>
		<a class="shortcut tips" href="#" title="Add File"><img src="./templates/blue_default/img/icons/shortcut/addfile.png" width="25" height="25" alt="icon" /></a>
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
		});
	</script>
<!-- End Data Tables Initialisation code -->
	<table cellpadding="0" cellspacing="0" border="0" class="display data-table" id="filemanager">
		<thead>
			<tr>
				<th width="5%"></th>
				<th width="70%">File Name</th>
				<th width="10%">Size</th>
				<th width="20%">Actions</th>
			</tr>
		</thead>
		<tbody>
			{%foreach directory in Directories}
				<tr class="gradeA">
					<td width="10" class="directory" value="{%?directory[name]}"><img src="./templates/blue_default/img/icons/shortcut/folder.png" alt="Directory"></img><a style="display:none;">Directory</a></td>
					<td>{%?directory[name]}</td>
					<td>{%?directory[size]}</td>
					<td>Buttons Here</td>
				</tr>
			{%/foreach}
			{%foreach file in Files}
				<tr class="gradeA">
					<td><img src="./templates/blue_default/img/icons/shortcut/file.png" alt="File"></img><a style="display:none;">File</a></td>
					<td>{%?file[name]}</td>
					<td>{%?file[size]}</td>
					<td>Buttons Here</td>
				</tr>
			{%/foreach}
		</tbody>
	</table>
</div>