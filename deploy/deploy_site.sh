#!/bin/bash
set -e # stop script if error

ssh ubuntu-for-test "sudo mkdir -p /var/www/psaule.com/public"
rsync -av /home/emile/Documents/project/psaule-site/www/ ubuntu-for-test:/var/www/psaule.com/public --rsync-path="sudo rsync"
