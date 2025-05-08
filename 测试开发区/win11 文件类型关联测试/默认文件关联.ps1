function Generate-Hash($progId, $userSid) {
    $timestamp = Get-Date -Format "yyyyMMddHHmm"
    $str = ".{0}{1}{2}" -f $userSid, $progId, $timestamp
    $bytes = [System.Text.Encoding]::Unicode.GetBytes($str)
    $hash = [System.Security.Cryptography.MD5]::Create()
    $hashBytes = $hash.ComputeHash($bytes)
    $hashBase64 = [Convert]::ToBase64String($hashBytes[0..7])
    return $hashBase64
}

function Set-FileAssociation($extension, $progId, $defaultIcon, $command) {
    # 创建或更新文件扩展名键
    if (-not (Test-Path "Registry::HKEY_CLASSES_ROOT\$extension")) {
        New-Item "Registry::HKEY_CLASSES_ROOT\$extension" -Force | Out-Null
    }
    New-ItemProperty "Registry::HKEY_CLASSES_ROOT\$extension" -Name "(default)" -Value $progId -Force | Out-Null

    # 创建或更新ProgId键
    if (-not (Test-Path "Registry::HKEY_CLASSES_ROOT\$progId")) {
        New-Item "Registry::HKEY_CLASSES_ROOT\$progId" -Force | Out-Null
    }
    New-ItemProperty "Registry::HKEY_CLASSES_ROOT\$progId" -Name "(default)" -Value "$progId File" -Force | Out-Null
    New-ItemProperty "Registry::HKEY_CLASSES_ROOT\$progId\DefaultIcon" -Name "(default)" -Value "`"$defaultIcon`",0" -Force | Out-Null

    # 创建或更新命令键
    if (-not (Test-Path "Registry::HKEY_CLASSES_ROOT\$progId\shell\open\command")) {
        New-Item "Registry::HKEY_CLASSES_ROOT\$progId\shell\open\command" -Force | Out-Null
    }
    New-ItemProperty "Registry::HKEY_CLASSES_ROOT\$progId\shell\open\command" -Name "(default)" -Value $command -Force | Out-Null

    # 获取用户的SID
    $userSid = Get-WmiObject Win32_UserAccount -Filter "Name='%USERNAME%'" | Select-Object -ExpandProperty SID

    # 生成Hash值
    $hash = Generate-Hash $progId $userSid

    # 设置UserChoice键
    if (-not (Test-Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$extension\UserChoice")) {
        New-Item "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$extension\UserChoice" -Force | Out-Null
    }
    New-ItemProperty "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$extension\UserChoice" -Name "ProgId" -Value $progId -Force | Out-Null
    New-ItemProperty "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$extension\UserChoice" -Name "Hash" -Value $hash -Force | Out-Null
}

# 示例：将.txt文件关联到Notepad++
$extension = ".zip"
$progId = "ZipFile"
$defaultIcon = "C:\Program Files\7-Zip/7zFM.exe"
$command = '"C:\Program Files\Notepad++\notepad++.exe" "%1"'
Set-FileAssociation $extension $progId $defaultIcon $command