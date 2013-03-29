<?php
include('./includes/loader.php');

	if($LoggedIn === false){
		header("Location: index.php");
		die();
	} else {
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
		$sRAMUsage[] = array("name" => "60", "used" => $sUsed[59], "total" => $sTotal[59]);
		$sRAMUsage[] = array("name" => "30", "used" => $sUsed[29], "total" => $sTotal[29]);
		$sRAMUsage[] = array("name" => "15", "used" => $sUsed[14], "total" => $sTotal[14]);
		$sRAMUsage[] = array("name" => "5", "used" => $sUsed[4], "total" => $sTotal[4]);
		$sRAMUsage[] = array("name" => "1", "used" => $sUsed[0], "total" => $sTotal[0]);
		$sLoadAverage = $database->CachedQuery("SELECT * FROM stats WHERE type='load' ORDER BY id DESC LIMIT 60", array(), 1);
		foreach($sLoadAverage->data as $key => $value){
			$sLoads[] = $value["result"];
		}
		$sLoad[] = array("name" => 60, "AVG" => $sLoads[59]);
		$sLoad[] = array("name" => 30, "AVG" => $sLoads[29]);
		$sLoad[] = array("name" => 15, "AVG" => $sLoads[14]);
		$sLoad[] = array("name" => 5, "AVG" => $sLoads[4]);
		$sLoad[] = array("name" => 1, "AVG" => $sLoads[0]);
		
		$sContent = Templater::AdvancedParse('/blue_default/main', $locale->strings, array(
		'PanelTitle'  => $sPanelTitle->sValue,
		'ErrorMessage'	=>	"",
		'Username'	=>	$sUser->sUsername,
		'InitialSetup'	=>	$sUser->sInitialSetup,
		'WelcomeClosed'	=>	$sUser->sWelcomeClosed,
		'InitialSetupContent'	=>	$sInitialSetupContent,
		'Load' => $sLoad,
		'RAM' => $sRAMUsage,
		));
		echo Templater::AdvancedParse('/blue_default/master', $locale->strings, array(
		'PageTitle'  => "Main Dashboard",
		'PageName'	=>	"main",
		'PanelTitle'	=>	$sPanelTitle->sValue,
		'ErrorMessage'	=>	"",
		'Username'	=>	$sUser->sUsername,
		'Content'	=>	$sContent
		));
	}
?>
