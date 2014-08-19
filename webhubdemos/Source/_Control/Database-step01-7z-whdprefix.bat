setlocal

:: Compress Delphi Prefix Registry EXE
:: prior to transfer to production server

cd %~dp0..\..\Live\WebHub\Apps

@del whdprefix-bin.7z

d:\Apps\Utilities\7Zip\7z.exe a whdprefix-bin.7z whdprefix.exe 
if errorlevel 1 pause

