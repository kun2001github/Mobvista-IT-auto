# 设置UAC级别为“始终通知”
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 5
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Value 1

# 获取UAC状态
$uacStatus = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
Write-Host "ConsentPromptBehaviorAdmin: " $uacStatus.ConsentPromptBehaviorAdmin
Write-Host "PromptOnSecureDesktop: " $uacStatus.PromptOnSecureDesktop
