<div align="center" class="MysqlDatabasesHome">
	<div class="simplebox grid740">
		<div class="titleh">
			<h3>Mysql Databases</h3>
			<div class="shortcuts-icons">
				<a class="shortcut tips" href="#" title="Add New Item"><img src="./templates/blue_default/img/icons/shortcut/plus.png" width="25" height="25" alt="icon" /></a>
			</div>
		</div>
		<table id="DatabaseTable" class="tablesorter"> 
			<thead> 
				<tr> 
					<th style="width:85%">Database Name</th> 
					<th>Actions</th> 
				</tr> 
			</thead> 
			<tbody>
				{%if isempty|DatabaseList == true}
					<tr>
						<td colspan="2">
							<div align="center">You currently have no databases</div>
						</td>
					</tr>
				{%/if}
				{%if isempty|DatabaseList == false}
					{%foreach database in DatabaseList}
						<tr> 
							<td>{%?database}</td> 
							<td>
								<div align="center">
									<a original-title="Delete" class="icon-button tips DeleteDatabase" style="padding-left:5px;padding-right:5px;cursor:pointer;" rel="{%?database}"><img src="./templates/blue_default/img/icons/32x32/stop32.png" alt="icon" height="16" width="16"></a>
									<a original-title="Rename" class="icon-button tips RenameDatabase" style="padding-left:5px;padding-right:5px;cursor:pointer;" rel="database"><img src="./templates/blue_default/img/icons/32x32/paperpencil32.png" alt="icon" height="16" width="16"></a>
								</div>
							</td> 
						</tr>
					{%/foreach}
				{%/if}
			</tbody> 
		</table>
	</div>
</div>