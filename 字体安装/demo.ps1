# 定义字体文件夹路径，这里假设字体文件解压后存放在该目录下，请根据实际情况修改
$fontSourcePath = "C:\Users\MVGZ0040\Downloads\Compressed\AlibabaPuHuiTi-3\AlibabaPuHuiTi"

# 获取系统字体文件夹路径
$fontDestinationPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Fonts)

# 输出调试信息
Write-Host "字体源路径: $fontSourcePath"
Write-Host "字体目标路径: $fontDestinationPath"

# 递归获取指定路径下及其子文件夹中的所有字体文件（.ttf、.ttc、.otf 格式）
$fontFiles = Get-ChildItem -Path $fontSourcePath -File -Recurse -Filter *.ttf
$fontFiles += Get-ChildItem -Path $fontSourcePath -File -Recurse -Filter *.ttc
$fontFiles += Get-ChildItem -Path $fontSourcePath -File -Recurse -Filter *.otf

# 输出找到的字体文件数量
Write-Host "找到的字体文件数量: $($fontFiles.Count)"

foreach ($fontFile in $fontFiles) {
    try {
        # 复制字体文件到系统字体文件夹
        Copy-Item -Path $fontFile.FullName -Destination $fontDestinationPath -Force

        # 创建注册表项以通知系统安装字体
        $fontName = [System.Drawing.Text.PrivateFontCollection]::new()
        $fontName.AddFontFile($fontFile.FullName)
        $installedFontName = $fontName.Families[0].Name
        $fontRegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
        if ($fontFile.Extension -eq ".ttf") {
            New-ItemProperty -Path $fontRegPath -Name $installedFontName -Value $fontFile.Name -PropertyType String -Force | Out-Null
        } elseif ($fontFile.Extension -eq ".ttc") {
            New-ItemProperty -Path $fontRegPath -Name ($installedFontName + " (TrueType Collection)") -Value $fontFile.Name -PropertyType String -Force | Out-Null
        } elseif ($fontFile.Extension -eq ".otf") {
            New-ItemProperty -Path $fontRegPath -Name $installedFontName -Value $fontFile.Name -PropertyType String -Force | Out-Null
        }
        Write-Host "已成功安装字体: $installedFontName"
    }
    catch {
        Write-Host "安装字体 $($fontFile.Name) 时出错: $($_.Exception.Message)"
    }
}