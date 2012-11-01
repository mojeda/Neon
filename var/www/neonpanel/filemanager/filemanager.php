<?php
include('./includes/loader.php');

// Users Root Directory
$sUser_sRootDir = '/home/'.$sUsername.'/';
$sUser_TrashDirectory = '/home/'.$sUsername.'/.trash/';
			
// Check if user is in a subdirectory if yes use it, if no use root path.
if(!empty($_GET['path'])){
	$uPath = $_GET['path'];
} else {
	$uPath = $sUser_sRootDir;
}

// Validate path
$path = new PathValidator($uPath);
if($path->ValidatePath($sUser_sRootDir)){
	$sPath= $uPath;
	if($sUser_sRootDir != $sPath){
		$sAllowBack = true;
		$uUpDirectory = dirname($uPath).'/';
	} else {
		$sAllowBack = false;
	}
} else {
	die("There seems to be a problem with your request. Please go back and try again.");
}

// If editor, load editor and file.
if(!empty($_GET['editor'])){
	$sSaveName = basename($sPath);
	$sDirectorySave = dirname($sPath);
	if(!empty($_GET['save'])){
		$uPostContent = $_POST['content'];
		file_put_contents($sPath, $uPostContent);
		echo "File Has Been Saved!";
	} else {
		$sFileContent = @file_get_contents($sPath);
		if($sFileContent === false){
			$sFileContent = "";
		}
		$sEditor = Templater::AdvancedParse('/blue_default/edit', $locale->strings, array(
			'PanelTitle'  => "Neon Panel",
			'ErrorMessage'	=>	"",
			'Username'	=>	$sUsername,
			'FileName'	=>	$sSaveName,
			'FilePath'	=>	$sPath,
			'FileContent'	=>	$sFileContent,
			'DefaultEditorTheme'	=>	$sUserTheme
		));
		echo $sEditor;
	}
	
	
	
} elseif(!empty($_GET['upload'])){
	include('./includes/upload.php');
	
	
	
} elseif(!empty($_GET['download_file'])){
	$user_ssh = new Net_SSH2('127.0.01');
	$user_sftp = new Net_SFTP('127.0.0.1');
	if (!$user_ssh->login($sUser->sUsername, $_SESSION['password'])) { exit('User Connection To Server Failed!');}
	if (!$user_sftp->login($sUser->sUsername, $_SESSION['password'])) { exit('User Connection To Server Failed!');}
	if (!is_dir('downloads/'.$sUser->sUsername.'/')) {
		mkdir('downloads/'.$sUser->sUsername.'/');
	}
	unlink('downloads/'.$sUser->sUsername.'/download.*.zip');
	$sFileContent = $user_ssh->exec('cd '.$sCurrentPath.'; zip -r '.$sUser->sRootDir.'download.'.$sTimestamp.'.zip '.$sCurrentFile);
	$user_sftp->get($sUser->sRootDir.'download.'.$sTimestamp.'.zip', 'downloads/'.$sUser->sUsername.'/download.'.$sTimestamp.'.zip');
	$sFileContent = $user_ssh->exec('rm -rf '.$sUser->sRootDir.'download.'.$sTimestamp.'.zip');
	header("Location: downloads/$sUser->sUsername/download.$sTimestamp.zip");
	
	
	
} elseif(!empty($_GET['download_folder'])){
	$user_ssh = new Net_SSH2('127.0.01');
	$user_sftp = new Net_SFTP('127.0.0.1');
	if (!$user_ssh->login($sUser->sUsername, $_SESSION['password'])) { exit('User Connection To Server Failed!');}
	if (!$user_sftp->login($sUser->sUsername, $_SESSION['password'])) { exit('User Connection To Server Failed!');}
	if (!is_dir('downloads/'.$sUser->sUsername.'/')) {
		mkdir('downloads/'.$sUser->sUsername.'/');
	}
	unlink('downloads/'.$sUser->sUsername.'/download.*.zip');
	$sFileContent = $user_ssh->exec('cd '.$sUser->sRootDir.'; zip -r '.$sUser->sRootDir.'download.'.$sTimestamp.'.zip '.$sCurrentDirectory);
	$user_sftp->get($sUser->sRootDir.'download.'.$sTimestamp.'.zip', 'downloads/'.$sUser->sUsername.'/download.'.$sTimestamp.'.zip');
	$sFileContent = $user_ssh->exec('rm -rf '.$sUser->sRootDir.'download.'.$sTimestamp.'.zip');
	header("Location: downloads/$sUser->sUsername/download.$sTimestamp.zip");
	
	
	
} else {
	// Create directories and files
	if(!empty($_GET['add_folder'])){
		$sFolderName = preg_replace("/[^a-z0-9_ .-]/i", "", $_GET['add_folder']);
		if(!empty($sFolderName)){
			$sCreateFolder = mkdir($sPath.$sFolderName, 0644);
		}
	}
	if(!empty($_GET['add_file'])){
		$sFileName = preg_replace("/[^a-z0-9_ .-]/i", "", $_GET['add_file']);
		if(!empty($sFileName)){
			$sCreateFile = file_put_contents($sPath.$sFileName, "");
		}
	}
	
	// Delete files/folders.
	if(!empty($_GET['delete'])){
		$sDelete = preg_replace("/[^a-z0-9_ .-]/i", "", $_GET['delete']);
		if(!empty($sDelete)){
			if(is_dir($sPath.$sDelete)){
				$sDeleteFolder = rmdir($sPath.$sDelete);
			} else {
				$sDeleteFile = unlink($sPath.$sDelete);
			}
		}
	}
			
	//get all files in specified directory
	$sEntries = glob($sPath . "*");
	$sDirectories = array();
	$sFiles = array();
	foreach($sEntries as $sEntry){
		if(is_dir($sEntry)){
		array_push($sDirectories, array("name" => $sEntry, "size" => filesize($sPath.$sEntry)));
		} else {
		array_push($sFiles, array("name" => $sEntry, "size" => filesize($sPath.$sEntry)));
		}
	}
		
	// Load filemanager.		
	$sFileManager = Templater::AdvancedParse('/blue_default/fmlayout', $locale->strings, array(
		'PanelTitle'  => "Neon Panel",
		'ErrorMessage'	=>	"",
		'Username'	=>	$sUsername,
		'Directories'	=>	$sDirectories,
		'Files'	=>	$sFiles,
		'MaxListFiles' =>	"-1",
		'AllowBack'	=>	$sAllowBack,
		'FilePath'	=>	$sPath,
		'MaxPanelUploadSize'	=>	"25MB",
	));
	$sContent = preg_replace('/\r\n|\r|\n/', '', $sFileManager);
	$sReturnArray = array("content"	=>	$sContent);
	echo json_encode($sReturnArray);
}	