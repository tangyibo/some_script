#!/bin/bash
############################################
# Function: Greenplum数据库全库analyze脚本
# Author: tang
# Date : 2020-12-07
#
# Usage: sh analyzeall.sh
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

for n in ${DBNAMES[@]}; do
   log "[INFO]: Analyze database for $n."
   $DIR/bin/analyzedb -a -p 10 -d "$n"
done

log "[INFO]: Success to finish analyze all database!"

