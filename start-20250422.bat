::解决中文乱码的
chcp 65001


::获取管理员权限
@echo off
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"


:: 设置bat标题
title  Mobvista-IT-标准化安装配置脚本

::检查是判断笔记本/台式机

for /f "delims=" %%i in ('powershell -Command "if((Get-WmiObject -Class Win32_SystemEnclosure).ChassisTypes -match '(9|10|11|12|14|18|22|30)'){Write-Host '笔记本电脑'}elseif((Get-WmiObject -Class Win32_SystemEnclosure).ChassisTypes -match '(3|4|5|6)'){Write-Host '台式机'}else{Write-Host '无法确定设备类型'}"') do set "deviceType=%%i"

if "%deviceType%"=="笔记本电脑" goto LAPTOP
if "%deviceType%"=="台式机" goto DESKTOP
goto UNKNOWN

:LAPTOP
echo.
echo 检测到是笔记本电脑，开始执行...
echo ******【1/22】安装/更新WIFI驱动以及蓝牙驱动，如果电脑重启，再次执行脚本即可******
echo 正在安装WIFI驱动...
WiFi-23.120.0-Driver64-Win10-Win11.exe -q -s 
if %errorlevel% equ 0 (
    echo √  wifi驱动安装成功
) else (
    echo ×  wifi驱动安装失败 错误代码：%errorlevel% &&  echo.
)
echo 正在安装蓝牙驱动...
BT-23.120.0-64UWD-Win10-Win11.exe /qn
if %errorlevel% equ 0 (
    echo √  蓝牙驱动安装成功
) else (
    echo ×  蓝牙驱动安装失败 错误代码：%errorlevel% && echo.
)
echo.
echo.
goto END

:DESKTOP
echo ******【1/22】安装/更新WIFI驱动以及蓝牙驱动******
echo 检测到是台式机，跳过安装WIFI驱动以及蓝牙驱动...
echo.
echo.
goto END

:UNKNOWN
echo 因设备类型无法确定，不执行安装/更新WIFI/蓝牙驱动。
goto END

:END

echo ******当前目录已更改为: %cd%******
echo.
echo.

echo ******"脚本开始时间: " %time%******
set start=%time%
echo.
echo.


::----------------------------------------------------------------------------------------------------------------
echo ******【2/22】连接WIFI MVIT******
echo 正在添加Wi-Fi配置文件...  
::netsh wlan add profile filename="C:\my_share\EasyU_tools\bat-demo\MVIT.xml"
netsh wlan add profile filename= "%cd%\MVIT.xml"
if %errorlevel% neq 0 echo ×  添加配置文件失败,文件不存在,或者是文件权限不足！

echo 正在连接Wi-Fi网络...  
netsh wlan connect name="MVIT" 
if %errorlevel% equ 0 (
    echo √  WIFI连接成功
) else (
    echo ×  连接Wi-Fi网络失败,wifi名错误，或者是配置文件不存在！ 错误代码：%errorlevel%
)
echo.
echo.

@REM echo 连接信息...
@REM netsh wlan show networks
@REM echo.
@REM echo.


::----------------------------------------------------------------------------------------------------------------
echo ******【3/22】设置电脑壁纸******
echo 复制壁纸图片到 C:\Windows\Web\Screen 中...
xcopy /Y ".\Mobvista\*.png" "C:\Windows\Web\Screen"
if %errorlevel% neq 0 echo ×  壁纸复制失败，请检查文件路径或权限！

echo 正在设置壁纸...

reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "C:\Windows\Web\Screen\1920x1080.png" /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
if %errorlevel% equ 0 (
    echo √  设置电脑壁纸成功，重启电脑即可生效
) else (
    echo ×  设置壁纸失败 错误代码：%errorlevel%
)
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
echo ******【4/22】设置电源选项配置******
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

echo √  关闭快速启动项完成

echo √  更改计算机休眠时间完成

echo √  配置电源管理 关闭盖子时 不采取任何措施完成
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


echo ******【5/22】修改用户密码******
echo 正在为用户名为：%USERNAME% 修改密码中...
echo 执行密码修改命令...
net user %USERNAME% Mobvista_256
@REM if %errorlevel% neq 0 echo 用户不存在，或者是权限不足，请看上面的ERROR
::测试密码是否设置成功runas /user:MVGZ001 cmd.exe   
if %errorlevel% equ 0 (
    echo √  密码修改成功，注销或者是重启即可生效
) else (
    echo ×  修改代码失败：%errorlevel%
)
echo.
echo.




::----------------------------------------------------------------------------------------------------------------
setlocal
echo ******【6/22】解锁C盘的BitLocker加密******
manage-bde -off C:
if %errorlevel% equ 0 (
    echo √  解锁BitLocker加密完成
) else (
    echo ×  可能并未开启BitLocker加密，或者是权限不足，所以解锁失败，不影响，详情请看上面的ERROR，错误代码是：%errorlevel%
)
echo.
echo.
endlocal


