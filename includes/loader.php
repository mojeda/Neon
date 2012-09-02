<?php
require_once('./includes/db.php');
require_once('./includes/functions.php');
require_once('./includes/global_settings.php');
require_once('./includes/lib/net/ssh.php');
require_once('./includes/lib/crypt/RSA.php');

$sWriteLog = fopen($cphp_config->settings->commandlog, 'w');

	$root_ssh = new Net_SSH2($sDefaultIP->sValue);
	$root_key = new Crypt_RSA();
	$root_key->loadKey(file_get_contents($cphp_config->settings->rootkey));
	if (!$root_ssh->login('root', $root_key)) {
		fwrite($sWriteLog, 'Login to root via key failed -> System Failed To Connect To The Server - Error #00001');
		exit('System Failed To Connect To The Server - Error: #00001');
	}
	
if(isset($_SESSION['user_id'])){
	$sUser = new User($_SESSION['user_id']);
	$LoggedIn = true;
	$user_ssh = new Net_SSH2($sDefaultIP->sValue);
	if (!$user_ssh->login($sUser->sUsername, $_SESSION['password'])) {
		fwrite($sWriteLog, 'Login to '.$sUser->sUsername.' via users password failed -> System Failed To Connect To The Server - Error #00002');
		exit('System Failed To Connect The User To The Server - Error: #00002');
	}
} else {
	$LoggedIn = false;
}

$sErrorMessage = NULL;

?>
