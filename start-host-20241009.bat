::解决中文乱码的
chcp 65001


::获取管理员权限
@echo off
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"


:: 设置bat标题
title  静默安装3.5

@REM echo ******请选择操作你的电脑类型******：

@REM echo ******1. 笔记本******

@REM echo ******2. 台式******

@REM set /p choice=请输入选项（1或2）并按回车键：

@REM echo.

:: 获取批处理文件所在的目录路径，并进入该目录  
cd /d "%~dp0"  
echo ******当前目录已更改为: %cd%******
echo.
echo.

@REM echo ******安装/更新WIFI驱动以及蓝牙驱动******
@REM WiFi-23.60.1-Driver64-Win10-Win11.exe -q -s
@REM BT-23.60.0-64UWD-Win10-Win11.exe /qn
@REM echo 安装/更新WIFI驱动以及蓝牙驱动完成！！！
@REM echo.
@REM echo.

::----------------------------------------------------------------------------------------------------------------
echo ******连接WIFI test******
echo 正在添加Wi-Fi配置文件...  
::netsh wlan add profile filename="C:\my_share\EasyU_tools\bat-demo\test.xml"
netsh wlan add profile filename= "%cd%\test.xml"
if %errorlevel% neq 0 echo 添加配置文件失败,文件不存在,或者是文件权限不足！

echo 正在连接Wi-Fi网络...  
netsh wlan connect name="test" 
if %errorlevel% neq 0 echo 连接Wi-Fi网络失败,wifi名错误，或者是配置文件不存在！
echo WIFI连接成功！！！
echo.
echo.

@REM echo 连接信息...
@REM netsh wlan show networks
@REM echo.
@REM echo.


::----------------------------------------------------------------------------------------------------------------
echo ******设置电脑壁纸******
echo 复制壁纸图片到 C:\Windows\Web\Screen 中...
xcopy /Y ".\Mobvista\*.png" "C:\Windows\Web\Screen"
echo 设置壁纸中....
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "C:\Windows\Web\Screen\1920x1080.png" /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
echo 设置电脑壁纸成功，重启电脑即可生效！！！
echo.
echo.
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

@REM echo ----------打开磁盘管理，删除没必要的分区防止还有其他分区导致数据外露----------
@REM start Diskmgmt.msc

::----------------------------------------------------------------------------------------------------------------


::----------------------------------------------------------------------------------------------------------------
echo ******设置电源选项配置******
@REM echo -------关闭快速启动项--------
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f
@REM 可以使用powershell查看：(GP "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power")."HiberbootEnabled"，或者是在cmd可以使用reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled
@REM 1表示开启，0表示关闭

@REM 使用电池时的设置》关闭显示器5分钟
powercfg /setdcvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 300

@REM 使用电池时的设置》使计算机进入睡眠状态30分钟
powercfg /setdcvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 1800

@REM 接通电源时的设置》关闭显示器30分钟
powercfg /setacvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 1800

@REM 接通电源时的设置》使计算机进入睡眠状态从不
powercfg /setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0

@REM ---------配置电源管理 关闭盖子时 不采取任何措施-----------
powercfg -setacvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0

@REM SCHEME_CURRENT：表示当前活动的电源计划。

@REM 0：表示将待机超时时间设置为“永不”，即系统不会进入待机状态。

echo 关闭快速启动项完成！！！

echo 更改计算机休眠时间完成！！！

echo 配置电源管理 关闭盖子时 不采取任何措施完成！！！
echo.
echo.




@REM setlocal
@REM echo ----------打开电源管理----------
@REM start powercfg.cpl
@REM ::if %errorlevel% neq 0 echo 打开电源管理可能失败,请手动打开！
@REM endlocal

@REM setlocal
@REM echo ----------打开系统更新----------
@REM start ms-settings:windowsupdate
@REM if %errorlevel% neq 0 echo 打开系统更新可能失败,请手动打开！
@REM echo.
@REM endlocal

