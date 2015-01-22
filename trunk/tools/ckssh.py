#!/usr/bin/python
# Author:  a950216t <a950216t AT gmail.com>
# Blog:  http://blog.myxnova.com

import socket,sys
sk = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sk.settimeout(1)
try:
    sk.connect((sys.argv[1],int(sys.argv[2])))
    print 'ok' 
except Exception:
    print 'no' 
sk.close()
