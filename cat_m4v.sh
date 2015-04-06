#!/bin/bash

newfilename=$1

if [ "X${newfilename}" = "X" ]; then
   echo "Usage cat_m4v.sh <newfilename>"
   exit 1
fi

filelist=`ls -1 *.m4v | sort`


for file in $filelist; do
   cmd_arg="${cmd_arg} -cat ${file}"
done

command="MP4Box ${cmd_arg} -new ${newfilename}"
echo ${command}
