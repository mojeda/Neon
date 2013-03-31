<?php
include('./includes/loader.php');

	if($LoggedIn === false){
		header("Location: index.php");
		die();
	} else {
		$sUserDomains = $database->CachedQuery("SELECT * FROM domains WHERE `user_id`=':UserId'", array(':UserId' => $sUser->sId), 1);
		foreach($sUserDomains->data as $key => $value){
			$sDomains[] = array("id" => $value["id"], "domain" => $value["domain_name"]);
		}
		
		$sContent = Templater::AdvancedParse('/blue_default/domainmanager', $locale->strings, array(
			'ErrorMessage'	=>	"",
		));
		echo Templater::AdvancedParse('/blue_default/master', $locale->strings, array(
		'PageTitle'  => "Domain Manager",
		'PageName'	=>	"domainmanager",
		'ErrorMessage'	=>	"",
		'Content'	=>	$sContent,
		'Domains' => $sDomains,
		));
	}
?>