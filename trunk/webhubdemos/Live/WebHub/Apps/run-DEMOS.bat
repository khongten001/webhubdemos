setlocal

:: set zmcontext variable
call %ZaphodsMap%zmset.bat zmcontext AsDefaultContext
set compilerdigits=25

::change to folder containing this bat file
cd /D %~dp0

::start the WebHub overview demo
if     "%zmcontext%"=="ultraann"	goto %zmcontext%
goto others

:ultraann
start whlite_x_d25_win64_src.exe /ID=demos
goto end

:others
start whLite /ID=demos

:end