::----------------------------------------------------------------------------------------------------------------
echo ******【7/22】调整UAC级别更改计算机时通知我（不降低桌面亮度）******
@REM reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0x5 /f
@REM echo.
@REM start C:\WINDOWS\System32\UserAccountControlSettings.exe
echo 调用powershell脚本，UAC_level2.ps1中...
PowerShell -ExecutionPolicy Bypass -Command "& { .\UAC_level2.ps1 }"
echo √  调用成功执行结束，出现5和0表示成功
echo.
echo.
::----------------------------------------------------------------------------------------------------------------


echo ******【8/22】显示桌面图标（计算机）******
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v {20D04FE0-3AEA-1069-A2D8-08002B30309D} /t REG_DWORD /d 0 /f
if %errorlevel% equ 0 (
    echo √  执行成功，显示此电脑图标完成
) else (
    echo ×  图片地址不存在，或者是权限不足，请看上面的ERROR，错误代码：%errorlevel%
)
echo.
echo.

echo ******【9/22】隐藏设置中恢复选项******
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "SettingsPageVisibility" /t REG_SZ /d "hide:recovery" /f
if %errorlevel% equ 0 (
    echo √  设置中的恢复选项隐藏成功
) else (
    echo ×  设置失败，错误代码：%errorlevel%
)
echo.
echo.

echo ******【10/22】关闭自动播放******
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /v DisableAutoplay /t REG_DWORD /d 1 /f
if %errorlevel% equ 0 (
    echo √  关闭自动播放成功
) else (
    echo ×  关闭失败，错误代码：%errorlevel%
)

@REM 如需显示设置中的恢复选项则运行reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "SettingsPageVisibility" /f
echo.
echo.

::----------------------------------------------------------------------------------------------------------------
echo ******【11/22】复制入职培训的PDF到桌面******
xcopy /Y ".\*.pdf" "%USERPROFILE%\Desktop\"
xcopy /Y ".\*.pptx"  "%USERPROFILE%\Desktop\"
if %errorlevel% equ 0 (
    echo √  入职培训PDF复制完成
) else (
    echo ×  似乎复制失败了，请手动复制！ 错误代码：%errorlevel%
)
echo.
echo.

@REM echo ******【12】打开此电脑，请检查是否有有其他分区，如有请进行清理数据******
@REM explorer.exe ::{20D04FE0-3AEA-1069-A2D8-08002B30309D}
@REM echo 打开此电脑完成，请手动检查是否有需要格式化的分区！！！
@REM echo.
@REM echo.


echo ******【12/22】系统更新******
echo 打开系统更新中...
start ms-settings:windowsupdate
echo 执行检查更新...
USOclient StartInteractiveScan 
echo √  执行完成，请等待获取更新并自动下载中...
echo.
echo.



echo "基础配置脚本执行结束: " %time%
set end=%time%

:: 计算时间差
set options="tokens=1-4 delims=:.,"
for /f %options% %%a in ("%start%") do set start_h=%%a&set /a start_m=100%%b %% 100&set /a start_s=100%%c %% 100&set /a start_ms=100%%d %% 100
for /f %options% %%a in ("%end%") do set end_h=%%a&set /a end_m=100%%b %% 100&set /a end_s=100%%c %% 100&set /a end_ms=100%%d %% 100
set /a hours=%end_h%-%start_h%
set /a mins=%end_m%-%start_m%
set /a secs=%end_s%-%start_s%
set /a ms=%end_ms%-%start_ms%
if %ms% lss 0 set /a secs = %secs% - 1 & set /a ms = 100%ms%
if %secs% lss 0 set /a mins = %mins% - 1 & set /a secs = 60%secs%
if %mins% lss 0 set /a hours = %hours% - 1 & set /a mins = 60%mins%
if %hours% lss 0 set /a hours = 24%hours%
if 1%ms% lss 100 set ms=0%ms%

echo.
echo.
:: 计算时间并输出
set /a totalsecs = %hours%*3600 + %mins%*60 + %secs%
echo "基础配置耗时：" %hours%:%mins%:%secs%.%ms% (%totalsecs%.%ms%s total)
echo.
echo.


::----------------------------------------------------------------------------------------------------------------
echo ******【13/22】发放标准软件安装******
echo [1/10] 正在安装7-Zip...
start /wait hPjeBME6V2khYZI3p-8bssXpQTdi9XPL.exe 
start /wait 7z2409-x64.exe /S
echo √  安装成功7-zip

echo [2/10] 正在安装otPlayer（播放器）...
start /wait PotPlayerSetup64.exe /S
echo √  安装成功PotPlayer（播放器）

