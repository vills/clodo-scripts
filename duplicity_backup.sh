#!/bin/bash

CONTAINER=`hostname`

export CLOUDFILES_USERNAME=storage_12345_3
export CLOUDFILES_APIKEY=b114a11e548a81dd43dfe4137be026ff
export CLOUDFILES_AUTHURL=http://testapi.clodo.ru
export PASSPHRASE=pass

# duplicity settings
DUPL_TIMEOUT=360 # Socket timeout (seconds)
DUPL_VOLSIZE=10 # Change the volume size to (Mb)


case "$1" in
	"backup" )
		duplicity --archive-dir /tmp/duplicity --timeout $DUPL_TIMEOUT --volsize $DUPL_VOLSIZE --include /root --include /home --include /etc --include /scripts --include /var/www --exclude '**' / cf+http://${CONTAINER}
		;;
	"list" )
		duplicity list-current-files cf+http://${CONTAINER}
		;;
	"restore" )
		duplicity restore cf+http://${CONTAINER} /tmp/${2}
		;;
	"stat" )
		duplicity collection-status cf+http://${CONTAINER}
		;;
	"compare" )
		# if need ??
		duplicity verify cf+http://${CONTAINER} $1
		;;
	"compare-full" )
		duplicity verify -v4 cf+http://${CONTAINER} $1
		;;
	* )
		echo "Usage: ..."
		;;
esac
