import winreg as reg

# 注册表路径
EXPLORER_KEY = r"Software\Microsoft\Windows\CurrentVersion\Explorer"
VALUE_NAME = "GlobalAssocChangedCounter"

def get_registry_value(key, subkey, value_name):
    """获取指定注册表键的值"""
    try:
        reg_key = reg.OpenKey(key, subkey, 0, reg.KEY_READ)
        value, reg_type = reg.QueryValueEx(reg_key, value_name)
        reg.CloseKey(reg_key)
        return value
    except FileNotFoundError:
        print(f"注册表项 {subkey} 不存在或未找到 {value_name}")
        return None
    except Exception as e:
        print(f"读取注册表失败: {e}")
        return None

def set_registry_value(key, subkey, value_name, value, reg_type=reg.REG_DWORD):
    """设置注册表键的值"""
    try:
        reg_key = reg.OpenKey(key, subkey, 0, reg.KEY_SET_VALUE)
        reg.SetValueEx(reg_key, value_name, 0, reg_type, value)
        reg.CloseKey(reg_key)
        print(f"成功设置 {subkey} -> {value_name}: {value}")
    except Exception as e:
        print(f"设置注册表失败: {e}")

def increment_global_assoc_changed_counter():
    """获取当前 GlobalAssocChangedCounter 值并递增"""
    current_value = get_registry_value(reg.HKEY_CURRENT_USER, EXPLORER_KEY, VALUE_NAME)
    
    if current_value is not None:
        new_value = current_value + 1  # 递增
        print(f"当前值为: {current_value}, 递增后的新值为: {new_value}")
        
        # 设置递增后的值
        set_registry_value(reg.HKEY_CURRENT_USER, EXPLORER_KEY, VALUE_NAME, new_value)

if __name__ == "__main__":
    # 以管理员权限运行脚本
    increment_global_assoc_changed_counter()
