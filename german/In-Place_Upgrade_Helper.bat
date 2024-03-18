@echo off

Rem Admin-Rechte holen
>nul 2>&1 fsutil dirty query %systemdrive% && (goto gotAdmin) || (goto UACPrompt)
:UACPrompt
if exist "%SYSTEMROOT%\System32\Cscript.exe" (
    echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "%~s0", "", "", "runas", 1 > "%temp%\getadmin.vbs" 
    "%temp%\getadmin.vbs"
    exit /b
) else (
    powershell -Command "Start-Process -Verb RunAs -FilePath '%0' -ArgumentList 'am_admin'"
    exit /b
)
:gotAdmin
if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs"
pushd "%CD%" && CD /D "%~dp0"

cls
SETLOCAL
REM Automatisches Laden der Systemvariablen
for /f "tokens=2*" %%i in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName') do set productname=%%j
for /f "tokens=2*" %%i in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID') do set editionid=%%j
for /f "tokens=2*" %%i in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CompositionEditionID') do set compositioneditionid=%%j
REM Ueberpruefen, ob die Variablen gesetzt wurden, und Standardwerte verwenden, wenn nicht
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
ECHO.
ECHO M-M-C's quick-n-dirty In-Place-Upgrade-Helper fuer Win10/11
echo V0.70
ECHO.
echo.
echo Derzeit ausgewaehlt:
echo.
echo EditionID: %editionid%
echo.
echo ProductName: %productname%
echo (auch bei Win11 wird in der Registry "Windows 10" angezeigt, das ist von MS selbst so gemacht)
echo.
echo OEM ProductKey: %productkey%
echo (offizieller Key von Microsoft zum Vorinstallieren, nicht zum Aktivieren. Ist das Feld leer wurde die jetzige
echo EditionID und ProductName aus dem laufenden System ausgelesen. Das passiert einmalig beim Start der Batch)
echo.
echo CompositionEditionID: %compositioneditionid%
echo (Basis-Edition, worauf die eigentliche Edition technisch basiert)
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
echo Sondereditionen, nur erhaeltlich auf separaten Installationsmedien:
echo 18) Windows 10 Enterprise LTSC 2021      21) Windows Server 2022 Standard
echo 19) Windows 10 IoT Enterprise LTSC 2021  22) Windows Server 2022 Datacenter
echo 20) Windows 10 Enterprise N LTSC 2021    
echo.
echo.
echo k) Methode 1) Versuche den ausgewaehlten Key mit slmgr zu installieren (simpler Editionswechsel ohne In-Place-Upgrade)
echo s) Methode 2) Upgrade ohne Editionsauswahl starten, Setup entscheidet alleine. Entspricht einem normalen In-Place-Upgrade
echo u) Methode 3) Upgrade auf die ausgewaehlten Edition starten. Der passende Vorinstallations-Key wird dabei fuer das Setup genutzt
echo f) Methode 4) ERZWUNGENES Upgrade auf die ausgewaehlten Edition starten. Der passende Vorinstallations-Key wird dabei fuer das Setup genutzt
echo.
echo.

echo 0) exit

set "choice="
set /p choice=Bitte Auswahl treffen: 
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
ECHO "%choice%" wurde nicht gefunden, bitte erneut versuchen &ECHO. &pause
ECHO.
goto mainmenu

:keychange
if "%productkey%"=="" goto nokeyselected
echo Es wird versucht die Edition per simplen Keywechsel zu aendern...
slmgr /ipk %productkey%
goto mainmenu

:runboringupgrade
if "%productkey%"=="" goto nokeyselected
echo.
echo Setup und Hintergrundprozesse laufen, bitte warten. Dieses Fenster schliesst danach automatisch.
%sourcespath%\setup.exe /eula accept /telemetry disable /priority normal /resizerecoverypartition enable
goto endofbatch

:runupgrade
if "%productkey%"=="" goto nokeyselected
echo.
echo Setup und Hintergrundprozesse laufen, bitte warten. Dieses Fenster schliesst danach automatisch.
%sourcespath%\setup.exe /eula accept /telemetry disable /priority normal /resizerecoverypartition enable /pkey %productkey%
goto endofbatch

:runforcedupgrade
if "%productkey%"=="" goto nokeyselected
echo.
echo Erzwingt ein In-Place-Upgrade (Apps und Einstellungen bleiben erhalten) auf die ausgewaehlte Version, indem in der Registry eine andere Version "vorgegaukelt" wird.
echo Soll z.B. die Pro installiert werden, dann wird "ProductName" und "EditionID" in der Registy mit den Werten der Pro-Edition ueberschrieben.
echo Setup denkt dann es ist bereits die Pro installiert und fuehrt mit dem In-Place-Upgrade fort.
echo So kann man ein In-Place-Upgrade machen, welches nicht im offiziellen Upgrade-Pfad ist, z.B. auch Downgrades von Pro zu Home.
echo Aber auch aus lizenzgruenden gesperrte Upgrade-Pfade, wie Home direkt zu Enterprise, lassen sich damit freischalten.
echo Oder auch ganz kreative Sachen wie Win10 Edu auf Win10 IoT Enterprise LTSC funktionieren.
echo.
echo Dieses ist natuerlich komplett unsupported von Microsoft, Benutzung auf eigene Gefahr.
echo Probleme sind allerdings bisher nicht aufgetreten, alles verhaelt sich wie ein normales In-Place-Upgrade.
echo Wirklich fortfahren? Ansonsten mit STRG+C abbrechen oder einfach das Fenster schliessen.
echo.
echo Sollte man aus Versehen eine falsche Edition in die Registry geschrieben haben, einfach das erzwungene In-Place-Upgrade mit der richtigen Edition erneut starten.
echo.
pause
echo.
echo Setze Registry-Eintraege...
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "EditionID" /t REG_SZ /d "%editionid%" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ProductName" /t REG_SZ /d "%productname%" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CompositionEditionID" /t REG_SZ /d "%compositioneditionid%" /f
Reg.exe add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion" /v "EditionID" /t REG_SZ /d "%editionid%" /f /reg:32
Reg.exe add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion" /v "ProductName" /t REG_SZ /d "%productname%" /f /reg:32
Reg.exe add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion" /v "CompositionEditionID" /t REG_SZ /d "%compositioneditionid%" /f /reg:32
echo.
echo Setup und Hintergrundprozesse laufen, bitte warten. Dieses Fenster schliesst danach automatisch.
%sourcespath%\setup.exe /eula accept /telemetry disable /priority normal /resizerecoverypartition enable /pkey %productkey%
goto endofbatch

:nosetupfound
echo Setup.exe und/oder Sources-Ordner nicht gefunden! Tool nicht zu den Installationsdateien kopiert?
echo Versuche ein externes Installationmedium zu nutzen...
set /p sourcespath=Bitte Pfad zum Installationsmedium (z.B. F:\ oder D:\entpackesISO\) eingeben: 
goto premainmenu

:nokeyselected
echo Keine Edition mit Key ausgewaehlt! Bitte erneut versuchen.
echo.
pause
goto mainmenu

REM Hier werden die verschiedenen Windows-Editionen definiert

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
