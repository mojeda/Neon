<?php
include('./includes/loader.php');

if($LoggedIn === false){
	header("Location: index.php");
	die();
} else {

	if(!empty($_GET['action'])){
		$sAction = $_GET['action'];
	}
	
	if(!empty($_GET['view'])){
		$sView = $_GET['view'];
	} else {
		die("Unfortunatly no view was selected, thus this page can not load.");
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
	
	if($sView == databases){
		$sPageTitle = "Mysql Databases";
		$sContent = Templater::AdvancedParse('/blue_default/mysqldatabases', $locale->strings, array(
			'PanelTitle'  => $sPanelTitle->sValue,
			'ErrorMessage'	=>	"",
			'Username'	=>	$sUser->sUsername
		));
	} elseif($sView == users){
		$sPageTitle = "Mysql Users";
		$sContent = Templater::AdvancedParse('/blue_default/mysqlusers', $locale->strings, array(
			'PanelTitle'  => $sPanelTitle->sValue,
			'ErrorMessage'	=>	"",
			'Username'	=>	$sUser->sUsername
		));
	} elseif($sView == databaseusers){
		$sPageTitle = "Mysql Database Users";
		$sContent = Templater::AdvancedParse('/blue_default/mysqldatabaseusers', $locale->strings, array(
			'PanelTitle'  => $sPanelTitle->sValue,
			'ErrorMessage'	=>	"",
			'Username'	=>	$sUser->sUsername
		));
	} elseif($sView == wizard){
		$sPageTitle = "Mysql Database Wizard";
		$sContent = Templater::AdvancedParse('/blue_default/mysqlwizard', $locale->strings, array(
			'PanelTitle'  => $sPanelTitle->sValue,
			'ErrorMessage'	=>	"",
			'Username'	=>	$sUser->sUsername
		));
	} else {
		die("Unfortunatly no view was selected, thus this page can not load.");
	}
	
echo Templater::AdvancedParse('/blue_default/master', $locale->strings, array(
	'PageTitle'  => $sPageTitle,
	'PageName'	=>	"mysql",
	'PanelTitle'	=>	$sPanelTitle->sValue,
	'ErrorMessage'	=>	"",
	'Username'	=>	$sUser->sUsername,
	'Content'	=>	$sContent
));
}
?>