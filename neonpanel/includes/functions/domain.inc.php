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
	
	public static function AddDomain($uDomain){
		global $sUser;
		global $sDefaultIP;
		global $user_ssh;
		global $user_sftp;
		global $database;

		// Filter Domain
		$uDomain = preg_replace("/[^a-z0-9_ .-]/i", "", $uDomain);
		$uDomain = str_replace("www.", "", $uDomain);
		$sDomain = str_replace("http://", "", $uDomain);
		
		$result = $database->CachedQuery("SELECT * FROM domains WHERE `domain_name` = :Domain", array(':Domain' => $sDomain), 5);
		
		if(empty($result)){
		
			// Validate path information
			$sUser->sRootDir = '/home/'.$sUser->sUsername.'/';
			$sValidate = new PathValidator($sUser->sRootDir.$sDomain);
			if($sValidate->ValidatePath($sUser->sRootDir)){
			
				// Connect to server
				if(!$user_ssh->login($sUser->sUsername, $_SESSION['password'])) { exit('User Connection To Server Failed!');}
				if(!$user_sftp->login($sUser->sUsername, $_SESSION['password'])) { exit('User Connection To Server Failed!');}
		
				// Create folders for domain & logs
				$sPublic = $sUser->sRootDir.$sDomain."/public_html/";
				$sLogs = $sUser->sRootDir."/logs/";
				$sCreateFolder = $user_ssh->exec("mkdir ".escapeshellarg($sUser->sRootDir.$sDomain).";mkdir ".escapeshellarg($sPublic).";mkdir ".escapeshellarg($sLogs).";");
		
				// Generate configs
				$sReplace = array("domain_name" => $sDomain, "username" => $sUser->sUsername);
				$sConfig = file_get_contents('./includes/configs/nginx.default.conf');
				foreach($sReplace as $key => $value){	
					$sConfig = str_replace($key, $value, $sConfig);
				}
				$sFileContent = $user_sftp->put('/etc/nginx/sites-enabled/'.$sDomain.'.conf', $sConfig);
				$sTestConfig = $user_ssh->exec("nginx -t -c /etc/nginx/nginx.conf");
				if(strpos($sTestConfig, 'failed') !== false){
					$sDeleteConfig = $user_ssh->exec("rm -rf /etc/nginx/sites-enabled/".$sDomain.".conf");
					die("Seems to be a problem setting up the config.");
				}
				$sReload = $user_ssh->exec("/etc/init.d/nginx reload");
		
				// Insert Domain Into Database
				$sCreateDomain = new Domain(0);
				$sCreateDomain->uName = $uDomain;
				$sCreateDomain->uOwner = $sUser->sId;
				$sCreateDomain->uActive = 1;
				$sCreateDomain->InsertIntoDatabase();
		
				// Add DNS Records
				$sResultOne = $database->CachedQuery("INSERT INTO dns.domains (name, type) VALUES(:Domain, 'NATIVE')", array(':Domain' => $sDomain));
				$sDomainId = $database->lastInsertId();
				$sResultTwo = $database->CachedQuery("INSERT INTO dns.records (domain_id, name, content, type, ttl, prio) VALUES(:Id, :Domain, :IPAddress, 'A', '120', 'NULL')", array(':Id' =>  $sDomainId, ':Domain' => $sDomain, ':IPAddress' => $sDefaultIP->sValue));
				return true;
			} else {
				return false;
			}
		} else {
			return false;
		}
	}
	
	public static function RemoveDomain($uDomain){
		global $sUser;
		global $sDefaultIP;
		global $user_ssh;
		global $user_sftp;
		global $database;
		
		// Filter domain
		$uDomain = preg_replace("/[^a-z0-9_ .-]/i", "", $uDomain);
		$uDomain = str_replace("www.", "", $uDomain);
		$sDomain = str_replace("http://", "", $uDomain);
		
		// Check to see if domain exists and user owns it
		
	}
}
