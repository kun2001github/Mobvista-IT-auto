import pyautogui
import subprocess

# 以管理员方式打开7-Zip
subprocess.Popen(['E:\\Program Files\\7-Zip\\7zFM.exe'], creationflags=subprocess.CREATE_NEW_PROCESS_GROUP | subprocess.DETACHED_PROCESS)
pyautogui.sleep(1)

# 按下Alt+T 和 o  
pyautogui.hotkey('alt', 't','o')
pyautogui.sleep(1)


# 截图当前屏幕并保存到当前目录
screenshot = pyautogui.screenshot()
screenshot.save('.\\images\\now_screenshot.png')

#需要点击位置的图片

# left_add_button_image='images\\left_add_button.png' #左边＋
# right_add_button_image='images\\right_add_button.png' #右边＋
# option_cab_button_image='images\\option_cab_button.png' #cab的按钮
# option_iso_button_image= 'images\\option_iso_button.png' #iso的按钮
# confirm_button_image = 'images\\confirm_button.png' #确定

# 定义按钮图像路径列表
button_images = [
    'images\\left_add_button.png',  # 左边＋
    'images\\right_add_button.png',  # 右边＋
    'images\\option_cab_button.png',  # cab的按钮
    'images\\option_iso_button.png',  # iso的按钮
    'images\\confirm_button.png'  # 确定
]

# 循环搜索屏幕上的每个按钮图像
for button_image in button_images:
    try:
        button_location = pyautogui.locateOnScreen(button_image)   #grayscale=False,confidence=0.7  设置可以提高图片是识别率，当然也会有误差，需要安装opencv-python库才能使用
        if button_location is not None:
            # 获取按钮的中心坐标
            center = pyautogui.center(button_location)
            print(f'找到按钮，图像路径为：{button_image}，坐标为：{center}')
            # 模拟鼠标移动到按钮的中心并点击
            pyautogui.moveTo(center)   #鼠标到中间
            pyautogui.click()   #模拟鼠标点击
            pyautogui.sleep(1)
        else:
            print(f'未找到图像路径为：{button_image}的按钮')
    except pyautogui.ImageNotFoundException:
        print(f'无法找到匹配的图像。请检查图像路径：{button_image}的准确性。')
