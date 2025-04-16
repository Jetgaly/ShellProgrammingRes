#!/bin/bash

for (( i=0; i < 100; i++ ))
do
	sum=$[ $sum + $i ]
done
echo $sum


for i in {0..99}
do
	sum2=$[ $sum2 + $i ]
done
echo $sum2
