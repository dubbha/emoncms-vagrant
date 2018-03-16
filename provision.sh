### Install Emoncms on Ubuntu / Debian Linux
### https://github.com/emoncms/emoncms/blob/master/docs/LinuxInstall.md

# Install dependencies (MySQL installed later)
sudo apt-get update
sudo apt-get install apache2 php5 libapache2-mod-php5 php5-mysql php5-curl php-pear php5-dev php5-mcrypt php5-json php5-redis git-core redis-server build-essential -y

# Configure Apache
sudo a2enmod rewrite
sudo cat <<EOF > /etc/apache2/sites-available/emoncms.conf
<Directory /var/www/html/emoncms>
    Options FollowSymLinks
    AllowOverride All
    DirectoryIndex index.php
    Order allow,deny
    Allow from all
</Directory>
EOF
sudo echo 'ServerName localhost' >> /etc/apache2/apache2.conf
sudo a2ensite emoncms
sudo service apache2 stop
sudo service apache2 start

# Install Emoncms
cd /var/www/
sudo chown $USER html
cd html
rm -rf emoncms
git clone -b stable https://github.com/emoncms/emoncms.git

# Setup Emoncms settings
cd emoncms
sudo cp -p default.settings.php settings.php
sudo sed -i 's/_DB_USER_/root/g' settings.php
sudo sed -i 's/_DB_PASSWORD_/password/g' settings.php

### Create a MYSQL database [u: root, p: password]
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'

apt-get install -y mysql-server mysql-client

mysql -uroot -ppassword -e "CREATE DATABASE IF NOT EXISTS emoncms DEFAULT CHARACTER SET utf8;";
mysql -uroot -ppassword -e "CREATE USER 'emoncms'@'localhost' IDENTIFIED BY 'emoncms';"
mysql -uroot -ppassword -e "GRANT ALL ON emoncms.* TO 'emoncms'@'localhost';"
mysql -uroot -ppassword -e "flush privileges;"

sudo service mysql restart

# Create data repositories for emoncms feed engines
sudo mkdir /var/lib/phpfiwa
sudo mkdir /var/lib/phpfina
sudo mkdir /var/lib/phptimeseries

sudo chown www-data:root /var/lib/phpfiwa
sudo chown www-data:root /var/lib/phpfina
sudo chown www-data:root /var/lib/phptimeseries


### Node.js (including NPM)
### https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
sudo apt-get update
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get install -y build-essential

### MongoDb
### https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list
sudo apt-get update
sudo apt-get install -y mongodb-org
