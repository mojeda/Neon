<?php
include('./includes/loader.php');

if($LoggedIn === false){
	header("Location: index.php");
	die();
} else {
	$sContent = Templater::AdvancedParse('/blue_default/help', $locale->strings, array(
		'ErrorMessage'	=>	"",
	));
	echo Templater::AdvancedParse('/blue_default/help', $locale->strings, array(
		'PageTitle'  => "Help & Information",
		'PageName'	=>	"help",
		'ErrorMessage'	=>	"",
		'Content'	=>	$sContent
	));
}
?>