@echo off
set CSSend=D:\Apps\HREFTools\MiscUtil\CodeSiteConsole.exe
set CSLogPathParams=/LogPath=D:\Projects\webhubdemos\Source\TempBuild
%CSSend% /note "compile-1demo_win64_nopackages.bat [%1]" %CSLogPathParams%
call %~dp0\default-compilerdigits.bat
setlocal

del d:\temp\DelphiTempDCU\*.dcu

:: use ZaphodsMap to find compiler
:: zmset.bat and ZMLookup.exe are FREE from HREF Tools Corp. via www.zaphodsmap.com
call %ZaphodsMap%zmset.bat droot UsingKey2Folder "HREFTools\Production\cv001 Delphi D%compilerdigits%"
set dcc=%droot%bin\dcc64.exe
if not exist %dcc% pause

:: use ZaphodsMap to find Raize CodeSite5 library root
call "%ZaphodsMap%zmset.bat" cslibroot UsingKey2Folder "HREFTools\Production\cv001 Delphi CodeSite5"

set wbits=64
if "%compilerdigits%"=="24" set raizepath=%cslibroot%\RX10.1\win%wbits%
if "%compilerdigits%"=="23" set raizepath=%cslibroot%\RX10\win%wbits%
if "%compilerdigits%"=="22" set raizepath=%cslibroot%\RS-XE8\win%wbits%
if "%compilerdigits%"=="21" set raizepath=%cslibroot%\RS-XE7\win%wbits%
if "%compilerdigits%"=="20" set raizepath=%cslibroot%\RS-XE6\win%wbits%
if "%compilerdigits%"=="19" set raizepath=%cslibroot%\RS-XE5\win%wbits%
if "%compilerdigits%"=="18" set raizepath=%cslibroot%\RS-XE4\win%wbits%
if "%compilerdigits%"=="17" set raizepath=%cslibroot%\RS-XE3\win%wbits%
set libsearchpath="h:\;h:\dcu_d%compilerdigits%_win64;k:\Rubicon\source;K:\Vendors\CPS\IBObjects\v5.x;%droot%lib\win64\release;D:\vcl\NexusDB4;"
set outputroot="d:\Projects\WebHubDemos\Live\WebHub\Apps"
set pkg=
:: flags off: ;LogAppTick;LOGIPC;LogHELO
set compilerflags=PREVENTSVCMGR;use_IBO;USE_TIBODataset;INHOUSE;CodeSite;Log2CSL
if "%1"=="whLite"  set compilerflags=%compilerflags%;AWSSUPPORT
if "%1"=="DServer" set compilerflags=%compilerflags%;AWSSUPPORT
set includepath=h:\;k:\Rubicon\source\inc;K:\Vendors\CPS\IBObjects\v5.x\

:: extra parameters for Delphi XE2
set dccflags=--no-config -M -Q -AGenerics.Collections=System.Generics.Collections;Generics.Defaults=System.Generics.Defaults;WinTypes=Windows;WinProcs=Windows
set dccns=-NSSystem;Xml;Data;Datasnap;Web;Soap;Winapi;System.Win;Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell


if exist %1.cfg REN %1.cfg %1.off

echo 1demo no-packages d%compilerdigits%_win64 %1

@echo on
set ok1=yes
"%dcc%"  %1.dpr  -w -h -b -nd:\temp\DelphiTempDCU -E%outputroot% -D%compilerflags% -LU%pkg% -u%libsearchpath%;%raizepath% -R%libsearchpath% -I%includepath% /$D- /$L- /$Y- /$Q- /$R %dccflags% %dccns%
if errorlevel 1 set ok1=no
if "%ok1%"=="no" %CSSend% /error "%1.dpr failed to compile" %CSLogPathParams%
if "%ok1%"=="no" pause
if "%ok1%"=="yes" cls

@echo off
if exist %1.off REN %1.off %1.cfg
