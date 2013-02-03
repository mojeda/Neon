<?php
$sTimestamp = time();
$sPanelTitle = Core::GetSetting('panel_title');
$sRegistrationEnabled = Core::GetSetting('registration_enabled');
$sForgotPasswordEnabled = Core::GetSetting('forgotpassword_enabled');
$sDefaultIP = Core::GetSetting('default_ip');
$sMaxPanelUploadSize = Core::GetSetting('max_panel_upload_size');
$sVersion = Core::GetSetting('version');

function remove_magic_quotes($array) {
    foreach ($array as $k => $v) {
        if (is_array($v)) {
            $array[$k] = remove_magic_quotes($v);
        } else {
            $array[$k] = stripslashes($v);
        }
    }
    return $array;
}
if (get_magic_quotes_gpc()) {
    $_GET    = remove_magic_quotes($_GET);
    $_POST   = remove_magic_quotes($_POST);
    $_COOKIE = remove_magic_quotes($_COOKIE);
}