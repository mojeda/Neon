<?php
include('./includes/loader.php');

if($LoggedIn === false){
	header("Location: index.php");
	die();
} else {
	$sContent = Templater::AdvancedParse('/blue_default/settings', $locale->strings, array(
		'ErrorMessage'	=>	"",
	));
	echo Templater::AdvancedParse('/blue_default/master', $locale->strings, array(
		'PageTitle'  => "Server Settings",
		'PageName'	=>	"settings",
		'ErrorMessage'	=>	"",
		'Content'	=>	$sContent
	));
}
?>