## 簡介
* 1. LAMP 指的是 Linux + Apache + MySQL + PHP 運行環境
* 2. LAMP 一鍵安裝是用 Linux Shell 語言編寫的，用於在 Linux 系統(Redhat/CentOS/Fedora)上一鍵安裝 LAMP 環境的工具腳本。

## 本腳本的系統需求
* 需要 2GB 及以上磁盤剩餘空間
* 需要 256M 及以上內存空間
* 服務器必須配置好軟件源和可連接外網
* 必須具有系統 Root 權限
* 建議使用乾淨系統全新安裝
* 日期：2015年01月08日

## 關於本腳本
* 支持 PHP 自帶所有組件；
* 支持 MySQL ，MariaDB， SQLite 數據庫;
* 支持 OCI8 （可選安裝）；
* 支持 pure-ftpd （可選安裝）；
* 支持 memcached （可選安裝）；
* 支持 ImageMagick （可選安裝）；
* 支持 GraphicsMagick （可選安裝）；
* 支持 Zend Guard Loader （可選安裝）；
* 支持 ionCube PHP Loader （可選安裝）；
* 支持 XCache ，Zend OPcache （可選安裝）；
* 命令行新增虛擬主機，操作簡便；
* 自助升級 PHP，phpMyAdmin，MySQL 或 MariaDB 至最新版本；
* 支持創建 FTP 用戶；
* 一鍵卸載。

## 將會安裝
*  1、Apache 2.4.10
*  2、MySQL 5.6.22, MySQL 5.5.41, MariaDB 5.5.41, MariaDB 10.0.15 （四選一安裝）
*  3、PHP 5.4.36, PHP 5.3.29, PHP 5.5.20 （三選一安裝）
*  4、phpMyAdmin 4.3.7
*  5、OCI8 2.0.8 （可選安裝）
*  6、xcache 3.2.0 （可選安裝）
*  7、pure-ftpd-1.0.36 （可選安裝）
*  8、memcached-1.4.22 （可選安裝）
*  9、Zend OPcache 7.0.4 （可選安裝）
* 10、ImageMagick-6.9.0-3 （可選安裝）
* 11、GraphicsMagick-1.3.20 （可選安裝）
* 12、Zend Guard Loader 3.3 （可選安裝）
* 13、ionCube PHP Loader 4.6.1 （可選安裝）

## 如何安裝
### 事前準備（安裝screen、unzip，創建 screen 會話）：

    yum -y install wget screen unzip
    screen -S lamp

### 第一步，下載、解壓、賦予權限：

    wget --no-check-certificate https://github.com/a950216t/lamp/archive/master.zip -O lamp.zip
    unzip lamp.zip
    cd lamp-master/
    chmod +x *.sh

### 第二步，安裝LAMP
終端中輸入以下命令：

    ./lamp.sh 2>&1 | tee lamp.log

### 安裝其它：

*  1、（可選安裝）執行腳本 xcache.sh 安裝 xcache 。(命令：./xcache.sh)
*  2、（可選安裝）執行腳本 oci8_oracle11g.sh 安裝 OCI8 擴展以及 oracle-instantclient11.2（命令：./oci8_oracle11g.sh）
*  3、（可選安裝）執行腳本 pureftpd.sh 安裝 pure-ftpd-1.0.36。(命令：./pureftpd.sh)
*  4、（可選安裝）執行腳本 ZendGuardLoader.sh 安裝 Zend Guard Loader。(命令：./ZendGuardLoader.sh)
*  5、（可選安裝）執行腳本 ioncube.sh 安裝 ionCube PHP Loader。(命令：./ioncube.sh)
*  6、（可選安裝）執行腳本 ImageMagick.sh 安裝 imagick 的 PHP 擴展。（命令：./ImageMagick.sh）
*  7、（可選安裝）執行腳本 GraphicsMagick.sh 安裝 gmagick 的 PHP 擴展。（命令：./GraphicsMagick.sh）
*  8、（可選安裝）執行腳本 opcache.sh 安裝 Zend OPcache 的 PHP 擴展。（命令：./opcache.sh）
*  9、（可選安裝）執行腳本 memcached.sh 安裝 memcached 及 memcached 的 PHP 擴展。（命令：./memcached.sh）
* 10、（升級腳本）執行腳本 upgrade_php.sh 將會升級 PHP 和 phpMyAdmin 至最新版本。(命令：./upgrade_php.sh | tee upgrade_php.log)
* 11、（升級腳本）執行腳本 upgrade_mysql.sh 將會升級 MySQL 至已安裝版本的最新版本。(命令：./upgrade_mysql.sh | tee upgrade_mysql.log)
* 12、（升級腳本）執行腳本 upgrade_mariadb.sh 將會升級 MariaDB 至已安裝版本的最新版本。(命令：./upgrade_mariadb.sh | tee upgrade_mariadb.log)

