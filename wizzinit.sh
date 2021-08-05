#!/bin/bash

PS1='\[\e[32m\u\] \[\e[36m\w\] \[\e[33m\]\[\e[1m\]$ \[\e[0m\]'

cd ~
tee -a .bashrc << EOF
PS1='\[\e[32m\u\] \[\e[36m\w\] \[\e[33m\]\[\e[1m\]$ \[\e[0m\]'
EOF

sudo apt-get update && sudo apt-get upgrade -y
sudo apt install htop -y
sudo apt install cpulimit -y
sudo apt install ncdu -y

;======================== NODE_EXPORTER ========================================================================
sudo useradd --no-create-home --shell /bin/false node_exporter;wget https://github.com/prometheus/node_exporter/releases/download/v1.2.0/node_exporter-1.2.0.linux-amd64.tar.gz;tar -xvzf node_exporter-1.2.0.linux-amd64.tar.gz;sudo cp node_exporter-1.2.0.linux-amd64/node_exporter /usr/local/bin/;sudo chmod 755 /usr/local/bin/node_exporter
rm node_exporter-1.2.0.linux-amd64.tar.gz

sudo tee <<EOF >/dev/null /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target
EOF

sudo systemctl daemon-reload;sudo systemctl start node_exporter;sudo systemctl enable node_exporter;
;=============================================================================================================
