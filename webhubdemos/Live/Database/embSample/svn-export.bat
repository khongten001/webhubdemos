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

endlocal

