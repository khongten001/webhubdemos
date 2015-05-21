setlocal
@echo off

::delete the session data for the quality-assurance test run
del c:\temp\whSessions\1204.var
del d:\temp\whSessions\1204.var

::change to folder containing this bat file
cd %~dp0


set /P whappid=Enter WebHub AppID in lowercase :  
if "%whappid%"=="" goto end
set demoparams="/ID=%whappid%"

echo Demo params: %demoparams%

set /P isdebug=Debug version? (y/n) :  
if "%isdebug%"=="" goto end
if "%isdebug%"=="y" set exename=DServer_x_d20_win32_debug.exe
if "%isdebug%"=="n" set exename=whLite.exe

echo exename is %exename%

set /P qty=Enter Number of instances to start (eg. 1, 3, 5, 10, 20, 30) :  
if "%qty%"=="" goto end
echo Qty %qty%
goto start%qty%

::start the WebHub advertising demo
::start %exename% /ID=adv 

:start1
start %exename% %demoparams%
goto end

:start3
for %%A IN (1 2 3) DO call run-1.bat %exename% %demoparams%
goto end

:start5
for %%A IN (1 2 3 4 5) DO call run-1.bat %exename% %demoparams%
goto end

:start10
for %%A IN (0 1 2 3 4 5 6 7 8 9) DO call run-1.bat %exename% %demoparams%
goto end

:start20
FOR %%I IN (1 2) DO for %%J IN (0 1 2 3 4 5 6 7 8 9) DO call run-1.bat %exename% %demoparams%
goto end

:start30
FOR %%I IN (1 2 3) DO for %%J IN (0 1 2 3 4 5 6 7 8 9) DO call run-1.bat %exename% %demoparams%
goto end

:end
endlocal
