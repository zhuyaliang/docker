#!/bin/bash

export LD_LIBRARY_PATH=/home/kingbase/KingbaseES/bin:/home/kingbase/KingbaseES/lib
export PATH=/home/kingbase/KingbaseES/bin:$PATH

# init kingbase create database table 
if [ ! -d "/home/kingbase/data/DB" ]; then
rm -rf /home/kingbase/data/*
 /home/kingbase/KingbaseES/bin/initdb -U$1 -W$2 --ssousername=SSO --ssopassword=123456 --saousername=SAO --saopassword=123456 --database=TEST -D /home/kingbase/data
mv /home/kingbase/KingbaseES/config/kingbase.conf /home/kingbase/data/.
fi

# delete pid file
if [ -f "/home/kingbase/data/kingbase.pid" ]; then
	rm -rf /home/kingbase/data/kingbase.pid
fi

#start kingbase
/home/kingbase/KingbaseES/bin/sys_ctl  -D /home/kingbase/data/ start
tail -l

