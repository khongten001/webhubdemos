del c:\temp\whSessions\1204.var
del d:\temp\whSessions\1204.var

::change to folder containing this bat file
cd %~dp0

::start the WebHub data entry form demo
start DServerD15.exe /ID=form 
