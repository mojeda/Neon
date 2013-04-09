{%if InitialSetup == false}
	<script type="text/javascript">
	$(document).ready(function(){
		$("#InitialSetup").modal({close:false});
		$('#SetupForm').ajaxForm(function() {
			$('#formsubmit').replaceWith('<input type="sname="button" disabled="disabled" id="submitsetupbutton" value="Please Wait..." class="st-button"/>');
				$.modal.close();
			$("#InitialSetup").css("display", "none");
         }); 
	});
	</script>
	{%?InitialSetupContent}
	<div id="setup"></div>
{%/if}
{%if WelcomeClosed == false}
	<script type="text/javascript">
		$(document).ready(function(){
			$("#RemoveWelcome").click(function(){
				$("#Welcome").remove();
				$.post("post_settings.php?id=WelcomeClosed");
			});
		});
	</script>
{%/if}
<div align="center" class="LaunchSetup">
{%if WelcomeClosed == false}
	<div style="z-index: 140;padding-top:10px;" class="simplebox grid740" id="Welcome">
       <div style="z-index: 130;" class="titleh"><div align="left"><h3>Welcome</h3></div>
            <div style="z-index: 120;" class="shortcuts-icons">
				<a class="shortcut tips" href="#">
					<img src="templates/blue_default/img/icons/shortcut/close.png" alt="icon" height="25" width="25" id="RemoveWelcome">
				</a>
			</div>
        </div>
        <div style="z-index: 110;padding:5px 5px 5px 5px;" class="body" align="left">
            Welcome To NEON,<br><br>
			To get started developing your website use the menus to the left and the menus below this box to navigate through various potrtions of the control panel. If your new to NEON please review our <a href="getting-started.php" target="_blank">getting started guide</a>, which is filled with tutorials and videos demonstrating how to administrate your website.<br><br>
        </div>
    </div>
{%/if}
    <script type="text/javascript">
      google.load("visualization", "1", {packages:["corechart"]});
      google.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['Minutes Ago', 'Free', 'Total'],
		  {%foreach entry in RAM}
			['{%?entry[name]}', {%?entry[used]}, {%?entry[total]}],
		  {%/foreach}
        ]);

        var options = {
          title: '',
          hAxis: {title: 'Minutes Ago'}
        };

        var chart = new google.visualization.AreaChart(document.getElementById('ramusage'));
        chart.draw(data, options);
      }
    </script>
	<script type="text/javascript">
      google.load("visualization", "1", {packages:["corechart"]});
      google.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['Minutes Ago', 'Load'],
		  {%foreach entry in Load}
			['{%?entry[name]}', {%?entry[AVG]}],
		  {%/foreach}
        ]);

        var options = {
          title: '',
          hAxis: {title: 'Minutes Ago'}
        };

        var chart = new google.visualization.AreaChart(document.getElementById('systemload'));
        chart.draw(data, options);
      }
	$.getJSON("pull_news.php",function(result){
		$("#news").html(result.content);
	});
    </script>
	<div class="grid740">
		<div class="simplebox">
			<div class="titleh"><h3>Neon Update Center</h3></div>
			<div class="body padding10">
				<div id="news" align="left"></div>
			</div>
		</div>
	</div>
	<div class="grid740">
		<div class="simplebox">
			<div class="titleh"><h3>System Load Average</h3></div>
			<div class="body padding10">
				<div align="center">
					<div id="systemload" style="width: 700px; height: 200px;"></div>
				</div>
			</div>
		</div>
	</div>
	<div class="grid740">
		<div class="simplebox">
			<div class="titleh"><h3>System RAM Usage</h3></div>
			<div class="body padding10">
				<div align="center">
					<div id="ramusage" style="width: 700px; height: 200px;"></div>
				</div>
			</div>
		</div>
	</div>
</div>