@REM echo ----------打开电源管理并打开系统更新----------
@REM start windows_update_and_powercfg_setting.exe
@REM echo 等待50秒完成操作
@REM timeout 50



::----------------------------------------------------------------------------------------------------------------

echo ******修改用户密码******
echo 正在为用户名为：%USERNAME% 修改密码中...
net user %USERNAME% Mobvista_256
if %errorlevel% neq 0 echo 用户不存在，或者是权限不足，请看上面的ERROR
::测试密码是否设置成功runas /user:MVGZ001 cmd.exe   
echo 密码修改成功，注销或者是重启即可生效！！！
echo.
echo.
endlocal


::----------------------------------------------------------------------------------------------------------------
setlocal
echo ******解锁C盘的BitLocker加密******
manage-bde -off C:
if %errorlevel% neq 0 echo 可能并未开启BitLocker加密，或者是权限不足，所以解锁失败，不影响，详情请看上面的ERROR
echo 解锁BitLocker加密完成！！！
echo.
echo.
endlocal


::----------------------------------------------------------------------------------------------------------------
echo ******调整UAC级别更改计算机时通知我（不降低桌面亮度）******
@REM reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0x5 /f
@REM echo.
@REM start C:\WINDOWS\System32\UserAccountControlSettings.exe
echo 调用powershell脚本，UAC_level2.ps1中...
PowerShell -ExecutionPolicy Bypass -Command "& { .\UAC_level2.ps1 }"
echo 调用成功执行结束，出现5和0表示成功！！！
echo.
echo.
::----------------------------------------------------------------------------------------------------------------


echo ******显示桌面图标（计算机）******
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v {20D04FE0-3AEA-1069-A2D8-08002B30309D} /t REG_DWORD /d 0 /f
if %errorlevel% neq 0 echo 图片地址不存在，或者是权限不足，请看上面的ERROR
echo 显示此电脑图标完成！！！
echo.
echo.

echo ******隐藏设置中恢复选项******
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "SettingsPageVisibility" /t REG_SZ /d "hide:recovery" /f
echo 设置中的恢复选项隐藏成功！！！

echo ******关闭自动播放******
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /v DisableAutoplay /t REG_DWORD /d 1 /f
echo 关闭自动播放完成！！！

@REM 如需显示设置中的恢复选项则运行reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "SettingsPageVisibility" /f
echo.
echo.

::----------------------------------------------------------------------------------------------------------------
echo ******复制入职培训的PDF到桌面******
xcopy /Y ".\*.pdf" "%USERPROFILE%\Desktop\"
xcopy /Y ".\*.pptx"  "%USERPROFILE%\Desktop\"
if %errorlevel% neq 0 echo 似乎复制失败了，请手动复制！ 
echo 入职培训PDF复制完成！！！
echo.
echo.

echo ******打开此电脑，请检查是否有有其他分区，如有请进行清理数据******
explorer.exe ::{20D04FE0-3AEA-1069-A2D8-08002B30309D}
echo 打开此电脑完成，请手动检查是否有需要格式化的分区！！！
echo.
echo.


echo ******系统更新******
echo 打开系统更新中...
start ms-settings:windowsupdate
echo 执行检查更新...
USOclient StartInteractiveScan 
echo 执行完成，请等待获取更新并自动下载！！！
echo.
echo.


::----------------------------------------------------------------------------------------------------------------
echo ******发放标准软件安装******
start /wait hPjeBME6V2khYZI3p-8bssXpQTdi9XPL.exe 
start /wait 7z2408-x64.exe /S
echo 安装成功7-zip

start /wait PotPlayerSetup64.exe /S
echo 安装成功PotPlayer（播放器）

start /wait WeChatSetup.exe /S
echo 安装成功微信

start /wait FeiLian_Windows_x86_v2.2.23_r1015_464e4f.exe /S
echo 安装成功飞连

