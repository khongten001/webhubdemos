set /P comp3=Enter Pascal Compiler Code in UPPERCASE (eg. D15 or D16) :   
if %comp3%=="" goto end


set cbat=D:\Projects\webhubdemos\Source\_Control\compile-1demo_%comp3%_win32.bat
set droot=\projects\WebHubDemos\Source\WHApps
d:

DEL D:\Projects\webhubdemos\Live\WebHub\Apps\DServerD1*.exe /q

cd %droot%\Lite Examples\whAppServer\whLite
call %cbat% whLite

cd %droot%\Lite Examples\whAppServer\aserver
call %cbat% aserver

cd %droot%\Lite Examples\whAppServer\dserver

:: as-service
set cbat=D:\Projects\webhubdemos\Source\_Control\compile-1demo_%comp3%_win32_svc.bat
call %cbat% dserver
REN D:\Projects\webhubdemos\Live\WebHub\Apps\dserver.exe DServer%comp3%svc.exe

set cbat=D:\Projects\webhubdemos\Source\_Control\compile-1demo_%comp3%_win32.bat
call %cbat% dserver
REN D:\Projects\webhubdemos\Live\WebHub\Apps\dserver.exe DServer%comp3%.exe
call D:\Projects\webhubdemos\Source\_Control\compile-1demo_%comp3%_win32_nopackages.bat dserver
REN D:\Projects\webhubdemos\Live\WebHub\Apps\dserver.exe DServer%comp3%_win32_NoPackages.exe

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
call d:\projects\compile-1demo_%comp3%_win32_svc.bat whStopspam

cd %droot%\More Examples\whText2Table
call %cbat% whText2Table

:END
