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

mode con:cols=170 lines=48
cls
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

:mainmenu
cls
ECHO M-M-C's quick-n-dirty In-Place-Upgrade-Helper for Win10/11
echo V0.72
ECHO.
echo.
echo 当前选择 Currently selected:
echo.
echo 版本ID EditionID: %editionid%
echo.
if "%productkey%"=="" echo 产品名称 ProductName: %productname% (从注册表中读取)
if not "%productkey%"=="" echo 产品名称 ProductName: %productname%
@REM echo (Microsoft uses "Windows 10" for this registry key even if Windows 11 is installed)
echo (即使安裝了 Windows 11，Microsoft 也會使用「Windows 10」作為此登錄項)
echo.
echo OEM产品密钥 OEM ProductKey: %productkey%
@REM echo (official key from Microsoft for pre-installation, not for activation)
echo (官方的预安装密钥，不用于激活)
echo.
echo 组合版本ID CompositionEditionID: %compositioneditionid%
@REM echo (basic edition, on which the actual edition is technically based)
echo (基本版本，实际版本在技术上基于它)
echo.
echo.
echo 1) Windows Home                          11) Windows Home N
echo 2) Windows Pro                           12) Windows Pro N
echo 3) Windows Pro for Workstations          13) Windows Pro N for Workstations
echo 4) Windows Enterprise                    14) Windows Pro Education N
echo 5) Windows Pro Education                 15) Windows Education N
echo 6) Windows Education                     16) Windows Enterprise N
echo 7) Windows Enterprise multi-session      17) Windows 11 SE CloudEdition N
echo 8) Windows IoT Enterprise
echo 9) Windows Home Single Language
echo 10) Windows 11 SE CloudEdition
echo.
@REM echo special editions, only available on separate installation media:
echo 特殊版本，只能在单独的安装媒介上获得:
echo 18) Windows 10 Enterprise LTSC 2021      21) Windows Server 2022 Standard
echo 19) Windows 10 IoT Enterprise LTSC 2021  22) Windows Server 2022 Datacenter
echo 20) Windows 10 Enterprise N LTSC 2021    
echo.
echo.
@REM echo k) Method 1) Try to install the selected key with slmgr (simple edition change without in-place upgrade)
echo k) 方法 1) 尝试使用 slmgr 安装选择的密钥（简单的版本更改，不需要进行就地升级）
@REM echo s) Method 2) Start upgrade without selecting edition, setup decides alone. Equivalent to a normal in-place upgrade
echo s) 方法 2) 开始升级而不选择版本，安装程序自己决定。相当于正常的就地升级
@REM echo u) Method 3) Start upgrade to the selected edition. The appropriate pre-installation key is used for the setup
echo u) 方法 3) 开始升级到选择的版本。安装程序使用适当的预安装密钥
@REM echo f) Method 4) Start FORCED upgrade to the selected edition. The appropriate pre-installation key is used for the setup
echo f) 方法 4) 开始强制升级到选择的版本。安装程序使用适当的预安装密钥
echo.
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
if '%choice%'=='21' goto setvarserv22std
if '%choice%'=='22' goto setvarserv22data
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
@REM ECHO "%choice%" was not found, please try again &ECHO. &pause
echo 未找到 "%choice%"，请重试 &ECHO. &pause
ECHO.
goto mainmenu

:keychange
if "%productkey%"=="" goto nokeyselected
@REM echo An attempt is made to change the edition by simply changing the key...
echo 试图通过简单更改密钥来更改版本...
slmgr /ipk %productkey%
goto mainmenu

:runboringupgrade
if "%productkey%"=="" goto nokeyselected
echo.
@REM echo Setup and background processes are running, please wait. This window then closes automatically.
echo 设置和后台进程正在运行，请稍候。然后此窗口会自动关闭。
%sourcespath%\setup.exe /eula accept /telemetry disable /priority normal /resizerecoverypartition enable
goto endofbatch

