setlocal

:: set zmcontext variable
call d:\AppsData\WinNT\bat\set-zmcontext.bat

::change to folder containing this bat file
cd %~dp0

::start the WebHub overview demo
if     "%zmcontext%"=="NYX" start DServer_x_d18_win64.exe /ID=demos
if NOT "%zmcontext%"=="NYX" start whLite.exe /ID=demos 

