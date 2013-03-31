<div align="center" class="DomainManagerHome">
	<div class="simplebox grid740">
		<div class="titleh">
			<h3>Domain Management</h3>
			<div class="shortcuts-icons">
				<a class="shortcut tips" href="#" title="Add New Item"><img src="img/icons/shortcut/plus.png" width="25" height="25" alt="icon" /></a>
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
							<td><div align="center"><a original-title="Delete" class="icon-button tips DeleteDomain" style="padding-left:5px;padding-right:5px;cursor:pointer;" rel="{%?domain[name]}"><img src="./templates/blue_default/img/icons/32x32/stop32.png" alt="icon" height="16" width="16"></a></div></td> 
						</tr> 
					{%/foreach}
				{%/if}
			</tbody> 
		</table>
	</div>
</div>