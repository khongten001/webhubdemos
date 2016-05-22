set CSSend=D:\Apps\HREFTools\MiscUtil\CodeSiteConsole.exe
set compilerflagsplus=CodeSite;

%CSSend% /note "compile-standalone.bat EMail_with_StartTLS" %CSLogPathParams%

cd %~dp0\..\StandaloneDemos\EMail_with_StartTLS

del %~dp0\..\..\Live\WebHub\Apps\Test_Indy*.exe

set compilerdigits=22
call %~dp0\compile-1demo_win32_nopackages.bat Test_Indy_Smtp
ren %~dp0\..\..\Live\WebHub\Apps\Test_Indy_Smtp.exe Test_Indy_Smtp_D%compilerdigits%.exe
if errorlevel 1 pause

set compilerdigits=24
call %~dp0\compile-1demo_win32_nopackages.bat Test_Indy_Smtp
ren %~dp0\..\..\Live\WebHub\Apps\Test_Indy_Smtp.exe Test_Indy_Smtp_D%compilerdigits%.exe
if errorlevel 1 pause

set compilerflagsplus=
