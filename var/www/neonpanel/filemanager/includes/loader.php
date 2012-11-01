<?php
require_once('./includes/db.php');
require_once('./includes/functions.php');
require_once('./includes/lib/net/ssh.php');
require_once('./includes/lib/crypt/RSA.php');
include('./includes/lib/net/sftp.php');

$sWriteLog = fopen($cphp_config->settings->commandlog, 'a');
$sError = array("content"	=> "Invalid key or username, please refresh the file manager or if the error persists log out and log back in.");

if(!empty($_GET['key'])){
	$uKey = $_GET['key'];
	$uUsername = $_GET['username'];
} elseif(!empty($_SESSION['key'])){
	$uKey = $_SESSION['key'];
	$uUsername = $_SESSION['username'];
}

if(!empty($uKey)){
	$sCheckUser = $sConnect->query("SELECT * FROM keys WHERE key='$uKey' AND username='$uUsername'");
	$sNumber = count($sCheckUser);
	if($sNumber != 1){
		echo json_encode($sError);
		die();
	} else {
		$sMaxListFiles = $sCheckUser['maxlistfiles'];
		$sUsername = $sCheckUser['username'];
		$sKey = $sCheckUser['key'];
		$sSettings = $sConnect->query("SELECT * FROM settings");
	}
} else {
	echo json_encode($sError);
	die();
}
$sErrorMessage = NULL;
?>
