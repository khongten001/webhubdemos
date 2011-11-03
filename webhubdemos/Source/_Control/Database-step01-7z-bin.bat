:: use 7z utility to compress executable files
:: 7z is free with open source

setlocal

cd %~dp0
cd ..\..\Live\WebHub\Apps

del Database-bin.7z
del Database-Library-bin.7z
del Database-dsp.7z

set t=Database-dsp.7z
d:\Apps\Utilities\7Zip\7z.exe a %t% whLite.exe
d:\Apps\Utilities\7Zip\7z.exe a %t% whDSP.exe

set t=Database-bin.7z

d:\Apps\Utilities\7Zip\7z.exe a %t% whLite.exe
d:\Apps\Utilities\7Zip\7z.exe a %t% whClone.exe
d:\Apps\Utilities\7Zip\7z.exe a %t% whQuery*.exe
d:\Apps\Utilities\7Zip\7z.exe a %t% whInstantForm.exe
d:\Apps\Utilities\7Zip\7z.exe a %t% whLoadFromDB.exe
d:\Apps\Utilities\7Zip\7z.exe a %t% whRubicon.exe
d:\Apps\Utilities\7Zip\7z.exe a %t% whSchedule.exe
d:\Apps\Utilities\7Zip\7z.exe a %t% whShopping.exe
d:\Apps\Utilities\7Zip\7z.exe a %t% whText2Table.exe
d:\Apps\Utilities\7Zip\7z.exe a %t% whDynamicJPEG.exe
d:\Apps\Utilities\7Zip\7z.exe a %t% whFirebird.exe
d:\Apps\Utilities\7Zip\7z.exe a %t% whFishStore.exe
d:\Apps\Utilities\7Zip\7z.exe a %t% whScanTable.exe
if errorlevel 1 pause

set t=Database-Library-bin.7z
set sdir=h:\pkg_d16_win32

d:\Apps\Utilities\7Zip\7z.exe a %t% %sdir%\ldiRegExLib_d16_win32.bpl
d:\Apps\Utilities\7Zip\7z.exe a %t% %sdir%\WebHub_d16_win32.bpl
d:\Apps\Utilities\7Zip\7z.exe a %t% %sdir%\WebHubDB_d16_win32.bpl
d:\Apps\Utilities\7Zip\7z.exe a %t% %sdir%\WebHubBDE_d16_win32.bpl
d:\Apps\Utilities\7Zip\7z.exe a %t% %sdir%\ZaphodsMapLib_d16_win32.bpl

pause

