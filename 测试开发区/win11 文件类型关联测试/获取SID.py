import win32api
import win32security

def get_current_user_sid():
    # 获取当前用户名
    username = win32api.GetUserName()
    # 获取计算机名称
    domain = win32api.GetComputerName()
    # 查找用户的SID
    sid = win32security.LookupAccountName(domain, username)[0]
    # 将SID转换为字符串形式
    sid_str = win32security.ConvertSidToStringSid(sid)
    return sid_str

# 调用函数并打印当前用户的SID
current_user_sid = get_current_user_sid()
print("当前用户的SID是:", current_user_sid)