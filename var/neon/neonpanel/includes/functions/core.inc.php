<?php
class Core {

	static function GetSetting($setting){
		global $database;
		$result = $database->CachedQuery("SELECT * FROM settings WHERE `setting_name` = :Setting", array(':Setting'	=> $setting));
		return new Setting($result);
	}
	
	static function UpdateSetting($setting, $value){
		global $database;
		$result = $database->CachedQuery("UPDATE settings SET `setting_value` = :Value WHERE `setting_name` = :Setting", array(':Value' => $value, ':Setting' => $setting));
		return true;
	}
}