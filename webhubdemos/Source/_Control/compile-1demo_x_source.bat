@echo off
set CSSend=P:\AllHREFToolsProducts\Pak\AllSetupProduction\PakUtilities\CodeSiteConsole.exe
%CSSend% /note "compile-1demo_x_source.bat [%1]"

setlocal

call %~dp0\default-compilerdigits.bat
set newipcdebug=CodeSite;Log2CSL;LogBAD;LOGLINKS
set newipcdebug=CodeSite;Log2CSL;LogIPC;LOGHelo;LOGLICENSE

del d:\temp\DelphiTempDCU\*.dcu

:: use ZaphodsMap to find compiler
:: zmset.bat and ZMLookup.exe are FREE from HREF Tools Corp. via www.zaphodsmap.com
call %ZaphodsMap%zmset.bat droot UsingKey2Folder "HREFTools\Production\cv001 Delphi D%compilerdigits%"
set dcc=%droot%bin\dcc32.exe
if not exist "%droot%bin\dcc32.exe" pause

set ibopath=K:\Vendors\CPS\IBObjects\v5.x\source\common;K:\Vendors\CPS\IBObjects\v5.x\source\tdataset;K:\Vendors\CPS\IBObjects\v5.x\source\tools;K:\Vendors\CPS\IBObjects\v5.x\source\core;K:\Vendors\CPS\IBObjects\v5.x\source\access
set libsearchpath="K:\webhub\lib;K:\webhub\lib\whvcl;K:\webhub\lib\whplus;K:\webhub\lib\whplus\cc;K:\webhub\lib\whdb;K:\webhub\tpack;K:\webhub\lib\wheditors;K:\webhub\lib\whrun;k:\webhub\zaphodsmap;k:\webhub\regex;k:\Rubicon\source;%ibopath%"
set outputroot=d:\Projects\WebHubDemos\Live\WebHub\Apps
set pkg=
set compilerflags=PREVENTSVCMGR;use_IBO;USE_TIBODataset;WEBHUBACE;INHOUSE

set includepath=k:\webhub\tpack;k:\WebHub\lib;k:\Rubicon\source\inc;K:\Vendors\CPS\IBObjects\v5.x\source\common;
set objdir=K:\webhub\regex\Pcre-Delphi-Win32-bcc6
set flags=-b -W-SYMBOL_PLATFORM -W-UNIT_PLATFORM  -$O- -$W+ -$J+ -$Q+ -$C- -$Y- /$D- /$L-  /$R -K00400000 -GD 

:: extra parameters for Delphi XE2
set dccflags=--no-config -M -Q -AGenerics.Collections=System.Generics.Collections;Generics.Defaults=System.Generics.Defaults;WinTypes=Windows;WinProcs=Windows;DbiTypes=BDE;DbiProcs=BDE;DbiErrs=BDE
set dccns=-NSSystem;Xml;Data;Datasnap;Web;Soap;Winapi;System.Win;Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Bde;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell

if "%compilerdigits%"=="20" set raizelib=K:\Vendors\Raize\CodeSite5\Lib\RS-XE6\Win32
if "%compilerdigits%"=="19" set raizelib=K:\Vendors\Raize\CodeSite5\Lib\RS-XE5\Win32
if "%compilerdigits%"=="18" set raizelib=K:\Vendors\Raize\CodeSite5\Lib\RS-XE4\Win32
if "%compilerdigits%"=="17" set raizelib=K:\Vendors\Raize\CodeSite5\Lib\RS-XE3\Win32
if "%compilerdigits%"=="16" set raizelib=K:\Vendors\Raize\CodeSite5\Lib\RS-XE2\Win32
:: %CSSend% raizelib "%raizelib%"

:: off May-2013 set eurparams=--el_pathK:\Vendors\EurekaLab\EurekaLog6\Delphi16  --el_config"k:\webhub\hub\d07\href_eurekalog_whsilent.eof"
:: --el_output=el6 --el_mode=delphi --el_verbose 
:: off May-2013 set eurparams=

if exist %1.dproj REN %1.dproj %1.dproj_off

%CSSend% newipcdebug %newipcdebug%

