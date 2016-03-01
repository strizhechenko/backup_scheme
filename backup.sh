#!/bin/bash

. /usr/local/Reductor/etc/const

make_name() {
	local kind
	kind="$1"
	case $kind in
	hourly )
		date +/var/lib/reductor/backups/last_24_hours/%H.tar.gz
		;;
	daily )
		date +/var/lib/reductor/backups/last_30_days/%d.tar.gz
		;;
	monthly )
		date +/var/lib/reductor/backups/last_12_month/%m.tar.gz
		;;
	yearly )
		date +/var/lib/reductor/backups/yearly/%Y.tar.gz
		;;
	static )
		date +/var/lib/reductor/backups/all/%Y.%m.%d_%H.%M.tar.gz
		;;
	esac
}

name="$(make_name static)"
mkdir -p "${name%/*}"
tar cfz "$name" $DUMPXML $LISTDIR
for kind in hourly daily monthly yearly; do
	echo "# $kind"
	tmp_name="$(make_name $kind)"
	mkdir -p "${tmp_name%/*}"
	ln -vf "$name" "$tmp_name"
done

find /var/lib/reductor/backups/all/ -type f -name "*.tar.gz" -links 1 -exec rm -vf {} \;