:runupgrade
if "%productkey%"=="" goto nokeyselected
echo.
@REM echo Setup and background processes are running, please wait. This window then closes automatically.
echo 设置和后台进程正在运行，请稍候。然后此窗口会自动关闭。
%sourcespath%\setup.exe /eula accept /telemetry disable /priority normal /resizerecoverypartition enable /pkey %productkey%
goto endofbatch

:runforcedupgrade
if "%productkey%"=="" goto nokeyselected
echo.
@REM echo Forces an in-place upgrade (apps and settings are retained) to the selected version by "faking" a different version in the registry.
echo 通过在注册表中“伪造”不同的版本，强制执行选择的版本的现场升级（应用程序和设置将被保留）。
@REM echo If, for example, Pro is to be installed, then "ProductName" and "EditionID" in the registry will be overwritten with the values ??of the Pro edition.
echo 例如，如果要安装专业版，则将在注册表中使用专业版的值覆盖 "ProductName" 和 "EditionID"。
@REM echo Setup then thinks the Pro is already installed and continues with the in-place upgrade.
echo 安装程序会认为专业版已经安装，并继续进行现场升级。
@REM echo This is how you can do an in-place upgrade that is not in the official upgrade path, e.g. downgrades from Pro to Home.
echo 这样你就可以进行非官方升级路径的现场升级，例如从专业版降级到家庭版。
@REM echo But upgrade paths that are blocked for licensing reasons, such as Home directly to Enterprise, can also be unlocked with this.
echo 但是出于许可证原因而被阻止的升级路径，例如从家庭版直接升级到企业版，也可以通过这种方式解锁。
@REM echo Or even very creative things like Win10 Edu work on Win10 IoT Enterprise LTSC.
echo 或者甚至非常有创意的事情，比如 Win10 Edu 在 Win10 IoT Enterprise LTSC 上运行。
echo.
@REM echo This is of course completely unsupported by Microsoft, use at your own risk.
@REM However, no problems have occurred so far, everything behaves like a normal in-place upgrade.
echo 当然，这是完全不受微软支持的，使用时自担风险。
然而，到目前为止还没有出现任何问题，一切都表现得像正常的现场升级。
@REM echo Are you sure you want to continue? Otherwise, cancel with CTRL+C or simply close the window.
echo 你确定要继续吗？否则，按 CTRL+C 取消，或者直接关闭窗口。
echo.
@REM echo If you accidentally wrote the wrong edition into the registry, simply restart the forced in-place upgrade with the correct edition.
echo 如果你不小心将错误的版本写入了注册表，只需使用正确的版本重新启动强制现场升级。
echo.
pause
echo.
@REM echo Set registry entries...
echo 正在设置注册表项...
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "EditionID" /t REG_SZ /d "%editionid%" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ProductName" /t REG_SZ /d "%productname%" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CompositionEditionID" /t REG_SZ /d "%compositioneditionid%" /f
Reg.exe add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion" /v "EditionID" /t REG_SZ /d "%editionid%" /f /reg:32
Reg.exe add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion" /v "ProductName" /t REG_SZ /d "%productname%" /f /reg:32
Reg.exe add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion" /v "CompositionEditionID" /t REG_SZ /d "%compositioneditionid%" /f /reg:32
echo.
@REM echo Setup and background processes are running, please wait. This window then closes automatically.
echo 设置和后台进程正在运行，请稍候。然后此窗口会自动关闭。
%sourcespath%\setup.exe /eula accept /telemetry disable /priority normal /resizerecoverypartition enable /pkey %productkey%
goto endofbatch

:nosetupfound
@REM echo Setup.exe and/or Sources folder not found! Tool not copied to the installation files?
echo Setup.exe 和/或 Sources 文件夹未找到！工具未复制到安装文件中？
@REM echo Trying to use an external installation medium...
echo 尝试使用外部安装媒介...
set /p sourcespath=Please enter the path to the installation medium (e.g. F:\ or D:\unpackesISO\): 
goto premainmenu

:nokeyselected
@REM echo No edition with key selected! Please try again.
echo 未选择带有密钥的版本！请重试。
echo.
pause
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

:endofbatch
exit
