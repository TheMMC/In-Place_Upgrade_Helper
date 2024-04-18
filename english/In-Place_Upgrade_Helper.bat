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
SETLOCAL
REM Automatic loading of system variables
for /f "tokens=2*" %%i in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName') do set productname=%%j
for /f "tokens=2*" %%i in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID') do set editionid=%%j
for /f "tokens=2*" %%i in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CompositionEditionID') do set compositioneditionid=%%j
REM check if the variables are set and use default values ??if not
if "%productname%"=="" set productname=Windows 10 Pro
if "%editionid%"=="" set editionid=Professional
if "%compositioneditionid%"=="" set compositioneditionid=Enterprise

set "choice="
set sourcespath=.

:premainmenu
if not exist "%sourcespath%"\setup.exe goto nosetupfound
if not exist "%sourcespath%"\sources\ goto nosetupfound
echo Installation files found
echo.
echo If the chosen edition is not available on the installation medium, Windows setup can generate certain editions by itself.
echo Upgrade chart:
echo.
echo Available edition for installation            required edition on installation medium
echo.
echo Windows Pro                                   Windows Pro
echo Windows Pro for Workstations                  Windows Pro
echo Windows Education                             Windows Pro
echo Windows Pro Education                         Windows Pro
echo Windows Enterprise                            Windows Pro
echo Windows Enterprise multi-session              Windows Pro
echo Windows IoT Enterprise                        Windows Pro
echo Windows SE [Cloud] (Win11 only)               Windows Pro
echo Windows Home                                  Windows Home
echo Windows Home Single Language                  Windows Home
echo Windows Pro N                                 Windows Pro N
echo Windows Pro N for Workstations                Windows Pro N
echo Windows Education N                           Windows Pro N
echo Windows Pro Education N                       Windows Pro N
echo Windows Enterprise N                          Windows Pro N
echo Windows SE [Cloud] N (Win11 only)             Windows Pro N
echo Windows 10 Enterprise LTSC 2021               Windows 10 Enterprise LTSC 2021
echo Windows 10 Enterprise N LTSC 2021             Windows 10 Enterprise LTSC N 2021
echo Windows 10 IoT Enterprise LTSC 2021           Windows 10 Enterprise LTSC 2021
echo Windows 11 Enterprise LTSC 2024               Windows 11 Enterprise LTSC 2024
echo Windows 11 Enterprise N LTSC 2024             Windows 11 Enterprise N LTSC 2024
echo Windows 11 IoT Enterprise LTSC 2024           Windows 11 Enterprise LTSC 2024
echo Windows 11 IoT Enterprise LTSC Subscr. 2024   Windows 11 Enterprise LTSC 2024
echo Windows Server 2022 Standard                  Windows Server 2022 Standard
echo Windows Server 2022 Datacenter                Windows Server 2022 Datacenter
echo Windows Server 2025 Standard                  Windows Server 2025 Standard
echo Windows Server 2025 Datacenter                Windows Server 2025 Datacenter