if "%raizelib%"=="" goto continue040
del %outputroot%\%1_x_d%compilerdigits%_win32_debug_src.exe
if NOT "%newipcdebug%"=="" echo 1demo x_d%compilerdigits%_win32_debug %1 "%eurparams%"
if NOT "%newipcdebug%"=="" @echo on
set ok=yes
if NOT "%newipcdebug%"=="" "%droot%bin\dcc32.exe"  %1.dpr  -nd:\temp\DelphiTempDCU -E%outputroot% -D%compilerflags%;%newipcdebug% -LU%pkg% -u%libsearchpath%;%droot%\lib\win32\release;%raizelib% -R%libsearchpath% -I%includepath% -O%objdir% %dccflags% %dccns% %flags% %eurparams%
if NOT "%newipcdebug%"=="" @if errorlevel 1 set ok=no
if "%ok%"=="no" %CSSend% /error "failed to compile"
if "%ok%"=="no" pause
if NOT "%newipcdebug%"=="" ren %outputroot%\%1.exe %1_x_d%compilerdigits%_win32_debug_src.exe

:continue040
del %outputroot%\%1_x_d%compilerdigits%_win32_src.exe
echo 1demo x_d%compilerdigits%_win32 %1 "%eurparams%"
@echo on
"%droot%bin\dcc32.exe"  %1.dpr  -nd:\temp\DelphiTempDCU -E%outputroot% -D%compilerflags% -LU%pkg% -u%libsearchpath%;%droot%\lib\win32\release;%raizelib% -R%libsearchpath% -I%includepath% -O%objdir% %dccflags% %dccns% %flags% %eurparams%
@if errorlevel 1 pause
ren %outputroot%\%1.exe %1_x_d%compilerdigits%_win32_src.exe

if "%compilerdigits%"=="20" set raizelib=K:\Vendors\Raize\CodeSite5\Lib\RS-XE6\Win64
if "%compilerdigits%"=="19" set raizelib=K:\Vendors\Raize\CodeSite5\Lib\RS-XE5\Win64
if "%compilerdigits%"=="18" set raizelib=K:\Vendors\Raize\CodeSite5\Lib\RS-XE4\Win64
if "%compilerdigits%"=="17" set raizelib=K:\Vendors\Raize\CodeSite5\Lib\RS-XE3\Win64
if "%compilerdigits%"=="16" set raizelib=K:\Vendors\Raize\CodeSite5\Lib\RS-XE2\Win64
P:\AllHREFToolsProducts\Pak\AllSetupProduction\PakUtilities\CodeSiteConsole.exe raizelib "%raizelib%"

::win64
if "%raizelib%"=="" goto continue041
@del %outputroot%\%1_x_d%compilerdigits%_win64_src.exe
set objdir=K:\webhub\regex\Pcre-Delphi-Win64-msc
%CSSend% win64 %1.dpr
%CSSend% outputroot %outputroot%
set okflag=yes
@echo on
%droot%bin\dcc64.exe  %1.dpr  -nd:\temp\DelphiTempDCU -E%outputroot% -D%compilerflags%;%newipcdebug% -LU%pkg% -u%libsearchpath%;%droot%\lib\win64\release;%raizelib% -R%libsearchpath% -I%includepath% -O%objdir% %dccflags% %dccns% %flags% %eurparams%
if errorlevel 1 set okflag=no
if "%okflag%"=="no" %CSSend% /error "Failed to compile %1.dpr for win64"
if "%okflag%"=="no" pause

set okflag=yes
ren %outputroot%\%1.exe %1_x_d%compilerdigits%_win64_src.exe
if errorlevel 1 set okflag=no
if "%okflag%"=="no" %CSSend% /error "Failed to rename %1.exe"
if "%okflag%"=="no" pause


:continue041
@echo off
if exist %1.dproj REN %1.dproj_off %1.dproj

@cd /d %outputroot%
::eur off if NOT "%eurparams%"=="" del %1_x_d%compilerdigits%_win32_debug_src.exe
::eur off if "%eurparams%"=="" del %1_x_d%compilerdigits%_win32_src.exe
::eur off if NOT "%eurparams%"=="" ren %1.exe %1_x_d%compilerdigits%_win32_debug_src.exe
::eur off if "%eurparams%"=="" ren %1.exe %1_x_d%compilerdigits%_win32_src.exe
if errorlevel 1 pause

@del *.drc
@del *.map

