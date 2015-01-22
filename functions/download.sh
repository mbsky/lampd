#!/bin/bash
# Author:  a950216t <a950216t AT gmail.com>
# Blog:  http://blog.myxnova.com

Download_src()
{
	[ -s "${src_url##*/}" ] && echo "${src_url##*/} found" || wget -c --no-check-certificate $src_url
        if [ ! -e "${src_url##*/}" ];then
                echo -e "\033[31m${src_url##*/} download failed, Please contact the author! \033[0m"
                kill -9 $$
        fi
}
