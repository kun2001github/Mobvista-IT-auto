# 重置Windows系统
function Reset-Windows {
    # 提示用户备份重要数据
    Write-Host "Please make sure to back up all important data before proceeding."
    Write-Host "This script will remove all personal files and apps."

    # 等待用户确认
    $confirmation = Read-Host "Are you sure you want to reset this PC? (Y/N)"
    if ($confirmation -ne 'Y') {
        Write-Host "Reset cancelled."
        return
    }

    # 调用系统重置命令
    try {
        # 删除所有个人文件并重置PC
        Start-Process "systemreset" -ArgumentList "/factoryreset /force" -NoNewWindow -Wait
        Write-Host "Windows reset initiated. The system will restart shortly."
    } catch {
        Write-Host "An error occurred: $_"
    }
}

# 执行重置操作
Reset-Windows
