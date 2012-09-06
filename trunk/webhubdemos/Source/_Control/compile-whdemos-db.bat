if NOT "%comp3%%bits%"=="" goto Continue00

set /P comp3=Enter Pascal Compiler Code in UPPERCASE (eg. D15 or D17) :   
if %comp3%=="" goto end

:Continue00
set droot=d:\projects\WebHubDemos\Source\WHApps
if "%demonopackages%"=="yes" goto Continue01
set cbat=d:\projects\webhubdemos\Source\_Control\compile-1demo_%comp3%_win32.bat
goto Continue02

:Continue01
set cbat=d:\projects\webhubdemos\Source\_Control\compile-1demo_d15_win32_nopackages.bat


:Continue02
:: need DEMOS app even on DB server
cd /d %droot%\Lite Examples\whAppServer\whLite
call %cbat% whLite

del %~dp0\..\..\Live\WebHub\Apps\whQuery1.exe /q
if "%compilehtq1%"=="" pause
if NOT "%compilehtq1%"=="no" cd %droot%\DB Examples\whQuery1
if NOT "%compilehtq1%"=="no" call %cbat% whQuery1

del %~dp0\..\..\Live\WebHub\Apps\whQuery2.exe /q
if "%compilehtq2%"=="" pause
if NOT "%compilehtq2%"=="no" cd %droot%\DB Examples\whQuery2
if NOT "%compilehtq2%"=="no" call %cbat% whQuery2

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
if NOT "%compilecoderage%"=="no" call %cbat% whSchedule

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
if NOT "%compilejpeg%"=="no" cd %droot%\More Examples\whDynamicJPEG
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

del %~dp0\..\..\Live\WebHub\Apps\whDSP*.exe
if "%compiledsp%"=="no" goto end
cd %droot%\Third Party Examples\whDSP
goto dsp%whipc%

:dspold
call %cbat% whDSP
goto end

:dspx
call d:\projects\webhubdemos\Source\_Control\compile-1demo_x_d17_win32_source.bat whDSP
::call d:\projects\webhubdemos\Source\_Control\compile-1demo_x_d15_win32_source.bat whDSP
copy %~dp0\..\..\Live\WebHub\Apps\whDSP_x_d17_win32.exe %~dp0\..\..\Live\WebHub\Apps\whDSP.exe
goto end

:END
echo Complete
pause
