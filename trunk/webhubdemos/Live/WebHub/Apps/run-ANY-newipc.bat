setlocal
@echo off

::change to folder containing this bat file
cd %~dp0


set /P whappid=Enter WebHub AppID in lowercase :  
if "%whappid%"=="" goto end
set demoparams="/ID=%whappid%"

echo Demo params: %demoparams%

set /P isdebug=Debug version? (Y/N) :  
if "%isdebug%"=="" goto end
if "%isdebug%"=="Y" set exename=DServer_x_d15_win32_debug.exe
if "%isdebug%"=="N" set exename=DServer_x_d15_win32.exe

echo %exename%

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
