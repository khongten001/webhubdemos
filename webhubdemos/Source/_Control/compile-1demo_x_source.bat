@echo off
set CSSend=D:\Apps\HREFTools\MiscUtil\CodeSiteConsole.exe
set CSLogPathParams=/LogPath=D:\Projects\webhubdemos\Source\TempBuild
%CSSend% /note "compile-1demo_x_source.bat [%1]" %CSLogPathParams%

setlocal

call %~dp0\default-compilerdigits.bat
:: unused ... set newipcdebug=CodeSite;Log2CSL;LogBAD;LOGLINKS;LogIPC;LOGHelo;LOGLICENSE;
set newipcdebug=CodeSite;Log2CSL;LogSTime;

:: use ZaphodsMap to find compiler
:: zmset.bat and ZMLookup.exe are FREE from HREF Tools Corp. via www.zaphodsmap.com
call %ZaphodsMap%zmset.bat droot UsingKey2Folder "HREFTools\Production\cv001 Delphi D%compilerdigits%"
set dcc=%droot%bin\dcc32.exe
if not exist "%droot%bin\dcc32.exe" pause

:: use ZaphodsMap to find Raize CodeSite5 library root
call "%ZaphodsMap%zmset.bat" cslibroot UsingKey2Folder "HREFTools\Production\cv001 Delphi CodeSite5"

set ibopath=K:\Vendors\CPS\IBObjects\v5.x\source\common;K:\Vendors\CPS\IBObjects\v5.x\source\tdataset;K:\Vendors\CPS\IBObjects\v5.x\source\tools;K:\Vendors\CPS\IBObjects\v5.x\source\core;K:\Vendors\CPS\IBObjects\v5.x\source\access
set libsearchpath="k:\webhub\zaphodsmap;K:\webhub\lib;K:\webhub\lib\whvcl;K:\webhub\lib\whplus;K:\webhub\lib\whplus\cc;K:\webhub\lib\whdb;K:\webhub\tpack;K:\webhub\lib\wheditors;K:\webhub\lib\whrun;k:\webhub\regex;k:\Rubicon\source;%ibopath%;"
set outputroot=d:\Projects\WebHubDemos\Live\WebHub\Apps
set pkg=
set compilerflags=PREVENTSVCMGR;use_IBO;USE_TIBODataset;INHOUSE

set includepath=k:\webhub\tpack;k:\WebHub\lib;k:\Rubicon\source\inc;K:\Vendors\CPS\IBObjects\v5.x\source\common;
set objdir=K:\webhub\regex\Pcre-Delphi-Win32-bcc6
set flags=-b -W-SYMBOL_PLATFORM -W-UNIT_PLATFORM  -$O- -$W+ -$J+ -$Q+ -$C- -$Y- /$D- /$L-  /$R -K00400000 -GD 

:: extra parameters for Delphi XE2
set dccflags=--no-config -M -Q -AGenerics.Collections=System.Generics.Collections;Generics.Defaults=System.Generics.Defaults;WinTypes=Windows;WinProcs=Windows
set dccns=-NSSystem;Xml;Data;Datasnap;Web;Soap;Winapi;System.Win;Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell

set wbits=32
call %~dp0set-raizepath.bat
%CSSend% raizepath "%raizepath%" %CSLogPathParams%

set eurparams=

if exist %1.dproj REN %1.dproj %1.dproj_off
if errorlevel 1 %CSSend% /warning "unable to rename .dproj out of the way" %CSLogPathParams%

%CSSend% newipcdebug %newipcdebug% %CSLogPathParams%

if "%raizepath%"=="" goto continue040
del %outputroot%\%1_x_d%compilerdigits%_win32_debug_src.exe
del d:\temp\DelphiTempDCU\*.dcu
if NOT "%newipcdebug%"=="" echo 1demo x_d%compilerdigits%_win32_debug %1 "%eurparams%"
if NOT "%newipcdebug%"=="" @echo on
set ok=yes
if NOT "%newipcdebug%"=="" "%droot%bin\dcc32.exe"  %1.dpr  -nd:\temp\DelphiTempDCU -E%outputroot% -D%compilerflags%;%newipcdebug% -LU%pkg% -u%libsearchpath%;h:\dcu_d%compilerdigits%_win32;%droot%\lib\win32\release;%raizepath% -R%libsearchpath% -I%includepath% -O%objdir% %dccflags% %dccns% %flags% %eurparams%
if NOT "%newipcdebug%"=="" @if errorlevel 1 set ok=no
if "%ok%"=="no" %CSSend% /error "failed to compile" %CSLogPathParams%
if "%ok%"=="no" pause
if NOT "%newipcdebug%"=="" ren %outputroot%\%1.exe %1_x_d%compilerdigits%_win32_debug_src.exe
if errorlevel 1 set ok=locked
if "%ok%"=="locked" %CSSend% /error "target file is locked; unable to rename to %1_x_d%compilerdigits%_win32_debug_src.exe" %CSLogPathParams%


:continue040
del %outputroot%\%1_x_d%compilerdigits%_win32_src.exe
del d:\temp\DelphiTempDCU\*.dcu

@echo on
set ok=yes
"%droot%bin\dcc32.exe"  %1.dpr  -nd:\temp\DelphiTempDCU -E%outputroot% -D%compilerflags% -LU%pkg% -u%libsearchpath%;h:\dcu_d%compilerdigits%_win32;%droot%\lib\win32\release;%raizepath% -R%libsearchpath% -I%includepath% -O%objdir% %dccflags% %dccns% %flags% %eurparams%
@if errorlevel 1 pause
ren %outputroot%\%1.exe %1_x_d%compilerdigits%_win32_src.exe
if errorlevel 1 set ok=locked
if "%ok%"=="locked" %CSSend% /error "target file is locked; unable to rename to %1_x_d%compilerdigits%_win32_src.exe" %CSLogPathParams%

set wbits=64
call %~dp0set-raizepath.bat
%CSSend% raizepath "%raizepath%" %CSLogPathParams%

::win64
if "%raizepath%"=="" goto continue041
@del %outputroot%\%1_x_d%compilerdigits%_win64_src.exe
del d:\temp\DelphiTempDCU\*.dcu
set objdir=K:\webhub\regex\Pcre-Delphi-Win64-msc
set okflag=yes
@echo on
%droot%bin\dcc64.exe  %1.dpr  -nd:\temp\DelphiTempDCU -E%outputroot% -D%compilerflags%;%newipcdebug% -LU%pkg% -u%libsearchpath%;h:\dcu_d%compilerdigits%_win64;%droot%\lib\win64\release;%raizepath% -R%libsearchpath% -I%includepath% -O%objdir% %dccflags% %dccns% %flags% %eurparams%
if errorlevel 1 set okflag=no
if "%okflag%"=="no" %CSSend% /error "Failed to compile %1.dpr for win64" %CSLogPathParams%
if "%okflag%"=="no" pause

set okflag=yes
ren %outputroot%\%1.exe %1_x_d%compilerdigits%_win64_src.exe
if errorlevel 1 set okflag=locked
if "%okflag%"=="locked" %CSSend% /error "target file is locked; unable to rename to %1_x_d%compilerdigits%_win64_src.exe" %CSLogPathParams%
if "%okflag%"=="locked" pause


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

set ok=
set okflag=
