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

cd %droot%\DB Examples\whQuery1
call %cbat% whQuery1

cd %droot%\DB Examples\whQuery2
call %cbat% whQuery2

cd %droot%\DB Examples\whQuery3
call %cbat% whQuery3

cd %droot%\DB Examples\whQuery4
call %cbat% whQuery4

::whSchedule uses IBObjects 
::cd %droot%\DB Examples\whSchedule
::::call %cbat% whSchedule

cd %droot%\DB Examples\whFishStore
call %cbat% whFishStore

cd %droot%\DB Examples\whClone
call %cbat% whClone

cd %droot%\DB Examples\whLoadFromDB
call %cbat% whLoadFromDB

cd %droot%\DB Examples\whShopping
call %cbat% whShopping

cd %droot%\DB Examples\whInstantForm
call %cbat% whInstantForm

cd %droot%\DB Examples\whScanTable
call %cbat% whScanTable

cd %droot%\More Examples\whDynamicJPEG
call %cbat% whDynamicJPEG

::whFirebird uses IBObjects 
cd %droot%\DB Examples\whFirebird
call %cbat% whFirebird

cd %droot%\Third Party Examples\whRubicon
call %cbat% whRubicon

cd %droot%\Third Party Examples\whDSP
call %cbat% whDSP

:END
pause
