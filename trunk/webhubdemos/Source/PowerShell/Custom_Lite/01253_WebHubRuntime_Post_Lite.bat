:: This runs the PowerShell .ps1 file whose name matches the name of THIS BAT file.
:: Credit: http://www.howtogeek.com/204088/how-to-use-a-batch-file-to-make-powershell-scripts-easier-to-run/

@ECHO OFF
PowerShell.exe -Command "& '%~dpn0.ps1'"
PAUSE

