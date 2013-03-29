<?php
include('./includes/loader.php');

// Just in case someone has a older version of neon.
$sStatsTable = $database->CachedQuery("CREATE TABLE IF NOT EXISTS `stats` (`id` int(8) NOT NULL AUTO_INCREMENT, `result` int(8) NOT NULL, `type` varchar(65) NOT NULL, `timestamp` int(16) NOT NULL, PRIMARY KEY (`id`)) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;", array(), 1);

// Pull used/total memory for stats
$sFree = shell_exec('free');
$sFree = (string)trim($sFree);
$sFree_Array = explode("\n", $sFree);
$sMemory = explode(" ", $sFree_Array[1]);
$sMemory = array_filter($sMemory);
$sMemory = array_merge($sMemory);
$sUsedMemory = $sMemory[2];
$sTotalMemory = $sMemory[1];

// Pull server load for stats
$sLoad = sys_getloadavg();
$sLoad = $sLoad[0];

$sStat = new Stat(0);
$sStat->uType = "used_memory";
$sStat->uResult = $sUsedMemory;
$sStat->uTimestamp = time();
$sStat->InsertIntoDatabase();

$sStat = new Stat(0);
$sStat->uType = "total_memory";
$sStat->uResult = $sTotalMemory;
$sStat->uTimestamp = time();
$sStat->InsertIntoDatabase();

$sStat = new Stat(0);
$sStat->uType = "load";
$sStat->uResult = $sLoad;
$sStat->uTimestamp = time();
$sStat->InsertIntoDatabase();