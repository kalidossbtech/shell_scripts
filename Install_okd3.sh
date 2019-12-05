#!/bin/bash

#Name			: kalidoss
#E-mail 		: kalidossbtech@gmail.com
#git repository : https://github.com/kalidossbtech

: '
This script will install the DNS server bind in your server
To run this script : ./install_okd3.sh
'

if [[ "$UID" -ne 0 ]]; then
  echo "Sorry, you need to run this as root"
  exit 1
fi

sudo yum -y update
sudo yum install -y yum-utils device-mapper-persistent-data lvm2 wget
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y  docker-ce docker-ce-cli containerd.io
if [[ "$?" -eq 0 ]]; then
	sudo usermod -aG docker $USER
	newgrp docker
fi

sudo mkdir /etc/docker /etc/containers

sudo tee /etc/containers/registries.conf<<EOF
[registries.insecure]
registries = ['172.30.0.0/16']
EOF

sudo tee /etc/docker/daemon.json<<EOF
{
   "insecure-registries": [
     "172.30.0.0/16"
   ]
}
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker && sudo systemctl enable docker

echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

DOCKER_BRIDGE=`docker network inspect -f "{{range .IPAM.Config }}{{ .Subnet }}{{end}}" bridge`

sudo firewall-cmd --permanent --new-zone dockerc
sudo firewall-cmd --permanent --zone dockerc --add-source $DOCKER_BRIDGE
sudo firewall-cmd --permanent --zone dockerc --add-port={80,443,8443}/tcp
sudo firewall-cmd --permanent --zone dockerc --add-port={53,8053}/udp
sudo firewall-cmd --reload

mkdir -p /data/openshift/
cd /data/openshift/
wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
tar xvf openshift-origin-client-tools*.tar.gz
cd openshift-origin-client*/
sudo mv  oc kubectl  /usr/local/bin/

oc version 

oc cluster up


