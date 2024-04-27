#!/bin/bash

cowsay "Gitness installation script. (GitHub: madisce)"

install() {
    read -p "Do you want to start the process? [y (YES)] " start
    if [[ $start == "y" ]]
    then
        echo "update your system."
        sudo apt update -y > /dev/null
        sudo apt install git docker nginx -y >/dev/null
        systemctl enable docker
        echo ""
        echo "Update and installing dependencies successfully"
        echo ""
        cd ~
        if git clone https://github.com/harness/gitness.git > /dev/null
        then
            cd gitness
            read -p "Enter your domain: " domain
            read -p "Enter your Port: " port
            if docker run -d -e GITNESS_URL_BASE=https://$domain -p $port:3000 -v /var/run/docker.sock:/var/run/docker.sock -v /mnt/gitness-data:/data --name gitness --restart always harness/gitness > /dev/null
            then
                echo "Gitness project are successfully deploy"
            else
                echo "cannot deploy Gitness"
            fi
            echo ""
            cat ./gitness.conf | sed "s/YOURDOAMIN/$domain//g" | sed "s/YOURPORT/$port//g" > /etc/nginx/sites-available/gitness.conf
            cd /etc/nginx/sites-available
            if ln -s /etc/nginx/sites-available/gitness.conf /etc/nginx/sites-enabled/ > /dev/null
            then
              sudo systemctl restart nginx.service
            fi
        else
            echo "cannot clone repo"
        fi
    else
        echo "Script closing"
    fi
}


a=`echo $USER`

if [[ $a == "root" ]]
then
    install
else
    echo "You should run script with root user."
fi
