:: use 7z utility to compress executable files
:: 7z is free with open source

call %~dp0\default-compilerdigits.bat

setlocal

cd %~dp0
cd ..\..\Live\WebHub\Apps

del LiteMore-bin.7z
del LiteMore-Library-bin.7z

:: compress the Lite and More EXEs
d:\Apps\Utilities\7Zip\7z.exe a LiteMore-bin.7z whLite.exe
if errorlevel 1 pause
::d:\Apps\Utilities\7Zip\7z.exe a LiteMore-bin.7z DServerD1?.exe
d:\Apps\Utilities\7Zip\7z.exe a LiteMore-bin.7z whConverter.exe
d:\Apps\Utilities\7Zip\7z.exe a LiteMore-bin.7z whDropdown.exe
d:\Apps\Utilities\7Zip\7z.exe a LiteMore-bin.7z whObjectInspector.exe
d:\Apps\Utilities\7Zip\7z.exe a LiteMore-bin.7z whOutline.exe
d:\Apps\Utilities\7Zip\7z.exe a LiteMore-bin.7z whOpenID.exe
d:\Apps\Utilities\7Zip\7z.exe a LiteMore-bin.7z whSendmail.exe
d:\Apps\Utilities\7Zip\7z.exe a LiteMore-bin.7z whStopspam.exe
d:\Apps\Utilities\7Zip\7z.exe a LiteMore-bin.7z whText2Table.exe
d:\Apps\Utilities\7Zip\7z.exe a LiteMore-bin.7z whAsyncDemo.exe

set t=LiteMore-Library-bin.7z
set sdir=h:\pkg_d%compilerdigits%_win32

d:\Apps\Utilities\7Zip\7z.exe a %t% %sdir%\ldiRegExLib_d%compilerdigits%_win32.bpl
d:\Apps\Utilities\7Zip\7z.exe a %t% %sdir%\WebHub_d%compilerdigits%_win32.bpl
d:\Apps\Utilities\7Zip\7z.exe a %t% %sdir%\ZaphodsMapLib_d%compilerdigits%_win32.bpl

pause

