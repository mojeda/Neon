<div id="setup" style="display:none;">
	{%if isempty|ErrorMessage == false}
		<div style="z-index: 670;" class="albox errorbox">
			{%?ErrorMessage}
			<a original-title="close" href="#" class="close tips">close</a>
		</div>
	{%/if}
	<div align="center" style="margin-bottom:15px;">
		Neon needs to collect some information about your website to setup your account for the first time.
		<br><br>
		<strong>NOTE:</strong> You can change these settings at any time!
	</div>
	<form id="form1" name="form1" method="post" action="setup.php?id=AddDomain">
        <span class="st-labeltext" style="width:85px">Your Domain:</span>
        <input name="domain" type="text" class="st-forminput" id="textfield1" style="width:178px;margin-left:2px;" value="www.domain.com" onclick="this.value='';" />
        <div class="clear"></div><br>
		<span class="st-labeltext" style="width:85px;">Stats Email*:</span>
            <select name="select" class="uniform" id="uniform-select1" style="width:150px;">
				<option value="1">Daily</option>
                <option value="7" selected="selected">Weekly</option>
				<option value="14">Twice Monthly</option>
				<option value="30">Monthly</option>
				<option value="0">Never</option>
			</select>
        <div class="clear"></div> 
		<div align="center" style="margin-top:20px;">
			<input type="submit" name="button" id="button" value="Finish Setup >>" class="st-button"/>
		</div>
	</form>
	<div align="center" style="margin-top:20px;">*How often Neon sends you statistics info on your site.</div>
</div>