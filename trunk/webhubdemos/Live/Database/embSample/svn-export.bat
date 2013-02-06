:: Embarcadero sample files are in subversion and included when you install Delphi.
:: http://docwiki.embarcadero.com/CodeExamples/XE3/en/Category:Sample

setlocal
set svnpath=D:\apps\Utilities\SVN\CollabNet
set urlroot=https://radstudiodemos.svn.sourceforge.net/svnroot/radstudiodemos/branches/RadStudio_XE3_Update
%svnpath%\svn.exe export %urlroot%/Data/employee.xml ./employee.xml --non-interactive --force 
if errorlevel 1 pause
%svnpath%\svn.exe export %urlroot%/Data/parts.xml ./parts.xml --non-interactive --force 
if errorlevel 1 pause
%svnpath%\svn.exe export %urlroot%/Data/biolife.xml ./biolife.xml --non-interactive --force 
if errorlevel 1 pause

:: cd ..\whInstantForm
:: del parts.*
:: %svnpath%\svn.exe export %urlroot%/Data/parts.db ./parts.db --non-interactive --force 
:: if errorlevel 1 pause
:: %svnpath%\svn.exe export %urlroot%/Data/parts.px ./parts.px --non-interactive --force 
:: %svnpath%\svn.exe export %urlroot%/Data/parts.VAL ./parts.VAL --non-interactive --force 
:: %svnpath%\svn.exe export %urlroot%/Data/parts.x02 ./parts.x02 --non-interactive --force 
:: %svnpath%\svn.exe export %urlroot%/Data/parts.y02 ./parts.y02 --non-interactive --force 
:: %svnpath%\svn.exe export %urlroot%/Data/parts.xg0 ./parts.xg0 --non-interactive --force 
:: %svnpath%\svn.exe export %urlroot%/Data/parts.yg0 ./parts.yg0 --non-interactive --force 

cd ..\whQuery3
del employee.*
%svnpath%\svn.exe export %urlroot%/Data/employee.db  ./employee.db  --non-interactive --force 
if errorlevel 1 pause
%svnpath%\svn.exe export %urlroot%/Data/employee.px  ./employee.px  --non-interactive --force 
%svnpath%\svn.exe export %urlroot%/Data/employee.xg0 ./employee.xg0 --non-interactive --force 
%svnpath%\svn.exe export %urlroot%/Data/employee.yg0 ./employee.yg0 --non-interactive --force 

copy employee.* ..\whQuery4
cd ..\whQuery4
:: dept.db made by HREF Tools not shipped by Embarcadero

cd ..\whClone
del biolife.*
%svnpath%\svn.exe export %urlroot%/Data/biolife.db  ./biolife.db  --non-interactive --force 
if errorlevel 1 pause
%svnpath%\svn.exe export %urlroot%/Data/biolife.mb  ./biolife.mb  --non-interactive --force 
%svnpath%\svn.exe export %urlroot%/Data/biolife.px  ./biolife.px  --non-interactive --force 

cd ..\whShopping
%svnpath%\svn.exe export %urlroot%/Data/dbdemos.mdb  ./dbdemos.mdb  --non-interactive --force 
if errorlevel 1 pause

endlocal
