# ReliableReboot_ServerStartup
# for HREF-Rack Server

# To start Task Scheduler on a system with no obvious shortcut for it, run taskschd.msc   (works regardless of language of Windows)

Invoke-Expression ($PSScriptRoot + '\..\WebHub_Appliance_PS\Initialize.ps1')  # loops back and uses custom values

$Bat = "D:\ServerControl\start-hrefrack-server.bat"
$A = New-ScheduledTaskAction –Execute $Bat
$T = New-ScheduledTaskTrigger -AtLogon
$S = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable
$D = New-ScheduledTask -Action $A -Trigger $T -Settings $S
Register-ScheduledTask -TaskName "Server Startup" -InputObject $D

$InfoMsg = ('"AutoStart" "server-startup.bat"')
Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow -Wait
Write-Output $InfoMsg
