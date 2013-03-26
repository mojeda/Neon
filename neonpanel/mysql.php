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
	
	if($sAction == createdatabase){
		$sDatabaseName = preg_replace("/[^a-z0-9.]+/i", "", $_GET['name']);
		$sDatabaseName = $sUser->sUsername."_".$sDatabaseName;
		$sCreateDatabase = $database->CachedQuery("CREATE DATABASE {$sDatabaseName}", array(), 1);
	}
	
	if($sAction == deletedatabase){
		$sDatabaseName = $_GET['name'];
		$sUsernameLength = strlen($sUser->sUsername) + 1;
		if(substr($sDatabaseName,0,$sUsernameLength) == $sUser->sUsername.'_'){
			$sDeleteDatabase = $database->CachedQuery("DROP DATABASE {$sDatabaseName}", array(), 1);
		}
	}
	
	if($sAction == createuser){
	
	}
	
	if($sAction == deleteuser){
	
	}
	
	if($sAction == adduser){
	
	}
	
	if($sAction == removeuser){
	
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
		));
	} elseif($sView == wizard){
		$sPageTitle = "Mysql Database Wizard";
		$sContent = Templater::AdvancedParse('/blue_default/mysqlwizard', $locale->strings, array(
			'PanelTitle'  => $sPanelTitle->sValue,
			'ErrorMessage'	=>	"",
		));
	} else {
		die("Unfortunatly no view was selected, thus this page can not load.");
	}

	
	if(!isset($sFormat)){
		$sMysql = Templater::AdvancedParse('/blue_default/mysql', $locale->strings, array(
			'PanelTitle'  => $sPanelTitle->sValue,
			'ErrorMessage'	=>	"",
			'MysqlManagerCode' => $sContent,
		));
		echo Templater::AdvancedParse('/blue_default/master', $locale->strings, array(
			'PageTitle'  => $sPageTitle,
			'PageName'	=>	"mysql",
			'ErrorMessage'	=>	"",
			'Content'	=>	$sMysql
		));
	} else {
		$sContent = preg_replace('/\r\n|\r|\n/', '', $sContent);
		$sReturnArray = array("content"	=>	$sContent);
		echo json_encode($sReturnArray);
	}
}
?>