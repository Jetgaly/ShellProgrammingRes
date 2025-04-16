#!/bin/bash
i=1
sum=0
while [ $i -le 100 ]
do
#	sum=$[ $i + $sum ]
#	i=$[$i+1]
	let sum+=i
	let i++
done
echo $sum
