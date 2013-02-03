<?php
include('./includes/loader.php');

function get_json($url){
	$base = "https://api.github.com/";
	$curl = curl_init();
	curl_setopt($curl, CURLOPT_URL, $base . $url);
	curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
	$content = curl_exec($curl);
	curl_close($curl);
	return $content;
}

function get_commits($type){
  return json_decode(get_json("repos/BlueVM/Neon/commits/$type"),true);
}

if(!empty($_GET['id'])){
	if($_GET['id'] == develop){
		if (!$user_ssh->login($sUser->sUsername, $_SESSION['password'])) { exit('User Connection To Server Failed!');}
		$sUpdate = $user_ssh->exec('cd ~;wget https://github.com/BlueVM/Neon/archive/develop.zip;unzip develop.zip;mv ~/Neon-develop/var/neon /var/;rm -rf Neon-develop;rm -rf develop.zip');
		$sVersion = get_commits("develop");
		$sData = Core::UpdateSetting('version', $sVersion["sha"]);
	}
}

$sDevelop = get_commits("develop");

if($sDevelop["sha"] == $sVersion->sValue){
	$sOutdated = false;
} else {
	$sOutdated = true;
}

if($LoggedIn === false){
	header("Location: index.php");
	die();
} else {
	$sContent = Templater::AdvancedParse('/blue_default/update', $locale->strings, array(
		'PanelTitle'  => $sPanelTitle->sValue,
		'ErrorMessage'	=>	"",
		'Username'	=>	$sUser->sUsername,
		'Outdated' => $sOutdated
	));
	echo Templater::AdvancedParse('/blue_default/master', $locale->strings, array(
		'PageTitle'  => "Neon Updater",
		'PageName'	=>	"update",
		'PanelTitle'	=>	$sPanelTitle->sValue,
		'ErrorMessage'	=>	"",
		'Username'	=>	$sUser->sUsername,
		'Content'	=>	$sContent
	));
}
?>