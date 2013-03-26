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
	
	// Multi-use variable.
	$sUsernameLength = strlen($sUser->sUsername) + 1;
	
	if($sAction == createdatabase){
		$sDatabaseName = preg_replace("/[^a-z0-9.]+/i", "", $_GET['name']);
		if(!empty($sDatabaseName)){
			$sDatabaseName = $sUser->sUsername."_".$sDatabaseName;
			$sCreateDatabase = $database->CachedQuery("CREATE DATABASE {$sDatabaseName}", array(), 1);
		}
	}
	
	if($sAction == deletedatabase){
		$sDatabaseName = preg_replace("/[^a-z0-9_.]+/i", "", $_GET['name']);
		if(substr($sDatabaseName,0,$sUsernameLength) == $sUser->sUsername.'_'){
			$sDeleteDatabase = $database->CachedQuery("DROP DATABASE {$sDatabaseName}", array(), 1);
		}
	}
	
	if($sAction == createuser){
		$sMysqlUsername = preg_replace("/[^a-z0-9_.]+/i", "", $_GET['name']);
		$sMysqlPassword = $_GET['password'];
		if((!empty($sMysqlUsername)) && (!empty($sMysqlPassword))){
			$sMysqlUsername = $sUser->sUsername."_".$sMysqlUsername;
			$sCreateUser = $database->CachedQuery("CREATE USER '{$sMysqlUsername}'@'localhost' IDENTIFIED BY '{$sMysqlPassword}'", array(), 1);
		}
	}
	
	if($sAction == deleteuser){
		$sMysqlUsername = preg_replace("/[^a-z0-9_.]+/i", "", $_GET['name']);
		if(substr($sMysqlUsername,0,$sUsernameLength) == $sUser->sUsername.'_'){
			$sDeleteUser = $database->CachedQuery("DROP USER '{$sMysqlUsername}'@'localhost'", array(), 1);
		}
	}
	
	if($sAction == adduser){
	
	}
	
	if($sAction == removeuser){
	
	}
	
	if($sView == databases){
		$sPageTitle = "Mysql Databases";
		$sDatabases = $database->CachedQuery("SHOW DATABASES", array(), 1);
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
		$sUsers = $database->CachedQuery("SELECT User from mysql.user", array(), 1);
		$sUserList = array();
		foreach($sUsers->data as $key => $value){
			if(substr($value["User"],0,$sUsernameLength) == $sUser->sUsername.'_'){
				$sUserList[] = $value["User"];
			}
		}
		$sContent = Templater::AdvancedParse('/blue_default/mysqlusers', $locale->strings, array(
			'ErrorMessage'	=>	"",
			'UserList' => $sUserList,
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