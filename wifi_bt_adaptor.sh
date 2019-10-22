#!/bin/bash

#Name	: kalidoss
#E-mail : kalidossbtech@gmail.com
#git repository  : https://github.com/kalidossbtech

: '
This script will enable the bluetooth and wifi drivers in parrot linux kernel version 5.2.0
To run this script : ./wifi_bt_adaptor.sh
'

if [[ ! -d "compat-wireless-2010-06-28" ]]; then
	if [[ ! -f compat-wireless-2010-06-28.tar.bz2 ]]; then
			wget https://mirror2.openwrt.org/sources/compat-wireless-2010-06-28.tar.bz2
			tar -xvf compat-wireless-2010-06-28.tar.bz2
		fi	
fi

cd compat-wireless-2010-06-28
make unload && make load

