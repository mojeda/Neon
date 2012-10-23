<?php
include('./includes/loader.php');

if($LoggedIn === false){
	header("Location: index.php");
	die();
} else {
	if(($_GET['id'] == InitialSetup) && ($_POST['domain'] != NULL) && ($_POST['stats'] != NULL)){
		$return = Domain::AddDomain($_POST['domain']);
		$sUser->uStatsEmail = $_POST['stats'];
		$sUser->uInitialSetup = true;
		$sUser->InsertIntoDatabase();
		
		if (!$user_ssh->login($sUser->sUsername, $_SESSION['password'])) { exit('User Connection To Server Failed!');}
		$sFolderName = preg_replace("/[^a-z0-9_ .-]/i", "", $_POST['domain']);
		$sUser->sRootDir = '/home/'.$sUser->sUsername.'/';
		if(!empty($sFolderName)){
			$sCreateFolder = $user_ssh->exec("mkdir '".$sUser->sRootDir.$sFolderName."'");
		}
		// Add perl execution to add domain later
		// Add user folder creator later
		// Write nginx config file
	} elseif($_GET['id'] == WelcomeClosed){
		$sUser->uWelcomeClosed = 1;
		$sUser->InsertIntoDatabase();
	} elseif($_GET['id'] == DefaultEditorTheme){
		$sUser->uDefaultEditorTheme = $_POST['theme'];
		$sUser->InsertIntoDatabase();
	}
}