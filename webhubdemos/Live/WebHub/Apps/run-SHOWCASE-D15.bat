::delete the session data for the quality-assurance test run
del c:\temp\whSessions\1204.var

::change to folder containing this bat file
cd %~dp0

::start the WebHub showcase demo
start dserverD15.exe /ID=showcase 

