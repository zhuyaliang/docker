#!/bin/bash
#this script is responsible for install the service
#started automaticlly when power on
# %% zkong %%

usage()
{
	echo "Usage: `basename $0` <options> servicename"
	echo "<options> may be:"
	echo "    -i, --install    	install the service"
	echo "    -u, --uninstall   uninstall the service"
	echo "    --help            show this help, then exit"
	exit 0
}

uninstall_service()
{
	if [ -f /usr/lib/lsb/remove_initd ]; then
		/usr/lib/lsb/remove_initd /etc/init.d/${servicename}
	else
		killservice="K15${servicename}"
		startservice="S85${servicename}"
		
		$path_prefix
		if [ -d /etc/rc.d ]; then
			path_prefix=/etc/rc.d
		else
			path_prefix=/etc
		fi
		
		rm -f /etc/init.d/${servicename}
		rm -f ${path_prefix}/rc0.d/${killservice}
		rm -f ${path_prefix}/rc1.d/${killservice}
		rm -f ${path_prefix}/rc2.d/${killservice}
		rm -f ${path_prefix}/rc3.d/${startservice}
		rm -f ${path_prefix}/rc4.d/${killservice}
		rm -f ${path_prefix}/rc5.d/${startservice}
		rm -f ${path_prefix}/rc6.d/${killservice}
	fi
	return $?
}

install_sevice()
{
	if [ -f /usr/lib/lsb/install_initd ]; then
		/usr/lib/lsb/install_initd /etc/init.d/${servicename}
	else
		chmod 755 /etc/init.d/${servicename}
		/sbin/chkconfig --add ${servicename}  >/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			killservice="K15${servicename}"
			startservice="S85${servicename}"
		  
			$path_prefix
			if [ -d /etc/rc.d ]; then
				path_prefix=/etc/rc.d
			else
				path_prefix=/etc
			fi
		
			ln -s /etc/init.d/${servicename} ${path_prefix}/rc0.d/${killservice}
			ln -s /etc/init.d/${servicename} ${path_prefix}/rc1.d/${killservice}
			ln -s /etc/init.d/${servicename} ${path_prefix}/rc2.d/${killservice}
			ln -s /etc/init.d/${servicename} ${path_prefix}/rc3.d/${startservice}
			ln -s /etc/init.d/${servicename} ${path_prefix}/rc4.d/${killservice}
			ln -s /etc/init.d/${servicename} ${path_prefix}/rc5.d/${startservice}
			ln -s /etc/init.d/${servicename} ${path_prefix}/rc6.d/${killservice}
		fi
	fi
	return $?
}
#****************************************************************************
if [ "$UID" -ne 0 ]; then
	echo "only the root user can install or uninstall service."
	exit -1
fi
#the script entry must two parameters
if [ "$#" -ne 2 ]; then
	usage
fi
servicename="$2"
#do you have copyed the service to /etc/init.d
if [ ! -f /etc/init.d/${servicename} ]; then
	echo "can't find ${servicename} in /etc/init.d"
	exit -1
fi
case "$1" in
    --help|-\?)
        usage
        exit $?
        ;;
    --uninstall|-u)
        uninstall_service
        exit $?
        ;;
	--install|-i)
		install_sevice
		exit $?
		;;
    *)
        usage
         exit $?
        ;;
    esac
exit $?

