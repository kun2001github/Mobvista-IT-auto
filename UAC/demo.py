import winreg

# 定义UAC级别的常数
UAC_LEVELS = {
    "ALWAYS_NOTIFY": 5,  # 始终通知
    "DEFAULT": 4,       # 仅当应用程序尝试更改我的计算机时通知我（默认）
    "NO_DIM_SCREEN": 3, # 仅当应用程序尝试更改我的计算机时通知我（不降低桌面的亮度）
    "NEVER_NOTIFY": 0   # 从不通知
}

# 调整UAC级别的函数
def set_uac_level(level):
    # 打开注册表项
    key = winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, r'Software\Microsoft\Windows\CurrentVersion\Policies\System', 0, winreg.KEY_WRITE)
    
    # 设置ConsentPromptBehaviorAdmin值
    winreg.SetValueEx(key, 'ConsentPromptBehaviorAdmin', 0, winreg.REG_DWORD, level)
    
    # 设置PromptOnSecureDesktop值
    if level == UAC_LEVELS["ALWAYS_NOTIFY"]:
        winreg.SetValueEx(key, 'PromptOnSecureDesktop', 0, winreg.REG_DWORD, 1)
    else:
        winreg.SetValueEx(key, 'PromptOnSecureDesktop', 0, winreg.REG_DWORD, 0)
    
    # 关闭注册表项
    winreg.CloseKey(key)

# 使用函数调整UAC级别
# 注意：这个脚本需要以管理员权限运行
try:
    set_uac_level(UAC_LEVELS["DEFAULT"])
    print("UAC级别已设置为默认。")
except Exception as e:
    print(f"错误：{e}")
