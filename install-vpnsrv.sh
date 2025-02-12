#!/bin/bash
set -e

sudo timedatectl set-ntp true || exit 1
sudo systemctl restart systemd-timesyncd
sudo systemctl enable systemd-timesyncd
sudo systemctl status systemd-timesyncd
#sudo apt-get update
#sudo apt-get install ntpdate
#sudo apt-get install -y ntp
#sudo /etc/init.d/ntp stop
#sudo ntpdate pool.ntp.org
#sudo /etc/init.d/ntp start

sudo apt update && sudo apt install openvpn easy-rsa -y
mkdir -p ~/easy-rsa
ln -s /usr/share/easy-rsa/* ~/easy-rsa/
chmod 700 ~/easy-rsa
cd ~/easy-rsa
./easyrsa init-pki
./easyrsa build-ca nopass
./easyrsa gen-req server nopass
cd
scp -i ca-key ~/easy-rsa/pki/reqs/server.req yc-user@89.169.135.4:~/easy-rsa/pki/reqs/ || exit 1
ssh -i ca-key yc-user@89.169.135.4 << COMMANDS
cd ~/easy-rsa
./easyrsa --batch sign-req server server
COMMANDS
sudo scp -i ca-key yc-user@89.169.135.4:~/easy-rsa/pki/issued/server.crt /etc/openvpn/server &&
sudo scp -i ca-key yc-user@89.169.135.4:~/easy-rsa/pki/ca.crt /etc/openvpn/server || exit 1
cd ~/easy-rsa
openvpn --genkey --secret ta.key &&
sudo cp ta.key /etc/openvpn/server || exit 1
sudo cp ~/easy-rsa/pki/private/server.key /etc/openvpn/server || exit 1
mkdir -p ~/clients/keys
chmod -R 700 ~/clients
./easyrsa gen-req client-19 nopass
cp ~/easy-rsa/pki/private/client-19.key ~/clients/keys/
cd
scp -i ca-key ~/easy-rsa/pki/reqs/client-19.req yc-user@89.169.135.4:~/easy-rsa/pki/reqs/ || exit 1
ssh -i ca-key yc-user@89.169.135.4 << COMMANDS
cd ~/easy-rsa
./easyrsa --batch sign-req client client-19
COMMANDS
sudo scp -i ca-key yc-user@89.169.135.4:~/easy-rsa/pki/issued/client-19.crt ~/clients/keys/ || exit 1
cd ~/easy-rsa
sudo cp ta.key ~/clients/keys/
sudo chown yc-user:yc-user ~/clients/keys/*
cd
wget https://github.com/RaifSpace/raif-devops/releases/download/v0.1.1-vpn/vpnsrv-conf_0.1-1_all.deb
sudo dpkg -i vpnsrv-conf_0.1-1_all.deb || exit 1
sudo chmod +x iptables.sh
sudo chmod 700 ~/clients/make-config.sh
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf || exit 1
sudo sysctl -p
mkdir -p ~/clients/files
sudo systemctl status openvpn-server@server.service
sudo apt install iptables-persistent
sudo chown yc-user:yc-user base.conf
sudo chown yc-user:yc-user make-config.sh
sudo cp /etc/openvpn/server/ca.crt ~/clients/keys/
sudo chown yc-user:yc-user ~/clients/keys/ca.crt
