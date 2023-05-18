#!/bin/bash
set -e # stop script if error

sudo rm -rf /etc/nginx.bak
sudo mv /etc/nginx /etc/nginx.bak

sudo git clone https://github.com/risan/nginx-config.git /etc/nginx
