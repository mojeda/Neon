<?php
require_once('./lib/crypt/RSA.php');
$sTimestamp = time();
$sTimestampOld = time() - 12*60*60;

// This script simply inserts the key into the database for file manager connection.
error_reporting(E_ERROR | E_PARSE);
$sConnect = new PDO('sqlite:authorized.db');
if (!$sConnect){
        die($sError);
}

$sTable = $sConnect->exec("CREATE TABLE IF NOT EXISTS keys (username text NOT NULL, key text NOT NULL, timestamp integer NOT NULL, max_list_files text NOT NULL)");
$sTable = $sConnect->exec("CREATE TABLE IF NOT EXISTS settings (setting_name text NOT NULL, setting_value text NOT NULL)");

$sOriginal = $argv[1];
$sSignature = base64_decode($argv[2]);
$sRSA = new Crypt_RSA();
$sRSA->loadKey(file_get_contents('id_rsa.pub'));
if($sRSA->verify($sOriginal, $sSignature) == true){

	$sOriginal = json_decode(base64_decode($sOriginal), true);
	$sUsername = $sOriginal['username'];
	$sKey = $sOriginal['key'];
	$sMaxListFiles = $sOriginal['max_list_files'];
	$sInsert = $sConnect->exec("INSERT INTO keys (username, key, timestamp, max_list_files) VALUES ('$sUsername', '$sKey', '$sTimestamp', '$sMaxListFiles');DELETE FROM keys WHERE timestamp < '$sTimestampOld';");
	
	$sPanelTitle = $sOriginal['panel_title'];
	$sMasterIP = $sOriginal['master_ip'];
	$sMaxPanelUploadSize = $sOriginal['max_panel_upload_size'];
	$sInsert = $sConnect->exec("INSERT INTO settings (setting_name, setting_value) VALUES ('panel_title', $sPanelTitle');");
	$sInsert = $sConnect->exec("INSERT INTO settings (setting_name, setting_value) VALUES ('master_ip', $sMasterIP');");
	$sInsert = $sConnect->exec("INSERT INTO settings (setting_name, setting_value) VALUES ('max_panel_upload_size', $sMaxPanelUploadSize');");

} else { die("Invalid Key"); }
?>
