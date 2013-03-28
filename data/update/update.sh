rm -rf /etc/nginx/sites-enabled/nginx.neon.conf
cp /var/neon/neonpanel/includes/configs/nginx.neon.conf /etc/nginx/sites-enabled/nginx.neon.conf
service nginx reload

cd /var/neon/neonpanel/
cat "<?php include('./includes/loader.php'); $sUpdate = $database->CachedQuery('ALTER TABLE panel.accounts ADD `wizard_closed` INT(2);', array(), 1); ?>" >> mysql_perform_update.php
php mysql_perform_update.php
rm -rf mysql_perform_update.php
