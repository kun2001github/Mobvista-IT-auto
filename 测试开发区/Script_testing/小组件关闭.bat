chcp 65001 > nul

:: Make sure you have administrator permission.
@echo off
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"

:: 关闭 Windows 11 小组件的任务（Widget 进程）

echo 关闭小组件进程...

taskkill /F /IM widgets.exe

:: 禁用任务栏小组件的功能

echo 正在禁用任务栏小组件...

reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f

@REM :: 刷新 Windows 资源管理器，应用更改

@REM echo 正在刷新资源管理器...

@REM taskkill /f /im explorer.exe
@REM start explorer.exe

echo 小组件已关闭！
pause
