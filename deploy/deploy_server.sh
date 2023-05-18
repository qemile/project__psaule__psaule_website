#!/bin/bash
set -e # stop script if error

echo "Cloning base config risan/nginx-config from github"
ssh ubuntu-for-test "bash -s" < /home/emile/Documents/project/psaule-site/deploy/clone_nginx_base.sh

echo "Copy psaule.com config"
rsync -av /home/emile/Documents/project/psaule-site/nginx_config/psaule.com ubuntu-for-test:/etc/nginx/sites-available/psaule.com --rsync-path="sudo rsync"

ssh ubuntu-for-test "bash -s" < /home/emile/Documents/project/psaule-site/deploy/setup_nginx_with_psaule_config.sh

#!/bin/bash
set +e # after this script don't stop if error

echo "Deploy end."
