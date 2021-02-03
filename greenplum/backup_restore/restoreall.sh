#!/bin/bash
############################################
# Function: Greenplum数据库恢复脚本
# Author: tang
# Date : 2020-12-07
#
# Usage : sh restoreall.sh 20201217
#
###########################################
BACKDIR=/data/gpdb/backup

if [ $# -ne 1 ];then
        echo "Usage: sh $0  < datatime >"
        echo -e "Example : sh $0 20201217 \n"
        echo -e "Available datatime is:\n"
        ls $BACKDIR/gpseg0/backups
        echo  ""
        exit 2
fi

if [ "$(whoami)" != 'gpadmin' ]; then
        echo "[ERROR]: You have no permission to run $0 as gpadmin user."
        exit 1
fi

DATETIME=$1
TIMESTAMPS=( $(ls $BACKDIR/gpseg0/backups/$DATETIME) )
DIR="$( cd "$( dirname "$0"  )" && pwd  )"

chmod u+x $DIR/bin/gprestore

echo "[INFO]: Begin to backup for all database : ${TIMESTAMPS[*]}"

# 全量恢复
for n in ${TIMESTAMPS[@]}; do
        echo "[INFO]: Full restore timestamp for $n."
        $DIR/bin/gprestore --timestamp $n --backup-dir $BACKDIR --debug
done

echo "[INFO]: Success to finish restore!"

