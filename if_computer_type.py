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

# 根据制造商名称判断品牌
if "HUAWEI" in manufacturer.upper():
    print("电脑品牌是华为")
elif "HP" in manufacturer.upper():
    print("电脑品牌是惠普")
elif "LENOVO" in manufacturer.upper():
    print("电脑品牌是联想")
else:
    print("无法识别的电脑品牌")
