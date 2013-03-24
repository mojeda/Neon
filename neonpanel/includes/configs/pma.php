<?php
session_set_cookie_params(0, '/', '', 0);
session_name('neon_auth');
session_start();
$_SESSION['PMA_single_signon_user'] = $_SESSION['username'];
if($_SESSION['username'] == root){
	$_SESSION['PMA_single_signon_password'] = 'databasepasswordhere';
} else {
	$_SESSION['PMA_single_signon_password'] = $_SESSION['password'];
}
$_SESSION['PMA_single_signon_host'] = 'localhost';
session_write_close();
if(!isset($_GET['server'])){
	header('Location: ./index.php?server=1');
}
?>
