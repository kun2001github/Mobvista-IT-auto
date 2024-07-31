::解决中文乱码的
chcp 65001
::----------------------------------------------------------------------------------------------------------------
::获取管理员权限
@echo off
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"
::----------------------------------------------------------------------------------------------------------------
:: 设置bat标题
title  静默安装3.1（2024.7.22）
::----------------------------------------------------------------------------------------------------------------
echo ----------切换到当前目录----------
:: 获取批处理文件所在的目录路径，并进入该目录  
cd /d "%~dp0"  
echo 当前目录已更改为: %cd%  
:: 例如，列出目录下的文件：  
echo.
echo.
echo.
::----------------------------------------------------------------------------------------------------------------
echo ----------连接WIFI test----------
echo 正在添加Wi-Fi配置文件...  
::netsh wlan add profile filename="C:\my_share\EasyU_tools\bat-demo\test.xml"
netsh wlan add profile filename= "%cd%\test.xml"
if %errorlevel% neq 0 echo 添加配置文件失败,文件不存在,或者是文件权限不足！

echo 正在连接Wi-Fi网络...  
netsh wlan connect name="test" 
if %errorlevel% neq 0 echo 连接Wi-Fi网络失败,wifi名错误，或者是配置文件不存在！
echo.

echo 连接信息...
netsh wlan show networks
echo.
echo.

::----------------------------------------------------------------------------------------------------------------
echo ----------设置壁纸----------
xcopy /Y ".\Mobvista\*.png" "C:\Windows\Web\Screen"
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "C:\Windows\Web\Screen\1920x1080.png" /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
:: 刷新桌面以应用更改（这将重启资源管理器）  
::taskkill /f /im explorer.exe  
::start explorer.exe
::if %errorlevel% neq 0 echo 图片地址不存在，或者是权限不足，请动手设置壁纸！
::----------------------------------------------------------------------------------------------------------------
:: 会导致电脑发热，以及CPU使用评率过高，删除2024.07.04
::echo ----------启动高性能模式----------
::powercfg /setactive SCHEME_MIN
::或者是：powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
::powercfg /list 
::echo.
::----------------------------------------------------------------------------------------------------------------
echo ----------关闭快速启动项 ----------
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f
:: 可以使用powershell查看：(GP "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power")."HiberbootEnabled"
:: 1表示开启，0表示关闭
:: 修改完成后，重启才会生效
::在cmd可以使用reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled
::来查询是否关闭成功，会开到最后的是0x0表示关闭，0x1表示开启
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled
echo.
echo.
echo.
::----------------------------------------------------------------------------------------------------------------
echo ----------设置电源配置 ----------
:: 使用电池时的设置
:: 关闭显示器 5 分钟
powercfg /setdcvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 300 
:: 使计算机进入睡眠状态 30分钟
powercfg /setdcvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 1800 


:: 接通电源时的设置
:: 关闭显示器 30分钟
powercfg /setacvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 1800 
:: 使计算机进入睡眠状态 从不
powercfg /setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0 


::设置接通电源，关闭盖子时，不采取任何操作
::powercfg /setacvalueindex SCHEME_CURRENT SUB_BUTTONS UIBUTTON_ACTION 0


:: 其实可以通过powercfg /list 查看电源计划的名称
:: powercfg /q 可以查看到电源计划的GUID，通过GUID来设置的
:: 例如：/setacvalueindex：一个命令参数，用于设置接通交流电源（AC）时的电源设置值。
:: 而电池用的是/setdcvalueindex
:: SCHEME_CURRENT：表示当前活动的电源计划。
:: SUB_SLEEP：表示电源设置的一个子组，这个子组包含了与睡眠模式相关的设置
:: STANDBYIDLE：表示在没有任何用户活动时，系统进入待机状态前的超时时间。
::0：表示将待机超时时间设置为“永不”，即系统不会进入待机状态。
::----------------------------------------------------------------------------------------------------------------

@REM setlocal
@REM echo ----------打开电源管理----------
@REM start powercfg.cpl
@REM ::if %errorlevel% neq 0 echo 打开电源管理可能失败,请手动打开！
@REM endlocal


echo ----------打开电源管理并打开系统更新----------
start windows_update_and_powercfg_setting.exe
echo 等待40秒完成操作
timeout 40

echo ----------打开磁盘管理，删除没必要的分区防止还有其他分区导致数据外露----------
start Diskmgmt.msc

