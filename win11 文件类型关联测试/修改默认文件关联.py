import hashlib
import base64
import os
import time
import winreg as reg
import win32api
import win32security
from datetime import datetime

# 获取当前用户 SID
def get_user_sid():
    try:
        user_name = win32api.GetUserName()
        user_info = win32security.LookupAccountName(None, user_name)
        sid = user_info[0]
        return win32security.ConvertSidToStringSid(sid)
    except Exception as e:
        print(f"[ERROR] 无法获取用户 SID: {e}")
        return None

# 使用自定义的哈希生成方法
def generate_user_choice_hash(prog_id, sid):
    # 获取当前时间戳，格式为yyyyMMddHHmm
    timestamp = datetime.now().strftime("%Y%m%d%H%M")
    # 拼接字符串
    str_to_hash = f".{sid}{prog_id}{timestamp}"
    # 将字符串转换为字节
    bytes_to_hash = str_to_hash.encode('utf-16-le')
    # 创建MD5哈希对象
    md5_hash = hashlib.md5(bytes_to_hash)
    # 计算哈希值
    hash_bytes = md5_hash.digest()
    # 取哈希值的前8字节
    final_hash_bytes = hash_bytes[:8]
    # 将最终的哈希值进行Base64编码
    hash_base64 = base64.b64encode(final_hash_bytes).decode('utf-8').rstrip('=')
    return hash_base64

# 测试生成的哈希值
def test_generate_user_choice_hash():
    sid = get_user_sid()
    prog_id = "7-Zip"
    hash_value = generate_user_choice_hash(prog_id, sid)
    print(f"[INFO] 生成的 Hash 值: {hash_value}")

# 测试生成的哈希值
test_generate_user_choice_hash()

# # 创建注册表项
# def create_registry_key(key_path, subkey_name):
#     try:
#         key = reg.CreateKey(reg.HKEY_CURRENT_USER, key_path)
#         subkey = reg.CreateKey(key, subkey_name)
#         print(f"[INFO] 成功创建了新的注册表项: {key_path}\\{subkey_name}")
#         return subkey
#     except OSError as e:
#         print(f"[ERROR] 无法创建注册表项: {e}")
#         return None

# # 获取 UserChoice 注册表值
# def get_user_choice_values(extension):
#     reg_path = f"Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\{extension}\\UserChoice"
#     try:
#         with reg.OpenKey(reg.HKEY_CURRENT_USER, reg_path) as user_choice_key:
#             prog_id = reg.QueryValueEx(user_choice_key, "ProgId")[0]
#             hash_value = reg.QueryValueEx(user_choice_key, "Hash")[0]
#             print(f"[INFO] 当前 {extension} 的 ProgId: {prog_id}")
#             print(f"[INFO] 当前 {extension} 的 Hash: {hash_value}")
#     except FileNotFoundError:
#         print(f"[ERROR] 注册表项 {reg_path} 不存在。")
#     except Exception as e:
#         print(f"[ERROR] 获取注册表值时发生错误: {e}")

# # 设置文件关联
# def set_default_app(extension, app_path):
#     try:
#         prog_id = f"Applications\\{os.path.basename(app_path)}"
#         # prog_id = "7-Zip"
#         sid = get_user_sid()

#         if not sid:
#             print("[ERROR] 无法获取用户 SID，操作终止。")
#             return
        
#         # 生成 Hash 值
#         hash_value = generate_user_choice_hash(prog_id, sid)

#         # 注册表路径
#         reg_path = f"Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\{extension}"
#         subkey_name = "UserChoice"

#         # 创建或打开注册表项
#         user_choice_key = create_registry_key(reg_path, subkey_name)
#         if user_choice_key:
#             try:
#                 # 设置 ProgId
#                 reg.SetValueEx(user_choice_key, "ProgId", 0, reg.REG_SZ, prog_id)
#                 print(f"[INFO] 成功设置 ProgId 为: {prog_id}")

#                 # 设置 Hash
#                 reg.SetValueEx(user_choice_key, "Hash", 0, reg.REG_SZ, hash_value)
#                 print(f"[INFO] 成功设置 Hash 为: {hash_value}")

#             except Exception as e:
#                 print(f"[ERROR] 无法设置注册表值: {e}")

#             finally:
#                 reg.CloseKey(user_choice_key)
#         else:
#             print(f"[ERROR] 无法创建 UserChoice 注册表项。")
        
#         # 获取并打印 UserChoice 的值
#         get_user_choice_values(extension)

#     except Exception as e:
#         print(f"[ERROR] 设置文件关联时发生错误: {e}")

# # 主函数
# def main():
#     extension = ".zip"
#     app_path = r"C:\Program Files\7-Zip\7zFM.exe"
#     if not os.path.exists(app_path):
#         print(f"[ERROR] 程序路径 {app_path} 不存在，请检查路径是否正确。")
#         return
#     set_default_app(extension, app_path)

# if __name__ == "__main__":
#     main()
