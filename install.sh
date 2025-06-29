#!/bin/bash

# PTERODACTYL PANEL AUTO INSTALLER - UBUNTU 20.04/22.04

echo -e "\n🦴 Installing Pterodactyl Panel..."
echo "🔄 Updating system..."
apt update -y && apt upgrade -y

echo "📦 Installing required packages..."
apt install -y nginx mariadb-server php php-{cli,gd,mysql,mbstring,xml,fpm,curl,zip,bcmath,common,tokenizer} curl unzip git redis-server supervisor

echo "🧱 Setting up MariaDB..."
mysql_secure_installation <<EOF

y
ptero123
ptero123
y
y
y
y
EOF

mysql -u root -pptero123 -e "CREATE DATABASE panel;"
mysql -u root -pptero123 -e "CREATE USER 'ptero'@'127.0.0.1' IDENTIFIED BY 'ptero123';"
mysql -u root -pptero123 -e "GRANT ALL PRIVILEGES ON panel.* TO 'ptero'@'127.0.0.1';"
mysql -u root -pptero123 -e "FLUSH PRIVILEGES;"

echo "📁 Downloading panel files..."
cd /var/www/
curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz
mkdir -p /var/www/pterodactyl && tar -xzvf panel.tar.gz -C /var/www/pterodactyl
cd /var/www/pterodactyl

echo "📦 Installing Composer & dependencies..."
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
composer install --no-dev --optimize-autoloader

cp .env.example .env
php artisan key:generate --force

echo "⚙️ Running initial setup..."
php artisan p:environment:setup --author="admin@example.com" --url="http://localhost" --timezone="Asia/Jakarta" --cache="redis" --session="redis" --queue="redis"
php artisan p:environment:database --host=127.0.0.1 --port=3306 --database=panel --username=ptero --password=ptero123
php artisan migrate --seed --force

chown -R www-data:www-data /var/www/pterodactyl
chmod -R 755 /var/www/pterodactyl/storage/* /var/www/pterodactyl/bootstrap/cache

echo "✅ Done! Now access http://your-ip in browser"
