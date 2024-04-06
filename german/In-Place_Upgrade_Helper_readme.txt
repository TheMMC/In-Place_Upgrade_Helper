# In-Place_Upgrade_Helper
Helper-Tool für Windows 10/11 In-Place-Upgrades und Editionswechsel

Geht euch das auch auf den Sack, wenn das Windows-Setup selbst entscheidet, was es machen soll?
Ihr wollt Pro installieren, aber das Setup springt automatisch auf Home, weil der Key in der Firmware hinterlegt ist?
Ihr wollte von der Pro auf Pro for Workstations upgraden aber habt gerade kein GLVK-Key zur Hand?
Habt ihr Pro installiert aber merkt erst hinterher, das ihr nur eine Lizenz für Home habt aber seid zu faul für ein Clean-Install?
Ihr wollt Home direkt auf Enterprise upgraden, da es technisch nichts anderes ist als ein Upgrade auf Pro, aber rein aus Lizenzgründen lässt es das Setup nicht zu?
Dabei merkt ihr, das die Enterprise-Edition eigentlich gar nicht auf eurer Consumer-ISO / auf eurem MediaCreationTool-USB-Stick drauf ist?
Ihr wollt von Pro Education zurück zur Pro, aber es gibt keinen Up- und Downgrade-Pfad? https://learn.microsoft.com/en-us/windows/deployment/upgrade/windows-edition-upgrades
Neuinstallationen habt ihr mit angepasster EI.cfg im Griff aber (In-Place-)Upgrades geben euch keine Editionsauswahl?
Ihr wollte ohne Bastelei und Modifikationen an der WIM ein (beinahe) All-In-One Installationsmedium bauen?

Dieses Tool schafft Abhilfe.
Für die genaue Funktionsweise einfach in die Batch reingucken. Dies ist kein Aktivierungstool, es werden ausschließlich offizielle Vorinstallations-Keys genutzt.
Diese Batch einfach zu der setup.exe in das Installationsmedium kopieren oder einzeln starten und den Pfad zum Installationsmedium angeben.

Sollte auf dem Installationsmedium die passende Version nicht vorhanden sein, ist das Setup in der Lage das passende Image on-the-fly zu generieren.
Höchstwahrscheinlich ist das die selbe Funktion, die DISM /Get-TargetEditions und DISM /Set-Edition nutzt (https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/change-the-windows-image-to-a-higher-edition-using-dism?view=windows-11).
Das ist die Methode, mit der z.B. https://uupdump.net/ aus den beiden Home und Pro Editionen alle anderen Editionen generieren kann (create_virtual_editions.cmd, https://github.com/abbodi1406/BatUtil/tree/master/uup-converter-wimlib)
Dies wurde mit einer WIM getestet, in der nur Home verfügbar war, aber das Setup mit Pro-Key gestartet wurde. Hier startete wie erwartet trotzdem das Home-Setup.
Dann wurde zu der WIM die Pro hinzugefügt, mehr aber nicht. Danach wurde Setup noch einmal mit dem Pro-Key gestartet, jetzt erscheint das richtige Pro-Setup.
Das Setup wurde abgebrochen und jetzt mit einem Pro for Workstations-Key gestartet. Das Setup generierte jetzt Pro for Workstations automatisch aus der Pro.
Als nächster Test wurde die Enterprise mit einer Consumer-ISO (de-de_windows_11_consumer_editions...iso) installiert, die eigentlich gar keine Enterprise hat. Das Setup hat auch diese aus der Pro generiert, wenn man den passenden Key als Parameter nimmt.
Alle Test wurden online durchgeführt.

Das ergibt folgende Upgrade-Tabelle:

Moegliche Edition zum Installieren            Benoetigte Edition im Installationsmedium

Windows Pro                                   Windows Pro
Windows Pro for Workstations                  Windows Pro
Windows Education                             Windows Pro
Windows Pro Education                         Windows Pro
Windows Enterprise                            Windows Pro
Windows Enterprise multi-session              Windows Pro
Windows IoT Enterprise                        Windows Pro
Windows SE [Cloud] (Nur Win11)                Windows Pro
Windows Home                                  Windows Home
Windows Home Single Language                  Windows Home
Windows Pro N                                 Windows Pro N
Windows Pro N for Workstations                Windows Pro N
Windows Education N                           Windows Pro N
Windows Pro Education N                       Windows Pro N
Windows Enterprise N                          Windows Pro N
Windows SE [Cloud] N (Nur Win11)              Windows Pro N
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


