# Delphi Redist files for WebHubDemos
# Copyright 2014-2017 HREF Tools Corp. 
# Creative Commons license - keep credits intact.

# call a separate script to init global variables.
Invoke-Expression ($PSScriptRoot + "\Initialize.ps1")

$InfoMsg = ('/note "Delphi Redist Files for WebHubDemos"')
Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 

$Global:FlagRedistWin64 = "1"
if     ($Global:ZMGlobalContext -eq 'DEMOS') { $Global:FlagRedistWin32 = "1" }
elseif ($Global:ZMGlobalContext -eq 'DORIS') { $Global:FlagRedistWin32 = "0" }

# The following script is available at riouxsvn.  Create an account there and ask HREF Tools Customer Support to 
# add you to the team list for access.
Invoke-Expression ($PSScriptRoot + "\01403_D25_Redist_BPLs.ps1")


