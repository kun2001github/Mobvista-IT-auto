import winreg as reg
import os
import sys
import ctypes

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

run_as_admin()

def associate_file_extension(ext, app_path, description):
    try:
        # 创建文件类型关联，如 .txt -> MyApp
        reg_key = reg.CreateKey(reg.HKEY_CLASSES_ROOT, ext)
        reg.SetValue(reg_key, '', reg.REG_SZ, 'MyApp.File')
        reg.CloseKey(reg_key)

        # 在注册表中创建文件描述信息
        reg_key = reg.CreateKey(reg.HKEY_CLASSES_ROOT, 'MyApp.File')
        reg.SetValue(reg_key, '', reg.REG_SZ, description)
        reg.CloseKey(reg_key)

        # 设置程序路径
        reg_key = reg.CreateKey(reg.HKEY_CLASSES_ROOT, r'MyApp.File\shell\open\command')
        reg.SetValue(reg_key, '', reg.REG_SZ, f'"{app_path}" "%1"')
        reg.CloseKey(reg_key)

        # 通知系统更新文件关联
        os.system('assoc ' + ext + '=MyApp.File')
        os.system('ftype MyApp.File=' + f'"{app_path}" "%1"')
        os.system('SHChangeNotify 0x08000000 0x0000')

        print(f"已将 {ext} 文件关联到 {app_path}，描述为 {description}")
    except Exception as e:
        print(f"文件关联失败: {e}")



# 示例：将 .txt 文件与自定义程序关联
associate_file_extension('.txt', r'C:\Path\To\YourApp.exe', 'My Custom App for Text Files')
input("按 Enter 键退出...")