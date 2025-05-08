# 有bug，惠普电脑可以，华为，联想，不行
import pyautogui
import os
import subprocess

def get_system_manufacturer():
    # 使用wmic命令获取系统制造商信息
    command = "wmic csproduct get vendor"
    result = subprocess.check_output(command, shell=True)
    # 解码结果并获取制造商名称
    manufacturer = result.decode("utf-8").split("\n")[1].strip()
    return manufacturer

# 获取系统制造商信息
manufacturer = get_system_manufacturer()
print(f"电脑品牌: {manufacturer}")

print("打开电源选项")
# 定义要模拟双击的文件路径
file_path = 'C:\\Windows\\System32\\powercfg.cpl'
#使用os打开
os.startfile(file_path)
pyautogui.sleep(3)

# 根据制造商名称判断品牌
if "HUAWEI" in manufacturer.upper():
    print("电脑品牌是华为") #华为MateBook B3-420 的电源选项都是一样的
    #按下TAB
    print('按下tab')
    pyautogui.press('tab')
    pyautogui.sleep(0.5)

    #按enter
    print('按下enter')
    pyautogui.press('enter')
    pyautogui.sleep(0.5)
    
    #按4个tab
    print('按下tab，4次')
    pyautogui.press('tab',presses=4)
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

elif "HP" in manufacturer.upper():
    print("电脑品牌是惠普")
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
    
elif "LENOVO" in manufacturer.upper():
    print("电脑品牌是联想")
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
else:
    print("无法识别的电脑品牌，按照常规的")

# 获取当前活动窗口的句柄
active_window = pyautogui.getActiveWindow()

# # 最大化窗口
# active_window.maximize()

# 关闭窗口
active_window.close()