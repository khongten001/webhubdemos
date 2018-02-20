%CSSend% /note "compile-whdemos-db.bat" %CSLogPathParams%

set bdecomp=25
call %~dp0set-compilerdigits.bat
set comp3=D%compilerdigits%
set ibocomp=%compilerdigits%

if NOT "%comp3%%bits%"=="D" goto Continue00

set /P comp3=Enter Pascal Compiler Digits as Number (eg. 23 or 22) :   
if %comp3%=="" goto end
set compilerdigits=%comp3%
set comp3=D%compilerdigits%

:Continue00
set droot=d:\projects\WebHubDemos\Source\WHApps
:: something for those that can compile with latest Delphi, win64
set cbatwin64=d:\projects\webhubdemos\Source\_Control\compile-1demo_win64.bat
if NOT Exist %cbatwin64% %CSSend% /error "[001] %cbatwin64% NOT FOUND" %CSLogPathParams%
if NOT Exist %cbatwin64% pause
:: continue...
if "%demonopackages%"=="yes" goto Continue01
set cbat=d:\projects\webhubdemos\Source\_Control\compile-1demo_win32.bat
if NOT Exist %cbat% %CSSend% /error "[001] %cbat% NOT FOUND" %CSLogPathParams%
if NOT Exist %cbat% pause
goto Continue02

:Continue01
set cbat=d:\projects\webhubdemos\Source\_Control\compile-1demo_win32_nopackages.bat
if NOT Exist %cbat% %CSSend% /error "[001] %cbat% NOT FOUND" %CSLogPathParams%
if NOT Exist %cbat% pause


:Continue02
:: Latest Compiler, win64
:: whLite /id=demos
:: need DEMOS app even on DB server
:: clearing compilerdigits makes it go to the default
set compilerdigits=
call %~dp0\default-compilerdigits.bat
cd /d %droot%\Lite Examples\whAppServer\whLite
call %cbatwin64% whLite

:: Fish Store uses FireDAC September 2014
del %~dp0\..\..\Live\WebHub\Apps\whFishStore.exe /q
if NOT "%compilehtfs%"=="no" cd %droot%\DB Examples\whFishStore
%CSSend% "cbatwin64 for Fish Store" %cbatwin64% %CSLogPathParams%
if NOT "%compilehtfs%"=="no" call %cbatwin64% whFishStore

del %~dp0\..\..\Live\WebHub\Apps\whShopping.exe
set compilerdigits=
call %~dp0\default-compilerdigits.bat
if NOT "%compileshop1%"=="no" cd %droot%\DB Examples\whShopping
if NOT "%compileshop1%"=="no" call %cbatwin64% whShopping

del %~dp0\..\..\Live\WebHub\Apps\whDynamicJPEG.exe
if NOT "%compilejpeg%"=="no" cd %droot%\DB Examples\whDynamicJPEG
if NOT "%compilejpeg%"=="no" call %cbatwin64% whDynamicJPEG

del %~dp0\..\..\Live\WebHub\Apps\whRubicon.exe
if NOT "%compilehtru%"=="no" cd %droot%\Third Party Examples\whRubicon
if NOT "%compilehtru%"=="no" call %cbat% whRubicon

:ContinueDPR
::whDPrefix uses NexusDB not BDE
:: NexusDB v4.004 as of 28-Apr-2014
@del %~dp0\..\..\Live\WebHub\Apps\whDPrefix*.exe 
call %~dp0\called-only-MakeResFile.bat whDPrefix DelphiPrefixRegistry
copy "%droot%\..\TempBuild\res\ver_whDPrefix.RES" "%droot%\Third Party Examples\whDPrefix"
del %droot%\..\TempBuild\res\ver_whDPrefix*
:: Sometimes, use same version of WebHub as CodeNewsFast so libraries are shared
if "%compiledpr%"=="no" goto Continue03
cd %droot%\Third Party Examples\whDPrefix
set compilerdigits=%ibocomp%
%CSSend% "whDPrefix with %compilerdigits%" %CSLogPathParams%
:: whDPrefix needs to compile as-service
call d:\projects\webhubdemos\Source\_Control\compile-1demo_win64_svc.bat whDPrefix
REM call d:\projects\webhubdemos\Source\_Control\compile-1demo_win64_nopackages.bat whDPrefix

