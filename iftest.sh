#!/bin/bash

if [ $1 -gt 18 ];then
	echo ok
fi

if [ $1 -gt 18 ]
then 
	echo ok
fi

if [ $1 -gt 18 ]
then 
	echo ok
elif [ $1 -gt 0 ] && [ $1 -le 18 ]
then 
	echo not ok
else
	echo age illegal
fi
