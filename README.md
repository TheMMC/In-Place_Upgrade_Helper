This is an upgrade-helper-tool for Win10/11
This tool can upgrade Windows via three different methods:
-simple key-change with slmgr ( see https://learn.microsoft.com/en-us/windows/deployment/upgrade/windows-edition-upgrades for supported upgrade-paths)
-start inplace-upgrade of a Windows-Edition of your choice. This stops Windows-Setup from using any build-in BIOS/UEFI/Firmware-key. This is done by using OEM/-GLVK-keys as setup parameter. Official upgrade-paths still apply: https://learn.microsoft.com/en-us/windows/deployment/upgrade/windows-upgrade-paths
-start a forced inplace-upgrade to keep all apps and settings. This method uses registry modifcations in combination with OEM-GLVK-keys. This allowes shenanigans like Pro to Home, Education Pro or Enterprise, or even something like Win10 Education to Win10 IoT Enterprise LTSC. This is of course unsupported by Microsoft. Create a backup and use a your own risk.
Additional information (in german) can be found in Inplace_Upgrade_Helper_readme.txt

Simply copy this tool to your installation-media alongside setup.exe and run it.

This is work in progress.
This tool is german only at this point.
Translation is ongoing. A Github-describtion with pictures and more information will follow after that.
