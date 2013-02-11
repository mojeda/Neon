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
		$sContent = Templater::AdvancedParse('/blue_default/main', $locale->strings, array(
		'PanelTitle'  => $sPanelTitle->sValue,
		'ErrorMessage'	=>	"",
		'Username'	=>	$sUser->sUsername,
		'InitialSetup'	=>	$sUser->sInitialSetup,
		'WelcomeClosed'	=>	$sUser->sWelcomeClosed,
		'InitialSetupContent'	=>	$sInitialSetupContent
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
