#!/bin/bash
set -e

#sudo timedatectl set-ntp true
#systemctl unmask systemd-timesyncd.service
#sudo systemctl start systemd-timesyncd
#sudo systemctl enable systemd-timesyncd
#sudo systemctl status systemd-timesyncd
sudo apt-get update && sudo apt-get install ntpdate ntp -y
sudo /etc/init.d/ntp stop
sudo ntpdate pool.ntp.org
sudo /etc/init.d/ntp start

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