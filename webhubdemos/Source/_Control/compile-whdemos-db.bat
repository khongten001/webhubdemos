set CSSend=P:\AllHREFToolsProducts\Pak\AllSetupProduction\PakUtilities\CodeSiteConsole.exe
%CSSend% /note "compile-whdemos-db.bat"

set compilerdigits=20
set comp3=D%compilerdigits%

if NOT "%comp3%%bits%"=="" goto Continue00

set /P comp3=Enter Pascal Compiler Digits as Number (eg. 20 or 22) :   
if %comp3%=="" goto end
set compilerdigits=%comp3%
set comp3=D%compilerdigits%

:Continue00
set droot=d:\projects\WebHubDemos\Source\WHApps
if "%demonopackages%"=="yes" goto Continue01
set cbat=d:\projects\webhubdemos\Source\_Control\compile-1demo_win32.bat
if NOT Exist %cbat% %CSSend% /error "[001] %cbat% NOT FOUND"
if NOT Exist %cbat% pause
goto Continue02

:Continue01
set cbat=d:\projects\webhubdemos\Source\_Control\compile-1demo_win32_nopackages.bat
if NOT Exist %cbat% %CSSend% /error "[001] %cbat% NOT FOUND"
if NOT Exist %cbat% pause


:Continue02
:: need DEMOS app even on DB server
:: clearing compilerdigits makes it go to the default
set compilerdigits=
set bits=64
set cbat=d:\projects\webhubdemos\Source\_Control\compile-1demo_win%bits%.bat
cd /d %droot%\Lite Examples\whAppServer\whLite
call %cbat% whLite
set bits=32
set compilerdigits=20
set cbat=d:\projects\webhubdemos\Source\_Control\compile-1demo_win%bits%.bat

:: whQuery1 uses BDE
del %~dp0\..\..\Live\WebHub\Apps\whQuery1.exe /q
if "%compilehtq1%"=="" %CSSend% /error "compilehtq1 is blank. Start from Database-step00-compile-win32."
if "%compilehtq1%"=="" pause
if NOT "%compilehtq1%"=="no" cd %droot%\DB Examples\whQuery1
if NOT "%compilehtq1%"=="no" set compilerdigits=20
if NOT "%compilehtq1%"=="no" call %cbat% whQuery1

:: whQuery2 uses IBObjects not BDE
set compilerdigits=
call %~dp0\default-compilerdigits.bat
del %~dp0\..\..\Live\WebHub\Apps\whQuery2.exe /q
if "%compilehtq2%"=="" %CSSend% /error "compilehtq2 is blank"
if "%compilehtq2%"=="" pause
if NOT "%compilehtq2%"=="no" cd %droot%\DB Examples\whQuery2
if NOT "%compilehtq2%"=="no" call %cbat% whQuery2

:: whQuery3 uses BDE
del %~dp0\..\..\Live\WebHub\Apps\whQuery3.exe /q
if NOT "%compilehtq3%"=="no" cd %droot%\DB Examples\whQuery3
if NOT "%compilehtq3%"=="no" set compilerdigits=20
if NOT "%compilehtq3%"=="no" call %cbat% whQuery3

:: whQuery4 uses BDE
del %~dp0\..\..\Live\WebHub\Apps\whQuery4.exe /q
if NOT "%compilehtq4%"=="no" cd %droot%\DB Examples\whQuery4
if NOT "%compilehtq4%"=="no" set compilerdigits=20
if NOT "%compilehtq4%"=="no" call %cbat% whQuery4

:: democoderage
:: whSchedule uses IBObjects and Rubicon, no BDE
del %~dp0\..\..\Live\WebHub\Apps\whSchedule.exe /q
set compilerdigits=20
if NOT "%compilecoderage%"=="no" cd %droot%\DB Examples\whSchedule
if NOT "%compilecoderage%"=="no" call %~dp0\default-compilerdigits.bat
if NOT "%compilecoderage%"=="no" call %cbat% whSchedule

:: Fish Store uses FireDAC September 2014
del %~dp0\..\..\Live\WebHub\Apps\whFishStore.exe /q
set compilerdigits=
if NOT "%compilehtfs%"=="no" cd %droot%\DB Examples\whFishStore
if NOT "%compilehtfs%"=="no" call %~dp0\default-compilerdigits.bat
%CSSend% compilerdigits %compilerdigits%
%CSSend% "cbat for Fish Store" %cbat%
if NOT "%compilehtfs%"=="no" call %cbat% whFishStore

:: whClone uses BDE
del %~dp0\..\..\Live\WebHub\Apps\whClone.exe /q
if NOT "%compilehtcl%"=="no" cd %droot%\DB Examples\whClone
if NOT "%compilehtcl%"=="no" set compilerdigits=20
if NOT "%compilehtcl%"=="no" call %cbat% whClone

:: whLoadFromDB relies on some properties on the BDE webapp object
set compilerdigits=20
call %~dp0\default-compilerdigits.bat
del %~dp0\..\..\Live\WebHub\Apps\whLoadFromDB.exe
if NOT "%compiledbhtml%"=="no" cd %droot%\DB Examples\whLoadFromDB
if NOT "%compiledbhtml%"=="no" call %cbat% whLoadFromDB

del %~dp0\..\..\Live\WebHub\Apps\whShopping.exe
if NOT "%compileshop1%"=="no" cd %droot%\DB Examples\whShopping
if NOT "%compileshop1%"=="no" call %cbat% whShopping

del %~dp0\..\..\Live\WebHub\Apps\whInstantForm.exe
if NOT "%compilehtfm%"=="no" cd %droot%\DB Examples\whInstantForm
if NOT "%compilehtfm%"=="no" call %cbat% whInstantForm

del %~dp0\..\..\Live\WebHub\Apps\whScanTable.exe
if NOT "%compilescan%"=="no" cd %droot%\DB Examples\whScanTable
if NOT "%compilescan%"=="no" call %cbat% whScanTable

del %~dp0\..\..\Live\WebHub\Apps\whDynamicJPEG.exe
if NOT "%compilejpeg%"=="no" cd %droot%\DB Examples\whDynamicJPEG
if NOT "%compilejpeg%"=="no" call %cbat% whDynamicJPEG

::whFirebird uses IBObjects 
del %~dp0\..\..\Live\WebHub\Apps\whFirebird.exe
if NOT "%compilefire%"=="no" cd %droot%\DB Examples\whFirebird
if NOT "%compilefire%"=="no" call %cbat% whFirebird

del %~dp0\..\..\Live\WebHub\Apps\whRubicon.exe
if NOT "%compilehtru%"=="no" cd %droot%\Third Party Examples\whRubicon
if NOT "%compilehtru%"=="no" call %cbat% whRubicon

call %ZaphodsMap%\zmset.bat whipc UsingKey2Value "HREFTools\Install WebHub ipc old"

echo .
echo ***
echo ipc is %whipc%
echo ***
echo .

::whDPrefix uses NexusDB not BDE
:: NexusDB v4.004 as of 28-Apr-2014
:: Use same version of WebHub as CodeNewsFast so libraries are shared
@del %~dp0\..\..\Live\WebHub\Apps\whDPrefix*.exe 
if "%compiledpr%"=="no" goto END
cd %droot%\Third Party Examples\whDPrefix
set compilerdigits=21
call d:\projects\webhubdemos\Source\_Control\compile-1demo_win64.bat whDPrefix

goto end

:END
%CSSend% "Complete"
%CSSend% "intentional pause..."
pause
