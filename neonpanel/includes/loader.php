<?php
session_name('neon_auth');
require_once('./includes/db.php');
require_once('./includes/functions.php');
require_once('./includes/global_settings.php');
require_once('./includes/lib/net/ssh.php');
require_once('./includes/lib/crypt/RSA.php');
include('./includes/lib/net/sftp.php');

$sWriteLog = fopen($cphp_config->settings->commandlog, 'a');

$user_ssh = new Net_SSH2($sDefaultIP->sValue);
$user_sftp = new Net_SFTP($sDefaultIP->sValue);

if(isset($_SESSION['user_id'])){
	$sUser = new User($_SESSION['user_id']);
	$LoggedIn = true;
	NewTemplater::SetGlobalVariable("Username", $sUser->sUsername);
	NewTemplater::SetGlobalVariable("UserId", $sUser->sId);
} else {
	$LoggedIn = false;
}

$sErrorMessage = NULL;
?>
