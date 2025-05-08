from pywinauto.application import Application
# 打开应用程序，其中backend选择对应的后端类型，有uia和win32两种
app = Application(backend="uia").start("notepad.exe")
