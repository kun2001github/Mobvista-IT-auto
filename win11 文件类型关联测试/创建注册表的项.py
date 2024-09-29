import winreg

def create_registry_key(key_path, subkey_name):
    try:
        # 打开指定的注册表路径
        with winreg.OpenKey(winreg.HKEY_CURRENT_USER, key_path, 0, winreg.KEY_WRITE) as key:
            # 在路径下创建一个名为UserChoice的子键
            subkey = winreg.CreateKey(key.handle, subkey_name)
            print(f"创建了新的注册表项: {key_path}\\{subkey_name}")
    except OSError as e:
        print(f"无法创建注册表项: {e}")

# 指定的注册表路径
key_path = r"Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.zip"
subkey_name = "UserChoice"

# 调用函数创建注册表项
create_registry_key(key_path, subkey_name)