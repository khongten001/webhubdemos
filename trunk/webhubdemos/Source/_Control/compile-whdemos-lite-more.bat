@echo off
set /P comp3=Enter Pascal Compiler Code in UPPERCASE (eg. D15 or D16) :   
if %comp3%=="" goto end
if %comp3%==D15 set bits=32
if %comp3%==D15 goto DServerContinue00
set /P bits=Enter 32 or 64 for win32 or win64 :   
if %bits%=="" goto end

:DServerContinue00
set cbat=D:\Projects\webhubdemos\Source\_Control\compile-1demo_%comp3%_win%bits%.bat
set droot=\projects\WebHubDemos\Source\WHApps
d:

DEL D:\Projects\webhubdemos\Live\WebHub\Apps\DServer*.exe /q

cd %droot%\Lite Examples\whAppServer\whLite
call %cbat% whLite

cd %droot%\Lite Examples\whAppServer\aserver
call %cbat% aserver

cd %droot%\Lite Examples\whAppServer\dserver

:: as-service
set cbat=D:\Projects\webhubdemos\Source\_Control\compile-1demo_%comp3%_win%bits%_svc.bat
call %cbat% dserver
REN D:\Projects\webhubdemos\Live\WebHub\Apps\dserver.exe DServer%comp3%svc.exe

:DServerContinue01
set cbat=D:\Projects\webhubdemos\Source\_Control\compile-1demo_%comp3%_win%bits%.bat
call %cbat% dserver
REN D:\Projects\webhubdemos\Live\WebHub\Apps\dserver.exe DServer%comp3%.exe
call D:\Projects\webhubdemos\Source\_Control\compile-1demo_%comp3%_win%bits%_nopackages.bat dserver
REN D:\Projects\webhubdemos\Live\WebHub\Apps\dserver.exe DServer%comp3%_win%bits%_NoPackages.exe
if errorlevel 1 pause

cd %droot%\More Examples\whCOM
call %cbat% whCOM

cd %droot%\More Examples\whASyncDemo
call %cbat% whASyncDemo

cd %droot%\More Examples\whDfm2html
call %cbat% f2hdemo

cd %droot%\More Examples\whDropdown
call %cbat% whDropdown

cd %droot%\More Examples\whConverter
call %cbat% whConverter

cd %droot%\More Examples\whDynamicJPEG
call %cbat% whDynamicJPEG

cd %droot%\More Examples\whOutline
call %cbat% whOutline

cd %droot%\More Examples\whObjectInspector
call %cbat% whObjectInspector

cd %droot%\More Examples\whSendmail
call %cbat% whSendmail

cd %droot%\More Examples\whStopspam
call d:\projects\compile-1demo_%comp3%_win%bits%_svc.bat whStopspam

cd %droot%\More Examples\whText2Table
call %cbat% whText2Table

:END
