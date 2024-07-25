from subprocess import Popen
from pywinauto import Desktop
from pywinauto.application import Application

# 启动电源选项
Popen('powercfg.cpl', shell=True)
#连接
app = Application("win32").connect(path=r'C:\Windows\explorer.exe')
print(app)
# 通过窗口标题选择，也可以通过类名选择，可以使用第三方工具ViewWizard
dlg = app["电源选项"]

#打印所有的控件
dlg.print_control_identifiers()

dlg_spec = app.window(title='屏电源选项')
dlg_spec.menu_select(r"选择关闭笔记本计算机盖的功能")

# #窗口最大化
# dlg.maximize()

# #窗口最小化
# dlg.minimize()

# #窗口恢复正常大小
# dlg.restore()

# #查找窗口显示的状态,其中最大化是：1 ，正常是0 
# status = dlg.get_show_state()
# print(status)

#获取窗口坐标
# rect = dlg.rectangle()
# print(rect)

# #关闭窗口
# dlg.close()

# ##选择控件
# #方法1，通过类名
# menu = dlg.CabinetWClass     #或者是menu = dlg["CabinetWClass"]
# print(menu.print_control_identifiers())

# #方法2，通过标题
# menu = dlg["电源选项"]
# print(menu.print_control_identifiers())

# # # #方法3 
# file = dlg.child_window(title="平衡", class_name="Button")
# file.draw_outline(colour='red')


