<?php
include('./includes/loader.php');

if($LoggedIn === false){
	header("Location: index.php");
	die();
} else {
	if(($_GET['id'] == InitialSetup) && ($_POST['domain'] != NULL) && ($_POST['stats'] != NULL)){
		$return = Domain::AddDomain($_POST['domain']);
		$return .= UpdateSettings::UpdateStatsEmail($_POST['stats']);
		$return .= UpdateSettings::UpdateInitialSetup('1');
		// Add perl execution to add domain later
		// Add user folder creator later
		// Write nginx config file
	} elseif($_GET['id'] == WelcomeClosed){
		$return = UpdateSettings::UpdateWelcomeClosed('1');
	}
}