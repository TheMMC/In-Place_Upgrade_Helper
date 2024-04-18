# In-Place_Upgrade_Helper
Helper tool for Windows 10/11 in-place upgrades and edition changes

Does it bother you when the Windows setup itself decides what it should do?
You want to install Pro, but the setup automatically jumps to Home because the key is stored in the firmware?
You wanted to upgrade from Pro to Pro for Workstations but don't have a GLVK key to hand?
Have you installed Pro but only realize afterwards that you only have a license for Home but are too lazy to do a clean install?
You want to upgrade Home directly to Enterprise because it's technically no different than an upgrade to Pro, but the setup doesn't allow it purely for licensing reasons?
Do you notice that the Enterprise Edition isn't actually on your consumer ISO / on your MediaCreationTool USB stick?
You want to go back to Pro from Pro Education, but there is no upgrade or downgrade path? https://learn.microsoft.com/en-us/windows/deployment/upgrade/windows-edition-upgrades
You have new installations under control with customized EI.cfg but (in-place) upgrades don't give you an edition selection?
You wanted to build an (almost) all-in-one installation medium without any tinkering or modifications to the WIM?

This tool helps.
To find out exactly how it works, just take a look at the batch. This is not an activation tool, only official pre-installation keys are used.
Simply copy this batch to the setup.exe in the installation medium. Or start it by itself and enter the path of your installation files.

If the appropriate version is not available on the installation medium, the setup is able to generate the appropriate image on the fly.
Most likely this is the same function that DISM /Get-TargetEditions and DISM /Set-Edition use (https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/change-the-windows-image -to-a-higher-edition-using-dism?view=windows-11).
This is the method with which, for example, https://uupdump.net/ can generate all other editions from the two Home and Pro editions (create_virtual_editions.cmd, https://github.com/abbodi1406/BatUtil/tree/master/uup -converter-wimlib)
This was tested with a WIM where only Home was available but setup was started with Pro-Key. As expected, the home setup still started here.
Then the Pro was added to the WIM, but nothing more. Setup was then started again with the Pro key and the correct Pro setup now appears.
The setup was aborted and now started with a Pro for Workstations key. The setup now automatically generated Pro for Workstations from the Pro.
The next test was to install Enterprise with a consumer ISO (de-de_windows_11_consumer_editions...iso), which actually doesn't have Enterprise at all. The setup also generated these from the Pro if you take the appropriate key as a parameter.
All tests were carried out online.

This results in the following upgrade chart:

Available edition for installation            required edition on installation medium

Windows Pro                                   Windows Pro
Windows Pro for Workstations                  Windows Pro
Windows Education                             Windows Pro
Windows Pro Education                         Windows Pro
Windows Enterprise                            Windows Pro
Windows Enterprise multi-session              Windows Pro
Windows IoT Enterprise                        Windows Pro
Windows SE [Cloud] (Win11 only)               Windows Pro
Windows Home                                  Windows Home
Windows Home Single Language                  Windows Home
Windows Pro N                                 Windows Pro N
Windows Pro N for Workstations                Windows Pro N
Windows Education N                           Windows Pro N
Windows Pro Education N                       Windows Pro N
Windows Enterprise N                          Windows Pro N
Windows SE [Cloud] N (Win11 only)             Windows Pro N
Windows 10 Enterprise LTSC 2021               Windows 10 Enterprise LTSC 2021
Windows 10 Enterprise N LTSC 2021             Windows 10 Enterprise LTSC N 2021
Windows 10 IoT Enterprise LTSC 2021           Windows 10 Enterprise LTSC 2021
Windows 11 Enterprise LTSC 2024               Windows 11 Enterprise LTSC 2024
Windows 11 Enterprise N LTSC 2024             Windows 11 Enterprise N LTSC 2024
Windows 11 IoT Enterprise LTSC 2024           Windows 11 Enterprise LTSC 2024
Windows 11 IoT Enterprise LTSC Subscr. 2024   Windows 11 Enterprise LTSC 2024
Windows Server 2022 Standard                  Windows Server 2022 Standard
Windows Server 2022 Datacenter                Windows Server 2022 Datacenter
Windows Server 2025 Standard                  Windows Server 2025 Standard
Windows Server 2025 Datacenter                Windows Server 2025 Datacenter


