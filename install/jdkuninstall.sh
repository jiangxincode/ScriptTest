echo "正在删除相关文件"
sudo rm -rf /usr/lib/jvm/
sudo rm -rf /usr/bin/eclipse/
sudo rm -rf ~/Desktop/eclipse
wait
echo "删除相关文件成功"

echo "恢复配置文件"
sudo rm /usr/bin/java /usr/bin/javac
sudo rm /etc/alternatives/java /etc/alternatives/javac

# sudo mv /etc/environment.backup.java /etc/environment
mv ~/.bashrc.backup.java ~/.bashrc
source ~/.bashrc
echo "恢复配置文件成功"
