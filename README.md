This is an upgrade-helper-tool for Win10/11


This tool can upgrade Windows via four different methods:


-simple key-change with slmgr ( see https://learn.microsoft.com/en-us/windows/deployment/upgrade/windows-edition-upgrades for supported upgrade-paths)

-start setup.exe and let it choose the edition by itself. More or less just the normal inplace-upgrade.

-start inplace-upgrade of a Windows-Edition of your choice. This stops Windows-Setup from using any build-in BIOS/UEFI/Firmware-key or using your current edition without asking. This is done by using OEM/-GLVK-keys as setup parameter. Official upgrade-paths still apply: https://learn.microsoft.com/en-us/windows/deployment/upgrade/windows-upgrade-paths

-start a forced inplace-upgrade to keep all apps and settings. This method uses registry modifcations in combination with OEM-GLVK-keys. This allowes shenanigans like Pro to Home, Education Pro or Enterprise, or even something like Win10 Education to Win10 IoT Enterprise LTSC. This is of course unsupported by Microsoft. Create a backup and use at your own risk.




Additional information (in german) can be found in Inplace_Upgrade_Helper_readme.txt

Simply copy this tool to your installation-media alongside setup.exe and run it.
![grafik](https://github.com/TheMMC/Inplace_Upgrade_Helper/assets/87301831/449e87d0-a146-45a2-a7e5-bd23d474f991)

This is work in progress. This tool does NOT activate Windows, all keys are publically available OEM-GLVK-keys.
This tool is german only at this point.
Translation is ongoing. A Github-description with pictures and more information will follow after that.

