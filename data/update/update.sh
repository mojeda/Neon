rm -rf /etc/nginx/sites-enabled/nginx.neon.conf
cp /var/neon/neonpanel/includes/configs/nginx.neon.conf /etc/nginx/sites-enabled/nginx.neon.conf
service nginx reload