<?php

class Domain extends CPHPDatabaseRecordClass {

	public $table_name = "domains";
	public $id_field = "id";
	public $fill_query = "SELECT * FROM domains WHERE `id` = :Id";
	public $verify_query = "SELECT * FROM domains WHERE `id` = :Id";
	public $query_cache = 1;
	
	public $prototype = array(
		'string' => array(
			'Name'			=> "domain_name"
		),
		'boolean' => array(
			'Active'		=> "active"
		),
		'numeric' => array(
			'Owner'			=> "user_id"
		)
	);
	
	public static function AddDomain($uDomainName){
	global $sWriteLog;
	global $sUser;
		$sDomain = new Domain(0);
		$sDomain->uName = $uDomainName;
		$sDomain->uOwner = $sUser->sId;
		$sDomain->uActive = 1;
		$sDomain->InsertIntoDatabase();
		fwrite($sWriteLog, 'Updated User: '.$sUser->sUsername.' - Added domain: '.$uDomainName.PHP_EOL);
	}
}
