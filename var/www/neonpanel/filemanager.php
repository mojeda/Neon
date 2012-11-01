<?php
include('./includes/loader.php');

	if($LoggedIn === false){
		header("Location: index.php");
		die();
	} else {
	
		//	Start server session and find current directory.
		if (!$root_ssh->login('root', $root_key)) {
			fwrite($sWriteLog, 'Login to root via key failed -> System Failed To Connect To The Server - Error #00001'.PHP_EOL);
			exit('System Failed To Connect To The Server - Error: #00001');
		}
		
		$sUser->sFileManagerHash = random_string(10).$sUser->sUsername;
		$sHash = crypt($sUser->sFileManagerHash, "$5\$rounds=50000\${$sUser->sFileManagerHash}{$cphp_config->settings->salt}$");
		$sParts = explode("$", $sHash);
		$sFMHash = $sParts[4];
		
		$sFMData = base64_encode(json_encode(array('username' => $sUser->sUsername, 'key' => $sFMHash, 'max_list_files' => $sUser->MaxListFiles, 'panel_title' => $sPanelTitle->sValue, 'master_ip' => $sDefaultIP->sValue, 'max_panel_upload_size' => $sMaxPanelUploadSize->sValue)));
		$sRSA = new Crypt_RSA();
		$sRSA->setEncryptionMode(CRYPT_RSA_ENCRYPTION_PKCS1);
		$sRSA->loadKey(file_get_contents('../../neon/data/id_rsa'));
		$sSignature = base64_encode($sRSA->sign($sFMData));
		
		$sInsertKey = $root_ssh->exec('cd /var/neon/data/ && php connect.php '.$sFMData.' '.$sSignature.';');
		
		$sContent = Templater::AdvancedParse('/blue_default/filemanager', $locale->strings, array(
			'PanelTitle'  => $sPanelTitle->sValue,
			'ErrorMessage'	=>	"",
			'Username'	=>	$sUser->sUsername,
			'DefaultIP'	=>	$sDefaultIP->sValue,
			'UserKey'	=>	$sFMHash,
		));
		echo Templater::AdvancedParse('/blue_default/master', $locale->strings, array(
			'PageTitle'  => "File Manager",
			'PageName'	=>	"filemanager",
			'PanelTitle'	=>	$sPanelTitle->sValue,
			'ErrorMessage'	=>	"",
			'Username'	=>	$sUser->sUsername,
			'Content'	=>	$sContent
		));
	}