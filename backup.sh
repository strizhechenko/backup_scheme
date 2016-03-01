#!/bin/bash

. /usr/local/Reductor/etc/const

BACKUP_DIR="/var/lib/reductor/backups"

make_name() {
	local kind
	kind="$1"
	case $kind in
	hourly )
		date +$BACKUP_DIR/last_24_hours/%H.tar.gz
		;;
	daily )
		date +$BACKUP_DIR/last_30_days/%d.tar.gz
		;;
	monthly )
		date +$BACKUP_DIR/last_12_month/%m.tar.gz
		;;
	yearly )
		date +$BACKUP_DIR/yearly/%Y.tar.gz
		;;
	static )
		date +$BACKUP_DIR/all/%Y.%m.%d_%H.%M.tar.gz
		;;
	esac
}

make_backup() {
	mkdir -p "${1%/*}"
	tar cfz "$@"
}

make_links() {
	local name
	name=$1
	for kind in hourly daily monthly yearly; do
		echo "# $kind"
		tmp_name="$(make_name $kind)"
		mkdir -p "${tmp_name%/*}"
		ln -vf "$name" "$tmp_name"
	done
}

delete_useless() {
	find /var/lib/reductor/backups/all/ -type f -name "*.tar.gz" -links 1 -exec rm -vf {} \;
}

name="$(make_name static)"
make_backup "$name" "$DUMPXML" "$LISTDIR"
make_links
delete_useless
