#!/bin/bash
set -e

sudo timedatectl set-timezone Europe/Moscow
sudo systemctl restart systemd-timesyncd.service && timedatectl

#sudo apt-get update && sudo apt-get install ntpdate ntp -y
#sudo /etc/init.d/ntp stop
#sudo ntpdate pool.ntp.org
#sudo /etc/init.d/ntp start

wget https://github.com/RaifSpace/raif-devops/releases/download/v0.1.1/easy-rsa-vars_0.1-1_all.deb

sudo iptables -F
sudo iptables -X
sudo iptables -t nat -F
sudo iptables -t nat -X
sudo iptables -t mangle -F
sudo iptables -t mangle -X
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
sudo iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
sudo iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
sudo apt update && sudo apt install iptables-persistent -y
sudo netfilter-persistent save && sudo systemctl enable netfilter-persistent

sudo apt install easy-rsa -y
sudo dpkg -i easy-rsa-vars_0.1-1_all.deb || exit 1
mkdir -p ~/easy-rsa
ln -s /usr/share/easy-rsa/* ~/easy-rsa/
chmod 700 ~/easy-rsa
cd ~/easy-rsa
./easyrsa init-pki || exit 1
./easyrsa build-ca nopass || exit 1

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo docker pull ribbybibby/ssl-exporter
sudo docker run -d --restart=unless-stopped -p 9219:9219 ribbybibby/ssl-exporter:latest

sudo apt install prometheus-node-exporter -y

sudo iptables -A INPUT -p tcp --dport 9100 -s 89.169.154.113 -j ACCEPT
sudo service netfilter-persistent save
