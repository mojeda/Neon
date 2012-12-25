apt-get update && apt-get -y upgrade --show-upgraded
echo -e "deb http://packages.dotdeb.org squeeze all" >> /etc/apt/sources.list
gpg --keyserver keys.gnupg.net --recv-key 89DF5277 && gpg -a --export 89DF5277 | apt-key add -
apt-get update
[[ $(pgrep apache2) ]] && service apache2 stop && update-rc.d -f apache2 disable
apt-get -y install nginx
apt-get -y install php5-fpm php5-gd php5-curl php5-mysql php5-cli php5-sqlite
apt-get -y install mysql-server
mkdir /var/www/neonpanel
cd /etc/nginx/sites-enabled/
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
        fastcgi_param  REQUEST_URI    $request_uri;
        fastcgi_param  DOCUMENT_URI   $document_uri;
        fastcgi_param  DOCUMENT_ROOT  $document_root;
        fastcgi_param  REMOTE_ADDR    $remote_addr;
        fastcgi_param  REMOTE_PORT    $remote_port;
        fastcgi_param  SERVER_ADDR    $server_addr;
        fastcgi_param  SERVER_PORT    $server_port;
        fastcgi_param  SERVER_NAME    $server_name;
        fastcgi_param  QUERY_STRING   $query_string;
        fastcgi_param  REQUEST_METHOD $request_method;
        fastcgi_param  CONTENT_TYPE   $content_type;
        fastcgi_param  CONTENT_LENGTH $content_length;
 
        ## prevent php version info
        fastcgi_hide_header X-Powered-By;
    }
}" > neonpanel
cd /var/www
echo "<div align='center'>Neon Panel Default Page</div>" > index.php
for s in nginx php5-fpm mysql; do service $s restart; done
apt-get -y install php5-apc && service php5-fpm restart
mkdir /var/www/neonpanel/downloads
mkdir /var/www/neonpanel/uploads
chmod 777 downloads
chmod 777 uploads