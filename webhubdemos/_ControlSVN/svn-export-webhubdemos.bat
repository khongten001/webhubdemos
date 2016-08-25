:: svn-export-webhubdemos.bat
:: For credentials, use your sourceforge account 


@echo off
setlocal

set src=https://svn.code.sf.net/p/webhubdemos/code/trunk
set svndir=D:\Apps\Utilities\SVN\CollabNet

cd /d %~dp0
cd ..

mkdir Live
mkdir Source

echo This requires a Subversion client (svn.exe) 
echo .
echo Delphi XE includes the CollabNet version of the Subversion client.
echo You can also download it from: www.open.collab.net/downloads/subversion/
echo Or use TortoiseSVN which has a cute graphical user interface.
echo .
pause

echo on

::Live
%svndir%\svn.exe export %src%/Live  ./Live  --force
@if errorlevel 1 pause

::Source
d:\Apps\Utilities\SVN\console\svn.exe export %src%/Source  ./Source  --force
@if errorlevel 1 pause

rem That is all, folks!
pause
