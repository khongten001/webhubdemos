set CSSend=D:\Apps\HREFTools\MiscUtil\CodeSiteConsole.exe
set CSLogPathParams=/LogPath=D:\Projects\webhubdemos\Source\TempBuild
%CSSend% /note "compile-1demo_win32.bat %1 %2" %CSLogPathParams%

@echo off
if "%compilerdigits%"=="" call %~dp0\default-compilerdigits.bat

setlocal
@del d:\temp\DelphiTempDCU\*.dcu

:: use ZaphodsMap to find compiler
:: zmset.bat and ZMLookup.exe are FREE from HREF Tools Corp. via www.zaphodsmap.com
call %ZaphodsMap%zmset.bat droot UsingKey2Folder "HREFTools\Production\cv001 Delphi D%compilerdigits%"

:: use ZaphodsMap to find Raize CodeSite5 library root
call "%ZaphodsMap%zmset.bat" cslibroot UsingKey2Folder "HREFTools\Production\cv001 Delphi CodeSite5"

set dcc=%droot%bin\dcc32.exe
if not exist %dcc% %CSSend% /error "Does not exist: [%dcc%]" %CSLogPathParams%
if not exist %dcc% pause

set wbits=32
if "%compilerdigits%"=="24" set raizepath=%cslibroot%\RX10.1\win%wbits%
if "%compilerdigits%"=="23" set raizepath=%cslibroot%\RX10\win%wbits%
if "%compilerdigits%"=="22" set raizepath=%cslibroot%\RS-XE8\win%wbits%
if "%compilerdigits%"=="21" set raizepath=%cslibroot%\RS-XE7\win%wbits%
if "%compilerdigits%"=="20" set raizepath=%cslibroot%\RS-XE6\win%wbits%
if "%compilerdigits%"=="19" set raizepath=%cslibroot%\RS-XE5\win%wbits%
if "%compilerdigits%"=="18" set raizepath=%cslibroot%\RS-XE4\win%wbits%
if "%compilerdigits%"=="17" set raizepath=%cslibroot%\RS-XE3\win%wbits%

set eurpath=D:\vcl\EurekaLog7\Lib\Win32\Release\Delphi%compilerdigits%

set ibopath=K:\Vendors\CPS\IBObjects\v5.x\source\common;K:\Vendors\CPS\IBObjects\v5.x\source\tdataset;K:\Vendors\CPS\IBObjects\v5.x\source\tools;K:\Vendors\CPS\IBObjects\v5.x\source\core;K:\Vendors\CPS\IBObjects\v5.x\source\access
set libsearchpath=h:\;h:\dcu_d%compilerdigits%_win32;h:\pkg_d%compilerdigits%_win32;k:\webhub\lib\whplus\rubi;k:\Rubicon\source;%ibopath%;%droot%lib\win32\release;D:\vcl\NexusDB4;%eurpath%
:: async requires OTL OmniThreadLibrary
set libsearchpath=%libsearchpath%;D:\Projects\webhubdemos\Source\WHApps\Externals\omnithreadlibrary-read-only\src;D:\Projects\webhubdemos\Source\WHApps\Externals\omnithreadlibrary-read-only
set outputroot=%~dp0..\..\Live\WebHub\Apps
:: vcldbx requires bdertl !!! Not available immediately when XE7 shipped.
set pkg=vcl;vclx;vcldb;soaprtl;xmlrtl;inet;ldiRegExLib;ZaphodsMapLib;WebHub;WebHubDB
if "%compilerdigits%"=="24" set pkg=%pkg%;vcldbx
if "%compilerdigits%"=="23" set pkg=%pkg%;vcldbx
if "%compilerdigits%"=="22" set pkg=%pkg%;vcldbx;bdertl
if "%compilerdigits%"=="21" set pkg=%pkg%;vcldbx
if "%compilerdigits%"=="20" set pkg=%pkg%;vcldbx
set compilerflags=PREVENTSVCMGR;INHOUSE;use_IBO;USE_TIBODataset;
set includepath=h:\;k:\Rubicon\source\inc;K:\Vendors\CPS\IBObjects\v5.x\source\common;

:: %CSSend% libsearchpath %libsearchpath% %CSLogPathParams%
:: %CSSend% pkg %pkg% %CSLogPathParams%

::-GD creates detailed MAP file (required for EurekaLog)

:: extra parameters for Delphi XE2+
set dccflags=--no-config -GD -M -Q -AGenerics.Collections=System.Generics.Collections;Generics.Defaults=System.Generics.Defaults;WinTypes=Windows;WinProcs=Windows
if "%compilerdigits%"=="20" set dccflags=%dccflags%;DbiTypes=BDE;DbiProcs=BDE;DbiErrs=BDE
if "%compilerdigits%"=="22" set dccflags=%dccflags%;DbiTypes=BDE;DbiProcs=BDE;DbiErrs=BDE
set dccns=-NSSystem;Xml;Data;Datasnap;Web;Soap;Winapi;System.Win;Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell

if exist %1.cfg REN %1.cfg %1.off
if exist %1.dproj REN %1.dproj %1.dprojoff

%CSSend% d%compilerdigits%_win32 %1 %CSLogPathParams%

set LUFlags=
:: vcldbx;
if NOT "%2"=="EurekaLog" set LUFlags=-LUvcl;vclx;vcldb;soaprtl;xmlrtl;inet;ldiRegExLib
if "%compilerdigits%"=="20" set LUFlags=%LUFlags%;vcldbx

set ok1=yes
@echo on
"%dcc%"  %1.dpr -w -h -b -nd:\temp\DelphiTempDCU "-E%outputroot%" -DCodeSite;Log2CSL;%compilerflags% %LUFlags% "-u%libsearchpath%;%raizepath%" -R%libsearchpath% -I%includepath% /$D- /$L- /$Y- /$Q- /$R %dccflags% %dccns%
if errorlevel 1 set ok1=no
@echo off

if exist %1.off REN %1.off %1.cfg
if exist %1.dprojoff REN %1.dprojoff %1.dproj

if "%ok1%"=="yes" %CSSend% "ok1 %1.dpr yes ... %ok1% with -DCodeSite;Log2CSL;%compilerflags%" %CSLogPathParams%
if "%ok1%"=="no" %CSSend% /error "%1.dpr failed to compile for CodeSite with -DCodeSite;Log2CSL;%compilerflags%" %CSLogPathParams%
if "%ok1%"=="no" pause

if NOT "%2"=="EurekaLog" goto continue030

:: ************************
:: EurekaLog compiler ecc32
:: ************************
%CSSend% "EurekaLog requested for %1.exe" %CSLogPathParams%
if NOT exist %outputroot%\%1.exe %CSSend% /error "File not found: %outputroot%\%1.exe" %CSLogPathParams%
if NOT exist %outputroot%\%1.exe goto continue030
%droot%\bin\ecc32.exe "--el_alter_exe=NUL;%outputroot%\%1.exe" --el_gui_error=463110  "--el_outputfilename=%outputroot%\%1.exe" --el_outputfilehandle=3960 --el_UnicodeOutput --el_config=%~dp0..\WHApps\Common\EurekaLog_v7_Options.eof --el_verbose --el_source=MAP
COPY %outputroot%\%1.exe %outputroot%\%1_eur.exe
DEL %outputroot%\%1.exe 

:continue030
:: forget non-CodeSite variation

:cleanup
@echo off
del %outputroot%\*.map
del %outputroot%\*.drc
if exist %1.off REN %1.off %1.cfg
if exist %1.dprojoff REN %1.dprojoff %1.dproj