echo [3/10] 正在安装微信...
start /wait WeChatWin.exe /S
echo √  安装成功微信

echo [4/10] 正在安装飞连...
start /wait FeiLian_Windows_x86_v2.2.23_r1015_464e4f.exe /S
echo √  安装成功飞连

echo [5/10] 正在安装钉钉...
start /wait 7.6.55-Release.250402005.exe /S
echo √  安装成功钉钉

echo [6/10] 正在安装chrome浏览器...
start /wait ChromeSetup.exe
echo √  安装成功chrome浏览器
taskkill -f -im DingTalk.exe


echo [7/10] 正在安装WPS...
start /wait WPS_Setup_20784.exe /S -agreelicense
echo √  安装成功wps
taskkill -f -im chrome.exe

echo [8/10] 正在安装AcroRdrDCx...
AcroRdrDCx642400220857_MUI\Setup.exe /sPB
echo √  安装成功AcroRdrDCx
taskkill -f -im wps.exe

echo [9/10] 正在安装AcroRdrALSDx64 语言包...
start /wait AcroRdrALSDx64_2300820422_all_DC.msi /passive
echo √  安装成功 AcroRdrALSDx64 语言包

echo [10/10] 正在安装智能云钉钉打印...
start /wait DingTalk_Pirnt.exe
echo √  安装智能云钉钉打印机成功
taskkill -f -im DingTalk.exe
echo.
echo.

echo ******【14/22】关闭软件以及其他配置******

tasklist | find "DingTalk.exe"  && echo 进程仍在运行 || echo √  已成功关闭钉钉

tasklist | find "wps.exe"  && echo 进程仍在运行 || echo √  已成功关闭wps

tasklist | find "chrome.exe"  && echo 进程仍在运行 || echo √  已成功关闭wps

reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{EEEEFCF7-867B-4FA2-9ABD-884CF531B600}" /f
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{EEEEFCF7-867B-4FA2-9ABD-884CF531B602}" /f

echo √  去除（隐藏）WPS云盘在此电脑的显示
echo.
echo.

@REM echo -------启动AcroRdrDCx 设置默认PDF-------------
@REM start "" "C:\Program Files\Adobe\Acrobat DC\Acrobat\ShowAppPickerForPDF.exe"

echo ******【15/22】启动Python脚本设置7Zip和PDF默认******
start 7Zip_and_PDF_default_setting_keyboard.exe
echo 等待40秒倒计时完成操作，请勿操作电脑...

timeout /t 40

echo.
echo.

echo ******【16/22】设置文件关联(7zip和PotPlayer)******

@REM 如果你需要设置更过其他的，请修改配置文件 Default-File-association.txt

SetUserFTA.exe Default-file-association.txt
if %errorlevel% equ 0 (
    echo √  文件关联设置完成
) else (
    echo ×  文件关联设置失败！ 错误代码：%errorlevel%
)
echo.
echo.

echo ******【17/22】卸载小组件******
winget  uninstall "windows web experience pack" --accept-source-agreements
echo √  卸载完成！！！重启后生效
echo.
echo.

echo ******【18/22】安装360企业云安全软件******
echo 开始安装360企业云安全...
echo 正在执行安装程序...
Setup[T1q358KV][6332a09e67259].exe /S /corp=1
if %errorlevel% equ 0 (
    echo √  360企业云安全安装成功
) else (
    echo ×  360企业云安全安装失败，错误代码：%errorlevel%
)
start "" "C:\Program Files (x86)\360\360Safe\EntAdmin\360EntDT.exe"

echo.
echo.
echo "软件安装耗时时间结束: " %time%
set end=%time%

:: 计算时间差
set options="tokens=1-4 delims=:.,"
for /f %options% %%a in ("%start%") do set start_h=%%a&set /a start_m=100%%b %% 100&set /a start_s=100%%c %% 100&set /a start_ms=100%%d %% 100
for /f %options% %%a in ("%end%") do set end_h=%%a&set /a end_m=100%%b %% 100&set /a end_s=100%%c %% 100&set /a end_ms=100%%d %% 100
set /a hours=%end_h%-%start_h%
set /a mins=%end_m%-%start_m%
set /a secs=%end_s%-%start_s%
set /a ms=%end_ms%-%start_ms%
if %ms% lss 0 set /a secs = %secs% - 1 & set /a ms = 100%ms%
if %secs% lss 0 set /a mins = %mins% - 1 & set /a secs = 60%secs%
if %mins% lss 0 set /a hours = %hours% - 1 & set /a mins = 60%mins%
if %hours% lss 0 set /a hours = 24%hours%
if 1%ms% lss 100 set ms=0%ms%

