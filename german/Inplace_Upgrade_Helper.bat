Rem Admin-Rechte holen
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

@echo off
cls
SETLOCAL
REM Windows Pro wird vorausgewÑhlt. Das verhindert, das man die Auswahl leer lÑsst und dann "Upgrade erzwingen" auswÑhlt, sonst werden leere Werte in die Registry geschrieben.
REM FÅr die Umsetzung einer automatischen Erkennung der jetzt installierten Edition bin ich zu faul, dafÅr ist dieses Tool ja auch nicht da. 
set productkey=VK7JG-NPHTM-C97JM-9MPGT-3V66T
set editionid=Professional
set productname=Windows 10 Pro
set "choice="
set forcedupgrade=Nein

:mainmenu
cls
ECHO.
ECHO M-M-C's quick-n-dirty Inplace-Upgrade-Helper fÅr Win10/11
echo V0.41
ECHO.
echo.
echo Derzeit ausgewÑhlt:
echo.
echo EditionID: %editionid%
echo.
echo ProductName: %productname%
echo (auch bei Win11 wird in der Registry "Windows 10" angezeigt, das ist von MS selbst so gemacht)
echo.
echo OEM ProductKey: %productkey%
echo (offizieller Key von Microsoft zum Vorinstallieren, nicht zum Aktivieren)
echo.
echo Inplace-Upgrade erzwingen: %forcedupgrade%
echo.
echo.
echo 1) Windows Home
echo 2) Windows Pro
echo 3) Windows Pro for Workstations
echo 4) Windows Enterprise
echo 5) Windows Pro Education
echo 6) Windows Education
echo 7) Windows Enterprise multi-session / Virtual Desktops
echo 8) Windows IoT Enterprise
echo 9) Windows Home Single Language
echo 10) Windows SE CloudEdition
echo 11) Windows Home N
echo 12) Windows Pro N
echo 13) Windows Pro N for Workstations
echo 14) Windows Pro Education N
echo 15) Windows Education N
echo 16) Windows Enterprise N
echo 17) Windows SE CloudEdition N
echo Sondereditionen, nur erhÑltlich auf separaten Installationsmedien:
echo 18) Windows 10 Enterprise LTSC 2021
echo 19) Windows 10 IoT Enterprise LTSC 2021
echo 20) Windows 10 Enterprise N LTSC 2021
echo.
echo u) Upgrade mit der ausgewÑhlten Edition starten
echo.
echo.
echo k) Versuche den ausgewÑhlten Key mit slmgr zu installieren (Editionswechsel ohne Inplace-Upgrade). Reicht oft schon aus.
echo s) Standard-Upgrade ohne Editionsauswahl, Setup entscheidet alleine
echo f) Erzwungenes Upgrade an/aus
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
if '%choice%'=='u' goto runupgrade
if '%choice%'=='U' goto runupgrade
if '%choice%'=='k' goto keychange
if '%choice%'=='K' goto keychange
if '%choice%'=='s' goto runboringupgrade
if '%choice%'=='S' goto runboringupgrade
if '%choice%'=='f' goto toggleforceupgrade
if '%choice%'=='F' goto toggleforceupgrade
if '%choice%'=='0' goto endofbatch
ECHO.
ECHO "%choice%" wurde nicht gefunden, bitte erneut versuchen &ECHO. &pause
ECHO.
goto mainmenu

:toggleforceupgrade
if '%forcedupgrade%'=='Ja' set forcedupgrade=Nein&goto mainmenu
if '%forcedupgrade%'=='Nein' set forcedupgrade=Ja&goto mainmenu
goto mainmenu

:keychange
echo Es wird versucht die Edition per simplen Keywechsel zu Ñndern...
slmgr /ipk %productkey%
goto mainmenu

:runboringupgrade
echo.
echo Setup und Hintergrundprozesse laufen, bitte warten. Dieses Fenster schlie·t danach automatisch.
setup.exe /eula accept /telemetry disable /priority normal /resizerecoverypartition enable
goto endofbatch

:runupgrade
if '%forcedupgrade%'=='Ja' goto runforcedupgrade
echo.
echo Setup und Hintergrundprozesse laufen, bitte warten. Dieses Fenster schlie·t danach automatisch.
setup.exe /eula accept /telemetry disable /priority normal /resizerecoverypartition enable /pkey %productkey%
goto endofbatch

:runforcedupgrade
echo.
echo Erzwingt ein Inplace-Upgrade (Apps und Einstellungen bleiben erhalten) auf die ausgewÑhlte Version, indem in der Registry eine andere Version "vorgegaukelt" wird.
echo Soll z.B. die Pro installiert werden, dann wird "ProductName" und "EditionID" in der Registy mit den Werten der Pro-Edition Åberschrieben.
echo Setup denkt dann es ist bereits die Pro installiert und fÑhrt mit dem Inplace-Upgrade fort.
echo So kann man ein Inplace-Upgrade machen, welches nicht im offiziellen Upgrade-Pfad ist, z.B. auch Downgrades von Pro zu Home.
echo Aber auch aus lizenzgrÅnden gesperrte Upgrade-Pfade, wie Home direkt zu Enterprise, lassen sich damit freischalten.
echo.
echo Dieses ist natÅrlich komplett unsupported von Microsoft, Benutzung auf eigene Gefahr.
echo Probleme sind allerdings bisher nicht aufgetreten, alles verhÑlt sich wie ein normales Inplace-Upgrade.
echo Wirklich fortfahren? Ansonsten mit STRG+C abbrechen oder einfach das Fenster schlie·en.
echo.
echo Sollte man aus Versehen eine falsche Edition in die Registry geschrieben haben, einfach das erzwungene Inplace-Upgrade mit der richtigen Edition erneut starten.
echo.
pause
echo.
echo Setze Registry-EintrÑge...
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "EditionID" /t REG_SZ /d "%editionid%" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ProductName" /t REG_SZ /d "%productname%" /f
Reg.exe add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion" /v "EditionID" /t REG_SZ /d "%editionid%" /f
Reg.exe add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion" /v "ProductName" /t REG_SZ /d "%productname%" /f
echo.
echo Setup und Hintergrundprozesse laufen, bitte warten. Dieses Fenster schlie·t danach automatisch.
setup.exe /eula accept /telemetry disable /priority normal /resizerecoverypartition enable /pkey %productkey%
goto endofbatch


