@echo off
set CSSend=P:\AllHREFToolsProducts\Pak\AllSetupProduction\PakUtilities\CodeSiteConsole.exe
%CSSend% /note "compile-1demo_win32_svc.bat %1"

call %~dp0\default-compilerdigits.bat
setlocal

del d:\temp\DelphiTempDCU\*.dcu

:: use ZaphodsMap to find compiler
:: zmset.bat and ZMLookup.exe are FREE from HREF Tools Corp. via www.zaphodsmap.com
call %ZaphodsMap%zmset.bat droot UsingKey2Folder "HREFTools\Production\cv001 Delphi D%compilerdigits%"
set dcc=%droot%bin\dcc32.exe
if not exist %dcc% pause

if "%compilerdigits%"=="21" set raizelib=K:\Vendors\Raize\CodeSite5\Lib\RS-XE7\Win32
if "%compilerdigits%"=="20" set raizelib=K:\Vendors\Raize\CodeSite5\Lib\RS-XE6\Win32
if "%compilerdigits%"=="19" set raizelib=K:\Vendors\Raize\CodeSite5\Lib\RS-XE5\Win32
if "%compilerdigits%"=="18" set raizelib=K:\Vendors\Raize\CodeSite5\Lib\RS-XE4\Win32
set libsearchpath=h:\;h:\dcu_d%compilerdigits%_win32;h:\pkg_d%compilerdigits%_win32;%raizelib%;%droot%lib\win32\release;
set outputroot="d:\Projects\WebHubDemos\Live\WebHub\Apps"
set pkg="vcl;vclx;soaprtl;xmlrtl;inet;"
:: LogInitFinal;LogAppTick;CodeSite;LogTerminate;LogHelo
set compilerflags=USE_TIBODataset;INHOUSE
set includepath=h:\;
set dcu=d:\temp\DelphiTempDCU
set respath=%droot%lib\win32\release

:: extra parameters for Delphi XE2+
set dccflags=--no-config -GD -M -Q -AGenerics.Collections=System.Generics.Collections;Generics.Defaults=System.Generics.Defaults;WinTypes=Windows;WinProcs=Windows
if "%compilerdigits%"=="20" set dccflags=%dccflags%;DbiTypes=BDE;DbiProcs=BDE;DbiErrs=BDE
set dccns=-NSSystem;Xml;Data;Datasnap;Web;Soap;Winapi;System.Win;Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell


if exist %1.cfg REN %1.cfg %1.off
if exist %1.dproj REN %1.dproj %1.dprojoff

%CSSend% "as-service d%compilerdigits%_win32 %1"

set okflag=yes
@echo on
"%dcc%"  -w -h -b %1.dpr  -n%dcu% -E%outputroot% -D%compilerflags% -LU%pkg% "-u%libsearchpath%" "-R%respath%;%libsearchpath%" -I%includepath% /$D- /$L- /$Y- /$Q- /$R %dccflags% %dccns%
if errorlevel 1 set okflag=no
@echo off
if "%okflag%"=="yes" %CSSend% "Compiled %1.dpr -D%compilerflags% -LU%pkg%"
if "%okflag%"=="no"  %CSSend% /error "Failed to compile %1.dpr -D%compilerflags% -LU%pkg%"
if "%okflag%"=="no"  pause

if exist %1.off REN %1.off %1.cfg
if exist %1.dprojoff REN %1.dprojoff %1.dproj

endlocal
