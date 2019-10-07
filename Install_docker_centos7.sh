#!/bin/bash

#Name			: kalidoss
#E-mail 		: kalidossbtech@gmail.com
#git repository : https://github.com/kalidossbtech

if [[ "$UID" -ne 0 ]]; then
  echo "Sorry, you need to run this as root"
  exit 1
fi

ctrl_c()
{ 
	printf "\n%s\n" "User Typed Ctrl + C ... Process Terminated";
 	exit 1;
}
trap "ctrl_c" SIGINT



#Find  OS version
release_version=$(cat /etc/os-release  | grep ^ID= | cut -d'=' -f2)
if [[ ${release_version} == '"centos"' ]]; then
	echo "success"
fi
centos()

centos() {


# Install molecule in Centos 7 / Redhat 7
yum install epel-release -y
yum repolist all 
yum install ansible python3-pip -y

#Install docker-ce and services from repository
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
#sudo yum-config-manager --enable docker-ce-nightly # For nightly repo enable
#sudo yum-config-manager --enable docker-ce-test # For test repo
sudo yum install docker-ce docker-ce-cli containerd.io -y
#run and enable docker service
sudo systemctl enable --now docker
if [ "$?" == 0 ]; then
		sudo docker run hello-world
		if [ "$?" == 0 ]; then
			echo "docker Installed Successfully"
		fi	
fi

}

