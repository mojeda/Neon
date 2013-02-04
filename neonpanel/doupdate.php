<?php
set_time_limit(0);
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
	$content = curl_exec($curl);
	curl_close($curl);
	return $content;
}

function get_commits($type){
  return json_decode(get_json("repos/BlueVM/Neon/commits/$type"),true);
}

$sDevelop = get_commits("develop");

if($sDevelop["sha"] != $sVersion->sValue){
	if(!empty($_GET['id'])){
			if (!$user_ssh->login($sUser->sUsername, $_SESSION['password'])) { exit('User Connection To Server Failed!');}
			$sUpdate = $user_ssh->exec('cd /var/neon/;git pull');
			$sVersion = get_commits("develop");
			$sData = Core::UpdateSetting('version', $sVersion["sha"]);
			$array = array("content" => "Neon is now up to date.");
	}
} else {
	$array = array("content" => "Neon is now up to date.");
}

echo json_encode($array);
?>