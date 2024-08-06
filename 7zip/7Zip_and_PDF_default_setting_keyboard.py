# 测试详细：
# 2024.7.22
# 7-Zip 24.07（x64）
# HP EliteBook 640 14 inch G10 Notebook PC 
# 该版本是使用键盘完成的，相对来说会比使用图片识别好的多 

import pyautogui
import subprocess

# 以管理员方式打开7-Zip
print("--------------打开7-zip--------------")
subprocess.Popen(['C:\\Program Files\\7-Zip\\7zFM.exe'], creationflags=subprocess.CREATE_NEW_PROCESS_GROUP | subprocess.DETACHED_PROCESS)
pyautogui.sleep(3)


# 获取当前活动窗口的句柄
active_window = pyautogui.getActiveWindow()

# # 最大化窗口
# active_window.maximize()

# 按下Alt+T 和 o  
print("按快捷键")
pyautogui.hotkey('alt', 't','o')
pyautogui.sleep(2)

#按下Enter键
print("按下回车键")
pyautogui.press('enter')
pyautogui.sleep(0.5)

#按下TAB键
print("按下TAB键")
pyautogui.press('tab')
pyautogui.sleep(0.5)

#按下 Enter键
print("按下回车键")
pyautogui.press('enter')
pyautogui.sleep(0.5)

#按下TAB键
print("按下TAB键")
pyautogui.press('tab')
pyautogui.sleep(0.5)

#按下键，按4次
print("按下方向键下，4次")
pyautogui.press('down',presses=4)
pyautogui.sleep(0.5
                )
# 按Enter 键
print("按下回车键")
pyautogui.press('enter')
pyautogui.sleep(0.5)

# 按下键，按一次
print("按下方向键下，1次")
pyautogui.press('down')
pyautogui.sleep(0.5
                )
# 按Enter键
print("按下回车键")
pyautogui.press('enter')
pyautogui.sleep(0.5)

#按 TAB键
print("按下TAB键")
pyautogui.press('tab')
pyautogui.sleep(0.5)

# 按Enter键
print("按下回车键")
pyautogui.press('enter')
pyautogui.sleep(0.5)

# 关闭窗口
active_window.close()

print("-------------任务操作完成-----------------")
print("")
print("")
print("--------------开始设置默认的PDF-----------")
# 以管理员方式打开Adobe设置默认PDF方式
print("打开Adobe 设置默认PDF")
subprocess.Popen(['C:\Program Files\Adobe\Acrobat DC\Acrobat\ShowAppPickerForPDF.exe'], creationflags=subprocess.CREATE_NEW_PROCESS_GROUP | subprocess.DETACHED_PROCESS)
pyautogui.sleep(1)

#按下TAB键
print("按下TAB键")
pyautogui.press('tab')
pyautogui.sleep(0.5)

#按下键，按4次
print("按下方向键下，2次")
pyautogui.press('down')
pyautogui.sleep(0.5)
pyautogui.press('down')
pyautogui.sleep(0.5)

#按下 Enter键
print("按下回车键")
pyautogui.press('enter')
pyautogui.sleep(0.5)
pyautogui.press('enter')
pyautogui.sleep(0.5)
print("--------默认的PDF设置完成---------")

input("请按任意键继续")






