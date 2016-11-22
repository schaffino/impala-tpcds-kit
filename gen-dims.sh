#!/bin/bash
source ./tpcds-env.sh

echo ${HOME}

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
done
wait

