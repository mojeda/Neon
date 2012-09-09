<?php
include('./includes/loader.php');

if($LoggedIn === false){
	header("Location: index.php");
	die();
} else {
	$sPageContents = Templater::AdvancedParse('/blue_default/setup', $locale->strings, array(
		'PanelTitle'  => $sPanelTitle->sValue,
		'ErrorMessage'	=>	"",
		'Username'	=>	$sUser->sUsername
	));
	echo(Templater::AdvancedParse('blue_default/master.setup', $locale->strings, array(
		'PanelTitle'	=> $sPanelTitle->sValue,
		'PageTitle'	=> "Setup",
		'contents'	=> $sPageContents
	)));
}