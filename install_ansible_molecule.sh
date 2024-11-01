#!/bin/bash
ctrl_c()
{
printf "\n%s\n" "User Typed Ctrl + C ... Process Terminated";
exit 1;
}
trap "ctrl_c" SIGINT

sudo apt update -y
sudo apt install -y python3-pip libssl-dev python3
sudo python3 -m pip install --upgrade --user setuptools
sudo python3 -m pip install ansible-dev-tools
sudo python3 -m pip install --user molecule
sudo python3 -m pip install --user molecule ansible-lint
#sudo python3 -m pip install --user "molecule-plugins[docker]"
sudo python3 -m pip install --user "molecule[docker]" "molecule[podman]" "molecule[azure]"
