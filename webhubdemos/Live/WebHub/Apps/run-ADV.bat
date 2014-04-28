setlocal

:: set zmcontext variable
call d:\AppsData\WinNT\bat\set-zmcontext.bat
set compilerdigits=20

::change to folder containing this bat file
cd %~dp0

::start the WebHub advertising demo
if     "%zmcontext%"=="NYX" start DServer_x_d%compilerdigits%_win64.exe /ID=adv
if NOT "%zmcontext%"=="NYX" start whLite.exe /ID=adv
