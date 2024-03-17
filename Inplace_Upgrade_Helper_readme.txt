# Inplace_Upgrade_Helper
Helper-Tool für Windows 10/11 Inplace-Upgrades und Editionswechsel

Geht euch das auch auf den Sack, wenn das Windows-Setup selbst entscheidet, was es machen soll?
Ihr wollt Pro installieren, aber das Setup springt automatisch auf Home, weil der Key in der Firmware hinterlegt ist?
Habt ihr Pro installiert aber merkt erst hinterher, das ihr nur eine Lizenz für Home habt aber seid zu faul für ein Clean-Install?
Ihr wollt Home direkt auf Enterprise upgraden, da es technisch nichts anderes ist als ein Upgrade auf Pro, aber rein aus Lizenzgründen lässt es das Setup nicht zu?
Dabei merkt ihr, das die Enterprise-Edition eigentlich gar nicht auf eurer Consumer-ISO / auf eurem MediaCreationTool-USB-Stick drauf ist?
Neuinstallationen habt ihr mit angepasster EI.cfg im Griff aber (Inplace-)Upgrades geben euch keine Editionsauswahl?
Ihr wollte ohne Bastelei und Modifikationen an der WIM ein (beinahe) All-In-One Installationsmedium bauen?

Dieses Tool schafft Abhilfe.
Für die genaue Funktionsweise einfach in die Batch reingucken. Dies ist kein Aktivierungstool, es werden ausschließlich offizielle Vorinstallations-Keys genutzt.
Diese Batch einfach zu der setup.exe in das Installationsmedium kopieren und starten.

Sollte auf dem Installationsmedium die passende Version nicht vorhanden sein, ist das Setup in der Lage das passende Image on-the-fly zu generieren.
Höchstwahrscheinlich ist das die selbe Funktion, die DISM /Get-TargetEditions und DISM /Set-Edition nutzt (https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/change-the-windows-image-to-a-higher-edition-using-dism?view=windows-11).
Das ist die Methode, mit der z.B. https://uupdump.net/ aus den beiden Home und Pro Editionen alle anderen Editionen generieren kann (create_virtual_editions.cmd, https://github.com/abbodi1406/BatUtil/tree/master/uup-converter-wimlib)
Dies wurde mit einer WIM getestet, in der nur Home verfügbar war, aber das Setup mit Pro-Key gestartet wurde. Hier startete wie erwartet trotzdem das Home-Setup.
Dann wurde zu der WIM die Pro hinzugefügt, mehr aber nicht. Danach wurde Setup noch einmal mit dem Pro-Key gestartet, jetzt erscheint das richtige Pro-Setup.
Das Setup wurde abgebrochen und jetzt mit einem Pro for Workstations-Key gestartet. Das Setup generierte jetzt Pro for Workstations automatisch aus der Pro.
Als nächster Test wurde die Enterprise mit einer Consumer-ISO (de-de_windows_11_consumer_editions...iso) installiert, die eigentlich gar keine Enterprise hat. Das Setup hat auch diese aus der Pro generiert, wenn man den passenden Key als Parameter nimmt.
Alle Test wurden online durchgeführt.

Somit ergibt sich folgende Tabelle:

Zusätzliche Edition						Erforderliche Edition
Windows Home Single Language					Windows Home
Windows Pro for Workstations					Windows Pro
Windows Pro Education						Windows Pro
Windows Education						Windows Pro
Windows Enterprise						Windows Pro
Windows Enterprise multi-session / Virtual Desktops		Windows Pro
Windows IoT Enterprise						Windows Pro
Windows SE [Cloud]						Windows Pro
Windows Pro N for Workstations					Windows Pro N
Windows Pro Education N						Windows Pro N
Windows Education N						Windows Pro N
Windows Enterprise N						Windows Pro N
Windows SE [Cloud] N						Windows Pro N

(Nur auf einem eigenen Installationsmedium erhältlich:
Windows 10 IoT Enterprise LTSC 2021				Windows 10 Enterprise LTSC 2021)

Ein Wechsel zwischen N und Nicht-N-Editionen wurde nicht probiert, davon ist aber generell abzuraten und N-Editionen benutzt sowieso niemand.


Im Umkehrschluss heißt das auch, das eure ISO nur Home, Home N, Pro und Pro N enthalten muss um sämtliche verfügbaren Editionen installieren zu können.
Ein ganz normales Consumer-Installationsmedium erfüllt schon diese Anforderungen.
Sprich: Eine Standard-ISO oder ein Standard-USB-Stick (https://www.microsoft.com/de-de/software-download/windows11) wird mit dieser Batch zu einem All-in-One-Installer.
Im Moment unterstützt das Tool nur die normalen Versionen, keine N/K/China Editionen.
Alle Installationstests wurden mit de-de_windows_11_consumer_editions_version_23h2_updated_feb_2024_x64_dvd_9665512b.iso und einem MediaCreationTool Win11_23H2 USB-Stick als Basis gemacht.

ACHTUNG:
LTSC-Editionen sind NICHT in den normalen Installationsmedien enthalten. Um diese Funktion zu nutzen muss man sich selbst die passende ISO organisieren.
Windows 10 Enterprise LTSC 2021 (und IoT/N) wurden mit de-de_windows_10_enterprise_ltsc_2021_x64_dvd_71796d33.iso getestet.
Fun fact: Die IoT bietet MS nur als englische Version an, man soll entweder ein Language-Pack nutzen oder ein fertig installiertes Nicht-Englisches-Nicht-IoT-LTSC per Key auf IoT upgraden.
Benutzt man dieses Tool und/oder passt sich das Installationsmedium mit abbodi1406's create_virtual_editions.cmd an, erhält man z.B. trotzdem ein deutsches IoT Enterprise LTSC basierend auf offiziellen MS-Quelldateien.
Der Vorinstallations-Key für LTSC 2024 ist zwar auch schon verfügbar (CGK42-GYN6Y-VD22B-BX98W-J8JXD), aber die Edition ist bisher nur eine geleakte technical preview evaluation. Erst nach Tests mit der Final wird der Key zu diesem Tool hinzugefügt.



Changelog:
V0.41
Formatierung gefixt, die Readme sieht jetzt auch auf Gitgub und im Windows-Editor ordentlich aus.
Einige Kommentare in die Batch eingefügt.

V0.40
LTSC 2021 hinzugefügt.

V0.30
N-Editionen hinzugefügt.

V0.21
Keychange-Funktion hinzugefügt.

V0.20
Restliche Nicht-N-Editionen hinzugefügt.

V0.11 Beta
Tests mit einem von MediaCreationTool_Win11_23H2.exe erstellten USB-Stick durchgeführt, anstatt einer install.wim werden dort install.swm/install2.swm genutzt. Klappt auch hier problemlos.
Einige Textänderungen vorgenommen.

V0.10 Beta
Vieles neu formuliert, Infos über verschiedene Editionen hinzugefügt. Tests abgeschlossen, Batch an Ergebnisse angepasst.

V0.01 Alpha
Erster Release. Support für Home/Pro/Pro for Workstations/Enterprise um erst einmal alles zu testen.
