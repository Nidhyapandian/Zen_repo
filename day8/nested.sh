#!/bin/bash
#Nested Loop
counter=0
while [ $counter -lt 10 ]                          #this is Loop1
do
	b=$counter
	while [ $b -ge 0 ]                   #this is Loop2
	do 
		echo -n "$b"
		b=$(($b - 1))
	done
	echo
	counter=$(($counter + 1))
done
