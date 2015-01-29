#!/bin/bash
# Author:  a950216t <a950216t AT gmail.com>
# Blog:  http://blog.myxnova.com

Install_phpMyAdmin()
{
cd $lnmp_dir/src
. ../functions/download.sh 
. ../options.conf 

src_url=http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/4.3.8/phpMyAdmin-4.3.8-all-languages.tar.gz && Download_src

tar xzf phpMyAdmin-4.3.8-all-languages.tar.gz
/bin/mv phpMyAdmin-4.3.8-all-languages $home_dir/default/phpMyAdmin
/bin/cp $lnmp_dir/conf/config.inc.php $home_dir/default/phpMyAdmin/config.inc.php
mkdir $home_dir/default/phpMyAdmin/{upload,save}
sed -i "s@blowfish_secret.*@blowfish_secret'\] = '"$HOSTNAME"."$RANDOM"';@" $home_dir/default/phpMyAdmin/config.inc.php
sed -i "s@controlpass.*@controlpass'\] = '"$dbrootpwd"';@" $home_dir/default/phpMyAdmin/config.inc.php
sed -i "s@UploadDir.*@UploadDir'\] = 'upload';@" $home_dir/default/phpMyAdmin/config.inc.php
sed -i "s@SaveDir.*@SaveDir'\] = 'save';@" $home_dir/default/phpMyAdmin/config.inc.php
chown -R www.www $home_dir/default/phpMyAdmin
cd ..
$mysql_install_dir/bin/mysql -uroot -p$dbrootpwd <<EOF
CREATE DATABASE phpmyadmin;
USE phpmyadmin;
source /home/wwwroot/default/phpMyAdmin/examples/create_tables.sql;
flush privileges;
exit
EOF
}
