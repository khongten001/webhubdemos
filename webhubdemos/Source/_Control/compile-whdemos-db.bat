set cbat=d:\projects\webhubdemos\Source\_Control\compile-1demoD15.bat
set droot=\projects\WebHubDemos\Source\WHApps
d:

cd %droot%\DB Examples\whQuery1
call %cbat% whQuery1

cd %droot%\DB Examples\whQuery2
call %cbat% whQuery2

cd %droot%\DB Examples\whQuery3
call %cbat% whQuery3

cd %droot%\DB Examples\whQuery4
call %cbat% whQuery4

::whSchedule uses IBObjects 
cd %droot%\DB Examples\whSchedule
call %cbat% whSchedule

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
