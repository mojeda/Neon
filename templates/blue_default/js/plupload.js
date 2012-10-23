$(function() {
	var uploader = new plupload.Uploader({
		runtimes : 'html5,flash',
		browse_button : 'SelectFiles',
		container : 'Uploads',
		max_file_size : '{%?MaxPanelUploadSize}',
		url : 'filemanager.php?upload=1',
		flash_swf_url : 'templates/blue_default/img/plupload.flash.swf',
		resize : {width : 320, height : 240, quality : 90}
	});
	uploader.bind('Init', function(up, params) {});
	$('#UploadedFiles').click(function(e) {
		uploader.start();
		e.preventDefault();
	});
	uploader.init();
	uploader.bind('FilesAdded', function(up, files) {
		$.each(files, function(i, file) {
			$('#FileList').append(
				'<div id="' + file.id + '">' +
				file.name + ' (' + plupload.formatSize(file.size) + ') <b></b>' +
			'</div>');
		});

		up.refresh(); // Reposition Flash/Silverlight
	});
	uploader.bind('UploadProgress', function(up, file) {
		$('#' + file.id + " b").html(file.percent + "%");
	});
	uploader.bind('Error', function(up, err) {
		$('#FileList').append("<div>Error: " + err.code +
			", Message: " + err.message +
			(err.file ? ", File: " + err.file.name : "") +
			"</div>"
		);

		up.refresh(); // Reposition Flash/Silverlight
	});
	uploader.bind('FileUploaded', function(up, file) {
		$('#' + file.id + " b").html("100%");
	});
});