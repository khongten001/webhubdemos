:: svn-checkout-webhubdemos.bat
:: For svn login, visit http://lite.demos.href.com/demos:pgDownload::demos


@echo off
setlocal

set src=http://svn.href.com/svn-public/projects/project-whdemos/trunk/

cd /d %~dp0
cd ..
cd ..

:: http://support.microsoft.com/kb/65994
IF NOT EXIST .\webhubdemos\NUL GOTO TargetFolderMissing

echo This requires a Subversion client (svn.exe) 
echo .
echo Delphi XE includes the CollabNet version of the Subversion client.
echo You can also download it from: www.open.collab.net/downloads/subversion/
echo Or use TortoiseSVN which has a cute graphical user interface.
echo .
pause

echo on

::Live
d:\Apps\Utilities\SVN\console\svn.exe checkout %src%/webhubdemos  ./webhubdemos  
if errorlevel 1 pause

rem That is all, folks!
pause
goto end

TargetFolderMissing:
rem Target folder must be named webhubdemos
pause

end: