@echo off
setlocal
:: use ZaphodsMap to find compiler
:: zmset.bat and ZMLookup.exe are FREE from HREF Tools Corp. via www.zaphodsmap.com
call %ZaphodsMap%zmset.bat d16 UsingKey2Folder "HREFTools\Production\cv001 Delphi D16"
set dcc=%d16%bin\dcc64.exe
if not exist %dcc% pause

::set raizelib=K:\Vendors\Raize\CodeSite4\Source\VCL\Indy;K:\Vendors\Raize\CodeSite4\Source\VCL
set libsearchpath="h:\;h:\dcu_d16_win64;h:\pkg_d16_win64;%raizelib%;%d16%\lib\win64\release;"
set outputroot="d:\Projects\WebHubDemos\Live\WebHub\Apps"
set pkg="vcl;vclx;vcldb;soaprtl;xmlrtl;inet;"
set compilerflags=
set includepath=h:\;
set dcu=d:\temp\DelphiTempDCU

:: extra parameters for Delphi XE2
set dccflags=--no-config -M -Q -AGenerics.Collections=System.Generics.Collections;Generics.Defaults=System.Generics.Defaults;WinTypes=Windows;WinProcs=Windows;DbiTypes=BDE;DbiProcs=BDE;DbiErrs=BDE
set dccns=-NSSystem;Xml;Data;Datasnap;Web;Soap;Winapi;System.Win;Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Bde;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell


ren %1.cfg %1.off

echo 1demo as-service d16_win64 %1

@echo on
"%dcc%"  -w -h -b %1.dpr  -n%dcu% -E%outputroot% -D%compilerflags% -LU%pkg% -u%libsearchpath% -R%libsearchpath% -I%includepath% /$D- /$L- /$Y- /$Q- /$R %dccflags% %dccns%
if errorlevel 1 pause

@echo off
ren %1.off %1.cfg

endlocal