start /wait 7.6.15-Release.91110808.exe /S
echo 安装成功钉钉

start /wait ChromeStandaloneSetup64.exe
echo 安装成功chrome浏览器

start /wait WPS_Setup_18276.exe /S -agreelicense
echo 安装成功wps

echo 关闭钉钉程序
taskkill -f -im DingTalk.exe

AcroRdrDCx642400220857_MUI\Setup.exe /sPB
echo 安装成功AcroRdrDCx 

start /wait AcroRdrALSDx64_2300820421_all_DC.msi /passive
echo 安装成功 AcroRdrALSDx64 语言包

start /wait DingTalk_Pirnt.exe
echo 安装智能云钉钉打印机成功


echo ******关闭软件******

taskkill -f -im chrome.exe
taskkill -f -im wps.exe
taskkill -f -im DingTalk.exe
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{EEEEFCF7-867B-4FA2-9ABD-884CF531B600}" /f
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{EEEEFCF7-867B-4FA2-9ABD-884CF531B602}" /f

echo 关闭谷歌浏览器成功

echo 关闭wps成功

echo 关闭钉钉成功

echo 去除（隐藏）WPS云盘在此电脑的显示
echo.
echo.

@REM echo -------启动AcroRdrDCx 设置默认PDF-------------
@REM start "" "C:\Program Files\Adobe\Acrobat DC\Acrobat\ShowAppPickerForPDF.exe"

echo ******启动Python脚本设置7Zip和PDF默认******
start 7Zip_and_PDF_default_setting_keyboard.exe
echo 等待40秒倒计时完成操作
timeout 40
echo.
echo.

echo ******设置文件关联(7zip和PotPlayer)******

@REM 如果你需要设置更过其他的，请修改配置文件 Default-File-association.txt

SetUserFTA.exe Default-file-association.txt
echo 文件关联设置完成
echo.
echo.


echo ******卸载小组件******
winget  uninstall "windows web experience pack" --accept-source-agreements
echo 卸载完成！！！重启后生效
echo.
echo.

echo 开始安装360企业云安全...
Setup[T1q358KV][6332a09e67259].exe /S /corp=1
echo 安装成功360企业云安全
start "" "C:\Program Files (x86)\360\360Safe\EntAdmin\360EntDT.exe"


@REM ::判断对应的类型，匹配不同的复制序列号
@REM if %choice%==1 goto notebook
@REM if %choice%==2 goto tablemodel
@REM echo 输入无效，请输入1或2。
@REM goto end

@REM :notebook
@REM echo ******获取笔记本序列号并且复制******
@REM wmic bios get serialnumber | findstr /V SerialNumber | clip
@REM echo 笔记本序列号（如果没有复制成功，请在下方手动复制即可）：
@REM wmic bios get serialnumber
@REM echo ******笔记本：获取序列号并且复制命令******
@REM echo "wmic bios get serialnumber | findstr /V SerialNumber | clip" 
@REM goto end

@REM :tablemodel
echo ******台式获取序列号并且复制******
wmic baseboard  get serialnumber | findstr /V SerialNumber | clip
echo 序列号（如果没有复制成功，请在下方手动复制即可）：
wmic baseboard  get serialnumber
echo ******台式：获取序列号并且复制命令******
echo "wmic baseboard  get serialnumber | findstr /V SerialNumber | clip"
@REM goto end

@REM :end

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
set "files[6]=%USERPROFILE%\AppData\Local\kingsoft\WPS Office\ksolaunch.exe"
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
        echo 文件 !targetFile! 未找到，可能未安装！！！！！
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

echo ******请选择对应的操作******：

echo ******1. 重启******

echo ******2. 关机******

set /p userinput=请输入选项（1或2）并按回车键：

if %userinput%==1 goto restart
if %userinput%==2 goto shutdown
echo 输入无效，请输入1或2。
goto end

:restart
shutdown /r /t 0
goto end

:shutdown
shutdown /s /t 0
goto end

:end

