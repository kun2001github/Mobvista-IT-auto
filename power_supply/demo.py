from subprocess import Popen
from pywinauto import Desktop, mouse
from pywinauto.application import Application

# 启动电源选项
Popen('powercfg.cpl', shell=True)

# 连接到电源选项对话框
app = Application(backend="win32").connect(path=r'C:\Windows\explorer.exe')
print(app)

# 选择“选择关闭笔记本计算机盖的功能”链接
# dlg = app["电源选项"][""]["选择关闭笔记本计算机盖的功能"]["系统设置"]
app.window()
