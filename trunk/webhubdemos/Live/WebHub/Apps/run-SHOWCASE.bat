setlocal

:: set zmcontext variable
call d:\AppsData\WinNT\bat\set-zmcontext.bat

::change to folder containing this bat file
cd %~dp0

::delete the session data for the quality-assurance test run
del c:\temp\whSessions\1204.var
del d:\temp\whSessions\1204.var

::start the WebHub showcase demo
if     "%zmcontext%"=="NYX" start DServer_x_d18_win64.exe /ID=showcase
if NOT "%zmcontext%"=="NYX" start whLite.exe /ID=showcase 
