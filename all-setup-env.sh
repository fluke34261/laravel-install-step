#!/bin/sh

sudo apt update

# install php and php-extension

#version 7 default
#sudo apt install -y php7.4 php7.4-fpm php7.4-curl php7.4-xml php7.4-bcmath php7.4-bz2 php7.4-intl php7.4-gd php7.4-mbstring php7.4-mysql php7.4-zip php7.4-common

#version 8
sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php -y
#sudo add-apt-repository ppa:ondrej/nginx-mainline
sudo apt update --fix-missing
sudo apt install -y php8.1 php8.1-fpm php8.1-curl php8.1-xml php8.1-bcmath php8.1-bz2 php8.1-intl php8.1-gd php8.1-mbstring php8.1-mysql php8.1-zip php8.1-common

# install nginx web server
sudo apt install -y nginx

# set default nginx
sudo rm /etc/nginx/sites-available/default
sudo curl https://raw.githubusercontent.com/fluke34261/laravel-install-step/main/default -o /etc/nginx/sites-available/default

sudo service apache2 stop
sudo /etc/init.d/nginx restart

# install composer
cd ~
sudo curl -sS https://getcomposer.org/installer -o composer-setup.php
HASH=`curl -sS https://composer.github.io/installer.sig`
echo $HASH
php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
composer

# set permission
# https://stackoverflow.com/questions/30266250/how-to-fix-error-mkdir-permission-denied-when-running-composer
sudo chown -Rv $USER:$USER /var/www/html
sudo chmod -Rv g+rw /var/www/html

# create project
if [ "$1" = "lumen" ]; then
    composer create-project laravel/lumen /var/www/html/app
    echo "Lumen created"
else
    composer create-project laravel/laravel /var/www/html/app
    echo "Laravel created"
fi

ls -al /var/www/html/app
