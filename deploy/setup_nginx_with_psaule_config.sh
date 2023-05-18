#!/bin/bash
set -e # stop script if error

# Create a symbolic link to your configuration file within the `sites-enabled` directory
# echo "Create symbolic link"
sudo ln -sfv /etc/nginx/sites-available/psaule.com /etc/nginx/sites-enabled/

# Test that the configuration file has no errors
# echo "Test config"
sudo nginx -t

# Tell Nginx to reload the configuration file
# echo "Relog nginx"
sudo service nginx reload
