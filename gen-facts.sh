#!/bin/bash

set -o pipefail

source "${HOME}/impala-tpcds-kit/tpcds-env.sh"

# find out what our node number is
source "${HOME}/impala-tpcds-kit/nodenum.sh"

count=$DSDGEN_THREADS_PER_NODE

start=(NODENUM-1)*$count+1
pids=()
for t in store_sales web_sales catalog_sales inventory
do

  for (( c=$start; c<($count+$start); c++ ))
  do
    echo "Generating part $c of ${DSDGEN_TOTAL_THREADS} for table ${t}"
    ${TPCDS_ROOT}/tools/dsdgen \
      -TABLE $t \
      -SCALE ${TPCDS_SCALE_FACTOR} \
      -CHILD $c \
      -PARALLEL ${DSDGEN_TOTAL_THREADS} \
      -DISTRIBUTIONS ${TPCDS_ROOT}/tools/tpcds.idx \
      -TERMINATE N \
      -FILTER Y \
      -QUIET Y | hdfs dfs -put -  ${FLATFILE_HDFS_ROOT}/${t}/${t}_${c}_${DSDGEN_TOTAL_THREADS}.dat &
    PID=$!
    pids+=("$PID")
    echo "job number is ${PID}"
  done


FAILURE=0
for job in "${pids[@]}"
do
echo "waiting on  $job"
wait $job || FAILURE=1
done

if [[ ${FAILURE} == 1 ]]; then
   echo "ERROR:FAILURE DETECTED IN PROCESS WHILE writing ${t} "
   exit 1
fi

  
done

