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
          ['Year', 'Sales', 'Expenses'],
          ['2004',  1000,      400],
          ['2005',  1170,      460],
          ['2006',  660,       1120],
          ['2007',  1030,      540]
        ]);

        var options = {
          title: 'Company Performance',
          hAxis: {title: 'Year',  titleTextStyle: {color: 'red'}}
        };

        var chart = new google.visualization.AreaChart(document.getElementById('chart_div'));
        chart.draw(data, options);
      }
    </script>
	<div class="grid740">
		<div class="simplebox">
			<div class="titleh"><h3>System RAM Usage</h3></div>
			<div class="body padding10">
				<div align="center">
					<div id="chart_div" style="width: 700px; height: 300px;"></div>
				</div>
			</div>
		</div>
	</div>
</div>