<?php

class User extends CPHPDatabaseRecordClass {

	public $table_name = "accounts";
	public $id_field = "id";
	public $fill_query = "SELECT * FROM accounts WHERE `id` = :Id";
	public $verify_query = "SELECT * FROM accounts WHERE `id` = :Id";
	public $query_cache = 1;
	
	public $prototype = array(
		'string' => array(
			'Username' 	    => "username",
			'EmailAddress'	    => "email",
			'ActivationCode'    => "activation_code",
			'Plan'		=>	"plan",
			'DefaultEditorTheme'	=>	"default_editor",
		),
		'numeric' => array(
			'StatsEmail'	=>	"stats_email",
			'MaxListFiles'	=>	"max_list_files",
		),
		'boolean' => array(
			'Active' 	=> "active",
			'InitialSetup'	=>	"initial_setup",
			'WelcomeClosed'	=>	"welcome_closed",
		)
	);
	
	public static function login($uUsername, $uPassword){
		global $database;
		global $user_ssh;
		if($result = $database->CachedQuery("SELECT * FROM accounts WHERE (`email` = :Username || `username` = :Username) && `active` = :Active", array(
		':Username' => $uUsername, ':Active' => '1'), 5)){
			$sUser = new User($result);
				$_SESSION['user_id'] = $sUser->sId;
				$_SESSION['username'] = $sUser->sUsername;
				$uPassword = stripslashes(str_replace("'", '', $uPassword));
				$_SESSION['password'] = $uPassword;
				if (!$user_ssh->login($sUser->sUsername, $uPassword)) {
					return "Invalid Login";
				}
				header("Location: main.php");
				die();
		} else {
			return "Invalid Login.";
		}
	}
}
