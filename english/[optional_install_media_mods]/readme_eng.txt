This script does the following:
-copy EI.CFG to force the setup to let you choose your edition for a clean installation, even if a license is found in the firmware
-remove installation requirements such as TPM or secure boot by adding the appropriate registry keys to boot.wim
-remove MS-account requirements, even for Windows Home. Just disconnect internet during setup.
-copy a souped up unattend.xml to sources\$OEM$\$$\Panther that does the following after the first boot:
	-remove installation requirements such as TPM or secure boot by adding the appropriate registry keys to Windows
	-disable ads, suggestions, recommendations and auto-installation of apps (Spotify, Candy Crush, MS Teams etc.) for new users (in case of a clean install this applies to all users)
	-disables automatic Bitlocker drive encryption during setup

Everything is done with official registry keys, no hacks that might mess up future updates.

ONLY sources\$OEM$\$$\Panther\unattend.xml IS SUPPORTED!
autounattend.xml in root folder or similar breaks In-Place_Upgrade_Helper.bat!


unattend.xml was based on a xml made with: https://schneegans.de/windows/unattend-generator/
