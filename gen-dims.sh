#!/bin/bash

set -o pipefail
source "${HOME}/impala-tpcds-kit/tpcds-env.sh" 

echo ${HOME}
pids=()
for t in $dims
do
  echo "Generating table $t"
  ${TPCDS_ROOT}/tools/dsdgen \
    -TABLE $t \
    -SCALE ${TPCDS_SCALE_FACTOR} \
    -DISTRIBUTIONS ${TPCDS_ROOT}/tools/tpcds.idx \
    -TERMINATE N \
    -FILTER Y \
    -QUIET Y | hadoop fs -put - ${FLATFILE_HDFS_ROOT}/${t}/${t}.dat &
    pids+=("$!")
done

FAILURE=0
for job in "${pids[@]}"
do
echo "waiting on  $job"
wait $job || FAILURE=1
done

if [[ ${FAILURE} == 1 ]]; then 
   echo "ERROR:FAILURE DETECTED IN PROCESS"
   exit 1
fi
