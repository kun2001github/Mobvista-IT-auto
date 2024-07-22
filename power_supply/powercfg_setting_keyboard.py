import pyautogui
import os

print("打开电源选项")
# 定义要模拟双击的文件路径
file_path = 'C:\\Windows\\System32\\powercfg.cpl'
#使用os打开
os.startfile(file_path)
pyautogui.sleep(2)

# 获取当前活动窗口的句柄
active_window = pyautogui.getActiveWindow()

# 最大化窗口
active_window.maximize()

#按下TAB
print('按下tab')
pyautogui.press('tab')
pyautogui.sleep(0.5)
#按enter
print('按下enter')
pyautogui.press('enter')
pyautogui.sleep(0.5)

#按6个tab
print('按下tab，6次')
pyautogui.press('tab',presses=6)
pyautogui.sleep(0.5)
#按方向键的左键
print('按下方向键左键')
pyautogui.press('left')
pyautogui.sleep(0.5)
#按tab，5次
print('按下tab，5次')
pyautogui.press('tab',presses=5)
pyautogui.sleep(0.5)
#按enter
print('按下enter')
pyautogui.press('enter')

print("任务操作完成")

# 关闭窗口
active_window.close()