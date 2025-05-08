chcp 65001 > nul

@echo off

:: Make sure you have administrator permission.
set "Apply=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  cmd /u /c echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && ""%~s0"" %Apply%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )


echo ------------笔记本获取序列号并且复制-------------------
wmic bios get serialnumber | findstr /V SerialNumber | clip
if %errorlevel% neq 0 echo 序列包复制失败，请手动输入 （wmic bios get serialnumber | findstr /V SerialNumber） 获取序列号并且复制
echo.
echo 序列号（如果没有复制成功，请在下方手动复制即可）：
wmic bios get serialnumber
echo ------------笔记本：获取序列号并且复制-------------------
echo bios get serialnumber
echo wmic bios get serialnumber | findstr /V SerialNumber | clip
echo.
echo.
echo.
pause
exit