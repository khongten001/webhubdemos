:: svn-export-webhubdemos.bat
:: For svn login, visit http://lite.demos.href.com/demos:pgDownload::demos


@echo off
setlocal

set src=http://svn.href.com/svn-public/projects/project-whdemos/trunk/webhubdemos/
set svndir=d:\Apps\Utilities\SVN\Console

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
if errorlevel 1 pause

::Source
d:\Apps\Utilities\SVN\console\svn.exe export %src%/Source  ./Source  --force
if errorlevel 1 pause

rem That is all, folks!
pause
