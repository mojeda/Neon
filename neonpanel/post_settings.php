<?php
include('./includes/loader.php');

if($LoggedIn === false){
	header("Location: index.php");
	die();
} else {
	if(($_GET['id'] == InitialSetup) && ($_POST['domain'] != NULL) && ($_POST['stats'] != NULL)){
		$sRemove = array("http://", "www.", "https://", "ftp://");
		$sDomain = preg_replace($sRemove, '', $_POST['domain']);
		if((preg_match("^(?:[-A-Za-z0-9]+\.)+[A-Za-z]{2,6}$", $sDomain)) && (!empty($sDomain))){
			$return = Domain::AddDomain($_POST['domain']);
			$sUser->uStatsEmail = $_POST['stats'];
			$sUser->uInitialSetup = true;
			$sUser->InsertIntoDatabase();
			if(!$user_ssh->login($sUser->sUsername, $_SESSION['password'])) { exit('User Connection To Server Failed!');}
			if(!$user_sftp->login($sUser->sUsername, $_SESSION['password'])) { exit('User Connection To Server Failed!');}
			$sUser->sRootDir = '/home/'.$sUser->sUsername.'/';
				$sValidate = new PathValidator($sUser->sRootDir.$sDomain);
				if($sValidate->ValidatePath($sUser->sRootDir)){
					$sCreateFolder = $user_ssh->exec("mkdir ".escapeshellarg($sUser->sRootDir.$sFolderName).";mkdir ".escapeshellarg($sUser->sRootDir.$sFolderName."/public_html/".).";mkdir ".escapeshellarg($sUser->sRootDir."/logs/".).";");
					$sReplace = array("0" => "{domain_name}", "1" => "{username}");
					$sReplacements = array("0" => $sFolderName, "1" => $sUser->sUsername);
					$sConfig = preg_replace($sReplace, $sReplacements, file_get_contents('./includes/configs/nginx.default.conf'));
					$sFileContent = $user_sftp->put('/etc/nginx/sites-enabled/'.$sDomain.'.conf', $sPostContent);
					$sReload = $user_ssh->exec("/etc/init.d/nginx reload");
					fwrite($sWriteLog, $sReload);
				} else {
					header("Location: main.php");
					die("There seems to be a problem with your request. Please go back and try again.");
				}
		} else {
			header("Location: main.php");
			die("Invalid Domain");
		}
	} elseif($_GET['id'] == WelcomeClosed){
		$sUser->uWelcomeClosed = 1;
		$sUser->InsertIntoDatabase();
	} elseif($_GET['id'] == DefaultEditorTheme){
		$sUser->uDefaultEditorTheme = $_POST['theme'];
		$sUser->InsertIntoDatabase();
	}
}