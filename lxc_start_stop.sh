#!/bin/bash
cat << -options-
Please select the option
1 . lxc-start
2 . lxc-stop
-options-

ctrl_c()
{
printf "\n%s\n" "User Typed Ctrl + C ... Process Terminated";
exit 1;
}
trap "ctrl_c" SIGINT

read -p "Please choose option: " option
if [ $option == 1 ];then
echo "lxc begins to start the containers"
for i in {centos_1,centos_2,ubuntu_1,ubuntu_2};do lxc-start --name $i -d; echo "$i started"; done; sleep 10; lxc-ls -f;
fi

if [ $option == 2 ];then
echo "lxc begins to stop the container"
for i in {centos_1,centos_2,ubuntu_1,ubuntu_2};do lxc-stop --name $i ; echo "$i stopped \n"; done; sleep 5; lxc-ls -f;
fi
