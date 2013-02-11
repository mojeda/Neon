echo Cleaning up please wait...
cd ~ >> neon-install.log 2>&1
/etc/init.d/apache2 stop >> install-neon.log 2>&1
/etc/init.d/apache stop >> install-neon.log 2>&1
apt-get -y remove apache apache2 mysql-server php5 php php-fpm php-pear php5-common php-common php5-mcrypt php-mcrypt php5-cli php-curl php5-curl php-cli nginx httpd >> install-neon.log 2>&1
echo Starting installation please wait...
echo "deb http://packages.dotdeb.org stable all" >> /etc/apt/sources.list
wget http://www.dotdeb.org/dotdeb.gpg >> install-neon.log 2>&1
cat dotdeb.gpg | apt-key add - >> install-neon.log 2>&1
echo Percent complete: 10%
apt-get update >> install-neon.log 2>&1
apt-get -y install php5 php5-fpm php-pear php5-common php5-mcrypt php5-curl php5-mysql php5-cli php5-gd git-core >> install-neon.log 2>&1
echo Percent complete: 20%
apt-get -y install nginx >> install-neon.log 2>&1
echo "server {
	listen 2026;

	root /var/neon/neonpanel;
	index index.php;

	location ~\.php$ {
		include fastcgi_params;
		fastcgi_intercept_errors off;
		fastcgi_pass 127.0.0.1:9000;
	}
}

server {
	listen 80;

	root /home/root;
	index index.php index.html index.htm;

	location ~\.php$ {
		include fastcgi_params;
		fastcgi_intercept_errors off;
		fastcgi_pass 127.0.0.1:9000;
	}
}" > /etc/nginx/sites-enabled/neonpanel
apt-get -y install acl >> install-neon.log 2>&1
echo Percent complete: 30%
mysqlpassword=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};`
salt=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};`
export DEBIAN_FRONTEND=noninteractive >> neon-install.log 2>&1
apt-get -q -y install mysql-server >> neon-install.log 2>&1
mysqladmin -u root password $mysqlpassword >> neon-install.log 2>&1
echo Percent complete: 45%
apt-get -q -y install zip unzip >> neon-install.log 2>&1
echo Percent complete: 60%
cd ~ >> neon-install.log 2>&1
git clone -b develop https://github.com/BlueVM/Neon.git /var/neon/  >> neon-install.log 2>&1
echo Percent complete: 70%
rm -rf /etc/php5/fpm/php.ini
mv /var/neon/php.ini /etc/php5/fpm/php.ini
touch /var/neon/data/log.txt
mkdir /var/neon/neonpanel/uploads
mkdir /var/neon/neonpanel/downloads
mkdir /home/root/
setfacl -Rm user:www-data:rwx /var/neon/* >> install-neon.log 2>&1
mysql -u root --password="$mysqlpassword" --execute="USE mysql;CREATE USER 'neon'@'localhost' IDENTIFIED BY '$mysqlpassword';GRANT ALL PRIVILEGES ON *.* TO 'neon'@'localhost';FLUSH PRIVILEGES;"
mysql -u neon --password="$mysqlpassword" --execute="USE mysql;DROP USER root;"
/etc/init.d/mysql restart >> neon-install.log 2>&1
mysql -u neon --password="$mysqlpassword" --execute="CREATE DATABASE IF NOT EXISTS panel;"
mysql -u neon --password="$mysqlpassword" panel < /var/neon/data.sql
echo Percent complete: 80%
cp /var/neon/data/config.example /var/neon/data/config.json >> neon-install.log 2>&1
sed -i 's/databaseusernamehere/neon/g' /var/neon/data/config.json >> neon-install.log 2>&1
sed -i 's/databasepasswordhere/'${mysqlpassword}'/g' /var/neon/data/config.json >> neon-install.log 2>&1
sed -i 's/databasenamehere/panel/g' /var/neon/data/config.json >> neon-install.log 2>&1
sed -i 's/randomlygeneratedsalthere/'${salt}'/g' /var/neon/data/config.json >> neon-install.log 2>&1
cd ~ >> neon-install.log 2>&1
echo Percent complete: 95%
ssh-keygen -t rsa -N "" -f ~/id_rsa >> neon-install.log 2>&1
mkdir ~/.ssh/ >> neon-install.log 2>&1
cat id_rsa.pub >> ~/.ssh/authorized_keys >> neon-install.log 2>&1
cp id_rsa /var/neon/data/ >> neon-install.log 2>&1
setfacl -Rm user:www-data:rwx /var/neon/* >> install-neon.log 2>&1
echo Finishing and cleaning up...
cd ~ >> neon-install.log 2>&1
rm -rf ~/dotdeb.gpg >> install-neon.log 2>&1
rm -rf ~/id_rsa >> neon-install.log 2>&1
rm -rf ~/id_rsa.pub >> neon-install.log 2>&1
/etc/init.d/nginx restart >> neon-install.log 2>&1
/etc/init.d/php5-fpm restart >> neon-install.log 2>&1
cd /var/neon/neonpanel/ >> neon-install.log 2>&1
php init.php >> neon-install.log 2>&1
rm -rf init.php >> neon-install.log 2>&1
cd ~ >> neon-install.log 2>&1
echo ================Neon Install Complete================
echo Mysql Root Password: $mysqlpassword
echo You can now login at http://yourip:2026
echo Username: root
echo Password: your_root_password
echo =====================================================