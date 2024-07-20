@REM  调用powershell脚本，执行UAC设置，会在当前目录下寻找powershell的脚本
PowerShell -ExecutionPolicy Bypass -Command "& { .\UAC_level2.ps1 }"