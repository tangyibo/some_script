#!/bin/bash
############################################
# Function: Greenplum数据库全库vacuum脚本
# Author: tang
# Date : 2020-12-07
#
# Usage: sh vacuumall.sh
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



log "[INFO]: Begin vacuum all database!"

vacuumdb --all --echo --full --verbose --analyze

log "[INFO]: Success to finish vacuum all database!"

