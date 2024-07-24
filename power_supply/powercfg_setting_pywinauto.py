from subprocess import Popen
from pywinauto import Desktop
from pywinauto.application import Application

# 启动电源选项
Popen('powercfg.cpl', shell=True)
app = Application("win32").connect(handle=1444256)
print(app)

