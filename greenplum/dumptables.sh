#!/bin/bash
############################################
# Function: Greenplum数据库全库结构备份工具
# Author: tang
# Date : 2020-12-07
#
# Usage: sh dumptables.sh 
#
###########################################
set -e

function log() {
    TIME=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$TIME $1"
}

if [ "$(whoami)" != 'gpadmin' ]; then
     log "[ERROR]: You have no permission to run $0 as gpadmin user."
     exit 1
fi

DIR="$( cd "$( dirname "$0"  )" && pwd  )"
DBNAMES=( $(psql -t -c 'SELECT sodddatname as database_name from gp_toolkit.gp_size_of_database') )
log "[INFO]:Find all database :${DBNAMES[*]} "

now_date=`date +"%Y-%m-%d_%H-%M-%S"`
mkdir -p ${now_date}

for n in ${DBNAMES[@]}; do
   log "[INFO]: Dump database table struct for $n."
   pg_dump -U gpadmin -d $n -w -s -c --if-exists > ${DIR}/${now_date}/${n}.sql
done

log "[INFO]: Success to finish dump all database struct!"

