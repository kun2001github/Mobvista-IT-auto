import hashlib
import base64
import ctypes
from datetime import datetime
import win32security
import win32api


def get_user_sid():
    try:
        # 获取当前进程的句柄
        token_handle = win32security.OpenProcessToken(win32api.GetCurrentProcess(), win32security.TOKEN_QUERY)
        # 获取SID对象
        sid = win32security.GetTokenInformation(token_handle, win32security.TokenUser)[0]
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

def main():
    # 获取当前用户的 SID
    sid = get_user_sid()
    print(f"Current user SID is: {sid}")

    # 获取当前时间戳，格式为yyyyMMddHHmm
    timestamp = datetime.now().strftime("%Y%m%d%H%M")
    
    # 构建基础信息字符串
    extension = ".txt"  # 扩展名
    prog_id = "txtfile"  # ProgId
    user_exp = "user choice set via windows user experience {d18b6dd5-6124-4341-9318-804003bafa0b}"
    
    base_info = f"{extension}{sid}{prog_id}{timestamp}{user_exp}".lower()
    
    # 生成 Hash 值
    hash_value = generate_hash(base_info)
    print(f"Generated Hash value: {hash_value}")

    # 打印注册表路径和值
    print(f"ProgId: {prog_id}")
    print(f"Hash: {hash_value}")

if __name__ == "__main__":
    main()