Im Umkehrschluss heißt das auch, das eure ISO nur Home, Home N, Pro und Pro N enthalten muss um sämtliche verfügbaren Editionen (ohne LTSC) installieren zu können.
Ein ganz normales Consumer-Installationsmedium erfüllt schon diese Anforderungen.
Sprich: Eine Standard-ISO oder ein Standard-USB-Stick (https://www.microsoft.com/de-de/software-download/windows11) wird mit dieser Batch zu einem All-in-One-Installer.
Im Moment unterstützt das Tool nicht die Home China Edition.
Alle Installationstests wurden mit de-de_windows_11_consumer_editions_version_23h2_updated_feb_2024_x64_dvd_9665512b.iso und einem MediaCreationTool Win11_23H2 USB-Stick als Basis gemacht.

ACHTUNG:
LTSC-Editionen sind NICHT in den normalen Installationsmedien enthalten. Um diese Funktion zu nutzen muss man sich selbst die passende ISO organisieren.
Das selbe gilt natürlich auch für Server 2022.
Windows 10 Enterprise LTSC 2021 (und IoT/N) wurden mit de-de_windows_10_enterprise_ltsc_2021_x64_dvd_71796d33.iso getestet.


Changelog:
v0.90
LTSC 2024 und Server 2025 hinzugefügt. Design optimiert (hoffe ich, ich bin schlecht in sowas).
Chinesische Übersetzung entfernt, ich kann nicht supporten, was ich nicht mal ansatzweise verstehe...

v0.80 Re-Upload
Github hat selbstständig an den end-of-line-Zeichen rumgefummelt, konkret CRLF nach LF. Dumm nur, das Windows-Batches in CRLF daherkommen UND DADURCH AUCH GERNE MAL KAPUTT GEHEN.
Eigenschaften des Repositories angepasst und die Dateien mit korrekter Formatierung neu hochgeladen.
Großen Dank Fox2k11 für's Melden. Ich hasse Github.

v0.80
Editionstabelle als Willkommensbildschirm hinzugefügt, danach werden dann noch die Editionen auf dem Installationsmedium angezeigt.

v0.72
Die Fenstergröße wird jetzt beim Start festgelegt. Auf einigen Systemen fehlte beim Start die Hälfte des Textes.
Das Hauptmenü wurde etwas lesbarer gestaltet.

V0.71
Jetzt mit Server 2022

V0.70
Danke an LizenzFass78851 für den Codeschnipsel zum auslesen der gerade laufenden Windows-Edition und der etwas sichereren Methode Adminrechte zu holen.
Tekkie Boy aus dem Deskmodder-Forum hat noch einen Bug gemeldet, der den Registry-Eintrag CompositionEditionID betrifft. Das erzwungene Upgrade setzt jetzt auch diesen Eintrag.

V0.60
Readme Lesen scheint out zu sein, viele kopieren dieses Tool nicht in ein Installationsmedium sondern starten es einzeln und wundern sich dann über Fehler.
Jetzt wird auf Vorhandensein von setup.exe und dem Ordner sources geprüft, wenn irgendetwas fehlt kann man jetzt auch externe Pfade als Installationsquelle angeben (z.B. ein gemountetes ISO).
"Inplace" in "In-Place" geändert. Microsoft selbst spricht von "In-Place", "Inplace" macht auch im Englischen keinen Sinn.

V0.50
skycommand war so freundlich und hat mein Gossen-Englisch korrigiert und eine ordentliche readme.md gebaut, besten Dank dafür!
Erwzungenes Upgrade ist jetzt kein Schalter mehr sondern ein eigener Menüpunkt.
Einiges neu formatiert, das Menü sieht jetzt etwas übersichtlicher aus.
Sollten sich keine Fehler eingeschlichen haben wird diese Version die Vorlage für die englische Übersetzung.

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
