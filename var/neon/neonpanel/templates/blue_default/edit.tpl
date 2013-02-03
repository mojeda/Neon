<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Neon - Editing: {%?FileName}</title>
    <link rel="stylesheet" href="templates/blue_default/js/lib/codemirror.css">
    <script src="templates/blue_default/js/lib/codemirror.js"></script>
	<script src="templates/blue_default/js/jquery.min.js"></script>
    <link rel="stylesheet" href="templates/blue_default/style/theme/erlang-dark.css">
    <link rel="stylesheet" href="templates/blue_default/style/theme/night.css">
    <link rel="stylesheet" href="templates/blue_default/style/theme/monokai.css">
    <link rel="stylesheet" href="templates/blue_default/style/theme/rubyblue.css">
    <link rel="stylesheet" href="templates/blue_default/style/theme/lesser-dark.css">
    <link rel="stylesheet" href="templates/blue_default/style/theme/xq-dark.css">
    <link rel="stylesheet" href="templates/blue_default/style/theme/ambiance.css">
    <link rel="stylesheet" href="templates/blue_default/style/theme/blackboard.css">
    <link rel="stylesheet" href="templates/blue_default/style/theme/vibrant-ink.css">
    <link rel="stylesheet" type="text/css" href="templates/blue_default/style/reset.css" /> 
    <link rel="stylesheet" type="text/css" href="templates/blue_default/style/root.css" /> 
    <link rel="stylesheet" type="text/css" href="templates/blue_default/style/grid.css" /> 
    <link rel="stylesheet" type="text/css" href="templates/blue_default/style/typography.css" /> 
    <link rel="stylesheet" type="text/css" href="templates/blue_default/style/jquery-ui.css" />
    <link rel="stylesheet" type="text/css" href="templates/blue_default/style/jquery-plugin-base.css" />
	<link rel="stylesheet" type="text/css" href="templates/blue_default/style/basic.css" />
    <!--[if IE 7]>	  <link rel="stylesheet" type="text/css" href="templates/blue_default/style/ie7-style.css" />	<![endif]-->
	<!--[if lt IE 7]> <link type='text/css' href='css/basic_ie.css' rel='stylesheet' media='screen' /> <![endif]-->
	<script type="text/javascript" src="templates/blue_default/js/jquery.simplemodal.js"></script>
    <style type="text/css">
		.CodeMirror {border: 1px solid black; font-size:13px; max-height:95%;}
		.CodeMirror-scroll {
			min-height: 100%; /* the minimum height */
		}
		html, body {margin: 0; padding: 0; height:90%;}
		#FileEditor, #FileEditor textarea { height: 90%; width:100%; clear:both; }
		#container { min-width:1000px; width: auto !important; width: 100%; }
		#element1 {
			float: left;
			width: 50%;
			padding-top: 5px;
			padding-bottom:5px;
		}
		#element2 {
			float: left;
			width: 50%;
			padding-top:12px;
			padding-bottom:5px;
			text-align:right;
		}
    </style>
  </head>
  <body onload="selectTheme()">
<div id="container">
	<div id="element1">
		<strong>&nbsp;File Path: </strong><input style="width:250px" type="text" value="{%?FilePath}" id="filepath"><a class="button-blue" style="cursor:pointer;" id="ChangeFile">Go</a>
		<z style="padding:20px";"></z>
		<strong>Theme: </strong><select onchange="selectTheme()" id=select>
				<option{%if DefaultEditorTheme == default} selected{%/if}>default</option>
				<option{%if DefaultEditorTheme == ambiance} selected{%/if}>ambiance</option>
				<option{%if DefaultEditorTheme == blackboard} selected{%/if}>blackboard</option>
				<option{%if DefaultEditorTheme == erlang-dark} selected{%/if}>erlang-dark</option>
				<option{%if DefaultEditorTheme == lesser-dark} selected{%/if}>lesser-dark</option>
				<option{%if DefaultEditorTheme == monokai} selected{%/if}>monokai</option>
				<option{%if DefaultEditorTheme == night} selected{%/if}>night</option>
				<option{%if DefaultEditorTheme == rubyblue} selected{%/if}>rubyblue</option>
				<option{%if DefaultEditorTheme == vibrant-inc} selected{%/if}>vibrant-ink</option>
				<option{%if DefaultEditorTheme == xq-dark} selected{%/if}>xq-dark</option>
			</select>
	</div>
	<div id="element2">
		<a id="status" style="display:none;"></a>&nbsp;&nbsp;&nbsp;&nbsp;<a class="button-blue" style="cursor:pointer;" id="SaveClose">Save File & Close Editor</a><a style="cursor:pointer;" class="button-blue" id="SaveFile">Save File</a>
	</div>
