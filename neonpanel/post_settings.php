<?php
include('./includes/loader.php');

if($LoggedIn === false){
	header("Location: index.php");
	die();
} else {
	if(($_GET['id'] == InitialSetup) && ($_POST['domain'] != NULL) && ($_POST['stats'] != NULL)){
		$sDomain = $_POST['domain'];
		if(!empty($sDomain)){
			$return = Domain::AddDomain($_POST['domain']);
		} else {
			header("Location: main.php");
			die("There seems to be a problem with your request. Please go back and try again.");
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