REM Hier werden die verschiedenen Windows-Editionen definiert

REM Windows Home
:setvarcore
set productkey=YTMG3-N6DKC-DKB77-7M9GH-8HVX7
set editionid=Core
set productname=Windows 10 Home
goto mainmenu

REM Windows Pro
:setvarpro
set productkey=VK7JG-NPHTM-C97JM-9MPGT-3V66T
set editionid=Professional
set productname=Windows 10 Pro
goto mainmenu

REM Windows Pro for Workstations
:setvarpfw
set productkey=DXG7C-N36C4-C4HTG-X4T3X-2YV77
set editionid=ProfessionalWorkstation
set productname=Windows 10 Pro for Workstations
goto mainmenu

REM Windows Enterprise
:setvarent
set productkey=XGVPP-NMH47-7TTHJ-W3FW7-8HV2C
set editionid=Enterprise
set productname=Windows 10 Enterprise
goto mainmenu

REM Windows Pro Education
:setvarproed
set productkey=8PTT6-RNW4C-6V7J2-C2D3X-MHBPB
set editionid=ProfessionalEducation
set productname=Windows 10 Pro Education
goto mainmenu

REM Windows Education
:setvared
set productkey=YNMGQ-8RYV3-4PGQ3-C8XTP-7CFBY
set editionid=Education
set productname=Windows 10 Education
goto mainmenu

REM Windows Enterprise multi-session / Virtual Desktops
:setvarentmulti
set productkey=CPWHC-NT2C7-VYW78-DHDB2-PG3GK
set editionid=ServerRdsh
set productname=Windows 10 Enterprise multi-session
goto mainmenu

REM Windows IoT Enterprise
:setvariotent
set productkey=XQQYW-NFFMW-XJPBH-K8732-CKFFD
set editionid=IoTEnterprise
set productname=Windows 10 IoT Enterprise
goto mainmenu

REM Windows Home Single Language
:setvarcoresl
set productkey=BT79Q-G7N6G-PGBYW-4YWX6-6F4BT
set editionid=CoreSingleLanguage
set productname=Windows 10 Home Single Language
goto mainmenu

REM Windows SE CloudEdition
:setvarcloud
set productkey=KY7PN-VR6RX-83W6Y-6DDYQ-T6R4W
set editionid=CloudEdition
set productname=Windows 10 SE
goto mainmenu

REM Windows Home N
:setvarcoren
set productkey=4CPRK-NM3K3-X6XXQ-RXX86-WXCHW
set editionid=CoreN
set productname=Windows 10 Home N
goto mainmenu

REM Windows Pro N
:setvarpron
set productkey=2B87N-8KFHP-DKV6R-Y2C8J-PKCKT
set editionid=ProfessionalN
set productname=Windows 10 Pro N
goto mainmenu

REM Windows Pro N for Workstations
:setvarpfwn
set productkey=WYPNQ-8C467-V2W6J-TX4WX-WT2RQ
set editionid=ProfessionalWorkstationN
set productname=Windows 10 Pro N for Workstations
goto mainmenu

REM Windows Pro Education N
:setvarproedn
set productkey=GJTYN-HDMQY-FRR76-HVGC7-QPF8P
set editionid=ProfessionalEducationN
set productname=Windows 10 Pro Education N
goto mainmenu

REM Windows Education N
:setvaredn
set productkey=84NGF-MHBT6-FXBX8-QWJK7-DRR8H
set editionid=EducationN
set productname=Windows 10 Education N
goto mainmenu

REM Windows Enterprise N
:setvarentn
set productkey=3V6Q6-NQXCX-V8YXR-9QCYV-QPFCT
set editionid=EnterpriseN
set productname=Windows 10 Enterprise N
goto mainmenu

REM Windows SE CloudEdition N
:setvarcloudn
set productkey=K9VKN-3BGWV-Y624W-MCRMQ-BHDCD
set editionid=CloudEditionN
set productname=Windows 10 SE N
goto mainmenu

REM Windows 10 Enterprise LTSC 2021
:setvarltsc2021
set productkey=M7XTQ-FN8P6-TTKYV-9D4CC-J462D
set editionid=EnterpriseS
set productname=Windows 10 Enterprise LTSC 2021
goto mainmenu

REM Windows 10 IoT Enterprise LTSC 2021
:setvariotltsc2021
set productkey=QPM6N-7J2WJ-P88HH-P3YRH-YY74H
set editionid=IoTEnterpriseS
set productname=Windows 10 IoT Enterprise LTSC 2021
goto mainmenu

REM Windows 10 Enterprise N LTSC 2021
:setvarltscn2021
set productkey=2D7NQ-3MDXF-9WTDT-X9CCP-CKD8V
set editionid=EnterpriseSN
set productname=Windows 10 Enterprise N LTSC 2021
goto mainmenu

:endofbatch
exit
