#!/bin/bash

_ERR_HDR_FMT="%.23s %s[%s]: "
_ERR_MSG_FMT="${_ERR_HDR_FMT}%s\n"

error_msg() {
  printf "$_ERR_MSG_FMT" $(date +%F.%T.%N) ${BASH_SOURCE[1]##*/} ${BASH_LINENO[0]} "${@}"
}

cat dn.txt | while read h
do
  scp -rp $HOME/tpcds-kit $h:$HOME ||  { error_msg "Failed scping  $HOME/tpcds-kit  to $h " ; exit 1; }
  scp -rp $HOME/impala-tpcds-kit $h:$HOME { error_msg "Failed scping  $HOME/impala-tpcds-kit  to $h " ; exit 1; }
done
