import ctypes
import base64
from datetime import datetime
import pywin32
import hashlib

def get_user_sid():
    try:
        # 获取当前登录用户的SID
        sid = pywin32.security.GetTokenInformation(pywin32.security.GetCurrentThreadToken())[1]
        return str(sid)
    except Exception as e:
        print(f"Error getting user SID: {e}")
        return None

def calc_value(a, b, c):
    return (a * c + b * (c >> 16)) & 0xFFFFFFFF

def get_mshash(md5_bytes, data):
    md5_1 = int.from_bytes(md5_bytes[0:4], 'little') | 1
    md5_2 = int.from_bytes(md5_bytes[4:8], 'little') | 1
    x1, y1 = 0, 0
    for i in range(0, len(data) // 4):
        d = (data[i * 4 + 0] + (data[i * 4 + 1] << 16)) & 0xFFFFFFFF
        x0 = (d + x1) & 0xFFFFFFFF
        x1 = (md5_1 * x0) & 0xFFFFFFFF
        x0 = calc_value(0x69FB0000, 0xEF0569FB, x0)
        x1 = (x1 + x0) & 0xFFFFFFFF
        x1 = calc_value(0x79F8A395, 0x689B6B9F, x1)
        x1 = calc_value(0xEA970001, 0xC3EFEA97, x1)
        y0 = (d + y1) & 0xFFFFFFFF
        y1 = (md5_1 * y0) & 0xFFFFFFFF
        y1 = calc_value(0xB1110000, 0xCF98B111, y0)
        y1 = calc_value(0x5B9F0000, 0x87085B9F, y1)
        y1 = calc_value(0xB96D0000, 0x12CEB96D, y1)
        y1 = calc_value(0x1D830000, 0x257E1D83, y1)
    h1 = (x1 ^ y1)
    h2 = 0  # 初始化为0
    h0 = (h2 << 32) + h1
    return h0.to_bytes(8, 'little')

def generate_hash(extension, prog_id):
    timestamp = datetime.now().strftime("%Y%m%d%H%M")
    sid = get_user_sid()
    user_exp = "user choice set via windows user experience {d18b6dd5-6124-4341-9318-804003bafa0b}"
    data = (extension + sid + prog_id + timestamp + user_exp).lower()
    md5 = hashlib.md5(data.encode('utf-16-le')).digest()
    mshash = get_mshash(md5, data.encode('utf-16-le'))
    return base64.b64encode(mshash).decode('utf-8').rstrip('=')

# 示例：生成 .txt 文件关联到 txtfile 的 Hash 值
extension = ".txt"
prog_id = "txtfile"
hash_value = generate_hash(extension, prog_id)
print(f"Generated Hash value: {hash_value}")