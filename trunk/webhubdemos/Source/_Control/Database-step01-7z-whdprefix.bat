setlocal

:: Compress Delphi Prefix Registry EXE
:: prior to transfer to production server

cd %~dp0..\..\Live\WebHub\Apps

@del whdprefix-bin.7z
@del database-dpr.7z

d:\Apps\Utilities\7Zip\7z.exe a database-dpr.7z whdprefix.exe 
if errorlevel 1 pause

call %~dp0\default-compilerdigits.bat
set t=Database-Library-d%compilerdigits%.7z
@del %t%
set sdir=h:\pkg_d%compilerdigits%_win64

d:\Apps\Utilities\7Zip\7z.exe a %t% %sdir%\ldiRegExLib_d%compilerdigits%_win64.bpl
:: d:\Apps\Utilities\7Zip\7z.exe a %t% %sdir%\WebHub_d%compilerdigits%_win64.bpl
:: d:\Apps\Utilities\7Zip\7z.exe a %t% %sdir%\WebHubDB_d%compilerdigits%_win64.bpl
d:\Apps\Utilities\7Zip\7z.exe a %t% %sdir%\ZaphodsMapLib_d%compilerdigits%_win64.bpl

pause
