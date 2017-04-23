setlocal

:: %1 should be ServiceName (no spaces)
:: %2 should be Display Name (sorry no spaces here either, and no surrounding quotes)

set productversion=3,0
set fileversion=3,2,0,0
set CSSend=d:\Apps\HREFTools\MiscUtil\CodeSiteConsole.exe

%CSSend% called-only-MakeResFile.bat %1 %2

:: Make version resource file for WebHub demo module
:: Change the following lines for each change in the VersionNo and the BuildNo

:: use ZaphodsMap to find default context of computer
call %ZaphodsMap%zmset.bat zmcontext AsDefaultContext
call %~dp0set-compilerdigits.bat
%CSSend% compilerdigits %compilerdigits%

:: get this year for copyright notice
call %ZaphodsMap%zmset.bat MiscUtil UsingKey2Folder "HREFTools\Production\cv001 Utilities MiscUtil"
call %MiscUtil%\set-ymd.bat thisyear yyyy
:: get Delphi Compiler root folder
call %ZaphodsMap%zmset.bat droot UsingKey2Folder "HREFTools\Production\cv001 Delphi D%compilerdigits%"

%CSSend% droot %droot%

:: ServiceName is passed in as the first command line parameter
if "%1"=="" goto errorblankparam1

set resfilenamenoext=%1_ver
set servicename=%1
%CSSend% servicename %servicename%
%CSSend% /note "param#2 for display name [%2]"

set filepurpose=Public Demo using WebHub Components

set brcc=%droot%\Bin\brcc32.exe
if not exist %brcc% goto BRCCNOTFOUND

cd /d %~dp0..\TempBuild\res
if errorlevel 1 pause

SET resfilenamenoext=ver_%1

cls
%CSSend% "Making version resource file" %resfilenamenoext%.rc

echo 1 VERSIONINFO > %resfilenamenoext%.rc
echo FILEVERSION %fileversion% >> %resfilenamenoext%.rc
echo PRODUCTVERSION %productversion% >> %resfilenamenoext%.rc
echo FILEOS VOS__WINDOWS32>> %resfilenamenoext%.rc
echo FILETYPE VFT_APP>> %resfilenamenoext%.rc
echo BEGIN >> %resfilenamenoext%.rc
echo  BLOCK "StringFileInfo">> %resfilenamenoext%.rc
echo  BEGIN >> %resfilenamenoext%.rc
echo   BLOCK "040904E4">> %resfilenamenoext%.rc
echo   BEGIN >> %resfilenamenoext%.rc
echo    VALUE "CompanyName", "HREF Tools Corp.\000" >> %resfilenamenoext%.rc
echo    VALUE "Company Info", "HREF Tools Corp. http://www.href.com/\000" >> %resfilenamenoext%.rc
echo    VALUE "FileDescription", "%filepurpose% %extradesc%\000" >> %resfilenamenoext%.rc
echo    VALUE "FileVersion", "%fileversion%\000" >> %resfilenamenoext%.rc
echo    VALUE "InternalName", "\000" >> %resfilenamenoext%.rc
echo    VALUE "ServiceName", "%servicename%\000" >> %resfilenamenoext%.rc
echo    VALUE "ProductName", "WebHub Components\000" >> %resfilenamenoext%.rc
echo    VALUE "OriginalFilename", "%1.exe\000" >> %resfilenamenoext%.rc
echo    VALUE "Technical Support", "https://www.href.com/\000" >> %resfilenamenoext%.rc
echo    VALUE "LegalCopyright", "Copyright \251 %thisyear% HREF Tools Corp.\000" >> %resfilenamenoext%.rc
echo    VALUE "Legal Notice", "\000" >> %resfilenamenoext%.rc
echo    VALUE "DisplayName", "%2\000" >> %resfilenamenoext%.rc
echo    VALUE "ZMBranch", "HREFTools/WebHub/cv004\000" >> %resfilenamenoext%.rc
echo   END >> %resfilenamenoext%.rc
echo  END >> %resfilenamenoext%.rc
echo  BLOCK "VarFileInfo" >> %resfilenamenoext%.rc
echo  BEGIN >> %resfilenamenoext%.rc
echo   VALUE "Translation", 1033, 1252 >> %resfilenamenoext%.rc
echo  END >> %resfilenamenoext%.rc
echo END >> %resfilenamenoext%.rc

:continue

if not exist %resfilenamenoext%.rc pause

%brcc% %resfilenamenoext%

if not exist %resfilenamenoext%.res pause

goto end

:BRCCNOTFOUND
echo error
echo %brcc% not found
pause
exit /b 1

:errorblankparam1
echo error
echo argument #1 [%1] should be service name
pause
exit /b 1

:end
endlocal
