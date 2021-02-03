#!/bin/bash
############################################
# Function: Greenplum数据库全库vacuum膨胀表
# Author: tang
# Date : 2020-12-07
#
# Usage: sh vacuumtab.sh
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


DBNAMES=( $(psql -t -c 'SELECT sodddatname as database_name from gp_toolkit.gp_size_of_database') )
log "[INFO]:Find all database : ${DBNAMES[*]} "

for n in ${DBNAMES[@]}; do
        log "[INFO]: Vacuum database for $n."
        SQL="select quote_ident(bdinspname)|| '.' || quote_ident(bdirelname) from gp_toolkit.gp_bloat_diag order by bdirelpages desc, bdidiag;"
        # echo $SQL
        TABLES=$( psql -d $n -t -c "$SQL")
        log "[INFO]:Find bloat tables : ${TABLES[*]} "
        for t in $TABLES
        do 
                vacuumdb -f -z -t "$t" "$n"
        done 
done

log "[INFO]: Success to finish vacuum all bloat tables!"

