#!/bin/bash
source ./tpcds-env.sh

# make the table level dir
hdfs dfs -mkdir -p ${FLATFILE_HDFS_ROOT} || { error_msg "Failed creating ${FLATFILE_HDFS_ROOT} "; exit 1; }

# make a directory for each table
for t in $dims $facts
do 
  echo "making HDFS directory ${FLATFILE_HDFS_ROOT}/${t}" 
  hdfs dfs -mkdir ${FLATFILE_HDFS_ROOT}/${t} || { error_msg "Failed creating ${FLATFILE_HDFS_ROOT}/${t} "; exit 1; }
done

echo "HDFS directories:"
hdfs dfs -ls ${FLATFILE_HDFS_ROOT}

