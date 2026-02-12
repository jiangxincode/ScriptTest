#!/bin/bash

# Program:
#	Add a new group named class1, then add thirty users named stu01-stu30 to this group.	
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

i=1
groupadd class1
while [ $i -le 30 ]
do
	if [ $i -le 9 ] ;then
		USERNAME=stu0${i}
	else
		USERNAME=stu${i}
	fi
	useradd -g class1 $USERNAME
	mkdir /home/$USERNAME
	chown -R $USERNAME /home/$USERNAME
	chgrp -R class1 /home/$USERNAME
	i=$(($i+1))
done

echo "Success!"
