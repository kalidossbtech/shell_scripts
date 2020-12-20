#!/bin/bash

#name			: kalidoss
#e-mail 		: kalidossbtech@gmail.com
#git repository : https://github.com/kalidossbtech


# install prometheus application on Centos/Redhat Servers


#Confirm that wget is installed to download the files


: '
This script will install prometheus Server in your centos box
To run this script : ./install_prometheus.sh
'

# Functions and modules
ctrl_c()
{ 
	printf "\n%s\n" "User Typed Ctrl + C ... Process Terminated";
 	exit 1;
}
trap "ctrl_c" SIGINT

#only root can run this script
if [[ "$UID" -ne 0 ]]; then
  echo "Sorry, you need to run this as root"
  exit 1
fi


#Variables
DOWNLOAD_URL=https://github.com/prometheus/prometheus/releases/download/v2.23.0/prometheus-2.23.0.linux-amd64.tar.gz

install_prometheus()
{
	#Download and extract the package
	if [[ ! $(which wget) ]];then yum install wget -y; fi 
	echo "Downloading prometheus..."
	wget  ${DOWNLOAD_URL} -O /tmp/prometheus-2.23.0.linux-amd64.tar.gz

	tar -xvf /tmp/prometheus-2.23.0.linux-amd64.tar.gz -C /tmp/
	
	useradd -m -s /bin/false prometheus
	id prometheus
	mkdir -p /etc/prometheus /var/lib/prometheus


	cp -r /tmp/prometheus-2.23.0.linux-amd64/{prometheus,promtool} /usr/local/bin/
	cp -r /tmp/prometheus-2.23.0.linux-amd64/{consoles,console_libraries,prometheus.yml} /etc/prometheus/

	chown -R prometheus:prometheus /var/lib/prometheus/
	chown -R prometheus:prometheus /etc/prometheus
	chown -R prometheus:prometheus /etc/prometheus/{consoles,console_libraries,prometheus.yml} 
	chown prometheus:prometheus /usr/local/bin/{prometheus,promtool}


	touch /etc/systemd/system/prometheus.service

	#Systemd service
#######################################################################
cat << EOF >> /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
	--config.file /etc/prometheus/prometheus.yml \
	--storage.tsdb.path /var/lib/prometheus/ \
	--web.console.templates=/etc/prometheus/consoles \
	--web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target

EOF
#######################################################################

	systemctl daemon-reload
	systemctl enable --now prometheus.service

	firewall-cmd --add-port=9090/tcp --permanent
	firewall-cmd --add-port=9090/tcp 


}


uninstall_prometheus()
{	
	systemctl stop prometheus.service
	rm -rf /etc/prometheus /var/lib/prometheus
	userdel -r prometheus
	firewall-cmd --remove-port=9090/tcp --permanent
	firewall-cmd --remove-port=9090/tcp 	
	rm -rf /etc/systemd/system/prometheus.service

}

install_prometheus;
#uninstall_prometheus;

