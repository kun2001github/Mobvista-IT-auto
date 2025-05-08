import os

def open_windows_settingsToUpdate():
    # 尝试打开设置应用的更新和安全部分
    os.system('start ms-settings:windowsupdate')

# 调用函数
open_windows_settingsToUpdate()
