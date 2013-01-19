echo Cleaning up please wait...
/etc/init.d/apache2 stop >> install-neon.log 2>&1
/etc/init.d/apache stop >> install-neon.log 2>&1
apt-get -y remove apache apache2 mysql-server php5 php php-fpm php-pear php5-common php-common php5-mcrypt php-mcrypt php5-cli php-cli nginx httpd >> install-neon.log 2>&1
echo Starting installation please wait...
echo "deb http://packages.dotdeb.org stable all" >> /etc/apt/sources.list
wget http://www.dotdeb.org/dotdeb.gpg >> install-neon.log 2>&1
cat dotdeb.gpg | apt-key add - >> install-neon.log 2>&1
rm -rf dotdeb.gpg >> install-neon.log 2>&1
echo Percent complete: 10%
apt-get update >> install-neon.log 2>&1
apt-get -y install php5 php5-fpm php-pear php5-common php5-mcrypt php5-mysql php5-cli php5-gd >> install-neon.log 2>&1
echo Percent complete: 20%
apt-get -y install nginx >> install-neon.log 2>&1
echo "server {
	server_name neonpanel.com www.neonpanel.com;
	access_log /var/www/neonpanel/logs/access.log;
	error_log /var/www/neonpanel/logs/error.log error;
	root /var/www/;
	index index.php index.html index.htm;
	location ~ \.php$ {
		try_files $uri =404;
		fastcgi_pass 127.0.0.1:9000;
		fastcgi_index index.php;
		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
		include fastcgi_params;
		fastcgi_split_path_info ^(.+\.php)(/.+)$;
		fastcgi_param REQUEST_URI $request_uri;
		fastcgi_param DOCUMENT_URI $document_uri;
		fastcgi_param DOCUMENT_ROOT $document_root;
		fastcgi_param REMOTE_ADDR $remote_addr;
		fastcgi_param REMOTE_PORT $remote_port;
		fastcgi_param SERVER_ADDR $server_addr;
		fastcgi_param SERVER_PORT $server_port;
		fastcgi_param SERVER_NAME $server_name;
		fastcgi_param QUERY_STRING $query_string;
		fastcgi_param REQUEST_METHOD $request_method;
		fastcgi_param CONTENT_TYPE $content_type;
		fastcgi_param CONTENT_LENGTH $content_length;
		## prevent php version info
		fastcgi_hide_header X-Powered-By;
	}
}" > /etc/nginx/sites-enabled/neonpanel
echo Percent complete: 30%
mysqlpassword=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};`
salt=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};`
export DEBIAN_FRONTEND=noninteractive >> neon-install.log 2>&1
apt-get -q -y install mysql-server >> neon-install.log 2>&1
mysqladmin -u root password $mysqlpassword >> neon-install.log 2>&1
echo Percent complete: 45%
apt-get -q -y install zip unzip >> neon-install.log 2>&1
echo Percent complete: 60%
wget https://github.com/BlueVM/Neon/archive/develop.zip >> neon-install.log 2>&1
mv develop.zip / >> neon-install.log 2>&1
unzip /develop.zip >> neon-install.log 2>&1
rm -rf /develop.zip >> neon-install.log 2>&1
echo Percent complete: 70%
query="CREATE DATABASE IF NOT EXISTS panel;"
mysql -u root --password="$mysqlpassword" --execute="$query"
mysql -u root --password="$mysqlpassword" panel < /data.sql
echo Percentage complete: 80%
cp /var/neon/data/config.example /var/neon/data/config.json >> neon-install.log 2>&1
sed -i 's/databaseusernamehere/root/g' /var/neon/data/config.json >> neon-install.log 2>&1
sed -i 's/databasepasswordhere/$mysqlpassword/g' /var/neon/data/config.json >> neon-install.log 2>&1
sed -i 's/databasenamehere/panel/g' /var/neon/data/config.json >> neon-install.log 2>&1
sed -i 's/randomlygeneratedsalthere/$salt/g' /var/neon/data/config.json >> neon-install.log 2>&1
cd ~ >> neon-install.log 2>&1
echo Percentage complete: 95%
ssh-keygen -t rsa >> neon-install.log 2>&1
cat id_rsa.pub >> .ssh/authorized_keys >> neon-install.log 2>&1
cp id_rsa /var/neon/data/ >> neon-install.log 2>&1
php /var/www/neonpanel/delete_admin_generator.php >> neon-install.log 2>&1
echo Finishing and cleaning up...
rm -rf id_rsa
rm -rf id_rsa.pub
rm -rf /data.sql >> neon-install.log 2>&1
rm -rf /README >> neon-install.log 2>&1
/etc/init.d/nginx restart >> neon-install.log 2>&1
echo ================Neon Install Complete================
echo Mysql Root Password: $mysqlpassword
echo You can now login at http://yourip/neonpanel
echo Username: admin
echo Password: admin
echo =====================================================