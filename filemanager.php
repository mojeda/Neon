<?php
include('./includes/loader.php');

	if($LoggedIn === false){
		header("Location: index.php");
		die();
	} else {
	
		//	Start server session and find current directory.
		if (!$user_ssh->login($sUser->sUsername, $_SESSION['password'])) { exit('User Connection To Server Failed!');}
			if((!empty($_SESSION['current_directory'])) && (!empty($_GET['ajax']))){
				$sCurrentDirectory = $_SESSION['current_directory'];
			} else {
				$sCurrentDirectory = '/home/'.$sUser->sUsername.'/';
			}
			if((!empty($_SESSION['directory_tree'])) && (!empty($_GET['up']))){
				foreach($_SESSION['directory_tree'] as $key => $value){
					if($value['name'] == $_GET['up']){
						$sCurrentDirectory = $sCurrentDirectory.$value["name"].'/';
					}
				}
			}
			$_SESSION['current_directory'] = $sCurrentDirectory;
			$sPullDirectories = $user_ssh->exec(' ls -l '.$sCurrentDirectory.' |grep ^d');
			$sParsedDirectories = preg_split('/\r\n|\r|\n/', $sPullDirectories);
			$sDirectories = array();
			foreach($sParsedDirectories as $value){
				if(!empty($value)){
					$value = preg_replace('/\s+/', ' ',$value);
					$values = explode(" ", $value);
					if(count($values) > 8){
					$sDirectoryName = str_replace("/","", $values[8]);
					$sDirectorySize = $values[5];
					array_push($sDirectories, array("name" => trim($sDirectoryName), "size" => trim($sDirectorySize)));
					}
					unset($values);
					$_SESSION['directory_tree'] = $sDirectories;
				}
			}
			
			$sPullFiles = $user_ssh->exec('ls -lsph1 '.$sCurrentDirectory.' | grep -v "\/"');
			$sParsedFiles = preg_split('/\r\n|\r|\n/', $sPullFiles);
			$sFiles = array();
			foreach($sParsedFiles as $value){
				if(!empty($value)){
					$value = preg_replace('/\s+/', ' ',$value);
					$values = explode(" ", $value);
					if(count($values) > 8){
					$sFileName = str_replace("/","", $values[9]);
					$sFileSize = $values[5];
					if(is_numeric($sFileSize)){
						$sFileSize = $sFileSize.'.0B';
					}
					array_push($sFiles, array("name" => trim($sFileName), "size" => trim($sFileSize)));
					unset($values);
					}
				}
			}
		// If not ajax, load html normally, if ajax load json for file manager.
		if(!isset($_GET['ajax'])){
			$sFileManager = Templater::AdvancedParse('/blue_default/fmlayout', $locale->strings, array(
				'PanelTitle'  => $sPanelTitle->sValue,
				'ErrorMessage'	=>	"",
				'Username'	=>	$sUser->sUsername,
				'Directories'	=>	$sDirectories,
				'Files'	=>	$sFiles,
				'MaxListFiles' =>	$sUser->sMaxListFiles
			));
			$sContent = Templater::AdvancedParse('/blue_default/filemanager', $locale->strings, array(
				'PanelTitle'  => $sPanelTitle->sValue,
				'ErrorMessage'	=>	"",
				'Username'	=>	$sUser->sUsername,
				'FileManagerCode'	=> $sFileManager
			));
			echo Templater::AdvancedParse('/blue_default/master', $locale->strings, array(
				'PageTitle'  => "File Manager",
				'PageName'	=>	"filemanager",
				'PanelTitle'	=>	$sPanelTitle->sValue,
				'ErrorMessage'	=>	"",
				'Username'	=>	$sUser->sUsername,
				'Content'	=>	$sContent
			));
		} else {
			$sContent = Templater::AdvancedParse('/blue_default/fmlayout', $locale->strings, array(
				'PanelTitle'  => $sPanelTitle->sValue,
				'ErrorMessage'	=>	"",
				'Username'	=>	$sUser->sUsername,
				'Directories'	=>	$sDirectories,
				'Files'	=>	$sFiles,
				'MaxListFiles' =>	$sUser->sMaxListFiles
			));
			$sContent = preg_replace('/\r\n|\r|\n/', '', $sContent);
			$sReturnArray = array("content"	=>	$sContent);
			echo json_encode($sReturnArray);
		}
	}