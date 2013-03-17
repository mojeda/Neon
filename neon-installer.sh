echo =====================================
echo     Welcome to Neon Installation
echo =====================================
echo Neon will remove any existing apache,
echo nginx, mysql or php services you have
echo installed upon this server. It will
echo also delete all custom config files
echo that you may have.
echo
echo It is reccomended that you run this
echo installer in a screen.
echo
echo This script will begin installing
echo Neon in 10 seconds. If you wish to
echo cancel the install press CTRL + C
sleep 10
echo

function check_root() {
	if [ ! "`whoami`" = "root" ]
	then
	    echo "Root previlege required to run this script. Rerun as root."
	    exit 1
	fi
}
check_root

echo Neon is now being installed.
echo Begining cleanup...

apt-get update >> install-neon.log 2>&1
mkdir ~/neon-install/
cd ~/neon-install/
/etc/init.d/apache2 stop >> ~/neon-install/neon-install.log 2>&1
/etc/init.d/apache stop >> ~/neon-install/neon-install.log 2>&1
/etc/init.d/httpd stop >> ~/neon-install/neon-install.log 2>&1
/etc/init.d/lighttpd stop >> ~/neon-install/neon-install.log 2>&1
apt-get -y remove --purge apache apache2 mysql-server php5 php php-fpm php-pear php5-common php-common php5-mcrypt php-mcrypt php5-cli php-curl php5-curl php-cli nginx httpd lighttpd >> ~/neon-install/neon-install.log 2>&1
echo Percent Complete: 5%

echo Starting installation please wait...
echo "deb http://packages.dotdeb.org stable all" >> /etc/apt/sources.list
wget http://www.dotdeb.org/dotdeb.gpg >> ~/neon-install/neon-install.log 2>&1
cat dotdeb.gpg | apt-key add - >> ~/neon-install/neon-install.log 2>&1
rm -rf dotdeb.gpg
echo Percent Complete: 10%

apt-get -y install nginx php5 phpmyadmin php5-mysql zip unzip sqlite3 php5-sqlite php5-curl php-pear php5-dev acl libcurl4-openssl-dev php5-gd php5-imagick php5-imap php5-mcrypt php5-xmlrpc php5-xsl php5-suhosin php5-fpm libpcre3-dev build-essential php-apc >> ~/neon-install/neon-install.log 2>&1
echo Percent complete: 20%

mysqlpassword=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};`
salt=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};`
export DEBIAN_FRONTEND=noninteractive >> ~/neon-install/neon-install.log 2>&1
apt-get -q -y install mysql-server >> ~/neon-install/neon-install.log 2>&1
mysqladmin -u root password $mysqlpassword >> ~/neon-install/neon-install.log 2>&1
echo Percent Complete: 30%

/etc/init.d/mysql stop >> ~/neon-install/neon-install.log 2>&1
/etc/init.d/nginx stop >> ~/neon-install/neon-install.log 2>&1
/etc/init.d/php5-fpm stop >> ~/neon-install/neon-install.log 2>&1
echo Percent Complete: 35%

wget https://raw.github.com/BlueVM/Neon/develop/neonpanel/includes/configs/my.cnf >> ~/neon-install/neon-install.log 2>&1
mv /etc/my.cnf /etc/my.cnf.backup >> ~/neon-install/neon-install.log 2>&1
mv my.cnf /etc/my.cnf >> ~/neon-install/neon-install.log 2>&1
echo Percent Complete: 40%

touch /etc/php5/conf.d/apc.ini 
cat > /etc/php5/conf.d/apc.ini <<END
extension=apc.so
apc.enabled=1
apc.shm_size=30M
END
wget https://raw.github.com/BlueVM/Neon/develop/neonpanel/includes/configs/php.conf >> ~/neon-install/neon-install.log 2>&1
mv php.conf /etc/php5/fpm/pool.d/www.conf >> ~/neon-install/neon-install.log 2>&1
echo Percent Complete: 45%

