setlocal

:: set zmcontext variable
call %ZaphodsMap%zmset.bat zmcontext AsDefaultContext
set compilerdigits=23

::change to folder containing this bat file
cd /d %~dp0

::start the WebHub advertising demo
if     "%zmcontext%"=="NYX" start DServer_x_d%compilerdigits%_win64.exe /ID=adv
if NOT "%zmcontext%"=="NYX" start whLite.exe /ID=adv
