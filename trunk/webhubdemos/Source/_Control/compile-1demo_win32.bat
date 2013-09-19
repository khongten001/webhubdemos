@echo off
call %~dp0\default-compilerdigits.bat

setlocal
del d:\temp\DelphiTempDCU\*.dcu

:: use ZaphodsMap to find compiler
:: zmset.bat and ZMLookup.exe are FREE from HREF Tools Corp. via www.zaphodsmap.com
call %ZaphodsMap%zmset.bat droot UsingKey2Folder "HREFTools\Production\cv001 Delphi D%compilerdigits%"
set dcc=%droot%bin\dcc32.exe
if not exist %dcc% pause

if "%compilerdigits%"=="19" set raizepath=
if "%compilerdigits%"=="18" set raizepath=K:\Vendors\Raize\CodeSite5\Lib\RS-XE4\Win32
if "%compilerdigits%"=="17" set raizepath=K:\Vendors\Raize\CodeSite5\Lib\RS-XE3\Win32
if "%compilerdigits%"=="16" set raizepath=K:\Vendors\Raize\CodeSite5\Lib\RS-XE2\Win32
set ibopath=K:\Vendors\CPS\IBObjects\v5.x\source\common;K:\Vendors\CPS\IBObjects\v5.x\source\tdataset;K:\Vendors\CPS\IBObjects\v5.x\source\tools;K:\Vendors\CPS\IBObjects\v5.x\source\core;K:\Vendors\CPS\IBObjects\v5.x\source\access
set libsearchpath="h:\;h:\dcu_d%compilerdigits%_win32;h:\pkg_d%compilerdigits%_win32;k:\webhub\lib\whplus\rubi;k:\Rubicon\source;%ibopath%;%droot%lib\win32\release;D:\vcl\NexusDB3;"
set outputroot="d:\Projects\WebHubDemos\Live\WebHub\Apps"
set pkg="vcl;vclx;vcldb;vcldbx;soaprtl;xmlrtl;inet;ldiRegExLib;ZaphodsMapLib;WebHub;WebHubDB"
set compilerflags=PREVENTSVCMGR;use_IBO;USE_TIBODataset;INHOUSE
set includepath=h:\;k:\Rubicon\source\inc;K:\Vendors\CPS\IBObjects\v5.x\source\common;

:: extra parameters for Delphi XE2+
set dccflags=--no-config -M -Q -AGenerics.Collections=System.Generics.Collections;Generics.Defaults=System.Generics.Defaults;WinTypes=Windows;WinProcs=Windows;DbiTypes=BDE;DbiProcs=BDE;DbiErrs=BDE
set dccns=-NSSystem;Xml;Data;Datasnap;Web;Soap;Winapi;System.Win;Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Bde;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell

ren %1.cfg %1.off

if "%raizepath%"=="" goto continue030
echo 1demo d%compilerdigits%_win32 %1
del %outputroot%\%1.exe %1.raize.bin
@echo on
"%dcc%"  %1.dpr -w -h -b -nd:\temp\DelphiTempDCU -E%outputroot% -DCodeSite;%compilerflags% -LUvcl;vclx;vcldb;vcldbx;soaprtl;xmlrtl;inet;ldiRegExLib -u%libsearchpath%;%raizepath% -R%libsearchpath% -I%includepath% /$D- /$L- /$Y- /$Q- /$R %dccflags% %dccns%
if errorlevel 1 pause
ren %outputroot%\%1.exe %1.raize.bin

:continue030
"%dcc%"  %1.dpr -w -h -b -nd:\temp\DelphiTempDCU -E%outputroot% -D%compilerflags% -LU%pkg% -u%libsearchpath% -R%libsearchpath% -I%includepath% /$D- /$L- /$Y- /$Q- /$R %dccflags% %dccns%
if errorlevel 1 pause

@echo off
ren %1.off %1.cfg
