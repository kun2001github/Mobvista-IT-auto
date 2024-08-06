import pyautogui
import subprocess

# 以管理员方式打开Adobe设置默认PDF方式
print("打开7-zip")
subprocess.Popen(['C:\Program Files\Adobe\Acrobat DC\Acrobat\ShowAppPickerForPDF.exe'], creationflags=subprocess.CREATE_NEW_PROCESS_GROUP | subprocess.DETACHED_PROCESS)
pyautogui.sleep(1)

#按下TAB键
print("按下TAB键")
pyautogui.press('tab')
pyautogui.sleep(0.5)

#按下键，按4次
print("按下方向键下，3次")
pyautogui.press('down')
pyautogui.sleep(0.5)
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

print("任务操作完成")
input("请按任意键继续")