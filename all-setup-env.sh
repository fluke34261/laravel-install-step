#!/bin/sh

# install php and php-extension
sudo apt install -y php7.4 php7.4-curl php7.4-xml php7.4-bcmath php7.4-bz2 php7.4-intl php7.4-gd php7.4-mbstring php7.4-mysql php7.4-zip php7.4-common

# install nginx web server
sudo apt install -y nginx

# install composer
cd ~
curl -sS https://getcomposer.org/installer -o composer-setup.php
HASH=`curl -sS https://composer.github.io/installer.sig`
echo $HASH
php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
composer

# set permission
# https://stackoverflow.com/questions/30266250/how-to-fix-error-mkdir-permission-denied-when-running-composer
sudo chown -Rv root:$USER /var/www/html
sudo chmod -Rv g+rw /var/www/html

# create project
# https://laravel.com/docs/master/installation
composer create-project laravel/laravel /var/www/html/app
ls -al /var/www/html/app
