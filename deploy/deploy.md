# deploy

## Developpement

Cf developpment (WARN : out-of-date)

## Production

### Setup server

```sh
# Change nginx conf
rsync -avhp /home/emile/Documents/project/psaule-site/nginx_config/psaule.com psaule-ec2-micro:/etc/nginx/sites-available/psaule.com --rsync-path="sudo rsync"
```

### Deploy site

```sh
# Push site to psaule-ec2-micro
rsync -avhp --delete /home/emile/Documents/project/psaule-site/public/ psaule-ec2-micro:/var/www/psaule.com/public --rsync-path="sudo rsync"
```

#### Ssh config

```sh
Host psaule-ec2
  Hostname ec2-35-180-225-196.eu-west-3.compute.amazonaws.com
  User ubuntu
  Port 22
  PreferredAuthentications publickey
  IdentityFile /home/emile/Documents/reflexion/projet/dev_freelance/1-psaule_web_site/conf/aws_ec2_psaule.pem

Host psaule-ec2-micro
  Hostname ec2-52-47-127-155.eu-west-3.compute.amazonaws.com
  User ubuntu
  Port 22
  PreferredAuthentications publickey
  IdentityFile /home/emile/Documents/reflexion/projet/dev_freelance/1-psaule_web_site/conf/aws_ec2_psaule.pem
```