echo.
echo Press any key to list available editions on the installation medium.
pause>nul|set/p=&echo(
echo Reading installation medium, please wait...
if exist "%sourcespath%\sources\install.wim" powershell -ExecutionPolicy Bypass -Command "Get-WindowsImage -ImagePath '%sourcespath%\sources\install.wim' | Select-Object -Property ImageName, ImageIndex"
if exist "%sourcespath%\sources\install.esd" powershell -ExecutionPolicy Bypass -Command "Get-WindowsImage -ImagePath '%sourcespath%\sources\install.esd' | Select-Object -Property ImageName, ImageIndex"
if exist "%sourcespath%\sources\install.swm" powershell -ExecutionPolicy Bypass -Command "Get-WindowsImage -ImagePath '%sourcespath%\sources\install.swm' | Select-Object -Property ImageName, ImageIndex"
echo Press any key to start the In-Place-Upgrade-Helper.
pause>nul|set/p=&echo(


:mainmenu
cls
ECHO M-M-C's quick-n-dirty In-Place-Upgrade-Helper for Win10/11
echo V0.93
echo.
echo Enter the number of your desired edition, press enter, choose an upgrade method, then press enter again.
echo.
if "%productkey%"=="" echo ProductName: [92m%productname%[0m [93m(read from registry)[0m
if not "%productkey%"=="" echo ProductName: [92m%productname%[0m
echo (The registry key always shows "Windows 10" even if Windows 11 is installed)
echo EditionID: [92m%editionid%[0m
if "%productkey%"=="" echo OEM ProductKey: [93mNo edition selected[0m
if not "%productkey%"=="" echo OEM ProductKey: [92m%productkey%[0m
echo (Official key from Microsoft for pre-installation, not for activation)
echo CompositionEditionID: [92m%compositioneditionid%[0m
echo (Base edition, on which the actual edition is technically derived from)
echo.
echo Standard editions:
echo 1) Windows Home                          10) Windows 11 SE CloudEdition
echo 2) Windows Pro                           11) Windows Home N
echo 3) Windows Pro for Workstations          12) Windows Pro N
echo 4) Windows Enterprise                    13) Windows Pro N for Workstations
echo 5) Windows Pro Education                 14) Windows Pro Education N
echo 6) Windows Education                     15) Windows Education N
echo 7) Windows Enterprise multi-session      16) Windows Enterprise N
echo 8) Windows IoT Enterprise                17) Windows 11 SE CloudEdition N
echo 9) Windows Home Single Language
echo LTSC:
echo 18) Windows 10 Enterprise LTSC 2021      22) Windows 11 IoT Enterprise LTSC 2024
echo 19) Windows 10 IoT Enterprise LTSC 2021  23) Windows 11 Enterprise N LTSC 2024
echo 20) Windows 10 Enterprise N LTSC 2021    24) Windows 11 IoT Enterprise LTSC Subscription 2024
echo 21) Windows 11 Enterprise LTSC 2024
echo Server:
echo 25) Windows Server 2022 Standard         27) Windows Server 2025 Standard
echo 26) Windows Server 2022 Datacenter       28) Windows Server 2025 Datacenter
echo.
echo k) Method 1 - Try to install the selected key with slmgr (simple edition change without in-place upgrade)
echo s) Method 2 - Start upgrade without selecting edition, setup decides alone. Equivalent to a normal in-place upgrade
echo u) Method 3 - Start upgrade to the selected edition. The appropriate pre-installation key is used for the setup
echo f) Method 4 - Start FORCED upgrade to the selected edition. The appropriate pre-installation key is used for the setup
echo.
echo 0) exit

