<?php
include('./includes/loader.php');

function get_update_array(){
	$base = "http://neonpanel.com/update_feed.php";
	$curl = curl_init();
	curl_setopt($curl, CURLOPT_URL, $base);
	curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
	$content = curl_exec($curl);
	curl_close($curl);
	return $content;
}


echo get_update_array();

