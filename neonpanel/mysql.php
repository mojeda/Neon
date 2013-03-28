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
	
	// Multi-use variables.
	$sUsernameLength = strlen($sUser->sUsername) + 1;
	$sPermissionsList = array("ALTER", "CREATE", "CREATE ROUTINE", "CREATE TEMPORARY TABLES", "CREATE VIEW", "DELETE", "DROP", "EXECUTE", "INDEX", "INSERT", "LOCK TABLES", "REFERENCES", "SELECT", "SHOW", "VIEW", "TRIGGER", "UPDATE");
		
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
		$sMysqlPassword = mysql_real_escape_string($_GET['password']);
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
		$sPermissions = $_POST['permissions'];
		$sTotalPermissions = count($sPermissions);
		$sMysqlUsername = preg_replace("/[^a-z0-9_.]+/i", "", $_GET['mysqluser']);
		$sMysqlDatabase = preg_replace("/[^a-z0-9_.]+/i", "", $_GET['mysqldatabase']);
		if($sTotalPermissions == 16){
			$sAddUserToDatabase = $database->CachedQuery("GRANT ALL ON {$sMysqlDatabase}.* TO {$sMysqlUsername}@'localhost'", array(), 1);
		} elseif($sTotalPermissions > 0) {
			foreach($sPermissions as $key => $value){
				if (in_array($value, $sPermissionList)) {
					$sGrantQuery .= $value.", ";
				}
			}
			$sAddUserToDatabase = $database->CachedQuery("GRANT {$sGrantQuery} ON {$sMysqlDatabase}.* TO {$sMysqlUsername}@'localhost'", array(), 1);
		}
	}
	
	if($sAction == removeuser){
		$sMysqlUsername = preg_replace("/[^a-z0-9_.]+/i", "", $_GET['name']);
		$sMysqlDatabase = preg_replace("/[^a-z0-9_.]+/i", "", $_GET['database']);
		if((substr($sMysqlUsername,0,$sUsernameLength) == $sUser->sUsername.'_') && (substr($sMysqlDatabase,0,$sUsernameLength) == $sUser->sUsername.'_')){
			$sRemoveUserDatabase =  $database->CachedQuery("REVOKE ALL ON {$sMysqlDatabase}.* FROM '{$sMysqlUsername}'@'localhost'", array(), 1);
		}
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
		$sDatabases = $database->CachedQuery("SHOW DATABASES", array(), 1);
		$sDatabaseList = array();
		foreach($sDatabases->data as $key => $value){
			if(substr($value["Database"],0,$sUsernameLength) == $sUser->sUsername.'_'){
				$sDatabaseUsers = $database->CachedQuery("SELECT User FROM mysql.db WHERE Db='{$value["Database"]}'", array(), 1);
				if(is_array($sDatabaseUsers->data)){
					foreach($sDatabaseUsers->data as $subkey => $subvalue){
						$sUsers[] = $subvalue["User"];
					}
				}
				$sNumber = count($sUsers);
				if($sNumber > 0){
					$sNumber++;
				}
				$sDatabaseList[] = array("name" => $value["Database"], "users" => $sUsers, "number" => $sNumber);
				unset($sUsers);
				unset($sNumber);
			}
		}
		$sUsers = $database->CachedQuery("SELECT User from mysql.user", array(), 1);
		$sUserList = array();
		foreach($sUsers->data as $key => $value){
			if(substr($value["User"],0,$sUsernameLength) == $sUser->sUsername.'_'){
				$sUserList[] = $value["User"];
			}
		}
		$sContent = Templater::AdvancedParse('/blue_default/mysqldatabaseusers', $locale->strings, array(
			'PanelTitle'  => $sPanelTitle->sValue,
			'ErrorMessage'	=>	"",
			'DatabaseList' => $sDatabaseList,
			'UserList' => $sUserList
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
			'PageName'	=>	$sView,
			'ErrorMessage'	=>	"",
			'Content'	=>	$sMysql,
			'MysqlPage' => 1,
		));
	} else {
		$sContent = preg_replace('/\r\n|\r|\n/', '', $sContent);
		$sReturnArray = array("content"	=>	$sContent);
		echo json_encode($sReturnArray);
	}
}
?>