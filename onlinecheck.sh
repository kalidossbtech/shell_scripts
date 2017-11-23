#!/bin/bash

#name	:	kalidoss
#e-mail : kalidossbtech@gmail.com
#git repository  : https://github.com/kalidossbtech


declare -a SIP
#Enter the ip addrees with space here
SIP=( 192.168.1.7 192.168.2.7 192.168.1.78 192.168.1.40 192.168.1.8 192.168.2.8 192.168.1.24 )

#color code for terminal
SUCCESS_COLOR='\e[92m';
FAILURE_COLOR='\e[91m';
IP_COLOR='\e[96m';
END_COLOR='\e[0m';

# Functions and modules
ctrl_c()
{ 
	printf "\n%s\n" "User Typed Ctrl + C ... Process Terminated";
 	exit 1;
}
trap "ctrl_c" SIGINT

#method  to find status
ping_ip() 
{
printf "%s\n" "Please wait we are verifying the Server Machines";
for x in  ${SIP[@]}; do
{
	printf "%s\n" "Connecting with Server ${x} ";
	ping -c 5 -i .5 ${x} 2>&1 > /dev/null ;
	if [ $? = 0 ] ; then printf "%b\n" "Server ${IP_COLOR}${x}${END_COLOR}  ${SUCCESS_COLOR}Online${END_COLOR}"; else printf "%b\n" "Server ${x} is ${FAILURE_COLOR}Offline${END_COLOR}"; fi
}
done
}


# Check the user is Root or Not
if [ ! $EUID = 0 ]; then { printf "%s\n" "You are not a Root"; exit 1; } fi 
printf "%s\n" "Welcome to Server status Tool";

printf "%s\n" "";


cat << STARTER 
############################################################
#           Welcome to Do With Linux                       #
############################################################


STARTER

printf "%s\n" "We are checking Ip address";

ping_ip;
