#!/bin/bash
# Author:  a950216t <a950216t AT gmail.com>
# Blog:  http://blog.myxnova.com
#
# This script's project home is:
#       http://blog.myxnova.com/lampd.html
#       https://github.com/a950216t/lampd

# Check if user is root
[ $(id -u) != "0" ] && echo "Error: You must be root to run this script" && exit 1

export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
clear
printf "
#######################################################################
#    LNMP/LAMP/LANMP for CentOS/RadHat 5+ Debian 6+ and Ubuntu 12+    #
# For more information please visit http://blog.myxnova.com/lampd.html  #
#######################################################################
"
[ ! -e "src" ] && mkdir src
cd src
. ../functions/download.sh

VPN_IP=`../functions/get_public_ip.py`

while :
do
	echo
        read -p "Please input VPN username: " VPN_USER 
        [ -n "$VPN_USER" ] && break 
done

while :
do
	echo
        read -p "Please input VPN password: " VPN_PASS 
        [ -n "$VPN_PASS" ] && break 
done

while :
do
	echo
	read -p "Please input private IP-Range(Default Range: 10.0.2): " iprange
	[ -z "$iprange" ] && iprange="10.0.2"
	if [ -z "`echo $iprange | grep -E "^10\.|^192\.168\.|^172\." | grep -o '^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$'`" ];then
		echo -e "\033[31minput error! Input format: xxx.xxx.xxx\033[0m"
	else
		break
	fi
done
clear

VPN_LOCAL=""$iprange".1"
VPN_REMOTE=""$iprange".2-254"

yum -y groupinstall "Development Tools"
rpm -Uvh http://poptop.sourceforge.net/yum/stable/rhel6/pptp-release-current.noarch.rpm
yum -y install policycoreutils policycoreutils
yum -y install ppp pptpd
yum -y update

echo "1" > /proc/sys/net/ipv4/ip_forward
sed -i 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/g' /etc/sysctl.conf
sed -i 's/net.ipv4.tcp_syncookies = 1/#net.ipv4.tcp_syncookies = 1/g' /etc/sysctl.conf

sysctl -p /etc/sysctl.conf

echo "localip $VPN_LOCAL" >> /etc/pptpd.conf # Local IP address of your VPN server
echo "remoteip $VPN_REMOTE" >> /etc/pptpd.conf # Scope for your home network

echo "ms-dns 8.8.8.8" >> /etc/ppp/options.pptpd # Google DNS Primary
echo "ms-dns 209.244.0.3" >> /etc/ppp/options.pptpd # Level3 Primary
echo "ms-dns 208.67.222.222" >> /etc/ppp/options.pptpd # OpenDNS Primary

echo "$VPN_USER pptpd $VPN_PASS *" >> /etc/ppp/chap-secrets

service iptables start
echo "iptables -t nat -A POSTROUTING -s $iprange.0/24 -o eth0 -j MASQUERADE" >> /etc/rc.local
iptables -t nat -A POSTROUTING -s ${iprange}.0/24 -o eth0 -j MASQUERADE
iptables -I INPUT -p tcp --dport 1723 -j ACCEPT
service iptables save
service iptables restart

service pptpd restart
chkconfig pptpd on

echo -e '\E[37;44m'"\033[1m You can now connect to your VPN via your external IP ($VPN_IP)\033[0m"
echo "Server Local IP:$iprange.1"
echo "Client Remote IP Range:$iprange.2-$iprange.254"
echo -e '\E[37;44m'"\033[1m Username: $VPN_USER\033[0m"
echo -e '\E[37;44m'"\033[1m Password: $VPN_PASS\033[0m"