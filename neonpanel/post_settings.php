<?php
include('./includes/loader.php');

if($LoggedIn === false){
	header("Location: index.php");
	die();
} else {
	if(($_GET['id'] == InitialSetup) && ($_POST['domain'] != NULL) && ($_POST['stats'] != NULL)){
		$sDomain = preg_replace("/[^a-z0-9_ .-]/i", "", $_POST['domain']);
		if(!empty($sDomain)){
			$return = Domain::AddDomain($sDomain);
			$sUser->uStatsEmail = $_POST['stats'];
			$sUser->uInitialSetup = true;
			$sUser->InsertIntoDatabase();
			if(!$user_ssh->login($sUser->sUsername, $_SESSION['password'])) { exit('User Connection To Server Failed!');}
			if(!$user_sftp->login($sUser->sUsername, $_SESSION['password'])) { exit('User Connection To Server Failed!');}
			$sUser->sRootDir = '/home/'.$sUser->sUsername.'/';
				$sValidate = new PathValidator($sUser->sRootDir.$sDomain);
				if($sValidate->ValidatePath($sUser->sRootDir)){
					$sPublic = $sUser->sRootDir.$sDomain."/public_html/";
					$sLogs = $sUser->sRootDir."/logs/";
					$sCreateFolder = $user_ssh->exec("mkdir ".escapeshellarg($sUser->sRootDir.$sDomain).";mkdir ".escapeshellarg($sPublic).";mkdir ".escapeshellarg($sLogs).";");
					$sReplace = array("domain_name" => $sDomain, "username" => $sUser->sUsername);
					$sConfig = file_get_contents('./includes/configs/nginx.default.conf');
					foreach($sReplace as $key => $value){	
						$sConfig = str_replace($key, $value, $sConfig);
					}
					$sFileContent = $user_sftp->put('/etc/nginx/sites-enabled/'.$sDomain.'.conf', $sConfig);
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
	} elseif($_GET['id'] == WizardClosed){
		$sUser->uWizardClosed = 1;
		$sUser->InsertIntoDatabase();
	} elseif($_GET['id'] == DefaultEditorTheme){
		$sUser->uDefaultEditorTheme = $_POST['theme'];
		$sUser->InsertIntoDatabase();
	}
}