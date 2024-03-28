#!/bin/bash
#While Loop
counter=0
while [ $counter -lt 5 ]
do
	echo "looping"
	echo "value of counter is" $counter
	counter=$(($counter + 1))
	sleep 1
done
echo "out of the loop"
