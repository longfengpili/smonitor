#!/bin/bash
# @Author: longfengpili
# @Date:   2024-12-11 16:05:52
# @Last Modified by:   longfengpili
# @Last Modified time: 2024-12-11 17:34:13

mkdir ~/procs
cp ./startup.sh ~/procs/startup.sh
cp ./process.yml ~/procs/process.yml
chmod +x ~/procs/startup.sh
sudo cp procs_exporter.service /etc/systemd/system/procs_exporter.service

sudo systemctl daemon-reload
sudo systemctl enable procs_exporter.service
sudo systemctl start procs_exporter.service
sudo systemctl restart procs_exporter.service
sudo systemctl status procs_exporter.service