### 關於 upgrade_php.sh

新增 upgrade_php.sh 腳本，目的是為了自動檢測和升級 PHP 和 phpMyAdmin。這兩種軟件版本更新比較頻繁，因此才會有此腳本，方便升級。

**使用方法：**

    ./upgrade_php.sh | tee upgrade_php.log

### 關於 upgrade_mysql.sh

新增 upgrade_mysql.sh 腳本，目的是為了自動檢測和升級 MySQL 。升級之前自動備份全部數據庫，在升級完成之後再將備份恢復。

**使用方法：**

    ./upgrade_mysql.sh | tee upgrade_mysql.log

### 關於 upgrade_mariadb.sh

新增 upgrade_mariadb.sh 腳本，目的是為了自動檢測和升級 MariaDB。升級之前自動備份全部數據庫，在升級完成之後再將備份恢復。

**使用方法：**

    ./upgrade_mariadb.sh | tee upgrade_mariadb.log

### 注意事項

1、執行腳本時出現下面的錯誤提示時該怎麼辦？

    -bash: ./lamp.sh: /bin/bash^M: bad interpreter: No such file or directory

是因為Windows下和Linux下的文件編碼不同所致。
解決辦法是執行：

    vi lamp.sh

輸入命令

    :set ff=unix 

回車後，輸入ZZ（兩個大寫字母z），即可保存退出。

2、連接外部Oracle服務器出現ORA-24408:could not generate unique server group name這樣的錯誤怎麼辦？
解決辦法是在hosts中將主機名添加即可：

    vi /etc/hosts

    127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4 test
    ::1 localhost localhost.localdomain localhost6 localhost6.localdomain6 test

上面的示例中，最後的那個test即為主機名。更改完畢後，輸入ZZ（兩個大寫字母Z），即可保存退出。
然後重啟網絡服務即可。

    service network restart

3、增加 FTP 用戶相關

在運行 lamp ftp add 命令之前，先要安裝 pure-ftpd ，如果開啟了防火牆的話，還需要對端口 21 放行。
執行以下命令安裝 pure-ftpd：

    ./pureftpd.sh 2>&1 | tee pureftpd.log
    
##使用提示：

* lamp add(del,list)：創建（刪除，列出）虛擬主機。
* lamp ftp(add|del|list)：創建（刪除，列出） FTP 用戶。
* lamp uninstall：一鍵刪除 LAMP （切記，刪除之前注意備份好數據！）

##程序目錄：

* MySQL 安裝目錄: /usr/local/mysql
* MySQL 數據庫目錄：/usr/local/mysql/data（默認路徑，安裝時可更改）
* MariaDB 安裝目錄: /usr/local/mariadb
* MariaDB 數據庫目錄：/usr/local/mariadb/data（默認路徑，安裝時可更改）
* PHP 安裝目錄: /usr/local/php
* Apache 安裝目錄： /usr/local/apache

##命令一覽：
* MySQL 或 MariaDB 命令: 

        /etc/init.d/mysqld(start|stop|restart|status)

* Apache 命令: 

        /etc/init.d/httpd(start|stop|restart|status)

##網站根目錄：

安裝完後默認的網站根目錄： /data/www/default

如果你在安裝後使用遇到問題，請訪問 [http://lamp.myxnova.com/](http://lamp.myxnova.com/) 或發郵件至 a950216t@gmail.com

最後，祝你使用愉快！