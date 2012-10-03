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
		// Add perl execution to add domain later
		// Add user folder creator later
		// Write nginx config file
	} elseif($_GET['id'] == WelcomeClosed){
		$return = UpdateSettings::UpdateWelcomeClosed('1');
	}
}