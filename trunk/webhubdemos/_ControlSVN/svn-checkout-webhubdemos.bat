:: svn-checkout-webhubdemos.bat
:: For credentials, use your sourceforge account 


@echo off
setlocal

set src=https://svn.code.sf.net/p/webhubdemos/code/trunk
set svndir=D:\Apps\Utilities\SVN\CollabNet

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
%svndir%\svn.exe checkout %src%/webhubdemos  ./webhubdemos  --force
@if errorlevel 1 pause
@echo off
goto end

:TargetFolderMissing
@echo Target folder must be named webhubdemos
pause

:end
rem That is all, folks!
pause
