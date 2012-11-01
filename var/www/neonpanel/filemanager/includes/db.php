<?php
$_CPHP_CONFIG = "../../../neon/data/config_filemanager.json";
$_CPHP = true;
require("./cphp/base.php");

$sConnect = new PDO('sqlite:../../../neon/data/authorized.db');
if (!$sConnect){
	die($sError);
}
?>