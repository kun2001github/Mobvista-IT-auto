import win32com.client

def check_windows_update():
    update_session = win32com.client.Dispatch("Microsoft.Update.Session")
    update_searcher = update_session.CreateUpdateSearcher()
    
    try:
        # 搜索更新
        search_result = update_searcher.Search("IsInstalled=0")
        print(f"找到 {search_result.Updates.Count} 个更新。")
        
        # 遍历所有更新
        for update in search_result.Updates:
            print(f"ID: {update.Identity.UpdateID}")
            print(f"标题: {update.Title}")
            print(f"描述: {update.Description}")
            print(f"重要性: {update.MsrcSeverity}")
            print("-" * 80)
            
    except Exception as e:
        print(f"错误: {e}")

# 调用函数
check_windows_update()


import win32com.client

def enable_automatic_updates():
    try:
        # 创建Windows Update自动化对象
        wu_settings = win32com.client.Dispatch("Microsoft.Update.AutoUpdate")
        
        # 设置为自动下载并安装更新
        wu_settings.Settings.NotificationLevel = 4  # 4代表自动下载并安装更新
        wu_settings.Settings.Save()
        
        print("自动下载并安装更新已启用。")
        
    except Exception as e:
        print(f"错误: {e}")

# 调用函数
enable_automatic_updates()
