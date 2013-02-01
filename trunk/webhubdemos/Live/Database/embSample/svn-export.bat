:: Embarcadero sample files are in subversion and included when you install Delphi.
:: http://docwiki.embarcadero.com/CodeExamples/XE3/en/Category:Sample

setlocal
set svnpath=D:\apps\Utilities\SVN\CollabNet
set urlroot=https://radstudiodemos.svn.sourceforge.net/svnroot/radstudiodemos/branches/RadStudio_XE3_Update
%svnpath%\svn.exe export %urlroot%/Data/employee.xml ./employee.xml
if errorlevel 1 pause
%svnpath%\svn.exe export %urlroot%/Data/parts.xml ./parts.xml
if errorlevel 1 pause
%svnpath%\svn.exe export %urlroot%/Data/biolife.xml ./biolife.xml
if errorlevel 1 pause

:: cd ..\whInstantForm
:: del parts.*
:: %svnpath%\svn.exe export %urlroot%/Data/parts.db ./parts.db
:: if errorlevel 1 pause
:: %svnpath%\svn.exe export %urlroot%/Data/parts.px ./parts.px
:: %svnpath%\svn.exe export %urlroot%/Data/parts.VAL ./parts.VAL
:: %svnpath%\svn.exe export %urlroot%/Data/parts.x02 ./parts.x02
:: %svnpath%\svn.exe export %urlroot%/Data/parts.y02 ./parts.y02
:: %svnpath%\svn.exe export %urlroot%/Data/parts.xg0 ./parts.xg0
:: %svnpath%\svn.exe export %urlroot%/Data/parts.yg0 ./parts.yg0

endlocal
