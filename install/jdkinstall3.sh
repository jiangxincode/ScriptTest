#!/bin/bash
#####################jdk install##############################
touch a
echo “y” >a
JDKPATH=./jdk-6u29-linux-i586.bin
if [ -x "$JDKPATH" ] ; then
   echo “JDK setup file can execute”
else
   chmod u+x $JDKPATH
fi
$JDKPATH < a
rm -rf a
mkdir /usr/java
mv jdk1.6.0_29/ /usr/java/
cp /etc/profile /etc/profile.bak
echo “export JAVA_HOME=/usr/java/jdk1.6.0_29″ >>/etc/profile
echo “export JRE_HOME=/usr/java/jdk1.6.0_29/jre” >>/etc/profile
echo “export CLASSPATH=.JAVA_HOME/libJRE_HOME/libCLASSPATH” >>/etc/profile
echo “export PATH=$JAVA_HOME/binJRE_HOME/binPATH” >>/etc/profile
#####################jdk install finish#############################
#可以再/etc/profile.d/目录下面生成一个文件，避免直接修改/etc/profile
