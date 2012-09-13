<?php

class Plan extends CPHPDatabaseRecordClass {

	public $table_name = "plans";
	public $id_field = "id";
	public $fill_query = "SELECT * FROM plans WHERE `id` = :Id";
	public $verify_query = "SELECT * FROM plans WHERE `id` = :Id";
	public $query_cache = 1;
	
	public $prototype = array(
		'string' => array(
			'Name'			=> "name"
		),
		'numeric' => array(
			'MaxDomains'			=> "max_domains",
			'MaxParkedDomains'		=> "max_parked_domains"
		)
	);
	
	public static function CheckUserPlan($uPlanValue){
	global $sUser;
	// This will check the accounts table to find out the user's plan then compare the used space with the total available space on the plan.
	// If the user can have that additional resource this function will return true, if not false.
	}
}