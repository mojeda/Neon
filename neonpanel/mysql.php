<?php
include('./includes/loader.php');

if($LoggedIn === false){
	header("Location: index.php");
	die();
} else {

	if(!empty($_GET['action'])){
		$sAction = $_GET['action'];
	}
	
	if(!empty($_GET['format'])){
		$sFormat = $_GET['format'];
	}
	
	if(!empty($_GET['view'])){
		$sView = $_GET['view'];
	} else {
		die("Unfortunatly no view was selected, thus this page can not load.");
	}
	
	if($sAction == create_database){
		echo $_GET['name'];
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
		$sDatabases = $database->CachedQuery("SHOW DATABASES", array(), 1);
		$sUsernameLength = strlen($sUser->sUsername) + 1;
		$sDatabaseList = array();
		foreach($sDatabases->data as $key => $value){
			if(substr($value["Database"],0,$sUsernameLength) == $sUser->sUsername.'_'){
				$sDatabaseList[] = $value["Database"];
			}
		}
		$sContent = Templater::AdvancedParse('/blue_default/mysqldatabases', $locale->strings, array(
			'ErrorMessage'	=>	"",
			'DatabaseList' => $sDatabaseList,
		));
	} elseif($sView == users){
		$sPageTitle = "Mysql Users";
		$sContent = Templater::AdvancedParse('/blue_default/mysqlusers', $locale->strings, array(
			'ErrorMessage'	=>	"",
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

	
	if(!isset($sFormat)){	
		echo Templater::AdvancedParse('/blue_default/master', $locale->strings, array(
			'PageTitle'  => $sPageTitle,
			'PageName'	=>	"mysql",
			'ErrorMessage'	=>	"",
			'Content'	=>	$sContent
		));
	} else {
		$sContent = preg_replace('/\r\n|\r|\n/', '', $sContent);
		$sReturnArray = array("content"	=>	$sContent);
		echo json_encode($sReturnArray);
	}
}
?>