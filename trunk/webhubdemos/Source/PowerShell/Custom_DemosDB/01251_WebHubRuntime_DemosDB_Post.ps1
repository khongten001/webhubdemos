# After WebHubRuntime and WebHubDemos have been installed
# Copyright 2015 HREF Tools Corp. 
# Creative Commons license - keep credits intact.

# call a separate script to init global variables.
Invoke-Expression ($PSScriptRoot + '\..\WebHub_Appliance_PS\Initialize.ps1')  # loops back and uses custom values

if (! (Test-Path ($env:USERPROFILE + '\Documents\WindowsPowerShell\Modules\Mod_IIS_Setup'))) { 
	mkdir ($env:USERPROFILE + '\Documents\WindowsPowerShell\Modules\Mod_IIS_Setup')
}
copy ($PSScriptRoot + '\..\WebHub_Appliance_PS\Mod_IIS_Setup.psm1')   $env:USERPROFILE\Documents\WindowsPowerShell\Modules\Mod_IIS_Setup\Mod_IIS_Setup.psm1
Import-Module Mod_IIS_Setup

# Disable Data Execution Prevention (for Hub, runner plus all custom WebHub EXEs)
Start-Process 'bcdedit.exe' -ArgumentList '/set nx OptIn'

$AWebSite = "IIS:\Sites\WebHubDemos"
$InfoMsg = 'VirtualDirectory "/seleniumgridoutput"'
Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 
echo $InfoMsg
if (! (Test-Path D:\Apps\Selenium\HREFTools\test-output)) { mkdir D:\Apps\Selenium\HREFTools\test-output }
New-Item ($AWebSite +'\seleniumgridoutput') -physicalPath 'D:\Apps\Selenium\HREFTools\test-output' -type VirtualDirectory

Start-Process 'iisreset' -NoNewWindow -Wait

StartHttpRunnerEcho 'local-db.demos.href.com' 'scripts' $True $True  # Yes new ipc; Yes 32bit

# Live\Library\*.bpl
Invoke-Expression ($PSScriptRoot + "\01253_WebHubRuntime_DemosDB_LibraryPath.ps1")

$InfoMsg = ('"WebHub Connection Layer has been reset; Done adjusting" ' + $Filespec)
Start-Process $Global:CSConsole -ArgumentList $InfoMsg -Wait -NoNewWindow 
echo $InfoMsg

