#!/bin/bash
source "${HOME}/impala-tpcds-kit//tpcds-env.sh"

_ERR_HDR_FMT="%.23s %s[%s]: "
_ERR_MSG_FMT="${_ERR_HDR_FMT}%s\n"

error_msg() {
  printf "$_ERR_MSG_FMT" $(date +%F.%T.%N) ${BASH_SOURCE[1]##*/} ${BASH_LINENO[0]} "${@}"
}


echo "sudo -u hdfs hdfs dfs -mkdir -p /user/$USER"
sudo -u hdfs hdfs dfs -mkdir -p /user/$USER || { error_msg "Failed creating homedir "; exit 1; }
echo "sudo -u hdfs hdfs dfs -chown $USER /user/$USER"
sudo -u hdfs hdfs dfs -chown $USER /user/$USER || { error_msg "Failed creating homedir "; exit 1; }
echo "sudo -u hdfs hdfs dfs -chmod 777 /user/$USER"
sudo -u hdfs hdfs dfs -chmod 777 /user/$USER || { error_msg "Failed creating homedir "; exit 1; }
