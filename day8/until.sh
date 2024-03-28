#!/bin/bash
#Until Loop
z=0
until [ ! $z -lt 10 ]
do
	echo $z
	z=$(($z + 1))
done