echo.
echo.
:: 计算时间并输出
set /a totalsecs = %hours%*3600 + %mins%*60 + %secs%
echo "基础配置加软件安装耗时：" %hours%:%mins%:%secs%.%ms% (%totalsecs%.%ms%s total)
echo.
echo.
@REM ::判断对应的类型，匹配不同的复制序列号
@REM if %choice%==1 goto notebook
@REM if %choice%==2 goto tablemodel
@REM echo 输入无效，请输入1或2。
@REM goto end

@REM :notebook
echo ******【19/22】获取笔记本序列号并且复制******
powershell -Command "(Get-WmiObject Win32_BIOS).SerialNumber | clip; Write-Host \"√  序列号已复制到剪贴板：\" -NoNewline; Get-Clipboard"
@REM wmic bios get serialnumber | findstr /V SerialNumber | clip
@REM echo 笔记本序列号（如果没有复制成功，请在下方手动复制即可）：
@REM wmic bios get serialnumber
@REM echo ******笔记本：获取序列号并且复制命令******
@REM echo "wmic bios get serialnumber | findstr /V SerialNumber | clip" 
@REM goto end

@REM :tablemodel
@REM echo ******台式获取序列号并且复制******
@REM wmic baseboard  get serialnumber | findstr /V SerialNumber | clip
@REM echo 序列号（如果没有复制成功，请在下方手动复制即可）：
@REM wmic baseboard  get serialnumber
@REM echo ******台式：获取序列号并且复制命令******
@REM echo "wmic baseboard  get serialnumber | findstr /V SerialNumber | clip"
@REM goto end

@REM :end


@REM echo 按1次回车即可查看软件是否安装成功 & pause

echo ---------------【20/22】检查是否安装成功----------------------
setlocal EnableDelayedExpansion  
:: 定义要检查的文件的路径和名称  
set "files[0]=C:\Program Files (x86)\DingDing\DingtalkLauncher.exe"  
set "files[1]=C:\Program Files\Tencent\Weixin\Weixin.exe"  
set "files[2]=C:\Program Files\Google\Chrome\Application\chrome.exe"  
set "files[3]=C:\Program Files\7-Zip\7zFM.exe"  
set "files[4]=C:\Program Files\DAUM\PotPlayer\PotPlayerMini64.exe"  
set "files[5]=C:\Program Files\CorpLink\current\Client\CorpLink.exe"  
set "files[6]=%USERPROFILE%\AppData\Local\kingsoft\WPS Office\ksolaunch.exe"
set "files[7]=C:\Program Files (x86)\Kingsoft Office Software\WPS Office\ksolaunch.exe"
set "files[8]=C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe"  
set "files[9]=C:\Program Files (x86)\360\360Safe\360Safe.exe"  
:: 智能云打印插件，暂时找不到包的位置


:: 设置数组的大小  
set "fileCount=8"  
  
:: 循环检查每个文件  
for /L %%i in (0,1,%fileCount%) do (  
    set "targetFile=!files[%%i]!"  
    if exist "!targetFile!" (  
        echo √  文件 !targetFile! 已找到，安装成功。
    ) else (  
        echo ×  文件 !targetFile! 未找到，可能未安装！！！！！
    )  
)  
endlocal
echo.
echo.

echo ******【21/22】格式化其他盘符，调用脚本...******
echo 调用powershell脚本，Format_disk_letter.ps1中...

echo 请手动确认一下吧，需要清理的盘符吧！

PowerShell -ExecutionPolicy Bypass -Command "& { .\Format_disk_letter.ps1 }"
echo √  执行成功，等待格式化完成
echo.
echo.


echo ******【22/22】获取电脑型号匹配卸载规则******
powershell -Command "$target='HP EliteBook 640 14 inch G11 Notebook PC'; $m=(Get-CimInstance Win32_ComputerSystem).Model; Write-Host '当前型号:'$m; if($m -eq $target){ try{ Start-Process cmd -ArgumentList '/c \"%cd%/remove_software.bat"'  -Verb RunAs -Wait; Write-Host '√  脚本已提权执行卸载脚本，请手动操作' -ForegroundColor Green }catch{ Write-Host '执行失败: '$_.Exception.Message -ForegroundColor Red } }else{ Write-Host '×  型号不匹配，无需卸载' -ForegroundColor Yellow }"
echo.
echo.

echo 按2次回车即可断开wifi以及忘记密码 & pause pause

echo -----------断开wifi链接---------
netsh wlan disconnect
if %errorlevel% neq 0 echo 连接Wi-Fi网络失败！

echo ----------忘记wifi-------------
netsh wlan delete profile MVIT
if %errorlevel% neq 0 echo 已忘记！
echo.
echo.

echo ******请选择对应的操作******：
echo *
echo *
echo ******1. 重启******
echo *
echo *
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

