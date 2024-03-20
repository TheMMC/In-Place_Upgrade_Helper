This is an upgrade helper tool for Windows 10 and 11.

This tool can upgrade Windows via four different methods:

- Changing the product key via `slmgr`. This method only supports [the official upgrade paths][1].

- Starting `Setup.exe` and letting it choose the edition by itself. This is an ordinary in-place upgrade.

- Starting an in-place upgrade of a Windows edition of your choice. This method stops Windows Setup from using any firmware-embedded keys or your current edition. This is done by using an OEM GLVK key as a setup parameter. This method only supports [the official upgrade paths][1].

- Starting a forced in-place upgrade to keep all apps and settings. This method modifies the Windows Registry before using OEM GLVK keys, enabling an edition change outside the supported upgrade path, e.g., "Pro" to "Home," "Education Pro" or "Enterprise," or "Education" to "IoT Enterprise LTSC". Microsoft does not endorse this method. Use this method at your own risk. Please back up your system in advance.

Additional information can be found in `In-Place_Upgrade_Helper_readme.txt`

Copy this tool to your installation media alongside `setup.exe` and run it.
External installation files, like a mounted ISO, are supported, too.

![grafik](https://github.com/TheMMC/Inplace_Upgrade_Helper/assets/87301831/449e87d0-a146-45a2-a7e5-bd23d474f991)

Please note:

- This tool is a work in progress.
- This tool **DOES NOT** activate Windows. Any product keys it uses are placeholder OEM GVLK keys.
- This tool is currently available in native German. English and Chinese are translations. Any help optimizing the translations is welcome. Further documentation and pictures will follow after that.

[1]: https://learn.microsoft.com/en-us/windows/deployment/upgrade/windows-edition-upgrades
