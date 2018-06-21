#!/bin/sh

# install using software
sudo apt-get update && upgrade
sudo apt-get install -y aptitude git zsh amule-daemon amule-utils python-pip transmission crudini apache2 jq
sudo pip install shadowsocks

# set up on-my-zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# set up amule-daemon and amulecmd
sudo useradd amule
crudini --set /etc/default/amule-damon AMULED_USER amule
crudini --set /etc/default/amule-daemon AMULED_HOME /home/amule
sudo service amule-daemon restart

crudini --set /home/amule/.aMule/amule.conf ExternalConnect AcceptExternalConnections 1
crudini --set /home/amule/.aMule/amule.conf ECPassword "$amulepassword"
amulecmd --create-config-from /home/amule/.aMule/amule.conf

# set up symbolic link to serve files
ln -s /var/www/html/files ~/files

# set up shadowsocks
mkdir /etc/shadowsocks
jq -n --arg password $sspassword (cat ./shadowsocks.config) > /etc/shadowsocks/shadowsocks.config
mv ./shadowsocks.service /etc/shadowsocks/shadowsocks.service
systemctl enable /etc/shadowsocks/shadowsocks.service

#






