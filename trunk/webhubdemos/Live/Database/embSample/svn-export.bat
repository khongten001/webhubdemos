:: Embarcadero sample files are in subversion and included when you install Delphi.
:: http://docwiki.embarcadero.com/CodeExamples/XE3/en/Category:Sample

setlocal
set svnpath=D:\apps\Utilities\SVN\CollabNet
set urlroot=https://radstudiodemos.svn.sourceforge.net/svnroot/radstudiodemos/branches/RadStudio_XE3_Update
%svnpath%\svn.exe export %urlroot%/Data/employee.xml ./employee.xml --accept theirs-full
if errorlevel 1 pause
%svnpath%\svn.exe export %urlroot%/Data/parts.xml ./parts.xml --accept theirs-full
if errorlevel 1 pause
%svnpath%\svn.exe export %urlroot%/Data/biolife.xml ./biolife.xml --accept theirs-full
if errorlevel 1 pause

:: cd ..\whInstantForm
:: del parts.*
:: %svnpath%\svn.exe export %urlroot%/Data/parts.db ./parts.db --accept theirs-full
:: if errorlevel 1 pause
:: %svnpath%\svn.exe export %urlroot%/Data/parts.px ./parts.px --accept theirs-full
:: %svnpath%\svn.exe export %urlroot%/Data/parts.VAL ./parts.VAL --accept theirs-full
:: %svnpath%\svn.exe export %urlroot%/Data/parts.x02 ./parts.x02 --accept theirs-full
:: %svnpath%\svn.exe export %urlroot%/Data/parts.y02 ./parts.y02 --accept theirs-full
:: %svnpath%\svn.exe export %urlroot%/Data/parts.xg0 ./parts.xg0 --accept theirs-full
:: %svnpath%\svn.exe export %urlroot%/Data/parts.yg0 ./parts.yg0 --accept theirs-full

endlocal