</div>
<div id="FileEditor"><form><textarea id="UserCode" name="code" class="UserCode">{%?FileContent}</textarea></form></div>
<div id="ChangeFileForm" style="display:none;" align="center">
	<div style="z-index: 610;" class="simplebox">
        <div style="z-index: 600; margin-top:0;" class="titleh" align="center"><h3>Warning</h3></div>
		<div style="z-index: 590;" class="body padding10">
			<form id="form1" name="form1" class="SubmitFile">	
                    Before loading a new file please make sure you have saved your current work in this file.
					<div style="padding:12px;"></div>
				<div align="center" style="margin-bottom:25px;"><a class="button-blue" style="cursor:pointer;" id="ReloadFile">Open New File</a></div>
				<div align="center" style="margin-bottom:5px;"><a class="button-blue" style="cursor:pointer;" id="SaveReloadFile">Save This File & Open New File</a></div>
			</form>
		</div>
	</div>
</div>
<script>
var editor = CodeMirror.fromTextArea(document.getElementById("UserCode"), {
	lineNumbers: true
});
var input = document.getElementById("select");
function selectTheme() {
	var theme = input.options[input.selectedIndex].innerHTML;
	editor.setOption("theme", theme);
	$.post("post_settings.php?id=DefaultEditorTheme",{theme: theme},function(result){
	});
}
var choice = document.location.search && document.location.search.slice(1);
if (choice) {
	input.value = choice;
    editor.setOption("theme", choice);
}
var browserHeight = document.documentElement.clientHeight;
editor.getWrapperElement().style.height = (0.94 * browserHeight) + 'px';
editor.refresh();
</script>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#SaveFile").click(function() {
				var content = editor.getValue();
				$.post("filemanager.php?request={%?FilePath}&action=editor&save=1",{content: content},function(result){
					$("#status").html('<a class="albox succesbox" style="width:180px;height:15px;padding:7px;background:#EBF9E2;">' + result + '</a>');
					$('#status').fadeIn(1000).delay(500).fadeOut(4000);
				});
			});
			$("#SaveClose").click(function() {
				var content = editor.getValue();
				$.post("filemanager.php?request={%?FilePath}&action=editor&save=1",{content: content},function(result){
					$("#status").html('<a class="albox succesbox" style="width:180px;height:15px;padding:7px;background:#EBF9E2;">' + result + '</a>');
					$('#status').fadeIn(1000).delay(500).fadeOut(4000);
					window.close();
				});
			});
			$("#ChangeFile").click(function() {
				$("#ChangeFileForm").modal({containerCss:{width:"290", height:"190"}});
			});
			$("#ReloadFile").click(function() {
				var file = $("#filepath").val();
				window.location.href = "filemanager.php?request=" + file + "&action=editor";
			});
			$("#SaveReloadFile").click(function() {
				var content = editor.getValue();
				$.post("filemanager.php?request={%?FilePath}&action=editor&save=1",{content: content},function(result){
				});
				var file = $("#filepath").val();
				window.location.href = "filemanager.php?request=" + file + "&action=editor";
			});
		});
</script>
  </body>
</html>