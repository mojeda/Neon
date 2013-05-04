<?php
include('./includes/loader.php');

if($LoggedIn === false){
	header("Location: index.php");
	die();
}

function get_json($url){
	$base = "https://api.github.com/";
	$curl = curl_init();
	curl_setopt($curl, CURLOPT_URL, $base . $url);
	curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
	curl_setopt($curl, CURLOPT_USERAGENT, 'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2 GTB5');
	$content = curl_exec($curl);
	curl_close($curl);
	return $content;
}

function get_commit($type){
  return json_decode(get_json("repos/BlueVM/Neon/commits/$type"),true);
}

$sDevelop = get_commit("develop");

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