<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Neon - Editing: {%?FileName}</title>
    <link rel="stylesheet" href="templates/blue_default/js/lib/codemirror.css">
    <script src="templates/blue_default/js/lib/codemirror.js"></script>
	<link rel="stylesheet" href="templates/blue_default/style/root.css" /> 
    <link rel="stylesheet" href="templates/blue_default/style/theme/erlang-dark.css">
    <link rel="stylesheet" href="templates/blue_default/style/theme/night.css">
    <link rel="stylesheet" href="templates/blue_default/style/theme/monokai.css">
    <link rel="stylesheet" href="templates/blue_default/style/theme/rubyblue.css">
    <link rel="stylesheet" href="templates/blue_default/style/theme/lesser-dark.css">
    <link rel="stylesheet" href="templates/blue_default/style/theme/xq-dark.css">
    <link rel="stylesheet" href="templates/blue_default/style/theme/ambiance.css">
    <link rel="stylesheet" href="templates/blue_default/style/theme/blackboard.css">
    <link rel="stylesheet" href="templates/blue_default/style/theme/vibrant-ink.css">
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
	<script type="text/javascript">
		$(document).ready(function() {
			$("#save").click(function() {
				var content = $('#code').val();
				$.post("filemanager.php?editor=1&file={%?FilePath}{%?FileName}&save=1", { content: content } );
			});
		});
</script>
  </head>
  <body>
<div id="container">
	<div id="element1">
		<strong>&nbsp;File Path: </strong><input style="width:250px" type="text" value="{%?FilePath}">
		<z style="padding:20px";"></z>
		<strong>Theme: </strong><select onchange="selectTheme()" id=select>
				<option selected>default</option>
				<option>ambiance</option>
				<option>blackboard</option>
				<option>erlang-dark</option>
				<option>lesser-dark</option>
				<option>monokai</option>
				<option>night</option>
				<option>rubyblue</option>
				<option>vibrant-ink</option>
				<option>xq-dark</option>
			</select>
	</div>
	<div id="element2">
		<a class="button-blue" id="SubmitFolder">Save File & Close Editor</a><a class="button-blue" id="SubmitFolder">Save File</a>
	</div>
</div>
<div id="FileEditor"><form><textarea id="code" name="code">{%?FileContent}</textarea></form></div>

<script>
var editor = CodeMirror.fromTextArea(document.getElementById("code"), {
	lineNumbers: true
});
var input = document.getElementById("select");
function selectTheme() {
	var theme = input.options[input.selectedIndex].innerHTML;
	editor.setOption("theme", theme);
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
  </body>
</html>