<?php
$_SESSION['user_id'] = 4;
include('./includes/loader.php');

	if($LoggedIn === false){
		header("Location: index.php");
		die();
	} else {
		$sContent = Templater::AdvancedParse('/blue_default/main', $locale->strings, array(
		'PanelTitle'  => $sPanelTitle->sValue,
		'ErrorMessage'	=>	"",
		'Username'	=>	$sUser->sUsername
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
