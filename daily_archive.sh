#!/bin/bash

if [ $# -ne 1 ]
then 
	echo "参数个数错误，应该为一个作为归档目录名的参数"
	exit
fi

if [ -d $1 ]
then
	echo
else 
	echo
	echo "目录不存在"
	echo
	exit
fi

DIR_NAME=$(basename $1)
DIR_PATH=$(cd $(dirname $1);pwd)

DATE=$(date +%y%m%d)

FILE=archive_${DIR_NAME}_${DATE}.tar.gz
DEST=/home/jjet/archive/$FILE

echo "开始归档"
echo

tar -czf $DEST $DIR_PATH/$DIR_NAME

if [ $? -eq 0 ]
then 
	echo 
	echo "success"
	echo "file is $DEST"
	echo
else
	echo
	echo "failed"
	echo
fi

exit

