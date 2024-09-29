import hashlib
import base64
import os
import time
import winreg as reg
import win32api
import win32security

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
    # 获取系统时间戳，去掉秒和微秒
    timestamp = str(int(time.time()))
    # 拼接字符串
    data = f".{sid}{prog_id}{timestamp}".encode('utf-8')
    # 使用MD5算法生成哈希值
    md5_hash = hashlib.md5(data).digest()
    # 使用自定义算法进行第二次哈希（这里简化为MD5）
    custom_hash = hashlib.md5(md5_hash).digest()
    # 取前8个字节
    final_hash = custom_hash[:8]
    # 转换为Base64
    base64_encoded = base64.b64encode(final_hash).decode('utf-8')
    return base64_encoded

# 创建注册表项
def create_registry_key(key_path, subkey_name):
    try:
        # 打开指定的注册表路径
        with reg.OpenKey(reg.HKEY_CURRENT_USER, key_path, 0, reg.KEY_WRITE) as key:
            # 在路径下创建一个名为 UserChoice 的子键
            subkey = reg.CreateKey(key, subkey_name)
            print(f"[INFO] 成功创建了新的注册表项: {key_path}\\{subkey_name}")
            return subkey
    except OSError as e:
        print(f"[ERROR] 无法创建注册表项: {e}")
        return None

# 设置文件关联
def set_default_app(extension, app_path):
    try:
        prog_id = f"Applications\\{os.path.basename(app_path)}"
        sid = get_user_sid()

        if not sid:
            print("[ERROR] 无法获取用户 SID，操作终止。")
            return
        
        # 生成 Hash 值
        hash_value = generate_user_choice_hash(prog_id, sid)

        # 注册表路径
        reg_path = f"Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\{extension}"
        subkey_name = "UserChoice"

        # 创建或打开注册表项
        user_choice_key = create_registry_key(reg_path, subkey_name)
        if user_choice_key:
            try:
                # 设置 ProgId
                reg.SetValueEx(user_choice_key, "ProgId", 0, reg.REG_SZ, prog_id)
                print(f"[INFO] 成功设置 ProgId 为: {prog_id}")

                # 设置 Hash
                reg.SetValueEx(user_choice_key, "Hash", 0, reg.REG_SZ, hash_value)
                print(f"[INFO] 成功设置 Hash 为: {hash_value}")

            except Exception as e:
                print(f"[ERROR] 无法设置注册表值: {e}")

            reg.CloseKey(user_choice_key)
        else:
            print(f"[ERROR] 无法创建 UserChoice 注册表项。")
    
    except Exception as e:
        print(f"[ERROR] 设置文件关联时发生错误: {e}")

# 主函数
def main():
    extension = ".zip"
    app_path = r"C:\Program Files\7-Zip\7zFM.exe"

    if not os.path.exists(app_path):
        print(f"[ERROR] 程序路径 {app_path} 不存在，请检查路径是否正确。")
        return
    set_default_app(extension, app_path)
    input("按回车键退出...")


if __name__ == "__main__":
    main()
