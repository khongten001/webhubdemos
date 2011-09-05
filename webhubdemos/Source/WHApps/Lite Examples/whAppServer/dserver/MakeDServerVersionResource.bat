setlocal

:: change the following line for each change in BuildNo
set fileversion=2,0,0,87
set productversion=2,0

:: use ZaphodsMap to find compiler
:: zmset.bat and ZMLookup.exe are FREE from HREF Tools Corp. via www.zaphodsmap.com
call %ZaphodsMap%zmset.bat brcc UsingKey2Folder "HREFTools\Production\cv001 Delphi D15"
set brcc=%brcc%bin\brcc32.exe
if not exist %brcc% pause

set resfilenamenoext=dserver_version
set servicename=dserver

:: resource file will be put into same folder as this BAT file
:: %resfilenamenoext%.rc and %resfilenamenoext%.res

echo Making version resource file

echo 1 VERSIONINFO >"%~dp0\%resfilenamenoext%.rc"
echo FILEVERSION %fileversion% >> "%~dp0%resfilenamenoext%.rc"
echo PRODUCTVERSION %productversion% >> "%~dp0%resfilenamenoext%.rc"
echo FILEOS VOS__WINDOWS32>> "%~dp0%resfilenamenoext%.rc"
echo FILETYPE VFT_APP>> "%~dp0%resfilenamenoext%.rc"
echo BEGIN >> "%~dp0%resfilenamenoext%.rc"
echo  BLOCK "StringFileInfo">> "%~dp0%resfilenamenoext%.rc"
echo  BEGIN >> "%~dp0%resfilenamenoext%.rc"
echo   BLOCK "040904E4">> "%~dp0%resfilenamenoext%.rc"
echo   BEGIN >> "%~dp0%resfilenamenoext%.rc"
echo    VALUE "CompanyName", "HREF Tools Corp.\000" >> "%~dp0%resfilenamenoext%.rc"
echo    VALUE "Company Info", "WebHub Demos at http://lite.demos.href.com/\000" >> "%~dp0%resfilenamenoext%.rc"
echo    VALUE "FileDescription", "WebHub Application Server for use with Dreamweaver\000" >> "%~dp0%resfilenamenoext%.rc"
echo    VALUE "FileVersion", "%fileversion%\000" >> "%~dp0%resfilenamenoext%.rc"
echo    VALUE "InternalName", "\000" >> "%~dp0%resfilenamenoext%.rc"
echo    VALUE "ServiceName", "%servicename%\000" >> "%~dp0%resfilenamenoext%.rc"
echo    VALUE "DisplayName", "WebHub %servicename%\000" >> "%~dp0%resfilenamenoext%.rc"
echo    VALUE "ProductName", "DServer\000" >> "%~dp0%resfilenamenoext%.rc"
echo    VALUE "OriginalFilename", "dserver.exe\000" >> "%~dp0%resfilenamenoext%.rc"
echo    VALUE "Technical Support", "http://www.href.com/contact\000" >> "%~dp0%resfilenamenoext%.rc"
echo    VALUE "LegalCopyright", "Copyright \251 2002 - 2011 HREF Tools Corp.\000" >> "%~dp0%resfilenamenoext%.rc"
echo    VALUE "Legal Notice", "\000" >> "%~dp0%resfilenamenoext%.rc"
echo    VALUE "ZMBranch", "HREFTools/WebHub/cv004\000" >> "%~dp0%resfilenamenoext%.rc"
echo   END >> "%~dp0%resfilenamenoext%.rc"
echo  END >> "%~dp0%resfilenamenoext%.rc"
echo  BLOCK "VarFileInfo" >> "%~dp0%resfilenamenoext%.rc"
echo  BEGIN >> "%~dp0%resfilenamenoext%.rc"
echo   VALUE "Translation", 1033, 1252 >> "%~dp0%resfilenamenoext%.rc"
echo  END >> "%~dp0%resfilenamenoext%.rc"
echo END >> "%~dp0%resfilenamenoext%.rc"

%brcc% "%~dp0%resfilenamenoext%"
if errorlevel 1 pause
