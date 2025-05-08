# 检查当前是否以管理员权限运行
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-not $isAdmin) {
    # 若没有管理员权限，则以管理员身份重新启动脚本
    $params = "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Definition)`""
    Start-Process -FilePath PowerShell.exe -Verb RunAs -ArgumentList $params
    exit
}


# 设置输出编码为 UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# 获取所有磁盘驱动器信息
$disks = Get-WmiObject -Class Win32_LogicalDisk

# 显示磁盘的盘符
Write-Host "当前磁盘的盘符如下:"
foreach ($disk in $disks) {
    Write-Host "  $($disk.DeviceID)"
}
Write-Host "---------------------"


# 用于存储 USB 磁盘的驱动器号
$usbDriveLetters = @()

try {
    # 获取所有USB磁盘（包括exFAT格式）
    $usbDiskDrives = Get-WmiObject -Class Win32_Volume | Where-Object {
        $_.DriveType -eq 2 -and $_.DriveLetter -ne $null
    }

    if ($usbDiskDrives) {
        foreach ($usbDrive in $usbDiskDrives) {
            $driveLetter = $usbDrive.DriveLetter
            $volumeName = if ($usbDrive.Label) { $usbDrive.Label } else { "未命名" }
            Write-Host "找到 USB 磁盘: $driveLetter (名称: $volumeName, 文件系统: $($usbDrive.FileSystem))"
            $usbDriveLetters += $driveLetter
            Write-Host "------------------------"
        }
    } else {
        Write-Host "没有找到 USB 磁盘。"
        Write-Host "---------------------"
    }
}
catch {
    Write-Host "获取 USB 磁盘驱动器号时出错: $($_.Exception.Message)"
    Write-Host "---------------------"
}

# 筛选出除 C 盘和 USB 磁盘驱动器号外的其他盘符
$otherDriveLetters = $disks | Where-Object {
    $_.DeviceID -ne "C:" -and $usbDriveLetters -notcontains $_.DeviceID
} | Select-Object -ExpandProperty DeviceID


foreach ($letter in $otherDriveLetters) {
    Write-Host "除 C 盘和 USB 磁盘外的其他盘符: $letter "
    Write-Host
    Write-Host "即将格式化盘符: $letter，此操作会清除该磁盘所有数据。"
    $confirmation = Read-Host "是否确认格式化？(y/n)"
    if ($confirmation -eq 'y') {
        try {
            Write-Host "正在格式化 $letter ..."
            Format-Volume -DriveLetter ($letter -replace ":", "") -FileSystem NTFS -Confirm:$false
            Write-Host " $letter 格式化完成。"
            Write-Host "------------------------"
            $items = Get-ChildItem -Path $letter -Force 
            Write-Host $items
        }
        catch {
            Write-Host "格式化 $letter 时出错: $($_.Exception.Message)"
        }
    } else {
        Write-Host "已取消格式化 $letter。"
    }
}

Write-Host "所有操作已完成，按回车键进行下一步吧。"
Read-Host | Out-Null