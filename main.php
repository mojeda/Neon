<?php
$_SESSION['user_id'] = 4;
include('./includes/loader.php');

	if($LoggedIn === false){
		header("Location: index.php");
		die();
	} else {
		if($sUser->sInitialSetup == 0){
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
		'PanelTitle'	=>	$sPanelTitle->sValue,
		'ErrorMessage'	=>	"",
		'Username'	=>	$sUser->sUsername,
		'Content'	=>	$sContent
		));
	}
?>
