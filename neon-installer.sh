function check_root() {
	if [ ! "`whoami`" = "root" ]
	then
		echo "Root previlege required to run this script. Rerun as root."
		exit 1
	fi
}
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

check_root
echo Neon is now being installed.
echo Begining cleanup...

mkdir ~/neon-install/
cd ~/neon-install/
echo "Neon installation begining." >> ~/neon-install/neon-install.log 2>&1
apt-get update >> ~/neon-install/neon-install.log 2>&1
service apache stop >> ~/neon-install/neon-install.log 2>&1
service apache2 stop >> ~/neon-install/neon-install.log 2>&1
service nginx stop >> ~/neon-install/neon-install.log 2>&1
service lighttpd stop >> ~/neon-install/neon-install.log 2>&1
update-rc.d -f apache2 remove >> ~/neon-install/neon-install.log 2>&1
service mysql stop >> ~/neon-install/neon-install.log 2>&1
kill -9 $( lsof -i:80 -t ) >> ~/neon-install/neon-install.log 2>&1
kill -9 $( lsof -i:3306 -t ) >> ~/neon-install/neon-install.log 2>&1
apt-get -y remove --purge apache2 apache-* mysql-server php5 php php-fpm php-pear php5-common php-common php5-mcrypt php-mcrypt php5-cli php-curl php5-curl php-cli nginx lighttpd >> ~/neon-install/neon-install.log 2>&1
echo "Neon has removed any excess programs that will interfere with its installation." >> ~/neon-install/neon-install.log 2>&1
echo Percent Complete: 5%

if type -p apache > /dev/null; then
    echo "Unfortunatly apache failed to uninstall, thus Neon's setup is aborting.";
	echo "Neon failed to install because apache refused to uninstall." >> ~/neon-install/neon-install.log 2>&1;
	exit 1
fi

echo Starting installation please wait...
echo "deb http://packages.dotdeb.org stable all" >> /etc/apt/sources.list
wget http://www.dotdeb.org/dotdeb.gpg >> ~/neon-install/neon-install.log 2>&1
cat dotdeb.gpg | apt-key add - >> ~/neon-install/neon-install.log 2>&1
rm -rf dotdeb.gpg
apt-get update >> ~/neon-install/neon-install.log 2>&1
echo "Neon has added dotdeb to apt-get's source.list and is ready to install the nessisary programs." >> ~/neon-install/neon-install.log 2>&1
echo Percent Complete: 10%

export DEBIAN_FRONTEND=noninteractive
apt-get -y -q install nginx >> ~/neon-install/neon-install.log 2>&1
echo "Neon has installed nginx." >> ~/neon-install/neon-install.log 2>&1
echo Percent Complete: 12%

if ! type -p nginx > /dev/null; then
    echo "Unfortunatly nginx failed to install via apt-get, installation aborting.";
	echo "Neon failed to install because nginx did not install." >> ~/neon-install/neon-install.log 2>&1;
	exit 1
fi

export DEBIAN_FRONTEND=noninteractive
apt-get -y -q  php5 vim openssl >> ~/neon-install/neon-install.log 2>&1
echo Percent Complete: 15%

if ! type -p php5 > /dev/null; then
    echo "Unfortunatly php5 failed to install via apt-get, installation aborting.";
	echo "Neon failed to install because php5 did not install." >> ~/neon-install/neon-install.log 2>&1;
	exit 1
fi

export DEBIAN_FRONTEND=noninteractive
apt-get -y -q  install php5-mysql zip unzip sqlite3 >> ~/neon-install/neon-install.log 2>&1
echo Percent Complete: 18%

export DEBIAN_FRONTEND=noninteractive
apt-get -y -q  install php5-sqlite php5-curl php-pear php5-dev acl >> ~/neon-install/neon-install.log 2>&1
echo Percent Complete: 20%

export DEBIAN_FRONTEND=noninteractive
apt-get -y -q  install libcurl4-openssl-dev php5-gd php5-imagick >> ~/neon-install/neon-install.log 2>&1
echo Percent Complete: 27%

export DEBIAN_FRONTEND=noninteractive
apt-get -y -q  install php5-imap php5-mcrypt php5-xmlrpc php5-xsl php5-suhosin php5-fpm libpcre3-dev >> ~/neon-install/neon-install.log 2>&1
echo Percent Complete: 30%

export DEBIAN_FRONTEND=noninteractive
apt-get -y -q  install build-essential php-apc git-core >> ~/neon-install/neon-install.log 2>&1
echo Percent Complete: 37%

if ! type -p git > /dev/null; then
    echo "Unfortunatly git-core failed to install via apt-get, installation aborting.";
	echo "Neon failed to install because git-core did not install." >> ~/neon-install/neon-install.log 2>&1;
	exit 1
