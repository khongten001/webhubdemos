::change to folder containing this bat file
cd %~dp0


::delete the session data for the quality-assurance test run
del c:\temp\whSessions\1204.var
del d:\temp\whSessions\1204.var

::start the WebHub showcase demo
start whLite.exe /ID=showcase 
