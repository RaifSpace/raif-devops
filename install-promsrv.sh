#!/bin/bash
set -e
sudo timedatectl set-timezone Europe/Moscow
sudo systemctl restart systemd-timesyncd.service && timedatectl

sudo apt update && sudo apt install prometheus prometheus-alertmanager prometheus-node-exporter

wget https://github.com/RaifSpace/raif-devops/releases/download/prometheus-conf/prometheus-conf_0.1-1_all.deb
sudo dpkg -i prometheus-conf_0.1-1_all.deb
sudo mv /tmp/*.yml /etc/prometheus/

sudo systemctl restart prometheus
sudo systemctl restart prometheus-alertmanager.service
promtool check rules /etc/prometheus/rules.yml