set "choice="
set /p choice=Please make a selection: 
if '%choice%'=='1' goto setvarcore
if '%choice%'=='2' goto setvarpro
if '%choice%'=='3' goto setvarpfw
if '%choice%'=='4' goto setvarent
if '%choice%'=='5' goto setvarproed
if '%choice%'=='6' goto setvared
if '%choice%'=='7' goto setvarentmulti
if '%choice%'=='8' goto setvariotent
if '%choice%'=='9' goto setvarcoresl
if '%choice%'=='10' goto setvarcloud
if '%choice%'=='11' goto setvarcoren
if '%choice%'=='12' goto setvarpron
if '%choice%'=='13' goto setvarpfwn
if '%choice%'=='14' goto setvarproedn
if '%choice%'=='15' goto setvaredn
if '%choice%'=='16' goto setvarentn
if '%choice%'=='17' goto setvarcloudn
if '%choice%'=='18' goto setvarltsc2021
if '%choice%'=='19' goto setvariotltsc2021
if '%choice%'=='20' goto setvarltscn2021
if '%choice%'=='21' goto setvarltsc2024
if '%choice%'=='22' goto setvariotltsc2024
if '%choice%'=='23' goto setvarltscn2024
if '%choice%'=='24' goto setvariotltscsub2024
if '%choice%'=='25' goto setvarserv22std
if '%choice%'=='26' goto setvarserv22data
if '%choice%'=='27' goto setvarserv25std
if '%choice%'=='28' goto setvarserv25data
if '%choice%'=='u' goto runupgrade
if '%choice%'=='U' goto runupgrade
if '%choice%'=='k' goto keychange
if '%choice%'=='K' goto keychange
if '%choice%'=='s' goto runboringupgrade
if '%choice%'=='S' goto runboringupgrade
if '%choice%'=='f' goto runforcedupgrade
if '%choice%'=='F' goto runforcedupgrade
if '%choice%'=='0' goto endofbatch
ECHO.
ECHO "%choice%" was not found, press any key to try again.&ECHO. &pause>nul|set/p=&echo(
ECHO.
goto mainmenu

:keychange
if "%productkey%"=="" goto nokeyselected
echo Attempting to change the edition by simply changing the key...
slmgr /ipk %productkey%
goto mainmenu

:runboringupgrade
echo.
echo Setup and background processes are running, please wait. This window then closes automatically.
%sourcespath%\setup.exe /eula accept /telemetry disable /priority normal /resizerecoverypartition enable
goto endofbatch

:runupgrade
if "%productkey%"=="" goto nokeyselected
echo.
echo Setup and background processes are running, please wait. This window then closes automatically.
%sourcespath%\setup.exe /eula accept /telemetry disable /priority normal /resizerecoverypartition enable /pkey %productkey%
goto endofbatch

:runforcedupgrade
if "%productkey%"=="" goto nokeyselected
echo.
echo Forces an in-place upgrade (apps and settings are retained) to the selected version by "faking" a different version in the registry.
echo If, for example, Pro is to be installed, then "ProductName" and "EditionID" in the registry will be overwritten with the values of the Pro edition.
echo Setup then thinks the Pro is already installed and continues with the in-place upgrade.
echo This is how you can do an in-place upgrade that is not in the official upgrade path, e.g. downgrades from Pro to Home.
echo Even upgrade paths that are blocked for licensing reasons, such as Home directly to Enterprise, can be unlocked with this.
echo Or even more creative things like Win10 Edu to Win10 IoT Enterprise LTSC are possible.
echo.
echo This is of course completely unsupported by Microsoft, use at your own risk.
echo However, no problems have occurred so far, everything behaves like a normal in-place upgrade.
echo If you accidentally wrote the wrong edition into the registry, simply restart the forced in-place upgrade with the correct edition.
echo.
echo Are you sure you want to continue? Otherwise close this window now!
echo.
pause>nul|set/p=Press any key to continue.&echo(
echo.
echo Setting registry entries...
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "EditionID" /t REG_SZ /d "%editionid%" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ProductName" /t REG_SZ /d "%productname%" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CompositionEditionID" /t REG_SZ /d "%compositioneditionid%" /f
Reg.exe add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion" /v "EditionID" /t REG_SZ /d "%editionid%" /f /reg:32
Reg.exe add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion" /v "ProductName" /t REG_SZ /d "%productname%" /f /reg:32
Reg.exe add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion" /v "CompositionEditionID" /t REG_SZ /d "%compositioneditionid%" /f /reg:32
echo.
echo Setup and background processes are running, please wait. This window then closes automatically.
%sourcespath%\setup.exe /eula accept /telemetry disable /priority normal /resizerecoverypartition enable /pkey %productkey%
goto endofbatch

:nosetupfound
echo Setup.exe and/or Sources folder not found! Tool not copied to the installation files?
echo Trying to use an external installation medium...
set /p sourcespath=Please enter the path to the installation medium (e.g. F:\ or D:\unpackedISO\): 
goto premainmenu

:nokeyselected
echo Please select a Windows Edition first!
echo.
pause>nul|set/p=Press any key to continue.&echo(
goto mainmenu

REM The different Windows editions are defined here

REM Windows Home
:setvarcore
set productkey=YTMG3-N6DKC-DKB77-7M9GH-8HVX7
set editionid=Core
set productname=Windows 10 Home
set compositioneditionid=Core
goto mainmenu

REM Windows Pro
:setvarpro
set productkey=VK7JG-NPHTM-C97JM-9MPGT-3V66T
set editionid=Professional
set productname=Windows 10 Pro
set compositioneditionid=Enterprise
goto mainmenu

REM Windows Pro for Workstations
:setvarpfw
set productkey=DXG7C-N36C4-C4HTG-X4T3X-2YV77
set editionid=ProfessionalWorkstation
set productname=Windows 10 Pro for Workstations
set compositioneditionid=Enterprise
goto mainmenu

REM Windows Enterprise
:setvarent
set productkey=XGVPP-NMH47-7TTHJ-W3FW7-8HV2C
set editionid=Enterprise
set productname=Windows 10 Enterprise
set compositioneditionid=Enterprise
goto mainmenu

REM Windows Pro Education
:setvarproed
set productkey=8PTT6-RNW4C-6V7J2-C2D3X-MHBPB
set editionid=ProfessionalEducation
set productname=Windows 10 Pro Education
set compositioneditionid=Enterprise
goto mainmenu

REM Windows Education
:setvared
set productkey=YNMGQ-8RYV3-4PGQ3-C8XTP-7CFBY
set editionid=Education
set productname=Windows 10 Education
set compositioneditionid=Enterprise
goto mainmenu

REM Windows Enterprise multi-session / Virtual Desktops
:setvarentmulti
set productkey=CPWHC-NT2C7-VYW78-DHDB2-PG3GK
set editionid=ServerRdsh
set productname=Windows 10 Enterprise multi-session
set compositioneditionid=Enterprise
goto mainmenu

REM Windows IoT Enterprise
:setvariotent
set productkey=XQQYW-NFFMW-XJPBH-K8732-CKFFD
set editionid=IoTEnterprise
set productname=Windows 10 IoT Enterprise
set compositioneditionid=Enterprise
goto mainmenu

REM Windows Home Single Language
:setvarcoresl
set productkey=BT79Q-G7N6G-PGBYW-4YWX6-6F4BT
set editionid=CoreSingleLanguage
set productname=Windows 10 Home Single Language
set compositioneditionid=Core
goto mainmenu

REM Windows SE CloudEdition
:setvarcloud
set productkey=KY7PN-VR6RX-83W6Y-6DDYQ-T6R4W
set editionid=CloudEdition
set productname=Windows 10 SE
set compositioneditionid=Enterprise
goto mainmenu

REM Windows Home N
:setvarcoren
set productkey=4CPRK-NM3K3-X6XXQ-RXX86-WXCHW
set editionid=CoreN
set productname=Windows 10 Home N
set compositioneditionid=CoreN
goto mainmenu

REM Windows Pro N
:setvarpron
set productkey=2B87N-8KFHP-DKV6R-Y2C8J-PKCKT
set editionid=ProfessionalN
set productname=Windows 10 Pro N
set compositioneditionid=EnterpriseN
goto mainmenu

REM Windows Pro N for Workstations
:setvarpfwn
set productkey=WYPNQ-8C467-V2W6J-TX4WX-WT2RQ
set editionid=ProfessionalWorkstationN
set productname=Windows 10 Pro N for Workstations
set compositioneditionid=EnterpriseN
goto mainmenu

REM Windows Pro Education N
:setvarproedn
set productkey=GJTYN-HDMQY-FRR76-HVGC7-QPF8P
set editionid=ProfessionalEducationN
set productname=Windows 10 Pro Education N
set compositioneditionid=EnterpriseN
goto mainmenu

REM Windows Education N
:setvaredn
set productkey=84NGF-MHBT6-FXBX8-QWJK7-DRR8H
set editionid=EducationN
set productname=Windows 10 Education N
set compositioneditionid=EnterpriseN
goto mainmenu

REM Windows Enterprise N
:setvarentn
set productkey=3V6Q6-NQXCX-V8YXR-9QCYV-QPFCT
set editionid=EnterpriseN
set productname=Windows 10 Enterprise N
set compositioneditionid=EnterpriseN
goto mainmenu

REM Windows SE CloudEdition N
:setvarcloudn
set productkey=K9VKN-3BGWV-Y624W-MCRMQ-BHDCD
set editionid=CloudEditionN
set productname=Windows 10 SE N
set compositioneditionid=EnterpriseN
goto mainmenu

REM Windows 10 Enterprise LTSC 2021
:setvarltsc2021
set productkey=M7XTQ-FN8P6-TTKYV-9D4CC-J462D
set editionid=EnterpriseS
set productname=Windows 10 Enterprise LTSC 2021
set compositioneditionid=EnterpriseS
goto mainmenu

REM Windows 10 IoT Enterprise LTSC 2021
:setvariotltsc2021
set productkey=QPM6N-7J2WJ-P88HH-P3YRH-YY74H
set editionid=IoTEnterpriseS
set productname=Windows 10 IoT Enterprise LTSC 2021
set compositioneditionid=EnterpriseS
goto mainmenu

REM Windows 10 Enterprise N LTSC 2021
:setvarltscn2021
set productkey=2D7NQ-3MDXF-9WTDT-X9CCP-CKD8V
set editionid=EnterpriseSN
set productname=Windows 10 Enterprise N LTSC 2021
set compositioneditionid=EnterpriseSN
goto mainmenu

REM Windows 11 Enterprise LTSC 2024
:setvarltsc2024
set productkey=M7XTQ-FN8P6-TTKYV-9D4CC-J462D
set editionid=EnterpriseS
set productname=Windows 10 Enterprise LTSC 2024
set compositioneditionid=EnterpriseS
goto mainmenu

REM Windows 11 IoT Enterprise LTSC 2024
:setvariotltsc2024
set productkey=KBN8V-HFGQ4-MGXVD-347P6-PDQGT
set editionid=IoTEnterpriseS
set productname=Windows 10 IoT Enterprise LTSC 2024
set compositioneditionid=EnterpriseS
goto mainmenu

REM Windows 11 Enterprise N LTSC 2024
:setvarltscn2024
set productkey=92NFX-8DJQP-P6BBQ-THF9C-7CG2H
set editionid=EnterpriseSN
set productname=Windows 10 Enterprise N LTSC 2024
set compositioneditionid=EnterpriseSN
goto mainmenu

REM Windows 11 IoT Enterprise LTSC Subscription 2024
:setvariotltscsub2024
set productkey=N979K-XWD77-YW3GB-HBGH6-D32MH
set editionid=IoTEnterpriseSK
set productname=Windows 10 IoT Enterprise Subscription LTSC 2024
set compositioneditionid=EnterpriseS
goto mainmenu

REM Windows Server 2022 Standard / Standard with desktop experience
:setvarserv22std
set productkey=VDYBN-27WPP-V4HQT-9VMD4-VMK7H
set editionid=ServerStandard
set productname=Windows Server 2022 Standard
set compositioneditionid=ServerStandard
goto mainmenu

REM Windows Server 2022 Datacenter / Datacenter with desktop experience
:setvarserv22data
set productkey=WX4NM-KYWYW-QJJR4-XV3QB-6VM33
set editionid=ServerDatacenter
set productname=Windows Server 2022 Datacenter
set compositioneditionid=ServerDatacenter
goto mainmenu

REM Windows Server 2025 Standard / Standard with desktop experience
:setvarserv25std
set productkey=DPNXD-67YY9-WWFJJ-RYH99-RM832
set editionid=ServerStandard
set productname=Windows Server 2025 Standard
set compositioneditionid=ServerStandard
goto mainmenu

REM Windows Server 2025 Datacenter / Datacenter with desktop experience
:setvarserv25data
set productkey=CNFDQ-2BW8H-9V4WM-TKCPD-MD2QF
set editionid=ServerDatacenter
set productname=Windows Server 2025 Datacenter
set compositioneditionid=ServerDatacenter
goto mainmenu

:endofbatch
exit
