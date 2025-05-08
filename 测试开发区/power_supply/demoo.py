from pywinauto_recorder.player import *


with UIPath(u"控制面板\\所有控制面板项\\电源选项||Window"):
	with UIPath(u"控制面板\\所有控制面板项\\电源选项||Pane->||Pane"):
		click(u"选择电源按钮的功能||Hyperlink")

with UIPath(u"控制面板\\所有控制面板项\\电源选项\\系统设置||Window"):
	with UIPath(u"控制面板\\所有控制面板项\\电源选项\\系统设置||Pane->||Pane->||Pane"):
		click(u"电源选项||Window")
		click(u"电源选项||Window->关闭盖子时: (接通电源)||ComboBox->关闭盖子时: (接通电源)||List->不采取任何操作||ListItem")
		click(u"电源选项||Window")

with UIPath(u"控制面板\\所有控制面板项\\电源选项||Window"):
	with UIPath(u"控制面板\\所有控制面板项\\电源选项||Pane->||Pane"):
		click(u"选择关闭笔记本计算机盖的功能||Hyperlink")