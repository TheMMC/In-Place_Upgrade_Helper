# In-Place_Upgrade_Helper
Windows 10/11 中的辅助工具，用于原地升级和版本更改

当Windows安装程序自行决定应该做什么时，你感到困扰吗？
你想安装专业版，但因为密钥存储在固件中设安装程序动跳转到家庭版，？
你想从专业版升级到专业工作站版，但没有GLVK密钥？
你安装了专业版，但后来才意识到你只有家庭版的许可证，但又懒得重新安装？
你想直接从家庭版升级到企业版，因为从技术上讲与升级到专业版没有任何区别，但安装程序纯粹出于许可证的原因不允许？
你注意到企业版实际上并不在你的消费者ISO / 媒体创建工具USB驱动器上？
你想从专业教育版回到专业版，但没有升级或降级路径？
你已经通过定制的EI.cfg搞定了新的安装，但现场升级没有给你选择版本的选项？
你想要构建一个（几乎）全能的安装介质，而无需对WIM进行任何调整或修改？

这个工具可以帮助你。
要了解它的确切工作原理，只需查看批处理文件。这不是一个激活工具，只使用官方的预安装密钥。
只需将此批处理复制到安装介质中的setup.exe中并启动它。

如果安装介质上没有相应的版本，设置能够动态生成适当的映像。
最可能的是这是DISM /Get-TargetEditions和DISM /Set-Edition使用的相同功能（https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/change-the-windows-image-to-a-higher-edition-using-dism?view=windows-11）。
这就是例如https://uupdump.net/可以从两个家庭版和专业版生成所有其他版本的方法（create_virtual_editions.cmd，https://github.com/abbodi1406/BatUtil/tree/master/uup-converter-wimlib）
这已经通过只有家庭版可用的WIM进行了测试，但是设置是以专业版密钥启动的。如预期的那样，这里仍然启动了家庭版设置。
然后将专业版添加到WIM中，但没有其他更改。然后再次使用专业版密钥启动设置，现在出现了正确的专业版设置。
Windows安装程序被中止，现在使用了专业工作站版密钥重新启动。设置现在自动从专业版生成专业工作站版。
下一个测试是使用消费者ISO（de-de_windows_11_consumer_editions...iso）安装企业版，实际上根本没有企业版。如果将适当的密钥作为参数，设置也会从专业版生成这些。
所有测试都在联网环境下进行。

这结果请见以下表格：

额外版本所需版本：
Windows Home Single Language Windows Home
Windows Pro for Workstations Windows Pro
Windows Pro Education Windows Pro
Windows Education Windows Pro
Windows Enterprise Windows Pro
Windows Enterprise multi-session / Virtual Desktops Windows Pro
Windows IoT Enterprise Windows Pro
Windows SE [Cloud] Windows Pro
Windows Pro N for Workstations Windows Pro N
Windows Pro Education N Windows Pro N
Windows Education N Windows Pro N
Windows Enterprise N Windows Pro N
Windows SE [Cloud] N Windows Pro N

(仅在单独的安装介质上可用：
Windows 10 IoT Enterprise LTSC 2021 Windows 10 Enterprise LTSC 2021)

相反，这也意味着你的ISO只需要包含Home、Home N、Pro和Pro N才能安装所有可用版本（不包括LTSC）。
一个完全正常的消费者安装介质已经满足了这些要求。
换句话说：一个标准的ISO或标准的USB驱动器（https://www.microsoft.com/de-de/software-download/windows11）通过这个批处理变成了一个全能的安装程序。
目前，该工具仅支持普通版本，不支持K版/中国版。
所有安装测试都是使用de-de_windows_11_consumer_editions_version_23h2_updated_feb_2024_x64_dvd_9665512b.iso和MediaCreationTool Win11_23H2 USB驱动器作为基础进行的。

危险：
LTSC版本不包含在普通的安装介质中。要使用此功能，您必须自己组织适当的ISO。
当然，这也适用于Server 2022。
Windows 10 Enterprise LTSC 2021（和IoT/N）已使用de-de_windows_10_enterprise_ltsc_2021_x64_dvd_71796d33.iso进行了测试。
有趣的事实是：微软只提供英文版的IoT，您应该使用语言包或者使用密钥将一个完全安装的非英文非IoT LTSC升级为IoT。
如果您使用此工具和/或调整安装介质使用abbodi1406的create_virtual_editions.cmd，您仍然会得到一个基于官方MS源文件的德语IoT企业版LTSC。
LTSC 2024的预安装密钥已经可用（CGK42-GYN6Y-VD22B-BX98W-J8JXD），但版本目前只是一个泄漏的技术预览评估。在与最终版测试后，该密钥将被添加到此工具中。
Server 2025目前尚未最终确定，但密钥已经存在（标准DPNXD-67YY9-WWFJJ-RYH99-RM832，数据中心CNFDQ-2BW8H-9V4WM-TKCPD-MD2QF）。