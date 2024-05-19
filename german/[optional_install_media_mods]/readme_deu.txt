Dieses Script macht folgendes:
-integriert die EI.CFG und erzwingt bei Neuinstallationen das Editionsauswahl-Menue, auch wenn eine Lizenz in der Firmware gefunden wurde
-entfernt Installationsvoraussetzungen wie TPM oder secure boot indem die passenden Reg-Keys in die boot.wim geschrieben werden
-entfernt den MS-Account-Zwang, sogar fuer Windows Home. Einfach ohne Internet installieren.
-kopiert eine aufgeblasene unattend.xml nach sources\$OEM$\$$\Panther, welche Folgendes beim ersten Neustart macht:
	-entfernt Installationsvoraussetzungen wie TPM oder secure boot, indem die passenden Reg-Keys in die Windows-Registry geschrieben werden
	-deaktiviert Werbung, Empfehlungen, Vorschlaege und Auto-Installation von Apps (Spotify, Candy Crush, MS Teams etc.) fuer neue Benutzer (bei Neuinstallationen sind das dann alle Benutzer)
	-deaktiviert die automatische Bitlocker Festplattenverschluesselung waehrend des Setups

Alles wird mit offiziellen Registry-Keys gemacht, keine Hacks die zukuenftige Updates stoeren koennten.

NUR sources\$OEM$\$$\Panther\unattend.xml WIRD UNTERSTUETZT!
autounattend.xml im root Ordner oder Aehnliches blockiert In-Place_Upgrade_Helper.bat!


unattend.xml basiert auf einer xml von: https://schneegans.de/windows/unattend-generator/
