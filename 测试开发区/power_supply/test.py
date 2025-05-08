import win32com.client

def disable_lid_shutdown():
    # 初始化WMI服务
    wmi_service = win32com.client.GetObject("winmgmts:\\\\.\\root\\cimv2")

    # 查询电源管理设置
    power_settings = wmi_service.ExecQuery("SELECT * FROM Win32_PowerSettingDataIndex WHERE InstanceID = 'ACPI\\PNP0C0A\\0'")

    # 遍历查询结果并修改设置
    for setting in power_settings:
        setting.LidShutdown = False
        setting.Put_()

# 关闭笔记本电脑盖子关闭功能
disable_lid_shutdown()
