set CSSend=P:\AllHREFToolsProducts\Pak\AllSetupProduction\PakUtilities\CodeSiteConsole.exe
%CSSend% /note "compile-1demo_win32.bat %1 %2"

@echo off
call %~dp0\default-compilerdigits.bat

setlocal
@del d:\temp\DelphiTempDCU\*.dcu

:: use ZaphodsMap to find compiler
:: zmset.bat and ZMLookup.exe are FREE from HREF Tools Corp. via www.zaphodsmap.com
call %ZaphodsMap%zmset.bat droot UsingKey2Folder "HREFTools\Production\cv001 Delphi D%compilerdigits%"

set dcc=%droot%bin\dcc32.exe
if not exist %dcc% %CSSend% /error "Does not exist: [%dcc%]"
if not exist %dcc% pause

if "%compilerdigits%"=="21" set raizepath=K:\Vendors\Raize\CodeSite5\Lib\RS-XE7\Win32
if "%compilerdigits%"=="20" set raizepath=K:\Vendors\Raize\CodeSite5\Lib\RS-XE6\Win32
if "%compilerdigits%"=="19" set raizepath=K:\Vendors\Raize\CodeSite5\Lib\RS-XE5\Win32
if "%compilerdigits%"=="18" set raizepath=K:\Vendors\Raize\CodeSite5\Lib\RS-XE4\Win32
if "%compilerdigits%"=="17" set raizepath=K:\Vendors\Raize\CodeSite5\Lib\RS-XE3\Win32
if "%compilerdigits%"=="16" set raizepath=K:\Vendors\Raize\CodeSite5\Lib\RS-XE2\Win32

set eurpath=D:\vcl\EurekaLog7\Lib\Win32\Release\Delphi%compilerdigits%

set ibopath=K:\Vendors\CPS\IBObjects\v5.x\source\common;K:\Vendors\CPS\IBObjects\v5.x\source\tdataset;K:\Vendors\CPS\IBObjects\v5.x\source\tools;K:\Vendors\CPS\IBObjects\v5.x\source\core;K:\Vendors\CPS\IBObjects\v5.x\source\access
set libsearchpath=h:\;h:\dcu_d%compilerdigits%_win32;h:\pkg_d%compilerdigits%_win32;k:\webhub\lib\whplus\rubi;k:\Rubicon\source;%ibopath%;%droot%lib\win32\release;D:\vcl\NexusDB4;%eurpath%
set libsearchpath=%libsearchpath%;D:\Projects\webhubdemos\Source\WHApps\Externals\omnithreadlibrary-read-only\src;D:\Projects\webhubdemos\Source\WHApps\Externals\omnithreadlibrary-read-only
set outputroot=%~dp0..\..\Live\WebHub\Apps
:: vcldbx requires bdertl !!! 
set pkg=vcl;vclx;vcldb;soaprtl;xmlrtl;inet;ldiRegExLib;ZaphodsMapLib;WebHub;WebHubDB
set compilerflags=PREVENTSVCMGR;INHOUSE;use_IBO;USE_TIBODataset;
set includepath=h:\;k:\Rubicon\source\inc;K:\Vendors\CPS\IBObjects\v5.x\source\common;

%CSSend% libsearchpath %libsearchpath%
%CSSend% pkg %pkg%

::-GD creates detailed MAP file (required for EurekaLog)

:: extra parameters for Delphi XE2+
set dccflags=--no-config -GD -M -Q -AGenerics.Collections=System.Generics.Collections;Generics.Defaults=System.Generics.Defaults;WinTypes=Windows;WinProcs=Windows
if "%compilerdigits%"=="20" set dccflags=%dccflags%;DbiTypes=BDE;DbiProcs=BDE;DbiErrs=BDE
set dccns=-NSSystem;Xml;Data;Datasnap;Web;Soap;Winapi;System.Win;Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell

if exist %1.cfg REN %1.cfg %1.off
if exist %1.dproj REN %1.dproj %1.dprojoff

if "%raizepath%"=="" %CSSend% "skip CodeSite here"
if "%raizepath%"=="" goto continue030
%CSSend% 1demo d%compilerdigits%_win32 %1
@del %outputroot%\%1.exe %1.raize.bin

set LUFlags=
:: vcldbx;
if NOT "%2"=="EurekaLog" set LUFlags=-LUvcl;vclx;vcldb;soaprtl;xmlrtl;inet;ldiRegExLib

set ok1=yes
@echo on
"%dcc%"  %1.dpr -w -h -b -nd:\temp\DelphiTempDCU "-E%outputroot%" -DCodeSite;Log2CSL;%compilerflags% %LUFlags% "-u%libsearchpath%;%raizepath%" -R%libsearchpath% -I%includepath% /$D- /$L- /$Y- /$Q- /$R %dccflags% %dccns%
if errorlevel 1 set ok1=no
@echo off

if exist %1.off REN %1.off %1.cfg
if exist %1.dprojoff REN %1.dprojoff %1.dproj

if "%ok1%"=="yes" %CSSend% "ok1 %1.dpr yes ... %ok1% with -DCodeSite;Log2CSL;%compilerflags%"
if "%ok1%"=="yes" COPY %outputroot%\%1.exe %outputroot%\%1.raize.bin
if "%ok1%"=="no" %CSSend% /error "%1.dpr failed to compile for CodeSite"
if "%ok1%"=="no" pause

if NOT "%2"=="EurekaLog" goto continue030

:: ************************
:: EurekaLog compiler ecc32
:: ************************
%CSSend% "EurekaLog requested for %1.exe"
if NOT exist %outputroot%\%1.exe %CSSend% /error "File not found: %outputroot%\%1.exe"
if NOT exist %outputroot%\%1.exe goto continue030
%droot%\bin\ecc32.exe "--el_alter_exe=NUL;%outputroot%\%1.exe" --el_gui_error=463110  "--el_outputfilename=%outputroot%\%1.exe" --el_outputfilehandle=3960 --el_UnicodeOutput --el_config=%~dp0..\WHApps\Common\EurekaLog_v7_Options.eof --el_verbose --el_source=MAP
COPY %outputroot%\%1.exe %outputroot%\%1_eur.exe
DEL %outputroot%\%1.exe 

:continue030
@del d:\temp\DelphiTempDCU\*.dcu
set ok1=yes
echo on
"%dcc%" %1.dpr -w -h -b -nd:\temp\DelphiTempDCU -E%outputroot% -D%compilerflags% -LU%pkg% -u%libsearchpath% -R%libsearchpath% -I%includepath% /$D- /$L- /$Y- /$Q- /$R %dccflags% %dccns%
if errorlevel 1 set ok1=no
@echo off
if "%ok1%"=="yes" %CSSend% "%1.dpr compiled with -D%compilerflags% -LU%pkg%"
if "%ok1%"=="no"  %CSSend% /error "%1.dpr failed to compile with -D%compilerflags%"
if "%ok1%"=="no"  pause

:cleanup
@echo off
del %outputroot%\*.map
del %outputroot%\*.drc
if exist %1.off REN %1.off %1.cfg
if exist %1.dprojoff REN %1.dprojoff %1.dproj