:::::::::::::::::::::::::::::::
:: Now demos which use IBObjects
:::::::::::::::::::::::::::::::
:Continue03
%CSSend% /note "IBObjects required" %CSLogPathParams%

set compilerdigits=%ibocomp%
set bits=64
set cbat=d:\projects\webhubdemos\Source\_Control\compile-1demo_win%bits%.bat

::whFirebird uses IBObjects 
del %~dp0\..\..\Live\WebHub\Apps\whFirebird.exe
if NOT "%compilefire%"=="no" cd %droot%\DB Examples\whFirebird
if NOT "%compilefire%"=="no" call %cbatwin64% whFirebird

:: whQuery2 uses IBObjects not BDE
del %~dp0\..\..\Live\WebHub\Apps\whQuery2.exe /q
if "%compilehtq2%"=="" %CSSend% /error "compilehtq2 is blank" %CSLogPathParams%
if "%compilehtq2%"=="" pause
if NOT "%compilehtq2%"=="no" cd %droot%\DB Examples\whQuery2
if NOT "%compilehtq2%"=="no" call %cbatwin64% whQuery2

:: democoderage
:: whSchedule uses IBObjects and Rubicon, no BDE
del %~dp0\..\..\Live\WebHub\Apps\whSchedule.exe /q
if NOT "%compilecoderage%"=="no" cd %droot%\DB Examples\whSchedule
if NOT "%compilecoderage%"=="no" call %cbatwin64% whSchedule



:::::::::::::::::::::::::::::::
:: Now BDE which requires win32
:::::::::::::::::::::::::::::::

%CSSend% /note "BDE required" %CSLogPathParams%

set compilerdigits=%bdecomp%
set bits=32
set cbat=d:\projects\webhubdemos\Source\_Control\compile-1demo_win32.bat

:: whQuery1 uses BDE
del %~dp0\..\..\Live\WebHub\Apps\whQuery1.exe /q
if "%compilehtq1%"=="" %CSSend% /error "compilehtq1 is blank. Start from Database-step00-compile-win32." %CSLogPathParams%
if "%compilehtq1%"=="" pause
if NOT "%compilehtq1%"=="no" cd %droot%\DB Examples\whQuery1
if NOT "%compilehtq1%"=="no" call %cbat% whQuery1

:: whQuery3 uses BDE
del %~dp0\..\..\Live\WebHub\Apps\whQuery3.exe /q
if "%compilehtq3%"=="yes" cd %droot%\DB Examples\whQuery3
if "%compilehtq3%"=="yes" call %cbat% whQuery3

:: whQuery4 uses BDE
del %~dp0\..\..\Live\WebHub\Apps\whQuery4.exe /q
if NOT "%compilehtq4%"=="no" cd %droot%\DB Examples\whQuery4
if NOT "%compilehtq4%"=="no" call %cbat% whQuery4

:: whClone uses BDE
del %~dp0\..\..\Live\WebHub\Apps\whClone.exe /q
if NOT "%compilehtcl%"=="no" cd %droot%\DB Examples\whClone
if NOT "%compilehtcl%"=="no" call %cbat% whClone

:: whLoadFromDB relies on some properties on the BDE webapp object
del %~dp0\..\..\Live\WebHub\Apps\whLoadFromDB.exe
if NOT "%compiledbhtml%"=="no" cd %droot%\DB Examples\whLoadFromDB
if NOT "%compiledbhtml%"=="no" call %cbat% whLoadFromDB

:: whInstantForm requires BDE
del %~dp0\..\..\Live\WebHub\Apps\whInstantForm.exe
if NOT "%compilehtfm%"=="no" cd %droot%\DB Examples\whInstantForm
if NOT "%compilehtfm%"=="no" call %cbat% whInstantForm

:: whScanTable uses bde
del %~dp0\..\..\Live\WebHub\Apps\whScanTable.exe
if NOT "%compilescan%"=="no" cd %droot%\DB Examples\whScanTable
if NOT "%compilescan%"=="no" call %cbat% whScanTable

goto end

:END
echo on
%CSSend% "Complete" %CSLogPathParams%
%CSSend% "intentional pause..." %CSLogPathParams%
dir %~dp0\..\TempBuild\*.csl
pause
