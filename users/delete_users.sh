#!/bin/bash

# Program:
#	Delete 30 users named stu01-stu30 which group is class1, 
#	and then delete the group class1.
# Version:
#	Version 0.01
# Author:
#	Create by jiangxin
#	jiangxinnju@126.com
# History:
#	2014/03/11	jiangxin	First release
# Warning:
#	This procedure without any warranty.
# Instructions
#	Run as root!

i=2
while [ $i -le 30 ]
do
	if [ $i -le 9 ] ;then
		userdel -r stu0${i}
	else
		userdel -r stu${i}
	fi
	i=$(($i+1))
done
groupdel class1

echo "Success!"
