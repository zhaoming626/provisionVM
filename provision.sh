#!/bin/sh

# install using software
sudo apt-get update && upgrade
sudo apt-get install -y aptitude git zsh amule-daemon amule-utils python-pip transmission crudini apache2 jq systemd
sudo curl https://github.com/fatedier/frp/releases/download/v0.20.0/frp_0.20.0_linux_arm64.tar.gz
sudo tar -xvzf frp_0.20.0_linux_arm64.tar.gz
sudo pip install shadowsocks

# append public key to authorized_keys
# echo $macbookPro > ./.ssh/authorized_keys
# echo $officeSshPublicKey > ./.authorized_keys

# set up on-my-zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# set up amule-daemon and amulecmd
sudo useradd amule
sudo mkdir -p /home/amule
sudo crudini --set /etc/default/amule-daemon "" AMULED_USER "amule"
sudo crudini --set /etc/default/amule-daemon "" AMULED_HOME "/home/amule"
sudo service amule-daemon restart

password = echo "password" | md5sum | cut -d ' ' -f 1
sudo crudini --set /home/amule/.aMule/amule.conf ExternalConnect AcceptExternalConnections 1
sudo crudini --set /home/amule/.aMule/amule.conf ExternalConnect ECPassword $password
sudo amulecmd --create-config-from=/home/amule/.aMule/amule.conf
sudo service amule-daemon restart

# set up symbolic link to serve files
sudo ln -s /var/www/html/files ~/files

# set up shadowsocks
sudo mkdir /etc/shadowsocks
sudo jq -n --arg password $sspassword (cat ./shadowsocks.config) > /etc/shadowsocks/shadowsocks.config
sudo mv ./shadowsocks.service /etc/systemd/system/ssserver.service
sudo chmod 664 /etc/systemd/system/ssserver.service
sudo systemctl enable /etc/systemd/system/ssserver.service

# azcopy for weekly backup
sudo echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-trusty-prod/ trusty main" > azure.list
sudo cp ./azure.list /etc/apt/sources.list.d/
sudo apt-key adv --keyserver packages.microsoft.com --recv-keys B02C46DF417A0893
sudo mv azure.list
sudo apt-get update
sudo apt-get install azcopy

# set timezone as Asia/Shanghai
sudo timedatectl set-timezone Asia/Shanghai






