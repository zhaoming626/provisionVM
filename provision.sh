#!/bin/sh

# install using software
sudo apt-get update && upgrade
sudo apt-get install -y aptitude git zsh amule-daemon amule-utils python-pip transmission crudini apache2 jq
sudo pip install shadowsocks

# append public key to authorized_keys
echo $macbookPro > ./.ssh/authorized_keys
echo $officeSshPublicKey > ./.authorized_keys

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

# azcopy for weekly backup
sudo echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-trusty-prod/ trusty main" > azure.list
sudo cp ./azure.list /etc/apt/sources.list.d/
apt-key adv --keyserver packages.microsoft.com --recv-keys B02C46DF417A0893
mv azure.list
sudo apt-get update
sudo apt-get install azcopy

# set timezone as Asia/Shanghai
timedatectl set-timezone Asia/Shanghai






