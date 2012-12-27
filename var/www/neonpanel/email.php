<?php
include('./includes/loader.php');

if($LoggedIn === false){
	header("Location: index.php");
	die();
} else {
	$sContent = Templater::AdvancedParse('/blue_default/email', $locale->strings, array(
		'PanelTitle'  => $sPanelTitle->sValue,
		'ErrorMessage'	=>	"",
		'Username'	=>	$sUser->sUsername
	));
	echo Templater::AdvancedParse('/blue_default/master', $locale->strings, array(
		'PageTitle'  => "Email Accounts",
		'PageName'	=>	"email",
		'PanelTitle'	=>	$sPanelTitle->sValue,
		'ErrorMessage'	=>	"",
		'Username'	=>	$sUser->sUsername,
		'Content'	=>	$sContent
	));
}
?>