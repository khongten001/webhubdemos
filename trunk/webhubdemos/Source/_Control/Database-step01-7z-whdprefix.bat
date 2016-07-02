setlocal

:: Compress Delphi Prefix Registry EXE
:: prior to transfer to production server

cd %~dp0..\..\Live\WebHub\Apps

@del database-dpr.7z

d:\Apps\Utilities\7Zip\7z.exe a database-dpr.7z whdprefix.exe 
if errorlevel 1 pause

REM off 02-Jul-2016 call %~dp0\default-compilerdigits.bat
REM off 02-Jul-2016 set t=Database-Library-d%compilerdigits%.7z
REM off 02-Jul-2016 @del %t%
REM off 02-Jul-2016 set sdir=h:\pkg_d%compilerdigits%_win64

REM off 02-Jul-2016 d:\Apps\Utilities\7Zip\7z.exe a %t% %sdir%\ldiRegExLib_d%compilerdigits%_win64.bpl
REM off 02-Jul-2016 d:\Apps\Utilities\7Zip\7z.exe a %t% %sdir%\ZaphodsMapLib_d%compilerdigits%_win64.bpl

pause
