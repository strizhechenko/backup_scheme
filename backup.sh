#!/bin/bash

set -euE

# Usage: $0 <system_name> <list of files and directories to backup>
# Example: $0 powerplan database.sqlite3

BACKUP_DIR="/var/backups/$1"
shift

make_name() {
        local kind="$1"
        case "$kind" in
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
        return 0
}

make_backup() {
        local name="$1"
        mkdir -p "${name%/*}"
        tar cfz "$@"  # 1 archive, rest - files to backup
        return 0
}

make_links() {
        local name="$1"
        local kind
        # for kind in hourly daily monthly yearly; do
        for kind in daily monthly yearly; do
                echo "# $kind"
                tmp_name="$(make_name $kind)"
                mkdir -p "${tmp_name%/*}"
                ln -vf "$name" "$tmp_name"
        done
        return 0
}

main() {
        local name
        name="$(make_name static)"
        make_backup "$name" "$@"
        make_links "$name"
        find $BACKUP_DIR -type f -name "*.tar.gz" -links 1 -delete
        return 0
}

main "$@"

exit 0
