if NOT "%comp3%%bits%"=="" goto Continue00

set /P comp3=Enter Pascal Compiler Code in UPPERCASE (eg. D15 or D16) :   
if %comp3%=="" goto end

:Continue00
set cbat=d:\projects\webhubdemos\Source\_Control\compile-1demo_%comp3%_win32.bat
set droot=\projects\WebHubDemos\Source\WHApps
d:

:: need DEMOS app even on DB server
cd %droot%\Lite Examples\whAppServer\whLite
call %cbat% whLite

del %~dp0\..\..\Live\WebHub\Apps\whQuery1.exe /q
if "%demohtq1%"=="" pause
if NOT "%demohtq1%"=="no" cd %droot%\DB Examples\whQuery1
if NOT "%demohtq1%"=="no" call %cbat% whQuery1

del %~dp0\..\..\Live\WebHub\Apps\whQuery2.exe /q
if "%demohtq2%"=="" pause
if NOT "%demohtq2%"=="no" cd %droot%\DB Examples\whQuery2
if NOT "%demohtq2%"=="no" call %cbat% whQuery2

del %~dp0\..\..\Live\WebHub\Apps\whQuery3.exe /q
if NOT "%demohtq3%"=="no" cd %droot%\DB Examples\whQuery3
if NOT "%demohtq3%"=="no" call %cbat% whQuery3

del %~dp0\..\..\Live\WebHub\Apps\whQuery4.exe /q
if NOT "%demohtq4%"=="no" cd %droot%\DB Examples\whQuery4
if NOT "%demohtq4%"=="no" call %cbat% whQuery4

:: democoderage
del %~dp0\..\..\Live\WebHub\Apps\whSchedule.exe /q
::whSchedule uses IBObjects 
::cd %droot%\DB Examples\whSchedule
::::call %cbat% whSchedule

del %~dp0\..\..\Live\WebHub\Apps\whFishStore.exe /q
if NOT "%demohtfs%"=="no" cd %droot%\DB Examples\whFishStore
if NOT "%demohtfs%"=="no" call %cbat% whFishStore

del %~dp0\..\..\Live\WebHub\Apps\whClone.exe /q
if NOT "%demohtcl%"=="no" cd %droot%\DB Examples\whClone
if NOT "%demohtcl%"=="no" call %cbat% whClone

del %~dp0\..\..\Live\WebHub\Apps\whLoadFromDB.exe
if NOT "%demodbhtml%"=="no" cd %droot%\DB Examples\whLoadFromDB
if NOT "%demodbhtml%"=="no" call %cbat% whLoadFromDB

del %~dp0\..\..\Live\WebHub\Apps\whShopping.exe
if NOT "%demoshop1%"=="no" cd %droot%\DB Examples\whShopping
if NOT "%demoshop1%"=="no" call %cbat% whShopping

del %~dp0\..\..\Live\WebHub\Apps\whInstantForm.exe
if NOT "%demohtfm%"=="no" cd %droot%\DB Examples\whInstantForm
if NOT "%demohtfm%"=="no" call %cbat% whInstantForm

del %~dp0\..\..\Live\WebHub\Apps\whScanTable.exe
if NOT "%demoscan%"=="no" cd %droot%\DB Examples\whScanTable
if NOT "%demoscan%"=="no" call %cbat% whScanTable

del %~dp0\..\..\Live\WebHub\Apps\whDynamicJPEG.exe
if NOT "%demojpeg%"=="no" cd %droot%\More Examples\whDynamicJPEG
if NOT "%demojpeg%"=="no" call %cbat% whDynamicJPEG

::whFirebird uses IBObjects 
del %~dp0\..\..\Live\WebHub\Apps\whFirebird.exe
if NOT "%demofire%"=="no" cd %droot%\DB Examples\whFirebird
if NOT "%demofire%"=="no" call %cbat% whFirebird

del %~dp0\..\..\Live\WebHub\Apps\whRubicon.exe
if NOT "%demohtru%"=="no" cd %droot%\Third Party Examples\whRubicon
if NOT "%demohtru%"=="no" call %cbat% whRubicon

del %~dp0\..\..\Live\WebHub\Apps\whDPP.exe
if NOT "%demodsp%"=="no" cd %droot%\Third Party Examples\whDSP
if NOT "%demodsp%"=="no" call %cbat% whDSP

:END
pause