This also means that your ISO only needs to contain Home, Home N, Pro and Pro N in order to be able to install all available editions (without LTSC).
A completely normal consumer installation medium already meets these requirements.
In other words: A standard ISO or a standard USB stick (https://www.microsoft.com/de-de/software-download/windows11) becomes an all-in-one installer with this batch.
At the moment the tool does not support the Home China edition.
All installation tests were done with de-de_windows_11_consumer_editions_version_23h2_updated_feb_2024_x64_dvd_9665512b.iso and an USB Stick created with MediaCreationTool Win11_23H2 as a base.

DANGER:
LTSC editions are NOT included in the normal installation media. To use this editions you have to get the appropriate ISO yourself.
The same of course also applies to Server 2022/2025.
Windows 10 Enterprise LTSC 2021 (and IoT/N) were tested with de-de_windows_10_enterprise_ltsc_2021_x64_dvd_71796d33.iso.

BONUS:
The folder "[optional_install_media_mods]" contains a script to deactivate any installation requirements like TPM or secure boot.
Additional info for EI.CFG: While doing a clean install only the actually existing editions on the installation medium are shown, not the edition that can be generated. Generating addition edtions is only possible with an in-place-upgrade.

ONLY sources\$OEM$\$$\Panther\unattend.xml IS SUPPORTED!
autounattend.xml in root folder or similar breaks In-Place_Upgrade_Helper.bat!


Changelog:
V0.93
Fixed 21 (LTSC 2024), 21 and 23 were identical by mistake.

v0.92
Did some tests with unattend.xml and autounattend.xml. Anything besides sources\$OEM$\$$\Panther\ breaks this tool, and that gave me some problems with some TPM-requirement workarounds...
So I wrote a small extra script to modify the Windows installation files. Obviously this only works with extracted ISOs and USB-sticks, not mounted ISOs.

v0.91
Small changes to the main menu.

v0.90
Added LTSC 2024 and Server 2025. Optimized the visual design (I hope, I'm bad at that).
Removed chinese translation, I can't support what I can't understand...

v0.80 re-upload
Github automatically changed the line endings from CRLF to LF without notification. That's the default setting for new repos. Too bad that Windows batches come in CRLF AND MIGHT BREAK IF YOU CONVERT THEM TO LF.
Modified the attributes for the repository and re-uploaded the files with correct line endings.
Huge thanks to Fox2k11 for reporting that. I hate Github.

v0.80
Added a welcome screen with all available editions. After that editions available on the provided installation medium are displayed.

V0.72
Window size is now set at start. On some systems half of the text was missing at start.
Main menu was made a little more legible.

V0.71
Now with Server 2022

V0.70
Thanks to LicenseFass78851 for the code snippet to read the currently running Windows edition and the somewhat safer method of getting admin rights.
Tekkie Boy from the Deskmodder forum has reported another bug that affects the registry entry CompositionEditionID. The forced upgrade now also sets this entry.

V0.60
Reading readme seems to be out, many people don't copy this tool into an installation medium but start it individually and are then surprised by errors.
Now the presence of setup.exe and the sources folder is checked. If anything is missing, you can now also specify external paths as the installation source (e.g. a mounted ISO).
Changed "Inplace" to "In-Place". Microsoft itself speaks of "In-Place", "Inplace" doesn't make any sense in English either.

V0.50
skycommand was kind enough to correct my gutter English and build a proper readme.md, thank you very much for that!
Forced upgrade is now no longer a switch but a separate menu item.
Some things have been reformatted, the menu now looks a bit clearer.
If there are no errors, this version will be the template for the English translation.

V0.41
Formatting fixed, the readme now looks neat on GitHub and in the Windows editor.
Added some comments to the batch.

V0.40
LTSC 2021 added.

V0.30
Added N editions.

V0.21
Added keychange function.

V0.20
Added remaining non-N editions.

V0.11 Beta
Tests were carried out with a USB stick created by MediaCreationTool_Win11_23H2.exe, instead of install.wim install.swm/install2.swm is used there. Works easily here too.
Made some text changes.

V0.10 Beta
A lot has been reformulated, information about different editions has been added. Tests completed, batch adjusted to results.

V0.01 Alpha
First release. Support for Home/Pro/Pro for Workstations/Enterprise to test everything first.
