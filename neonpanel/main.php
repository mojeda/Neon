<?php
include('./includes/loader.php');

	if($LoggedIn === false){
		header("Location: index.php");
		die();
	} else {
	
		function check_set($var){
			if(!empty($var)){
				return $var;
			} else {
				return 0;
			}
		}
		
		if($sUser->sInitialSetup == 0){
			if(!$result = $database->CachedQuery("SELECT * FROM mysql.user WHERE `User` = :Username", array(':Username' => $sUser->sUsername), 1)){
				$result = $database->CachedQuery("CREATE USER :Username@'localhost' IDENTIFIED BY :Password", array(':Username' => $sUser->sUsername, ':Password' => $_SESSION['password']), 1);
				$result = $database->CachedQuery("REVOKE ALL PRIVILEGES, GRANT OPTION FROM :Username", array(':Username' => $sUser->sUsername), 1);
			}
			$sInitialSetupContent = Templater::AdvancedParse('/blue_default/setup', $locale->strings, array(
			'PanelTitle'  => $sPanelTitle->sValue,
			'ErrorMessage'	=>	"",
			'Username'	=>	$sUser->sUsername,
			'InitialSetup'	=>	$sUser->sInitialSetup
			));
		} else {
			$sInitialSetupContent = "";
		}
		
		$sUsedMemory = $database->CachedQuery("SELECT * FROM stats WHERE type='used_memory' ORDER BY id DESC LIMIT 60", array(), 1);
		foreach($sUsedMemory->data as $key => $value){
			$sUsed[] = $value["result"];
		}
		$sTotalMemory = $database->CachedQuery("SELECT * FROM stats WHERE type='total_memory' ORDER BY id DESC LIMIT 60", array(), 1);
		foreach($sTotalMemory->data as $key => $value){
			$sTotal[] = $value["result"];
		}
		$sRAMUsage[] = array("name" => "60", "used" => round($sUsed[59] / 1024), "total" => round($sTotal[59] / 1024));
		$sRAMUsage[] = array("name" => "30", "used" => round($sUsed[29] / 1024), "total" => round($sTotal[29] / 1024));
		$sRAMUsage[] = array("name" => "15", "used" => round($sUsed[14] / 1024), "total" => round($sTotal[14] / 1024));
		$sRAMUsage[] = array("name" => "5", "used" => round($sUsed[4] / 1024), "total" => round($sTotal[4] /1024));
		$sRAMUsage[] = array("name" => "1", "used" => round($sUsed[0] / 1024), "total" => round($sTotal[0] / 1024));
		$sLoadAverage = $database->CachedQuery("SELECT * FROM stats WHERE type='load' ORDER BY id DESC LIMIT 60", array(), 1);
		foreach($sLoadAverage->data as $key => $value){
			$sLoads[] = $value["result"];
		}
		$sLoad[] = array("name" => 60, "AVG" => check_set($sLoads[59]));
		$sLoad[] = array("name" => 30, "AVG" => check_set($sLoads[29]));
		$sLoad[] = array("name" => 15, "AVG" => check_set($sLoads[14]));
		$sLoad[] = array("name" => 5, "AVG" => check_set($sLoads[4]));
		$sLoad[] = array("name" => 1, "AVG" => $sLoads[0]);
		
		$sContent = Templater::AdvancedParse('/blue_default/main', $locale->strings, array(
			'ErrorMessage'	=>	"",
			'InitialSetup'	=>	$sUser->sInitialSetup,
			'WelcomeClosed'	=>	$sUser->sWelcomeClosed,
			'InitialSetupContent'	=>	$sInitialSetupContent,
			'Load' => $sLoad,
			'RAM' => $sRAMUsage,
		));
		echo Templater::AdvancedParse('/blue_default/master', $locale->strings, array(
			'PageTitle'  => "Main Dashboard",
			'PageName'	=>	"main",
			'ErrorMessage'	=>	"",
			'Content'	=>	$sContent
		));
	}
?>
