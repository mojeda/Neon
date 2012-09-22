<?php

class UpdateSettings extends User {

	public static function UpdateStatsEmail($uStatsEmail){
	global $sUser;
	$sUser->sStatsEmail = $uStatsEmail;
	$sUser->InsertIntoDatabase();
	}
	
	public static function UpdateInitialSetup($uInitialSetup){
	global $sUser;
	$sUser->sInitialSetup = $uInitialSetup;
	$sUser->InsertIntoDatabase();
	}
	
	public static function UpdateWelcomeClosed($uWelcomeClosed){
	global $sUser;
	$sUser->sWelcomeClosed = $uWelcomeClosed;
	$sUser->InsertIntoDatabase();
	}

}