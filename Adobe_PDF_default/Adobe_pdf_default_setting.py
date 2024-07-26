import pyautogui
import subprocess
#以管理员打开Adobe Acrobat Reder
print("打开Adobe Acrobat Reder")
subprocess.Popen(['C:\\Program Files\\Adobe\Acrobat DC\\Acrobat\\Acrobat.exe'], creationflags=subprocess.CREATE_NEW_PROCESS_GROUP | subprocess.DETACHED_PROCESS)
pyautogui.sleep(5)

#同意软件许可协议
#按下TAB，按回车   等待5秒 会有弹窗设置Acrobat Reder为默认PDF ，按2次tab，回车即可设置，然后在按一次回车

# 获取当前活动窗口的句柄
active_window = pyautogui.getActiveWindow()


#按下TAB键
print("按下TAB键")
pyautogui.press('tab')
pyautogui.sleep(0.5)


#按下Enter键
print("按下回车键")
pyautogui.press('enter')
pyautogui.sleep(0.5)


pyautogui.sleep(6)

#按下TAB键
print("按下TAB键")
pyautogui.press('tab')
pyautogui.sleep(1)      

pyautogui.press('tab')
pyautogui.sleep(1)

#按下方向键下，2次，
pyautogui.press('down',presse=2)
pyautogui.sleep(1)


#按下Enter键
print("按下回车键")
pyautogui.press('enter',presses=2)
pyautogui.sleep(0.5)


print("任务操作完成")


# pyautogui.sleep(5)


# # 关闭窗口
# active_window.close()