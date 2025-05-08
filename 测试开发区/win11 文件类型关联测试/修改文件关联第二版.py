import winreg

def set_file_association(extension, prog_id):
    # 打开注册表中的文件关联键
    with winreg.OpenKey(winreg.HKEY_CLASSES_ROOT, extension, 0, winreg.KEY_SET_VALUE) as key:
        winreg.SetValueEx(key, None, 0, winreg.REG_SZ, prog_id)

    # 打开注册表中的UserChoice键
    with winreg.OpenKey(winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\{}".format(extension), 0, winreg.KEY_SET_VALUE) as key:
        with winreg.CreateKey(key, "UserChoice") as subkey:
            winreg.SetValueEx(subkey, "ProgId", 0, winreg.REG_SZ, prog_id)

# 设置.zip文件的关联程序为7-Zip
set_file_association(".zip", "7-Zip.zip")