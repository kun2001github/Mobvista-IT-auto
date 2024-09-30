import winreg
import base64
import hashlib
import ctypes
from datetime import datetime

def get_user_sid():
    try:
        # 获取当前登录用户的SID
        sid = winreg.QueryInfoKey(winreg.OpenKey(winreg.HKEY_CURRENT_USER, '', 0, winreg.KEY_READ))[1]
        return str(sid)
    except Exception as e:
        print(f"Error getting user SID: {e}")
        return None

def generate_hash(base_info):
    # 计算 MD5 哈希值
    md5_hash = hashlib.md5(base_info.encode('utf-16-le')).digest()
    
    # 将哈希值转换为 Base64 编码的字符串
    base64_hash = base64.b64encode(md5_hash).decode('utf-8').rstrip('=')
    
    # 移除 Base64 编码中的 '+' 和 '/'
    base64_hash = base64_hash.replace('+', '').replace('/', '')
    
    return base64_hash

def set_fta(prog_id, extension, icon=None):
    # 获取当前用户的 SID
    user_sid = get_user_sid()
    if not user_sid:
        raise Exception("Failed to get user SID")

    # 获取当前时间戳，格式为yyyyMMddHHmm
    timestamp = datetime.now().strftime("%Y%m%d%H%M")

    # 构建基础信息字符串
    user_experience = "user choice set via windows user experience {d18b6dd5-6124-4341-9318-804003bafa0b}"
    base_info = f"{extension}{user_sid}{prog_id}{timestamp}{user_experience}".lower()

    # 生成 Hash 值
    prog_hash = generate_hash(base_info)
    print(f"Generated hash: {prog_hash}")

    # 设置注册表项
    try:
        # 删除旧的 UserChoice 键
        user_choice_key = winreg.OpenKey(winreg.HKEY_CURRENT_USER, f"Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\{extension}\\UserChoice", 0, winreg.KEY_WRITE)
        winreg.DeleteKey(user_choice_key, None)

        # 创建新的 UserChoice 键
        user_choice_key = winreg.CreateKey(winreg.HKEY_CURRENT_USER, f"Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\{extension}\\UserChoice")
        winreg.SetValueEx(user_choice_key, "ProgId", 0, winreg.REG_SZ, prog_id)
        winreg.SetValueEx(user_choice_key, "Hash", 0, winreg.REG_SZ, prog_hash)
        winreg.CloseKey(user_choice_key)

        # 如果提供了图标，设置图标
        if icon:
            icon_key = winreg.CreateKey(winreg.HKEY_CURRENT_USER, f"Software\\Classes\\{prog_id}\\DefaultIcon")
            winreg.SetValueEx(icon_key, None, 0, winreg.REG_SZ, icon)
            winreg.CloseKey(icon_key)

    except Exception as e:
        print(f"Failed to set registry keys: {e}")
        return

    print(f"Set default association for {extension} to {prog_id} with hash {prog_hash}")

# 示例：将.txt文件关联到txtfile
set_fta("txtfile", ".txt")