fi

mysqlpassword=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};`
salt=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};`
export DEBIAN_FRONTEND=noninteractive >> ~/neon-install/neon-install.log 2>&1
apt-get -q -y install mysql-server >> ~/neon-install/neon-install.log 2>&1
mysqladmin -u root password $mysqlpassword >> ~/neon-install/neon-install.log 2>&1
apt-get -q -y install phpmyadmin >> ~/neon-install/neon-install.log 2>&1
echo Percent Complete: 40%

if ! type -p mysql > /dev/null; then
    echo "Unfortunatly mysql failed to install via apt-get, installation aborting.";
	echo "Neon failed to install because mysql did not install." >> ~/neon-install/neon-install.log 2>&1;
	exit 1
fi

/etc/init.d/mysql stop >> ~/neon-install/neon-install.log 2>&1
/etc/init.d/nginx stop >> ~/neon-install/neon-install.log 2>&1
/etc/init.d/php5-fpm stop >> ~/neon-install/neon-install.log 2>&1
echo Percent Complete: 44%

wget https://raw.github.com/BlueVM/Neon/develop/neonpanel/includes/configs/my.cnf >> ~/neon-install/neon-install.log 2>&1
mv /etc/my.cnf /etc/my.cnf.backup >> ~/neon-install/neon-install.log 2>&1
mv my.cnf /etc/my.cnf >> ~/neon-install/neon-install.log 2>&1
echo Percent Complete: 47%

wget https://raw.github.com/BlueVM/Neon/develop/neonpanel/includes/configs/php.conf >> ~/neon-install/neon-install.log 2>&1
mv php.conf /etc/php5/fpm/pool.d/www.conf >> ~/neon-install/neon-install.log 2>&1
echo Percent Complete: 49%

mkdir /usr/ssl >> ~/neon-install/neon-install.log 2>&1
cd /usr/ssl >> ~/neon-install/neon-install.log 2>&1
openssl genrsa -out neon.key 1024 >> ~/neon-install/neon-install.log 2>&1
openssl rsa -in neon.key -out neon.pem >> ~/neon-install/neon-install.log 2>&1
openssl req -new -key neon.pem -subj "/C=US/ST=Oregon/L=Portland/O=IT/CN=www.neonpanel.com" -out neon.csr >> ~/neon-install/neon-install.log 2>&1
openssl x509 -req -days 365 -in neon.csr -signkey neon.pem -out neon.crt >> ~/neon-install/neon-install.log 2>&1
cd ~/neon-install/ >> ~/neon-install/neon-install.log 2>&1
wget https://raw.github.com/BlueVM/Neon/develop/neonpanel/includes/configs/nginx.neon.conf >> ~/neon-install/neon-install.log 2>&1
rm -rf /etc/nginx/sites-enabled/* >> ~/neon-install/neon-install.log 2>&1
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
mysql -u root --password="$mysqlpassword" panel < /var/neon/data.sql
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

/etc/init.d/apache2 stop >> ~/neon-install/neon-install.log 2>&1
/etc/init.d/apache stop >> ~/neon-install/neon-install.log 2>&1
kill -9 $( lsof -i:80 -t ) >> ~/neon-install/neon-install.log 2>&1
/etc/init.d/nginx restart >> ~/neon-install/neon-install.log 2>&1
/etc/init.d/php5-fpm restart >> ~/neon-install/neon-install.log 2>&1
cd /var/neon/neonpanel/ >> ~/neon-install/neon-install.log 2>&1
php init.php >> ~/neon-install/neon-install.log 2>&1
rm -rf init.php >> ~/neon-install/neon-install.log 2>&1
cd ~/neon-install/ >> ~/neon-install/neon-install.log 2>&1
echo "=========NEON_INSTALL_COMPLETE========" >> ~/neon-install/neon-install.log 2>&1
echo "Mysql Root Password: $mysqlpassword" >> ~/neon-install/neon-install.log 2>&1
echo "You can now login at http://yourip:2026" >> ~/neon-install/neon-install.log 2>&1
echo "Username: root" >> ~/neon-install/neon-install.log 2>&1
echo "Password: your_root_password" >> ~/neon-install/neon-install.log 2>&1
echo "=====================================" >> ~/neon-install/neon-install.log 2>&1
echo
echo =========NEON_INSTALL_COMPLETE========
echo Mysql root password: $mysqlpassword
echo You can login at: http://yourip:2026
echo Username: root
echo Password: your_root_password
echo =====================================
echo It is reccomended you download the
echo log ~/neon-install/neon-install.log
echo and delete it from your system.