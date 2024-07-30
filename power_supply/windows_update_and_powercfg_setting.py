#encoding: utf-8
# from pywinauto.application import Application
# import pyautogui
from subprocess import Popen
from pywinauto_recorder.player import *
import os
import time 
#倒计时函数
# 修改后的倒计时函数，接受一个参数来指定倒计时的秒数
def countdown(seconds):
    for i in range(seconds, -1, -1):
        print(i)
        time.sleep(1)  # 暂停1秒
    print("倒计时结束！")

# 启动系统更新界面
os.system('start ms-settings:windowsupdate')
countdown(5)
#开始执行操作
with UIPath(u"设置||Window"):
	with UIPath(u"设置||Window->||Custom->||Group->||Pane"):
		click(u"更多选项||Group->在最新更新可用后立即获取||Button")
		click(u"检查更新||Button")
print("操作系统更新成功，已开启“在最新更新可用后立即获取”，以及检查更新。请检查，如果失败请手动更新")
countdown(5)

# 启动电源选项
Popen('powercfg.cpl', shell=True)
countdown(5)
# 获取当前活动窗口的句柄
# active_window = pyautogui.getActiveWindow()
# # # 最大化窗口
# active_window.maximize()
# pyautogui.sleep(1)

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

print("操作完成，已设置“关闭盖子时”不采取任何操作，请检查，如果失败请手动设置")
input("请按回车键继续...")

# pyautogui.alert(text='已设置“更新”以及“关闭盖子时不采取任何操作”请检查是否成功，失败则手动点击即可', title='滴滴滴~不出意外的话', button='知道啦')