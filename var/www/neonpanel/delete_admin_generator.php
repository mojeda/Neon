<?php
include('./includes/loader.php');

$sErrorMessage = User::register("root", "admin", "admin", "admin@localhost.com");

?>