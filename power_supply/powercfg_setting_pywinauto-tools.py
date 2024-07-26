#encoding: utf-8
from subprocess import Popen
from pywinauto.application import Application
from pywinauto_recorder.player import *
import pyautogui
# 启动电源选项
Popen('powercfg.cpl', shell=True)

pyautogui.sleep(5)
# 获取当前活动窗口的句柄
active_window = pyautogui.getActiveWindow()

# # 最大化窗口
active_window.maximize()
pyautogui.sleep(1)

#开始执行操作
with UIPath(u"电源选项||Window"):
	with UIPath(u"电源选项||Pane->||Pane"):
		click(u"选择关闭笔记本计算机盖的功能||Hyperlink")
with UIPath(u"系统设置||Window"):
	with UIPath(u"系统设置||Pane->||Pane->||Pane->电源选项||Window"):
		click(u"关闭盖子时: (接通电源)||ComboBox")
		click(u"关闭盖子时: (接通电源)||ComboBox->关闭盖子时: (接通电源)||List->不采取任何操作||ListItem")
		click(u"保存修改||Button")
with UIPath(u"电源选项||Window"):
	with UIPath(u"电源选项||Pane->||Pane"):
		click(u"选择关闭笔记本计算机盖的功能||Hyperlink")

pyautogui.alert(text='自动设置“电源选项”的关闭盖子时：不采取任何操作，如果没有设置成功，请手动操作', title='温馨提示', button='知道啦')