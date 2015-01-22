#!/bin/bash
# Author:  a950216t <a950216t AT gmail.com>
# Blog:  http://blog.myxnova.com

TEST()
{
cd $lnmp_dir/src
. ../functions/download.sh 
. ../options.conf

src_url=https://github.com/phpsysinfo/phpsysinfo/archive/v3.2.0.tar.gz && Download_src
tar zxvf v3.2.0.tar.gz
/bin/mv phpsysinfo-3.2.0 $home_dir/default/phpsysinfo
/bin/cp $lnmp_dir/conf/vpsinfo.php $home_dir/default/vpsinfo.php
/bin/cp $lnmp_dir/conf/sysinfo.php $home_dir/default/sysinfo.php

public_IP=`../functions/get_public_ip.py`
if [ "`../functions/get_ip_area.py $public_IP`" == 'CN' ];then
	FLAG_IP=CN
# else if [ "`../functions/get_ip_area.py $public_IP`" == 'TW' ];then
	# FLAG_IP=TW
# else if [ "`../functions/get_ip_area.py $public_IP`" == 'HK' ];then
	# FLAG_IP=HK
# else if [ "`../functions/get_ip_area.py $public_IP`" == 'MO' ];then
	# FLAG_IP=MO
fi

if [ "$location_1234" == "CN" ];then
	src_url=http://www.yahei.net/tz/tz.zip && Download_src
	unzip -q tz.zip -d $home_dir/default
	/bin/cp $lnmp_dir/conf/index_cn.html $home_dir/default/index.html
	rm -rf /etc/localtime
	ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	/bin/cp $lnmp_dir/conf/phpsysinfo_zh.ini $home_dir/default/phpsysinfo/phpsysinfo.ini
elif [ "$location_1234" == "TW" ];then
	src_url=http://www.yahei.net/tz/tz_tw.zip && Download_src
	unzip -q tz_tw.zip -d $home_dir/default
	/bin/cp $lnmp_dir/conf/index_tw.html $home_dir/default/index.html
	rm -rf /etc/localtime
	ln -s /usr/share/zoneinfo/Asia/Taipei /etc/localtime
	/bin/cp $lnmp_dir/conf/phpsysinfo_tw.ini $home_dir/default/phpsysinfo/phpsysinfo.ini
elif [ "$location_1234" == "HK" ];then
	src_url=http://www.yahei.net/tz/tz_tw.zip && Download_src
	unzip -q tz_tw.zip -d $home_dir/default
	/bin/mv $home_dir/default/tz_tw.php $home_dir/default/tz_hk.php
	/bin/cp $lnmp_dir/conf/index_hk.html $home_dir/default/index.html
	rm -rf /etc/localtime
	ln -s /usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime
	/bin/cp $lnmp_dir/conf/phpsysinfo_tw.ini $home_dir/default/phpsysinfo/phpsysinfo.ini
elif [ "$location_1234" == "MO" ];then
	src_url=http://www.yahei.net/tz/tz_tw.zip && Download_src
	unzip -q tz_tw.zip -d $home_dir/default
	/bin/mv $home_dir/default/tz_tw.php $home_dir/default/tz_mo.php
	/bin/cp $lnmp_dir/conf/index_mo.html $home_dir/default/index.html
	rm -rf /etc/localtime
	ln -s /usr/share/zoneinfo/Asia/Macao /etc/localtime
	/bin/cp $lnmp_dir/conf/phpsysinfo_tw.ini $home_dir/default/phpsysinfo/phpsysinfo.ini
else
	src_url=http://www.yahei.net/tz/tz_e.zip && Download_src
	unzip -q tz_e.zip -d $home_dir/default;/bin/mv $home_dir/default/{tz_e.php,proberv.php}
	sed -i 's@https://ajax.googleapis.com/ajax/libs/jquery/1.7.0/jquery.min.js@http://lib.sinaapp.com/js/jquery/1.7/jquery.min.js@' $home_dir/default/proberv.php 
	/bin/cp $lnmp_dir/conf/index.html $home_dir/default
	rm -rf /etc/localtime
	ln -s /usr/share/zoneinfo/America/New_York /etc/localtime
	/bin/cp $lnmp_dir/conf/phpsysinfo_en.ini $home_dir/default/phpsysinfo/phpsysinfo.ini
fi
src_url=https://gist.githubusercontent.com/ck-on/4959032/raw/0b871b345fd6cfcd6d2be030c1f33d1ad6a475cb/ocp.php && Download_src

echo '<?php phpinfo() ?>' > $home_dir/default/phpinfo.php
[ "$PHP_cache" == '1' ] && /bin/cp ocp.php $home_dir/default && sed -i 's@<a href="/xcache" target="_blank" class="links">xcache</a>@<a href="/ocp.php" target="_blank" class="links">Opcache</a>@' $home_dir/default/index.html
[ "$PHP_cache" == '3' ] && sed -i 's@<a href="/xcache" target="_blank" class="links">xcache</a>@<a href="/apc.php" target="_blank" class="links">APC</a>@' $home_dir/default/index.html
[ "$PHP_cache" == '4' ] && /bin/cp eaccelerator-*/control.php $home_dir/default && sed -i 's@<a href="/xcache" target="_blank" class="links">xcache</a>@<a href="/control.php" target="_blank" class="links">eAccelerator</a>@' $home_dir/default/index.html
[ "$Web_yn" == 'y' -a "$Nginx_version" != '3' -a "$Apache_version" != '3' ] && sed -i 's@LNMP@LANMP@g' $home_dir/default/index.html
[ "$Web_yn" == 'y' -a "$Nginx_version" == '3' -a "$Apache_version" != '3' ] && sed -i 's@LNMP@LAMP@g' $home_dir/default/index.html
chown -R www.www $home_dir/default
[ -e "$db_install_dir" -a -z "`ps -ef | grep -v grep | grep mysql`" ] && /etc/init.d/mysqld restart 
[ -e "$apache_install_dir" -a -z "`ps -ef | grep -v grep | grep apache`" ] && /etc/init.d/httpd restart 
cd ..
}
