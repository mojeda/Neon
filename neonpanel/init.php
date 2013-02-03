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

$sDevelop = get_commits("develop");

$sData = Core::UpdateSetting('version', $sDevelop["sha"]);
