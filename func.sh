#!/bin/bash

function add()
{
	s=$[$1+$2]
	echo $s
}

read -p "first num : " a
read -p "second num : " b

sum=$(add $a $b)
echo $sum

