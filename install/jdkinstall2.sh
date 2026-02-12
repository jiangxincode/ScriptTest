#!/bin/bash

chmod u+x jdk-6u29-linux-i586.bin
installPath=/usr/java
if [ ! -d /usr/java ];
then
	mkdir /usr/java
fi
./jdk-6u29-linux-i586.bin -D  /usr/java
cp  -R jdk1.6.0_29/ /usr/java/jdk1.6.0_29/

touch environment
echo "PATH=\"$PATH:/usr/java/jdk1.6.0_29/bin\"" >> environment
echo "JAVA_HOME=/usr/java/jdk1.6.0_29" >> environment
echo "CLASSPATH=.:%JAVA_HOME%/lib/dt.jar:%JAVA_HOME%/lib/tools.jar" >> environment
rm -rf /etc/environment
cp environment /etc
source /etc/environment
update-alternatives --install /usr/bin/java java /usr/java/jdk1.6.0_29/bin/java 300
update-alternatives --install /usr/bin/javac javac /usr/java/jdk1.6.0_29/bin/javac 300
update-alternatives --config java
