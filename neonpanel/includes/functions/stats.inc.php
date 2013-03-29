<?php

class Stat extends CPHPDatabaseRecordClass {

	public $table_name = "stats";
	public $id_field = "id";
	public $fill_query = "SELECT * FROM stats WHERE `id` = :Id";
	public $verify_query = "SELECT * FROM stats WHERE `id` = :Id";
	public $query_cache = 1;
	
	public $prototype = array(
		'string' => array(
			'Type'		=> "type",
		),
		'numeric' => array(
			'Result' 	=> "result",
			'Timestamp' => "timestamp",
		)
	);
}
