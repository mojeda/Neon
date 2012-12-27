<?php
ob_start();
include('./includes/loader.php');

if($LoggedIn === false){
	header("Location: index.php");
	die();
} else {
	// Users Root Directory
	$sUser->sRootDir = '/home/'.$sUser->sUsername.'/';
	$sUser->TrashDirectory = '/home/'.$sUser->sUsername.'/.trash/';
	if (!$user_ssh->login($sUser->sUsername, $_SESSION['password'])) { exit('User Connection To Server Failed!');}
		
	// Variables for the file manager to determine what needs to be done.
	if(!empty($_GET['request'])){
		$uRequest = $_GET['request'];
	} else {
		$uRequest = $sUser->sRootDir;
	}
	
	if(!empty($_GET['action'])){
		$sAction = $_GET['action'];
		if(($sAction == download_file) || ($sAction == download_folder) || ($sAction == upload)){
			if (!$user_sftp->login($sUser->sUsername, $_SESSION['password'])) { exit('User Connection To Server Failed!');}
		}
	}
	
	if(is_numeric($_GET['save'])){
		$sSave = $_GET['save'];
	}
	
	if(!empty($_GET['format'])){
		$sFormat = $_GET['format'];
	}
		
	// Validate path
	$sValidate = new PathValidator($uRequest);
	if($sValidate->ValidatePath($sUser->sRootDir)){
		$sRequest = $uRequest;
	} else {
		die("There seems to be a problem with your request. Please go back and try again.");
	}
		
	// Check if root directory to enable or disable the up button.
	if($sUser->sRootDir != $sRequest){
		$sAllowBack = true;
		$sBack = dirname($sRequest).'/';
	} else {
		$sAllowBack = false;
	$sBack = 0;
	}
			
			
			
	// Begin preforming actions. Actions ending in die(); do not need to load the template engine or have their own template.
			
			
			
	if($sAction == editor){
		$sEditorFileName = basename($sRequest);
		$sEditorDirectoryName = dirname($sRequest);
		if($sSave == 1){
			$sSavingCode = random_string(15);
			$sPostContent = $_POST['content'];
			$sFileContent = $user_ssh->exec("cat >".$sRequest." <<".$sSavingCode."
".$sPostContent);
			echo "File Has Been Saved!";
			die();
		} else {
			$sFileContent = $user_ssh->exec('cat "'.$sRequest.'"');
			$sCheckNonExistant = "cat: ".$sCurrentDirectory.": No such file or directory";
			if(stristr($sFileContent, $sCheckNonExistant)){
				$sFileContent = "";
			}
			$sEditor = Templater::AdvancedParse('/blue_default/edit', $locale->strings, array(
				'PanelTitle'  => $sPanelTitle->sValue,
				'ErrorMessage'	=>	"",
				'Username'	=>	$sUser->sUsername,
				'FileName'	=>	$sEditorFileName,
				'FilePath'	=>	$sRequest,
				'FileContent'	=>	$sFileContent,
				'DefaultEditorTheme'	=>	$sUser->sDefaultEditorTheme
			));
			echo $sEditor;
			die();
		}
	}
			
	if($sAction == upload){
		include('./includes/upload.php');
		die();
	}
			
	if(($sAction == download_file) || ($sAction == download_folder)){
		if (!is_dir('downloads/'.$sUser->sUsername.'/')) {
			mkdir('downloads/'.$sUser->sUsername.'/');
		}
		$sTimestamp = time();
	}
			
	if($sAction == download_file){		
		$sDownloadFileName = basename($sRequest);
		$sDownloadFilePath = dirname($sRequest);
		// In a nutshell: zip file(s) -> download to local host -> redirect to said files for the user to download.
		$sFileContent = $user_ssh->exec('cd '.escapeshellarg($sDownloadFilePath).'; zip -r '.$sUser->sRootDir.'download.'.$sTimestamp.'.zip '.escapeshellarg($sDownloadFileName));
		$user_sftp->get($sUser->sRootDir.'download.'.$sTimestamp.'.zip', 'downloads/'.$sUser->sUsername.'/download.'.$sTimestamp.'.zip');
		$sFileContent = $user_ssh->exec('rm -rf '.$sUser->sRootDir.'download.'.$sTimestamp.'.zip');
		header("Location: downloads/$sUser->sUsername/download.$sTimestamp.zip");
		die();
	}
			
	if($sAction == download_folder){
		$sFileContent = $user_ssh->exec('cd '.$sUser->sRootDir.'; zip -r '.$sUser->sRootDir.'download.'.$sTimestamp.'.zip '.escapeshellarg($sRequest));
		$user_sftp->get($sUser->sRootDir.'download.'.$sTimestamp.'.zip', 'downloads/'.$sUser->sUsername.'/download.'.$sTimestamp.'.zip');
		$sFileContent = $user_ssh->exec('rm -rf '.$sUser->sRootDir.'download.'.$sTimestamp.'.zip');
		header("Location: downloads/$sUser->sUsername/download.$sTimestamp.zip");
		die();
	}
			
	if($sAction == add_folder){
		$uFolderName = preg_replace("/[^a-z0-9\/;_ \.-]/i", "", $_GET['name']);
		$sNewValidate = new PathValidator($sRequest.$uFolderName);
		if($sNewValidate->ValidatePath($sUser->sRootDir)){
			$sFolderName = $uFolderName;
			if(!empty($sFolderName)){
				$sCreateFolder = $user_ssh->exec("mkdir ".escapeshellarg($sRequest.$sFolderName));
			} else {
				die("No folder to create!");
			}
		} else {
			die("Invalid Path!");
		}
	}
			
	if($sAction == add_file){
		$uFileName = preg_replace("/[^a-z0-9\/;_ \.-]/i", "", $_GET['name']);
		$sNewValidate = new PathValidator($sRequest.$uFileName);
		if($sNewValidate->ValidatePath($sUser->sRootDir)){
			$sFileName = $uFileName;
			if(!empty($sFileName)){
				$sCreateFile = $user_ssh->exec('echo -n " " >> '.escapeshellarg($sRequest.$sFileName));
			} else {
				die("No file to create!");
			}
		} else {
			die("Invalid Path!");
		}
	}
			
	if($sAction == delete){
		$uDelete = preg_replace("/[^a-z0-9\/;_ \.-]/i", "", $_GET['delete']);
		$sDeleteValidate = new PathValidator($sRequest.$uDelete);
		if($sDeleteValidate->ValidatePath($sUser->sRootDir)){
			$sDelete = $uDelete;
			if(!empty($sDelete)){
				$sRemove = $user_ssh->exec('rm -rf '.escapeshellarg($sRequest.$sDelete).';');
			} else {
				die("No file/folder specified");
			}
		} else {
			die("Invalid Path");
		}
	}
	
	if(($sAction == rename_folder) || ($sAction == rename_file)){
		$uFrom = preg_replace("/[^a-z0-9\/;_ \.-]/i", "", $_GET['from']);
		$uTo = preg_replace("/[^a-z0-9\/;_ \.-]/i", "", $_GET['to']);
		$sFromValidate = new PathValidator($sRequest.$uFrom);
		if($sFromValidate->ValidatePath($sUser->sRootDir)){
			$sFrom = $uFrom;
			$sToValidate = new PathValidator($sRequest.$uTo);
			if($sToValidate->ValidatePath($sUser->sRootDir)){
				$sTo = $uTo;
				$sRename = $user_ssh->exec('mv '.escapeshellarg($sRequest.$sFrom).' '.escapeshellarg($sRequest.$sTo));
			} else {
				die("Invalid Path!");
			}
		} else {
			die("Invalid Path!");
		}
	}
	
	if(($sAction == copy_folder) || ($sAction == move_folder) || ($sAction == copy_file) || ($sAction == move_file)){
		$uFrom = preg_replace("/[^a-z0-9\/;_ \.-]/i", "", $_GET['from']);
		$uTo = preg_replace("/[^a-z0-9\/;_ \.-]/i", "", $_GET['to']);
		$sFromValidate = new PathValidator($uFrom);
		if($sFromValidate->ValidatePath($sUser->sRootDir)){
			$sFrom = $uFrom;
			$sToValidate = new PathValidator($uTo);
			if($sToValidate->ValidatePath($sUser->sRootDir)){
				$sTo = $uTo;
				if($sAction == copy_folder){
					$sCopy = $user_ssh->exec('cd '.escapeshellarg($sFrom).'; mkdir '.escapeshellarg($sTo).'; cp -r * '.escapeshellarg($sTo));
				} elseif(($sAction == move_folder) || ($sAction == move_file)){
					$sMove = $user_ssh->exec('mv '.escapeshellarg($sFrom).' '.escapeshellarg($sTo));
				} elseif($sAction == copy_file){
					$sCopy = $user_ssh->exec('cp -r '.escapeshellarg($sFrom).' '.escapeshellarg($sTo));
				}
			} else {
				die("There seems to be a problem with your request. Please go back and try again.");
			}
		} else {
			die("There seems to be a problem with your request. Please go back and try again.");
		}
	}
	
	if($sAction == permissions){
		$uName = preg_replace("/[^a-z0-9\/;_ \.-]/i", "", $_GET['name']);
		if(is_numeric($_GET['value'])){
			$sNameValidate = new PathValidator($sRequest.$uName);
			if($sNameValidate->ValidatePath($sUser->sRootDir)){
				$sName = $uName;
				$sPerms = $user_ssh->exec('chmod '.$_GET["value"].' '.escapeshellarg($sRequest.$sName));
			} else {
				die("Invalud File Path");
			}
		} else {
			die("Permissions error!");
		}
	}
	
	// Begin pulling folder & file data to display to the user.
			
			
			
	$sPullDirectories = $user_ssh->exec('ls -l '.escapeshellarg($sRequest).' |grep ^d');
	$sParsedDirectories = preg_split('/\r\n|\r|\n/', $sPullDirectories);
	$sDirectories = array();
	foreach($sParsedDirectories as $sValue){
		if(!empty($sValue)){
			$sValue = preg_replace('/\s+/', ' ',$sValue);
			$sValues = explode(" ", $sValue);
			if(count($sValues) > 8){
				foreach($sValues as $key => $value){
					if($key == 8){
						$sDirectoryName = str_replace("/","", $value);
					} elseif($key >= 9){
						$sDirectoryName .= " ".str_replace("/","", $value);
					}
				}
				$sPullSize = $user_ssh->exec('du -hs '.escapeshellarg($sRequest.$sDirectoryName));
				$sDirPerm = $user_ssh->exec('stat -c %a '.escapeshellarg($sRequest.$sDirectoryName));
				$sSizeValues = explode("	", $sPullSize);
				array_push($sDirectories, array("name" => trim($sDirectoryName), "size" => trim($sSizeValues[0]), "perms" => trim($sDirPerm)));
			}
			unset($values);
			if(!empty($sDirectoryName)){
				unset($sDirectoryName);
			}
		}
	}
			
	$sPullFiles = $user_ssh->exec('ls -lsph1 '.escapeshellarg($sRequest).' | grep -v "\/"');
	$sParsedFiles = preg_split('/\r\n|\r|\n/', $sPullFiles);
	$sFiles = array();
	foreach($sParsedFiles as $value){
		if(!empty($value)){
			$value = preg_replace('/\s+/', ' ',$value);
			$value = preg_replace('/^ /', '', $value);
			$values = explode(" ", $value);
			if(count($values) > 8){
				foreach($values as $key => $value){
					if($key == 9){
						$sFileName = str_replace("/","", $value);
					} elseif($key >= 10){
						$sFileName .= " ".str_replace("/","", $value);
					}
				}
				$sFileSize = $values[5];
				$sFilePerm = $user_ssh->exec('stat -c %a '.escapeshellarg($sRequest.$sFileName));
				if(is_numeric($sFileSize)){
					$sFileSize = $sFileSize.'.0B';
				}
				array_push($sFiles, array("name" => trim($sFileName), "size" => trim($sFileSize), "perms" => trim($sFilePerm)));
				unset($values);
			}
		}
	}			
			
			
			
	// Load filemanager template.


			
	$sFileManager = Templater::AdvancedParse('/blue_default/fmlayout', $locale->strings, array(
		'PanelTitle'  => $sPanelTitle->sValue,
		'ErrorMessage'	=>	"",
		'Username'	=>	$sUser->sUsername,
		'Directories'	=>	$sDirectories,
		'Files'	=>	$sFiles,
		'MaxListFiles' =>	$sUser->sMaxListFiles,
		'AllowBack'	=>	$sAllowBack,
		'Back'	=>	$sBack,
		'FilePath'	=>	$sRequest,
		'MaxPanelUploadSize'	=>	$sMaxPanelUploadSize->sValue,
	));
			
			
			
	// Run ajax or display full page.
			
			
			
	if(!isset($sFormat)){
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
		$sContent = preg_replace('/\r\n|\r|\n/', '', $sFileManager);
		$sReturnArray = array("content"	=>	$sContent);
		echo json_encode($sReturnArray);
	}
}
ob_flush();			