::----------------------------------------------------------------------------------------------------------------
@REM setlocal
@REM echo ----------打开系统更新----------
@REM start ms-settings:windowsupdate
@REM if %errorlevel% neq 0 echo 打开系统更新可能失败,请手动打开！
@REM echo.
@REM endlocal
::----------------------------------------------------------------------------------------------------------------
setlocal
echo ----------修改密码----------
echo 正在为用户名为：%USERNAME% 修改密码中..
net user %USERNAME% Mobvista_256
if %errorlevel% neq 0 echo 用户不存在，或者是权限不足，请看上面的ERROR
::测试密码是否设置成功runas /user:MVGZ001 cmd.exe   
echo.
echo.
echo.
endlocal
::----------------------------------------------------------------------------------------------------------------
setlocal
echo ----------解锁BitLocker加密----------
manage-bde -off C:
if %errorlevel% neq 0 echo 可能未开启BitLocker加密，或者是权限不足，请看上面的ERROR
echo.
echo.
echo.
endlocal
::----------------------------------------------------------------------------------------------------------------
echo ----------调整UAC级别更改计算机时通知我（不降低桌面亮度）----------
@REM reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0x5 /f
@REM echo.
@REM start C:\WINDOWS\System32\UserAccountControlSettings.exe
PowerShell -ExecutionPolicy Bypass -Command "& { .\UAC_level2.ps1 }"
::----------------------------------------------------------------------------------------------------------------
echo ----------显示桌面图标（计算机）----------
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v {20D04FE0-3AEA-1069-A2D8-08002B30309D} /t REG_DWORD /d 0 /f
if %errorlevel% neq 0 echo 图片地址不存在，或者是权限不足，请看上面的ERROR
echo.
::----------------------------------------------------------------------------------------------------------------
echo ----------复制入职培训的PDF到桌面---------- 
xcopy /Y ".\*.pdf" "%USERPROFILE%\Desktop\"
xcopy /Y ".\*.pptx"  "%USERPROFILE%\Desktop\"
if %errorlevel% neq 0 echo 似乎复制失败了，请手动复制！ 
echo.
echo.
echo.
::----------------------------------------------------------------------------------------------------------------
echo ------------------软件安装-----------------------
start /wait hPjeBME6V2khYZI3p-8bssXpQTdi9XPL.exe 
start /wait 7z2407-x64.exe /S
echo 安装成功7-zip

@REM echo 设置默认的7-zip中，设置中
@REM start "" "C:\Program Files\7-Zip\7zFM.exe" 
@REM echo 设置默认的7-zip完成
echo 设置默认的7-zip，使用python脚本
start 7zip_default_setting_keyboard.exe
echo 等待40秒完成操作
timeout 40

start /wait PotPlayerSetup64.exe /S
echo 安装成功PotPlayer（播放器）

start /wait WeChatSetup.exe /S
echo 安装成功微信

start /wait FeiLian_Windows_x86_v2.2.23_r1015_464e4f.exe /S
echo 安装成功飞连

start /wait 7.6.0-Release.72310802.exe /S
echo 安装成功钉钉

start /wait ChromeStandaloneSetup64.exe
echo 安装成功chrome浏览器

start /wait WPS_Setup_17147.exe /S -agreelicense
echo 安装成功wps

AcroRdrDCx642400220857_MUI\Setup.exe /sPB
echo 安装成功AcroRdrDCx 

start /wait AcroRdrALSDx64_2300820421_all_DC.msi /passive
echo 安装成功 AcroRdrALSDx64 语言包

echo -------启动AcroRdrDCx 设置默认PDF-------------
"C:\Users\Public\Desktop\Adobe Acrobat.lnk"

start /wait DingTalk_Pirnt.exe
echo 安装智能云钉钉打印机成功

Setup[T1q358KV][6332a09e67259].exe /S /corp=1
echo 安装成功360安全

::----------------------------------------------------------------------------------------------------------------
echo ------------获取序列号并且复制-------------------
wmic baseboard  get serialnumber | findstr /V SerialNumber | clip
if %errorlevel% neq 0 echo 序列包复制失败，请手动输入 （wmic bios get serialnumber | findstr /V SerialNumber） 获取序列号并且复制
echo.
echo 序列号（如果没有复制成功，请在下方手动复制即可）：
wmic baseboard  get serialnumber
echo ------------台式机：获取序列号并且复制命令-------------------
echo baseboard  get serialnumber
echo "wmic baseboard  get serialnumber | findstr /V SerialNumber | clip" 
echo.
echo.
echo.

echo 按1次回车即可查看软件是否安装成功 & pause

echo ---------------检查是否安装成功----------------------
setlocal EnableDelayedExpansion  
:: 定义要检查的文件的路径和名称  
set "files[0]=C:\Program Files (x86)\DingDing\DingtalkLauncher.exe"  
set "files[1]=C:\Program Files\Tencent\WeChat\WeChat.exe"  
set "files[2]=C:\Program Files\Google\Chrome\Application\chrome.exe"  
set "files[3]=C:\Program Files\7-Zip\7zFM.exe"  
set "files[4]=C:\Program Files\DAUM\PotPlayer\PotPlayerMini64.exe"  
set "files[5]=C:\Program Files\CorpLink\current\Client\CorpLink.exe"  
set "files[6]=C:\Program Files (x86)\Kingsoft Office Software\WPS Office\ksolaunch.exe"
set "files[7]=C:\Program Files (x86)\360\360Safe\360Safe.exe"  
:: AcroRdrDC 和 智能云打印插件，暂时找不到包的位置

:: 设置数组的大小  
set "fileCount=7"  

:: 循环检查每个文件  
for /L %%i in (0,1,%fileCount%) do (  
    set "targetFile=!files[%%i]!"  
    if exist "!targetFile!" (  
        echo 文件 !targetFile! 已成功安装。  
    ) else (  
        echo 文件 !targetFile! 未找到，可能未安装，请手动安装。  
    )  
)  
endlocal
echo.
echo.


echo 按2次回车即可断开wifi以及忘记密码 & pause pause

echo -----------断开wifi链接---------
netsh wlan disconnect
if %errorlevel% neq 0 echo 连接Wi-Fi网络失败！

echo ----------忘记wifi-------------
netsh wlan delete profile test
if %errorlevel% neq 0 echo 已忘记！
echo.
echo.
echo.


echo 按2次回车键即可重启哦 & pause pause
shutdown /r /t 0