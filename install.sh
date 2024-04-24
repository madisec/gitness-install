#!/bin/bash

echo "Gitness project\n"
echo "Cloning Gitness"
cd ~
git clone https://github.com/harness/gitness.git
cd gitness

docker run -d \
  -e GITNESS_URL_BASE=https://$1 \
  -p $2:3000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /mnt/gitness-data:/data \
  --name gitness \
  --restart always \
  harness/gitness

echo "Config Nginx"
cat gitness.conf | sed "s/YOURDOAMIN/$1/g" > /etc/nginx/sites-available/gitness.conf

ln -s /etc/nginx/sites-available/gitness.conf /etc/nginx/sites-enabled

systemctl reload nginx

echo "FINISHED"
