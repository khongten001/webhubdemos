del c:\temp\whSessions\1204.var
del d:\temp\whSessions\1204.var

::change to folder containing this bat file
cd %~dp0

::start the WebHub showcase demo 
start dserverD07nopackages.exe /ID=showcase 

