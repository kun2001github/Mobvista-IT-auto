import os
import sys
import ctypes
import winreg as reg
import subprocess

def is_admin():
    """
    检查当前是否以管理员权限运行。
    """
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

def run_as_admin():
    """
    如果当前未以管理员权限运行，重新以管理员权限运行该脚本。
    """
    if not is_admin():
        print("[INFO] 正在请求管理员权限...")
        # 获取当前 Python 解释器的路径
        executable = sys.executable
        params = " ".join([f'"{arg}"' for arg in sys.argv])
        # 调用 ShellExecuteW 以管理员身份运行
        ctypes.windll.shell32.ShellExecuteW(None, "runas", executable, params, None, 1)
        sys.exit()

def set_default_app(extension, app_path):
    """
    修改指定扩展名的默认打开程序。
    
    参数:
        extension (str): 要修改的文件扩展名 (例如 ".txt")。
        app_path (str): 要关联的程序的完整路径 (例如 "C:\\Program Files\\Notepad++\\notepad++.exe")。
    """
    try:
        # 构建注册表键路径
        ext_key = f"Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\{extension}\\UserChoice"
        key = reg.CreateKey(reg.HKEY_CURRENT_USER, ext_key)
        
        # 设置 ProgId，Windows 使用这个来识别默认程序
        prog_id = f"Applications\\{os.path.basename(app_path)}"
        
        # 写入 ProgId 到注册表
        reg.SetValueEx(key, "ProgId", 0, reg.REG_SZ, prog_id)

        # 删除可能存在的 Hash 值
        try:
            reg.DeleteValue(key, "Hash")
        except FileNotFoundError:
            pass
        
        print(f"[INFO] 已成功将 {extension} 关联到 {app_path}")
    
    except Exception as e:
        print(f"[ERROR] 设置文件关联时发生错误: {e}")
    
    finally:
        reg.CloseKey(key)

def restart_explorer():
    """
    重启 Windows 资源管理器以应用更改。
    """
    print("[INFO] 正在重启资源管理器以应用更改...")
    subprocess.run("taskkill /f /im explorer.exe", shell=True)
    ctypes.windll.shell32.ShellExecuteW(None, "open", "explorer.exe", None, None, 1)

def main():
    # 确保 UAC 提升
    run_as_admin()
    
    # 用户输入要修改的文件扩展名和关联程序路径
    extension = input("请输入要修改的文件扩展名 (例如 .txt): ").strip()
    app_path = input("请输入要关联的程序路径 (例如 C:\\Program Files\\Notepad++\\notepad++.exe): ").strip()
    
    # 检查文件路径是否存在
    if not os.path.exists(app_path):
        print(f"[ERROR] 程序路径 {app_path} 不存在，请检查路径是否正确。")
        return
    
    # 设置默认应用程序
    set_default_app(extension, app_path)
    
    # 重启资源管理器
    restart_explorer()
    input("按 Enter 键退出...")

if __name__ == "__main__":
    main()
