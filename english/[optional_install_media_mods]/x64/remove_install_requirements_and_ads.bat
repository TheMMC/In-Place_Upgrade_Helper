@echo off

Rem Get admin rights
>nul 2>&1 fsutil dirty query %systemdrive% && (goto gotAdmin) || (goto UACPrompt)
:UACPrompt
if exist "%SYSTEMROOT%\System32\Cscript.exe" (
    echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "%~s0", "", "", "runas", 1 > "%temp%\getadmin.vbs"
    cscript //nologo "%temp%\getadmin.vbs"
    exit /b
) else (
    powershell -Command "Start-Process -Verb RunAs -FilePath '%~s0'"
    exit /b
)
:gotAdmin
if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs"
pushd "%CD%" && CD /D "%~dp0"

if not defined iammaximized (
    set iammaximized=1
    start /max "" "%0" "%*"
    exit
)

cls
Echo If this windows is not maximized please change the size manually.
echo This is a know bug in Windows Terminal.
echo.
echo.
SETLOCAL
:premainmenu
echo This script does the following:
echo -copy EI.CFG to force the setup to let you choose your edition for a clean installation, even if a license is found in the firmware
echo -remove installation requirements such as TPM or secure boot by adding the appropriate registry keys to boot.wim
echo -remove MS-account requirements, even for Windows Home. Just disconnect internet during setup.
echo -copy a souped up unattend.xml to sources\$OEM$\$$\Panther that does the following after the first boot:
echo    -remove installation requirements such as TPM or secure boot by adding the appropriate registry keys to Windows
echo    -disable ads, suggestions, recommendations and auto-installation of apps (Spotify, Candy Crush, MS Teams etc.) for new users
echo                                                                           (in case of a clean install this applies to all users)
echo.
echo Everything is done with official registry keys, no hacks that might mess up future updates.
echo.
echo ONLY sources\$OEM$\$$\Panther\unattend.xml IS SUPPORTED!
echo autounattend.xml in root folder or similar breaks In-Place_Upgrade_Helper.bat!
echo.

set "sourcespath="
set /p sourcespath=Please enter the path to the WRITABLE installation medium (e.g. F:\ or D:\unpackedISO\): 

if not exist "%sourcespath%"\setup.exe goto premainmenu
if not exist "%sourcespath%"\sources\ goto premainmenu

md "%temp%\mounttemp"
dism /mount-wim /wimfile:"%sourcespath%\sources\boot.wim" /index:1 /mountdir:"%temp%\mounttemp"
reg load HKLM\offline "%temp%\mounttemp\windows\system32\config\system"
reg add HKLM\offline\Setup\LabConfig /v BypassTPMCheck /t reg_dword /d 0x00000001 /f
reg add HKLM\offline\Setup\LabConfig /v BypassSecureBootCheck /t reg_dword /d 0x00000001 /f
reg add HKLM\offline\Setup\LabConfig /v BypassRAMCheck /t reg_dword /d 0x00000001 /f
reg add HKLM\offline\Setup\LabConfig /v BypassStorageCheck /t reg_dword /d 0x00000001 /f
reg add HKLM\offline\Setup\LabConfig /v BypassCPUCheck /t reg_dword /d 0x00000001 /f
reg add HKLM\offline\Setup\LabConfig /v BypassDiskCheck /t reg_dword /d 0x00000001 /f
reg add HKLM\offline\Setup\MoSetup /v AllowUpgradesWithUnsupportedTPMOrCPU /t reg_dword /d 0x00000001 /f
reg unload HKLM\offline
dism /unmount-image /mountdir:"%temp%\mounttemp" /commit
dism /mount-wim /wimfile:"%sourcespath%\sources\boot.wim" /index:2 /mountdir:"%temp%\mounttemp"
reg load HKLM\offline "%temp%\mounttemp\windows\system32\config\system"
reg add HKLM\offline\Setup\LabConfig /v BypassTPMCheck /t reg_dword /d 0x00000001 /f
reg add HKLM\offline\Setup\LabConfig /v BypassSecureBootCheck /t reg_dword /d 0x00000001 /f
reg add HKLM\offline\Setup\LabConfig /v BypassRAMCheck /t reg_dword /d 0x00000001 /f
reg add HKLM\offline\Setup\LabConfig /v BypassStorageCheck /t reg_dword /d 0x00000001 /f
reg add HKLM\offline\Setup\LabConfig /v BypassCPUCheck /t reg_dword /d 0x00000001 /f
reg add HKLM\offline\Setup\LabConfig /v BypassDiskCheck /t reg_dword /d 0x00000001 /f
reg add HKLM\offline\Setup\MoSetup /v AllowUpgradesWithUnsupportedTPMOrCPU /t reg_dword /d 0x00000001 /f
reg unload HKLM\offline
dism /unmount-image /mountdir:"%temp%\mounttemp" /commit
rd /S /Q "%temp%\mounttemp\"
md "%sourcespath%\sources\$OEM$\$$\Panther"
del /f "%sourcesspath%\unattend.xml"
del /f "%sourcespath%\autounattend.xml"
del /f "%sourcespath%\sources\unattend.xml"
del /f "%sourcespath%\sources\autounattend.xml"
del /f "%sourcespath%\sources\$OEM$\$$\Panther\unattend.xml"
del /f "%sourcespath%\sources\$OEM$\$$\Panther\autounattend.xml"
copy .\sources\$OEM$\$$\Panther\unattend.xml "%sourcespath%\sources\$OEM$\$$\Panther\"
del /f "%sourcespath%\sources\EI.CFG"
copy .\sources\EI.CFG "%sourcespath%\sources\"
echo.
echo.
echo.
echo Done.
echo Press any key to exit.
echo.
pause>nul|set/p=&echo(
exit