wget https://raw.github.com/BlueVM/Neon/develop/neonpanel/includes/configs/nginx.neon.conf >> ~/neon-install/neon-install.log 2>&1
wget https://raw.github.com/BlueVM/Neon/develop/neonpanel/includes/configs/nginx.conf >> ~/neon-install/neon-install.log 2>&1
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup >> ~/neon-install/neon-install.log 2>&1
mv nginx.conf /etc/nginx/nginx.conf >> ~/neon-install/neon-install.log 2>&1
mv nginx.neon.conf /etc/nginx/sites-enabled/nginx.neon.conf >> ~/neon-install/neon-install.log 2>&1
echo Percent Complete: 50%

mkdir /var/neon/
git clone -b develop https://github.com/BlueVM/Neon.git /var/neon/ >> ~/neon-install/neon-install.log 2>&1
echo Percent complete: 60%

rm -rf /etc/php5/fpm/php.ini >> ~/neon-install/neon-install.log 2>&1
mv /var/neon/php.ini /etc/php5/fpm/php.ini >> ~/neon-install/neon-install.log 2>&1
touch /var/neon/data/log.txt >> ~/neon-install/neon-install.log 2>&1
mkdir /var/neon/neonpanel/uploads >> ~/neon-install/neon-install.log 2>&1
mkdir /var/neon/neonpanel/downloads >> ~/neon-install/neon-install.log 2>&1
mkdir /home/root/ >> ~/neon-install/neon-install.log 2>&1
/etc/init.d/mysql start >> ~/neon-install/neon-install.log 2>&1
/etc/init.d/nginx start >> ~/neon-install/neon-install.log 2>&1
/etc/init.d/php5-fpm start >> ~/neon-install/neon-install.log 2>&1
echo Percent Complete: 70%

setfacl -Rm user:www-data:rwx /var/neon/* >> ~/neon-install/neon-install.log 2>&1
mysql -u root --password="$mysqlpassword" --execute="CREATE DATABASE IF NOT EXISTS panel;"
mysql -u neon --password="$mysqlpassword" panel < /var/neon/data.sql
echo Percent Complete: 80%

cp /var/neon/data/config.example /var/neon/data/config.json >> ~/neon-install/neon-install.log 2>&1
sed -i 's/databaseusernamehere/root/g' /var/neon/data/config.json >> ~/neon-install/neon-install.log 2>&1
sed -i 's/databasepasswordhere/'${mysqlpassword}'/g' /var/neon/data/config.json >> ~/neon-install/neon-install.log 2>&1
sed -i 's/databasenamehere/panel/g' /var/neon/data/config.json >> ~/neon-install/neon-install.log 2>&1
sed -i 's/randomlygeneratedsalthere/'${salt}'/g' /var/neon/data/config.json >> ~/neon-install/neon-install.log 2>&1
echo Percent Complete: 90%

ssh-keygen -t rsa -N "" -f ~/neon-install/id_rsa >> ~/neon-install/neon-install.log 2>&1
mkdir ~/.ssh/ >> ~/neon-install/neon-install.log 2>&1
cat id_rsa.pub >> ~/.ssh/authorized_keys >> ~/neon-install/neon-install.log 2>&1
mv id_rsa /var/neon/data/ >> ~/neon-install/neon-install.log 2>&1
setfacl -Rm user:www-data:rwx /var/neon/* >> ~/neon-install/neon-install.log 2>&1
echo Finishing and cleaning up...

/etc/init.d/nginx restart >> ~/neon-install/neon-install.log 2>&1
/etc/init.d/php5-fpm restart >> ~/neon-install/neon-install.log 2>&1
cd /var/neon/neonpanel/ >> ~/neon-install/neon-install.log 2>&1
php init.php >> ~/neon-install/neon-install.log 2>&1
rm -rf init.php >> ~/neon-install/neon-install.log 2>&1
cd ~/neon-install/ >> ~/neon-install/neon-install.log 2>&1
echo
echo =========NEON_INSTALL_COMPLETE========
echo Mysql Root Password: $mysqlpassword
echo You can now login at http://yourip:2026
echo Username: root
echo Password: your_root_password
echo =====================================