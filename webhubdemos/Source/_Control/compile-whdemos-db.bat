set CSSend=P:\AllHREFToolsProducts\Pak\AllSetupProduction\PakUtilities\CodeSiteConsole.exe
%CSSend% /note "compile-whdemos-db.bat"

if NOT "%comp3%%bits%"=="" goto Continue00

set /P comp3=Enter Pascal Compiler Digits as Number (eg. 18 or 19) :   
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
cd /d %droot%\Lite Examples\whAppServer\whLite
call %cbat% whLite

del %~dp0\..\..\Live\WebHub\Apps\whQuery1.exe /q
if "%compilehtq1%"=="" %CSSend% /error "compilehtq1 is blank"
if "%compilehtq1%"=="" pause
if NOT "%compilehtq1%"=="no" cd %droot%\DB Examples\whQuery1
if NOT "%compilehtq1%"=="no" call %cbat% whQuery1

:: whQuery2 uses IBObjects and that compiles for D19
del %~dp0\..\..\Live\WebHub\Apps\whQuery2.exe /q
if "%compilehtq2%"=="" %CSSend% /error "compilehtq2 is blank"
if "%compilehtq2%"=="" pause
if NOT "%compilehtq2%"=="no" cd %droot%\DB Examples\whQuery2
if NOT "%compilehtq2%"=="no" call %cbat% whQuery2
set compilerdigits=

del %~dp0\..\..\Live\WebHub\Apps\whQuery3.exe /q
if NOT "%compilehtq3%"=="no" cd %droot%\DB Examples\whQuery3
if NOT "%compilehtq3%"=="no" call %cbat% whQuery3

del %~dp0\..\..\Live\WebHub\Apps\whQuery4.exe /q
if NOT "%compilehtq4%"=="no" cd %droot%\DB Examples\whQuery4
if NOT "%compilehtq4%"=="no" call %cbat% whQuery4

:: democoderage
del %~dp0\..\..\Live\WebHub\Apps\whSchedule.exe /q
::whSchedule uses IBObjects and Rubicon
if NOT "%compilecoderage%"=="no" cd %droot%\DB Examples\whSchedule
::if NOT "%compilecoderage%"=="no" set compilerdigits=18
if NOT "%compilecoderage%"=="no" call %cbat% whSchedule

::set compilerdigits=
del %~dp0\..\..\Live\WebHub\Apps\whFishStore.exe /q
if NOT "%compilehtfs%"=="no" cd %droot%\DB Examples\whFishStore
if NOT "%compilehtfs%"=="no" call %cbat% whFishStore

del %~dp0\..\..\Live\WebHub\Apps\whClone.exe /q
if NOT "%compilehtcl%"=="no" cd %droot%\DB Examples\whClone
if NOT "%compilehtcl%"=="no" call %cbat% whClone

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
::if NOT "%compilefire%"=="no" set compilerdigits=18
if NOT "%compilefire%"=="no" call %cbat% whFirebird
::set compilerdigits=

del %~dp0\..\..\Live\WebHub\Apps\whRubicon.exe
if NOT "%compilehtru%"=="no" cd %droot%\Third Party Examples\whRubicon
if NOT "%compilehtru%"=="no" call %cbat% whRubicon

call %ZaphodsMap%\zmset.bat whipc UsingKey2Value "HREFTools\Install WebHub ipc old"

echo .
echo ***
echo ipc is %whipc%
echo ***
echo .

::whDPrefix uses NexusDB which is not ready for D19 yet
@del %~dp0\..\..\Live\WebHub\Apps\whDPrefix*.exe 
if "%compiledpr%"=="no" goto dspstart
cd %droot%\Third Party Examples\whDPrefix
:: call %~dp0\default-compilerdigits.bat
set compilerdigits=18
call d:\projects\webhubdemos\Source\_Control\compile-1demo_win32.bat whDPrefix

:dspstart
set compilerdigits=
call %~dp0\default-compilerdigits.bat
@del %~dp0\..\..\Live\WebHub\Apps\whDSP*.exe
if "%compiledsp%"=="no" goto end
cd %droot%\Third Party Examples\whDSP

::dsp new-ipc
cd /d %~dp0
call compile-1demo_win32.bat whDSP
if errorlevel 1 %CSSend% /error "%~dp0\compile-1demo_win32.bat failed for whDSP"
goto end

:END
echo Complete
pause
