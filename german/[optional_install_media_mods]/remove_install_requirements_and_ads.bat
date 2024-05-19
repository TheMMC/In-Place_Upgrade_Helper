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
Echo Wenn das Fenster nicht maximiert ist, bitte per Hand vergroessern/maximieren.
echo Dies ist ein bekannter Bug bei Windows Terminal.
echo.
echo.
SETLOCAL
:premainmenu
echo Dieses Script macht folgendes:
echo -integriert die EI.CFG und erzwingt bei Neuinstallationen das Editionsauswahl-Menue, auch wenn eine Lizenz in der Firmware gefunden wurde
echo -entfernt Installationsvoraussetzungen wie TPM oder secure boot indem die passenden Reg-Keys in die boot.wim geschrieben werden
echo -entfernt den MS-Account-Zwang, sogar fuer Windows Home. Einfach ohne Internet installieren.
echo -kopiert eine aufgeblasene unattend.xml nach sources\$OEM$\$$\Panther, welche Folgendes beim ersten Neustart macht:
echo    -entfernt Installationsvoraussetzungen wie TPM oder secure boot, indem die passenden Reg-Keys in die Windows-Registry geschrieben werden
echo    -deaktiviert Werbung, Empfehlungen, Vorschlaege und Auto-Installation von Apps (Spotify, Candy Crush, MS Teams etc.) fuer neue Benutzer
echo                                                                                        (bei Neuinstallationen sind das dann alle Benutzer)
echo.
echo Alles wird mit offiziellen Registry-Keys gemacht, keine Hacks die zukuenftige Updates stoeren koennten.
echo.
echo NUR sources\$OEM$\$$\Panther\unattend.xml WIRD UNTERSTUETZT!
echo autounattend.xml im root Ordner oder Aehnliches blockiert In-Place_Upgrade_Helper.bat!
echo.

set "sourcespath="
set /p sourcespath=Bitte den Pfad zum BESCHREIBBAREN Installationsmedium eingeben (z.B. F:\ oder D:\entpacktesISO\): 

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
echo Fertig.
echo Beliebige Taste zum Beenden druecken.
echo.
pause>nul|set/p=&echo(
exit
