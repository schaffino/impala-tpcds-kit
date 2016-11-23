#!/bin/bash
source ./tpcds-env.sh

_ERR_HDR_FMT="%.23s %s[%s]: "
_ERR_MSG_FMT="${_ERR_HDR_FMT}%s\n"

error_msg() {
  printf "$_ERR_MSG_FMT" $(date +%F.%T.%N) ${BASH_SOURCE[1]##*/} ${BASH_LINENO[0]} "${@}"
}



sudo -u hdfs hdfs dfs -mkdir /user/$USER || { error_msg "Failed creating homedir "; exit 1; }

sudo -u hdfs hdfs dfs -chown $USER /user/$USER || { error_msg "Failed creating homedir "; exit 1; }

sudo -u hdfs hdfs dfs -chmod 777 /user/$USER || { error_msg "Failed creating homedir "; exit 1; }
