import winreg as reg
import os

# 注册表路径定义
HKEY_CURRENT_USER = reg.HKEY_CURRENT_USER
ZIP_EXTENSION_KEY = r"Software\Classes\.zip"
SEVENZIP_PROGID_KEY = r"Software\Classes\7Zip.zip"
USERCHOICE_KEY = r"Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.zip\UserChoice"
EXPLORER_KEY = r"Software\Microsoft\Windows\CurrentVersion\Explorer"

def set_registry_value(key, subkey, name, value, reg_type=reg.REG_SZ):
    try:
        reg_key = reg.CreateKey(key, subkey)
        reg.SetValueEx(reg_key, name, 0, reg_type, value)
        reg.CloseKey(reg_key)
        print(f"成功设置 {subkey} -> {name}: {value}")
    except Exception as e:
        print(f"设置注册表失败: {e}")

def modify_zip_association():
    # 修改 .zip 文件扩展名关联到 7-Zip
    set_registry_value(HKEY_CURRENT_USER, ZIP_EXTENSION_KEY, "7Zip_bak", "7-Zip.zip")
    set_registry_value(HKEY_CURRENT_USER, ZIP_EXTENSION_KEY, "", "7Zip.zip")

    # 修改 7Zip.zip 的描述，不设置图标
    set_registry_value(HKEY_CURRENT_USER, SEVENZIP_PROGID_KEY, "", "ZIP 压缩文件")
    # 不设置图标路径，因此省略 DefaultIcon 项
    set_registry_value(HKEY_CURRENT_USER, SEVENZIP_PROGID_KEY + r"\Shell\Open", "FriendlyAppName", "7-Zip")
    set_registry_value(HKEY_CURRENT_USER, SEVENZIP_PROGID_KEY + r"\Shell\Open\Command", "", r"\"C:\Program Files\7-Zip\7zFM.exe\" \"%1\"")

    # 删除 Hash 以便系统重新生成，并设置 ProgId
    try:
        reg_key = reg.CreateKey(HKEY_CURRENT_USER, USERCHOICE_KEY)
        reg.DeleteValue(reg_key, "Hash")  # 删除 Hash
        reg.SetValueEx(reg_key, "ProgId", 0, reg.REG_SZ, "7Zip.zip")
        reg.CloseKey(reg_key)
        print("成功设置 UserChoice -> ProgId: 7Zip.zip，并删除 Hash")
    except Exception as e:
        print(f"设置 UserChoice 失败: {e}")

    # 修改 GlobalAssocChangedCounter
    set_registry_value(HKEY_CURRENT_USER, EXPLORER_KEY, "GlobalAssocChangedCounter", 0x1d3, reg.REG_DWORD)

if __name__ == "__main__":
    # 以管理员权限运行脚本
    modify_zip_association()
    input() 
