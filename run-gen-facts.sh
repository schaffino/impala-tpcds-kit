#!/bin/bash

_ERR_HDR_FMT="%.23s %s[%s]: "
_ERR_MSG_FMT="${_ERR_HDR_FMT}%s\n"

error_msg() {
  printf "$_ERR_MSG_FMT" $(date +%F.%T.%N) ${BASH_SOURCE[1]##*/} ${BASH_LINENO[0]} "${@}"
}

pids=()
while read h;do 
  ssh $h "cd $HOME/impala-tpcds-kit; ./gen-facts.sh;"  &
  PID=$! 
  echo "Submitted job on $h as job number ${PID}"
  pids+=("$PID")
done <"$HOME/impala-tpcds-kit/dn.txt" 


FAILURE=0
for job in "${pids[@]}"; do
   echo "waiting on  $job"
   wait $job || FAILURE=1
done

if [[ ${FAILURE} == 1 ]]; then
    error_msg "ERROR:FAILURE DETECTED IN PROCESS"
    exit 1
fi


