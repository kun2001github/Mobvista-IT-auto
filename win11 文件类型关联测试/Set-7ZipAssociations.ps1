# 设置文件关联
New-Item -Path "HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\.zip" -Value "7-Zip" -Force
New-Item -Path "HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\.rar" -Value "7-Zip" -Force
New-Item -Path "HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\.7z" -Value "7-Zip" -Force

# 设置打开方式
Set-ItemProperty -Path "HKCU:\Software\Classes\7-Zip" -Name "(default)" -Value "7-Zip"