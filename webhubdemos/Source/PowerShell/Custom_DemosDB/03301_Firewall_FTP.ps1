# Firewall adjustments for FTP access

# call a separate script to init global variables.
Invoke-Expression ($PSScriptRoot + '\..\WebHub_Appliance_PS\Initialize.ps1')  # loops back and uses custom values

# https://technet.microsoft.com/en-us/library/jj554908.aspx
New-NetFirewallRule -DisplayName ("FTP port 21 ") -Direction Inbound -Action Allow -Protocol TCP -LocalPort 21
New-NetFirewallRule -DisplayName ("FTP secure port 990 ") -Direction Inbound -Action Allow -Protocol TCP -LocalPort 990
New-NetFirewallRule -DisplayName ("FTP port 8021-8041 ") -Direction Inbound -Action Allow -Protocol TCP -LocalPort 8021-8041
Start-Process $Global:CSConsole -ArgumentList '"Firewall: FTP Ports Opened" "21, 990, 8021-8041"'  -NoNewWindow 



