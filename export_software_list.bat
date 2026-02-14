::导出的安装程序为注册表中有注册值的安装版程序(不包括绿色软件)
@echo off
title 注册表扫描中...
mode con cols=50 lines=10
for /f "tokens=3 delims=\" %%i in ('reg query HKLM\SOFTWARE') do (
echo 当前扫描信息: HKLM\SOFTWARE\%%i
>>reglist.txt                echo  ++++++++++++++++++
>>reglist.txt                echo  软件名称:%%i
>>reglist.txt                echo  ++++++++++++++++++
if not "%%i"=="Classes" for /f "tokens=4 delims=\" %%j in ('reg query HKLM\SOFTWARE\%%i 2^>nul') do (echo 软件信息: %%j>>reglist.txt)
)
echo 扫描完毕！
ping 127.0>nul
reglist.txt