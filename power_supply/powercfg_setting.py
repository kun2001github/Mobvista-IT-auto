import pyautogui
import os
import subprocess


# 以管理员方式打开
# subprocess.run(['control', 'powercfg.cpl'], check=True)


# 定义要模拟双击的文件路径
file_path = 'C:\\Windows\\System32\\powercfg.cpl'
#使用os打开
os.startfile(file_path)
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
    'images\\select_out.png',
    'images\\close.png',
    'images\\save.png'
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
            #使用if判断，等于的时时候在执行这个差异化的操作
            if button_image == "images\\close.png":
                x,y= center  #把中间值，提取出现
                x= x+150   #在中间值的x轴增加
                pyautogui.moveTo(x,y,4)  #现对于当前位置移动，向x轴的右边移动
                pyautogui.click()   #模拟鼠标点击
                pyautogui.sleep(1)
                y=y+18
                pyautogui.moveTo(x,y,4)
            else:
                exit
            pyautogui.click()   #模拟鼠标点击
            pyautogui.sleep(1)
        else:
            print(f'未找到图像路径为：{button_image}的按钮')
    except pyautogui.ImageNotFoundException:
        print(f'无法找到匹配的图像。请检查图像路径：{button_image}的准确性。')

# # 定位关闭盖子时的位置以及点击不采取任何操作
# close_images = 'images\\close.png'
# try:
#         close_button_location = pyautogui.locateOnScreen(close_images)   #grayscale=False,confidence=0.7  设置可以提高图片是识别率，当然也会有误差，需要安装opencv-python库才能使用
#         if close_button_location is not None:
#             # 获取按钮的中心坐标
#             center = pyautogui.center(close_button_location)
#             print(f'找到按钮，图像路径为：{close_images}，坐标为：{center}')
#             # 模拟鼠标移动到按钮的中心并点击
#             pyautogui.moveTo(center)   #鼠标到中间
#             x,y= center  #把中间值，提取出现
#             x= x+150   #在中间值的x轴增加
#             pyautogui.moveTo(x,y,4)  #现对于当前位置移动，向x轴的右边移动
#             pyautogui.click()   #模拟鼠标点击
#             pyautogui.sleep(1)
#             y=y+18
#             pyautogui.moveTo(x,y,4)
#             pyautogui.click()
#         else:
#             print(f'未找到图像路径为：{close_images}的按钮')
# except pyautogui.ImageNotFoundException:
#         print(f'无法找到匹配的图像。请检查图像路径：{close_images}的准确性。')