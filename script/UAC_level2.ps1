# 设置UAC级别为“仅当应用程序尝试更改我的计算机时通知我（不降低桌面的亮度）”
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 5
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Value 0

# 输出UAC级别状态，输出5和0是对的
$uacStatus = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
Write-Host "ConsentPromptBehaviorAdmin: " $uacStatus.ConsentPromptBehaviorAdmin
Write-Host "PromptOnSecureDesktop: " $uacStatus.PromptOnSecureDesktop

# 使用判断是否为5 和 0 
if ($uacStatus.ConsentPromptBehaviorAdmin -eq 5 -and $uacStatus.PromptOnSecureDesktop -eq 0) {
    Write-Host "UAC succeed"
} else {
    Write-Host "UAC fail"
}

# ConsentPromptBehaviorAdmin：
# 0：从不通知
# 5：始终通知
# 其他值：其他通知行为
# PromptOnSecureDesktop：
# 1：在安全桌面上提示
# 0：不在安全桌面上提示