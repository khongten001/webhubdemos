set cbat=D:\Projects\webhubdemos\Source\_Control\compile-1demoD15.bat
set droot=\projects\WebHubDemos\Source\WHApps
d:


DEL D:\Projects\webhubdemos\Live\WebHub\Apps\DServerD15*.exe /q
DEL D:\Projects\webhubdemos\Live\WebHub\Apps\DServerD07*.exe /q

cd %droot%\Lite Examples\whAppServer\whLite
call %cbat% whLite

cd %droot%\Lite Examples\whAppServer\aserver
call %cbat% aserver

cd %droot%\Lite Examples\whAppServer\dserver
call %cbat% dserver
REN D:\Projects\webhubdemos\Live\WebHub\Apps\dserver.exe DServerD15.exe
call D:\Projects\webhubdemos\Source\_Control\compile-1demoD15nopackages.bat dserver
REN D:\Projects\webhubdemos\Live\WebHub\Apps\dserver.exe DServerD15NoPackages.exe

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
::call d:\projects\compile-1demosvcD07.bat whStopspam
call d:\projects\compile-1demosvcD15.bat whStopspam

cd %droot%\More Examples\whText2Table
call %cbat% whText2Table

:END
