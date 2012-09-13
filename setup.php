<?php
include('./includes/loader.php');

if($LoggedIn === false){
	header("Location: index.php");
	die();
} else {
	if(($_GET['submit'] == 1) && ($_POST['domain'] != NULL) && ($_POST['stats'] != NULL)){
	$return = Domain::AddDomain($_POST['domain']);
	$return .= User::UpdateStatsEmail($_POST['stats']);
	}
}