#!/bin/bash

echo "创建/usr/lib/jvm/目录"
if [ ! -d /usr/lib/jvm ];
then
	sudo mkdir /usr/lib/jvm
fi
echo "目录/usr/lib/jvm/创建成功"

echo "正在安装JDK和Eclipse"
os_version=`uname -a`
echo $os_version
architecture="64"
echo "$os_version" | grep -q "$architecture"
if [ $? -eq 0 ]
then
	echo "您正在使用64位操作系统，为您选择64位JDK和eclipse"
	sudo tar -zxvf jdk-7u60-linux-x64.tar.gz -C /usr/lib/jvm/
	sudo chown -R jiangxin:jiangxin /usr/lib/jvm/jdk1.7.0_60
	sudo tar -zxvf eclipse-java-luna-R-linux-gtk-x86_64.tar.gz -C /usr/bin/
	sudo chown -R jiangxin:jiangxin /usr/bin/eclipse
	sudo ln -s /usr/bin/eclipse/eclipse ~/Desktop/eclipse
else
	echo "您正在使用32位操作系统，为您选择32位JDK和eclipse"
	sudo tar -zxvf jdk-7u60-linux-i586.tar.gz -C /usr/lib/jvm/
	sudo chown -R jiangxin:jiangxin /usr/lib/jvm/jdk1.7.0_60
	sudo tar -zxvf eclipse-java-luna-R-linux-gtk.tar.gz -C /usr/bin/
	sudo chown -R jiangxin:jiangxin /usr/bin/eclipse
	sudo ln -s /usr/bin/eclipse/eclipse ~/Desktop/eclipse
fi
echo "安装JDK和Eclipse成功"

echo "配置环境变量"

# sudo mv /etc/environment /etc/environment.backup.java
# touch environment
# sudo echo "PATH=\"$PATH:/usr/lib/jvm/jdk1.7.0_60/bin\"" >> environment
# sudo echo "JAVA_HOME=/usr/lib/jvm/jdk1.7.0_60" >> environment
# sudo echo "CLASSPATH=.:%JAVA_HOME%/lib/dt.jar:%JAVA_HOME%/lib/tools.jar" >> environment
# sudo mv environment /etc/environment
# source /etc/environment

mv ~/.bashrc ~/.bashrc.backup.java
cat ~/.bashrc.backup.java >> ~/.bashrc
echo "PATH=\"$PATH:/usr/lib/jvm/jdk1.7.0_60/bin\"" >> ~/.bashrc
echo "export JAVA_HOME=/usr/lib/jvm/jdk1.7.0_60" >> ~/.bashrc
echo "export CLASSPATH=.:%JAVA_HOME%/lib/dt.jar:%JAVA_HOME%/lib/tools.jar" >> ~/.bashrc
source ~/.bashrc
echo "配置环境成功"

# 如果有多个java版本需要进行以下配置（包括openjdk）
echo "设置默认jdk"
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk1.7.0_60/bin/java 300
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk1.7.0_60/bin/javac 300
sudo update-alternatives --config java
# echo "设置默认jdk成功"


echo "测试是否安装成功"
java -version
echo "安装成功"

