<?php
require_once('./includes/db.php');
require_once('./includes/functions.php');
require_once('./includes/global_settings.php');
require_once('./includes/lib/net/ssh.php');
require_once('./includes/lib/crypt/RSA.php');

$sWriteLog = fopen($cphp_config->settings->commandlog, 'a');

$root_ssh = new Net_SSH2($sDefaultIP->sValue);
$root_key = new Crypt_RSA();
$root_key->loadKey(file_get_contents($cphp_config->settings->rootkey));
$user_ssh = new Net_SSH2($sDefaultIP->sValue);

if(isset($_SESSION['user_id'])){
	$sUser = new User($_SESSION['user_id']);
	$LoggedIn = true;
} else {
	$LoggedIn = false;
}

$sErrorMessage = NULL;

?>
