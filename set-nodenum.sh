#!/bin/bash

ERR_HDR_FMT="%.23s %s[%s]: "
_ERR_MSG_FMT="${_ERR_HDR_FMT}%s\n"

error_msg() {
  printf "$_ERR_MSG_FMT" $(date +%F.%T.%N) ${BASH_SOURCE[1]##*/} ${BASH_LINENO[0]} "${@}"
}


n=1
cat "${HOME}/impala-tpcds-kit/dn.txt" | while read h
do 
  echo "$h = $n"
  ssh $h "echo export NODENUM=${n} > $HOME/impala-tpcds-kit/nodenum.sh" < /dev/null  ||  { error_msg "Failed writing nodenumber to host $h "; exit 1; }
  ((n=n+1))
done
