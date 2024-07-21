import win32com.client

def auto_update_and_install():
    try:
        # 创建Windows Update会话和搜索器
        update_session = win32com.client.Dispatch("Microsoft.Update.Session")
        update_searcher = update_session.CreateUpdateSearcher()
        
        # 搜索更新
        search_result = update_searcher.Search("IsInstalled=0")
        print(f"找到 {search_result.Updates.Count} 个更新。")
        
        if search_result.Updates.Count > 0:
            # 创建下载和安装对象
            downloader = update_session.CreateUpdateDownloader()
            installer = update_session.CreateUpdateInstaller()
            
            # 设置更新集合
            updates_to_download = win32com.client.Dispatch("Microsoft.Update.UpdateColl")
            for update in search_result.Updates:
                updates_to_download.Add(update)
            
            # 下载更新
            print("开始下载更新...")
            downloader.Updates = updates_to_download
            download_result = downloader.Download()
            print(f"下载完成，结果: {download_result.ResultCode}")
            
            # 安装更新
            if download_result.ResultCode == 2:  # 2表示下载成功
                print("开始安装更新...")
                installer.Updates = updates_to_download
                install_result = installer.Install()
                print(f"安装完成，结果: {install_result.ResultCode}")
            else:
                print("下载失败，无法安装更新。")
        
        else:
            print("没有找到需要安装的更新。")
        
    except Exception as e:
        print(f"错误: {e}")

# 调用函数
auto_update_and_install()
