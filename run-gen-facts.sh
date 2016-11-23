#!/bin/bash

# TODO: make sure you have set up dn.txt with your DataNode hostnames, 1 per line

_ERR_HDR_FMT="%.23s %s[%s]: "
_ERR_MSG_FMT="${_ERR_HDR_FMT}%s\n"

error_msg() {
  printf "$_ERR_MSG_FMT" $(date +%F.%T.%N) ${BASH_SOURCE[1]##*/} ${BASH_LINENO[0]} "${@}"
}

pids=()
cat dn.txt | while read h
do 
  ssh $h "cd $HOME/impala-tpcds-kit; ./gen-facts.sh" < /dev/null &
  pids+=("$!") 
done


FAILURE=0
for job in "${pids[@]}"
do
echo "waiting on  $job"
wait $job || FALIURE=1
done

if [[ ${FAILURE} == 1 ]]; then
    error_msg "ERROR:FAILURE DETECTED IN PROCESS"
   exit 1
fi


