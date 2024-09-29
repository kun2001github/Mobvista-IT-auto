import winreg as reg
import sys

def set_registry_value(key, value_name, value):
    try:
        # 打开注册表键
        registry_key = reg.OpenKey(key, r"Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", 0, reg.KEY_SET_VALUE)
        # 设置注册表值
        reg.SetValueEx(registry_key, value_name, 0, reg.REG_DWORD, value)
        reg.CloseKey(registry_key)
        print(f"Successfully set {value_name} to {value}")
    except Exception as e:
        print(f"Error: {e}")

def main():
    # 禁用小组件
    set_registry_value(reg.HKEY_CURRENT_USER, "TaskbarDa", 0)
    # 如果需要启用小组件，将上面的 0 改为 1
    # set_registry_value(reg.HKEY_CURRENT_USER, "TaskbarDa", 1)

if __name__ == "__main__":
    main()
