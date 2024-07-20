import pyautogui
import time
import subprocess

# 以管理员方式打开7-Zip
subprocess.Popen(['C:\\Program Files\\7-Zip\\7zFM.exe'], creationflags=subprocess.CREATE_NEW_PROCESS_GROUP | subprocess.DETACHED_PROCESS)

# 等待7-Zip窗口出现
time.sleep(1)

# 按下Alt+T
pyautogui.hotkey('alt', 'T')
time.sleep(1)

# 按下Alt+O
pyautogui.hotkey('O')

time.sleep(1)
# 截图当前屏幕并保存到当前目录
screenshot = pyautogui.screenshot()
screenshot.save('demo.png')

# “确定”按钮的图像文件名
button_image = '确定.png'
jia1_image='jia1.png'
jia2_image='jia2.png'

# 在屏幕上搜索“确定”按钮的图像
try:
    button_location = pyautogui.locateOnScreen(jia1_image)
    if button_location is not None:
        # 获取“+1”按钮的中心坐标
        center = pyautogui.center(button_location)
        print(f'找到“jia1”按钮，坐标为：{center}')
        # 模拟鼠标移动到“确定”按钮的中心并点击
        pyautogui.moveTo(center)
        pyautogui.click()
    else:
        print('未找到“jia1”按钮')
except pyautogui.ImageNotFoundException:
    print('无法找到匹配的图像。请检查屏幕截图的准确性。')

# 在屏幕上搜索“确定”按钮的图像
try:
    button_location = pyautogui.locateOnScreen(jia2_image)
    if button_location is not None:
        # 获取“+2”按钮的中心坐标
        center = pyautogui.center(button_location)
        print(f'找到“jia2”按钮，坐标为：{center}')
        # 模拟鼠标移动到“确定”按钮的中心并点击
        pyautogui.moveTo(center)
        pyautogui.click()
    else:
        print('未找到“jia2”按钮')
except pyautogui.ImageNotFoundException:
    print('无法找到匹配的图像。请检查屏幕截图的准确性。')





# 在屏幕上搜索“确定”按钮的图像
try:
    button_location = pyautogui.locateOnScreen(button_image)
    if button_location is not None:
        # 获取“确定”按钮的中心坐标
        center = pyautogui.center(button_location)
        print(f'找到“确定”按钮，坐标为：{center}')
        # 模拟鼠标移动到“确定”按钮的中心并点击
        pyautogui.moveTo(center)
        pyautogui.click()
    else:
        print('未找到“确定”按钮')
except pyautogui.ImageNotFoundException:
    print('无法找到匹配的图像。请检查屏幕截图的准确性。')
