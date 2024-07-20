:解决中文乱码的
chcp 65001

:获取管理员权限
@echo off
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"


setlocal
echo ----------打开系统更新----------
start ms-settings:windowsupdate
if %errorlevel% neq 0 echo 打开系统更新可能失败,请手动打开！
echo.
endlocal

echo 检查是否更新最新，如果是最新，请按回车检测软件以及断开wifi & pause

echo ---------------检查是否安装成功----------------------

setlocal EnableDelayedExpansion  
:: 定义要检查的文件的路径和名称  
set "files[0]=C:\Program Files (x86)\DingDing\DingtalkLauncher.exe"  
set "files[1]=C:\Program Files\Tencent\WeChat\WeChat.exe"  
set "files[2]=C:\Program Files\Google\Chrome\Application\chrome.exe"  
set "files[3]=C:\Program Files\7-Zip\7zFM.exe"  
set "files[4]=C:\Program Files\DAUM\PotPlayer\PotPlayerMini64.exe"  
set "files[5]=C:\Program Files\CorpLink\current\Client\CorpLink.exe"  
set "files[6]=C:\Users\%USERNAME%\AppData\Local\kingsoft\WPS Office\ksolaunch.exe"  
set "files[7]=C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe"  
set "files[8]=C:\Program Files (x86)\360\360Safe\360Safe.exe"  
:: 智能云打印插件，暂时找不到包的位置


:: 设置数组的大小  
set "fileCount=8"  
  
:: 循环检查每个文件  
for /L %%i in (0,1,%fileCount%) do (  
    set "targetFile=!files[%%i]!"  
    if exist "!targetFile!" (  
        echo 文件 !targetFile! 已成功安装。  
    ) else (  
        echo 文件 !targetFile! 未找到，可能未安装。  
    )  
)  
endlocal

echo -----------断开wifi链接---------
netsh wlan disconnect
if %errorlevel% neq 0 echo 连接Wi-Fi网络失败！

echo ----------忘记wifi-------------
netsh wlan delete profile test
if %errorlevel% neq 0 echo 忘记失败？

echo 请按2次回车键即可关机哦 & pause
pause

shutdown /s /f
