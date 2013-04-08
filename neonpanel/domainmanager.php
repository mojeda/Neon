<?php
include('./includes/loader.php');

	if($LoggedIn === false){
		header("Location: index.php");
		die();
	} else {
		if(!empty($_GET['format'])){
			$sFormat = $_GET['format'];
		}
		
		if(!empty($_GET['action'])){
			$sAction = $_GET['action'];
		}
		
		if($sAction == adddomain){
			$return = Domain::AddDomain($_GET['name']);
		}
		
		if($sAction == removedomain){
			$return = Domain::RemoveDomain($_GET['name']);
		}
		
		$sUserDomains = $database->CachedQuery("SELECT * FROM domains WHERE `user_id` = :UserId ", array(':UserId' => $sUser->sId), 1);
		if(!empty($sUserDomains)){
			foreach($sUserDomains->data as $key => $value){
				$sDomains[] = array("id" => $value["id"], "domain" => $value["domain_name"]);
			}
		}
		
		
		$sDomainManager = Templater::AdvancedParse('/blue_default/domainmanager', $locale->strings, array(
			'ErrorMessage'	=>	"",
			'Domains' => $sDomains,
		));
		
		if(!isset($sFormat)){
			$sContent = Templater::AdvancedParse('/blue_default/domains', $locale->strings, array(
				'ErrorMessage'	=>	"",
				'DomainManagerCode'	=> $sDomainManager
			));
			echo Templater::AdvancedParse('/blue_default/master', $locale->strings, array(
				'PageTitle'  => "Domain Manager",
				'PageName'	=>	"domainmanager",
				'ErrorMessage'	=>	"",
				'Content'	=>	$sContent
			));
		} else {
			$sContent = preg_replace('/\r\n|\r|\n/', '', $sDomainManager);
			$sReturnArray = array("content"	=>	$sContent);
			echo json_encode($sReturnArray);
		}
	}
?>