@echo off
set CSSend=D:\Apps\HREFTools\MiscUtil\CodeSiteConsole.exe
%CSSend% /note "compile-whdemos-lite-more.bat" %CSLogPathParams%

if NOT "%comp3%%bits%"=="" goto LiteServerContinue00

set /P comp3=Enter Pascal Compiler Digits as NUMBER (eg. 18 or 20) :   
if %comp3%=="" goto end
set compilerdigits=%comp3%
set comp3=D%compilerdigits%
if %compilerdigits%==15 set bits=32
if %compilerdigits%==15 goto LiteServerContinue00
set /P bits=Enter 32 or 64 for win32 or win64 :   
if %bits%=="" goto end

:LiteServerContinue00
set cbat=D:\Projects\webhubdemos\Source\_Control\compile-1demo_win%bits%.bat
if NOT Exist %cbat% %CSSend% /error "%cbat% NOT FOUND" %CSLogPathParams%
if NOT Exist %cbat% pause
set droot=\projects\WebHubDemos\Source\WHApps
d:

@DEL D:\Projects\webhubdemos\Live\WebHub\Apps\AServer*.exe /q
@DEL D:\Projects\webhubdemos\Live\WebHub\Apps\CServer*.exe /q

cd "%droot%\Lite Examples\whAppServer\whLite"
call %cbat% whLite

cd "%droot%\Lite Examples\whAppServer\aserver"
call %cbat% aserver

:CompileCServerADV
cd "%droot%\Lite Examples\whAppServer\cserver"
set servicename=adv
call MakeCServerVersionResource.bat
copy cserver_adv_version.res cserver_version.res
call %cbat% cserver
REN D:\Projects\webhubdemos\Live\WebHub\Apps\cserver.exe CServer_%servicename%.exe
if errorlevel 1 %CSSend% /error "[02] Rename cserver.exe failed for %servicename%" %CSLogPathParams%

:CompileCServerHTSC
cd "%droot%\Lite Examples\whAppServer\cserver"
set servicename=htsc
call MakeCServerVersionResource.bat
copy cserver_htsc_version.res cserver_version.res
call %cbat% cserver
REN D:\Projects\webhubdemos\Live\WebHub\Apps\cserver.exe CServer_%servicename%.exe
if errorlevel 1 %CSSend% /error "[02] Rename cserver.exe failed for %servicename%" %CSLogPathParams%

:asyncdemo
:: set bits=32
cd %droot%\More Examples\whASyncDemo
call %cbat% whASyncDemo
:: set bits=64

cd %droot%\More Examples\whDropdown
call %cbat% whDropdown

%CSSend% "next app to compile" whConverter %CSLogPathParams%
%CSSend% "cbat" "%cbat%" %CSLogPathParams%
cd %droot%\More Examples\whConverter
call %cbat% whConverter

cd %droot%\More Examples\whOutline
call %cbat% whOutline

cd %droot%\More Examples\whOpenID
call %cbat% whOpenID

cd %droot%\More Examples\whObjectInspector
call %cbat% whObjectInspector

cd %droot%\More Examples\whSendmail
call %cbat% whSendmail

cd %droot%\More Examples\whStopspam
::call D:\Projects\webhubdemos\Source\_Control\compile-1demo_win%bits%_svc.bat whStopspam
call %cbat% whStopspam

cd %droot%\More Examples\whText2Table
call %cbat% whText2Table

:END
