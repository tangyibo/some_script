#!/bin/bash
############################################
# Function: Greenplum数据库数据全量备份脚本
# Author: tang
# Date : 2020-12-07
#
# Usage: sh backupall.sh
#
###########################################
BACKDIR=/data/gpdb/backup

if [ "$(whoami)" != 'gpadmin' ]; then
        echo "[ERROR]: You have no permission to run $0 as gpadmin user."
        exit 1
fi

DIR="$( cd "$( dirname "$0"  )" && pwd  )"
DBNAMES=( $(psql -t -c 'SELECT sodddatname as database_name from gp_toolkit.gp_size_of_database') )

chmod u+x $DIR/bin/gpbackup

echo "[INFO]: Begin to backup for all database : ${DBNAMES[*]}!"

# 全量备份
for n in ${DBNAMES[@]}; do
        echo "[INFO]: Full backup database for $n."
        $DIR/bin/gpbackup --dbname $n --backup-dir $BACKDIR --debug
done

echo "[INFO]: Success to finish backup!"
