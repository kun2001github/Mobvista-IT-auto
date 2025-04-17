@echo off 
::解决中文乱码的
chcp 65001

title 软件卸载工具 
color 0A 
echo 正在执行卸载操作...
echo -----------------------------------
 
:: 1. 卸载CooCare5云服务 
echo [1/3] 正在卸载CooCare5云服务...
start /wait "" "C:\Program Files (x86)\StarSoftComm\CooCare5\CloudOnline\BIN\CCSetup.exe"  /uninstall 
if %errorlevel% equ 0 (
    echo √ CooCare5卸载成功 
) else (
    echo × CooCare5卸载失败 错误代码：%errorlevel%
)
 
:: 2. 卸载金山文档（静默模式）
echo [2/3] 正在静默卸载金山文档...
start /wait "" "C:\Program Files (x86)\金山文档\uninst.exe"  /S 
if %errorlevel% equ 0 (
    echo √ 金山文档卸载成功 
) else (
    echo × 金山文档卸载失败 错误代码：%errorlevel%
)
 
:: 3. 运行StarCenter安装程序（可能是修复或卸载）
echo [3/3] 正在处理StarCenter...
start /wait "" "C:\Program Files (x86)\StarSoftComm\StarCenter\setup\setup.exe" 
if %errorlevel% equ 0 (
    echo √ StarCenter处理完成 
) else (
    echo × StarCenter处理异常 错误代码：%errorlevel%
)
 
echo -----------------------------------
echo 所有操作执行完毕 
pause 