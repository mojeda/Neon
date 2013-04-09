<?php
include('./includes/loader.php');

if($LoggedIn === false){
	header("Location: index.php");
	die();
} else {
	$sContent = Templater::AdvancedParse('/blue_default/process', $locale->strings, array(
		'ErrorMessage'	=>	"",
	));
	echo Templater::AdvancedParse('/blue_default/process', $locale->strings, array(
		'PageTitle'  => "Process Manager",
		'PageName'	=>	"process",
		'ErrorMessage'	=>	"",
		'Content'	=>	$sContent
	));
}
?>