<?php
include('./includes/loader.php');

if($LoggedIn === false){
	header("Location: index.php");
	die();
} else {

	if(!empty($_GET['action'])){
		$sAction = $_GET['action'];
	}
	
	if($sAction == create_database){
	
	}
	
	if($sAction == delete_database){
	
	}
	
	if($sAction == create_user){
	
	}
	
	if($sAction == delete_user){
	
	}
	
	if($sAction == add_user){
	
	}
	
	if($sAction == remove_user){
	
	}
	
	$sContent = Templater::AdvancedParse('/blue_default/mysql', $locale->strings, array(
		'PanelTitle'  => $sPanelTitle->sValue,
		'ErrorMessage'	=>	"",
		'Username'	=>	$sUser->sUsername
	));
	echo Templater::AdvancedParse('/blue_default/master', $locale->strings, array(
		'PageTitle'  => "MYSQL Databases",
		'PageName'	=>	"mysql",
		'PanelTitle'	=>	$sPanelTitle->sValue,
		'ErrorMessage'	=>	"",
		'Username'	=>	$sUser->sUsername,
		'Content'	=>	$sContent
	));
}
?>