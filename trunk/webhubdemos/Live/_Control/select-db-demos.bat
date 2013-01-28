:: select-db-demos.bat
:: Copyright (c) 2011-2012 HREF Tools Corp.
:: www.href.com

call %ZaphodsMap%\zmset.bat whipc UsingKey2Value "HREFTools\Install WebHub ipc old"

echo .
echo ***
echo ipc is %whipc%
echo ***
echo .

:: init all to NO
set demodbhtml=no
set demodsp=no
set demodpr=no
set democoderage=yes
set demofire=no
set demohtcl=no
set demohtfm=no
set demohtfs=yes
set demohtq1=yes
set demohtq2=yes
set demohtq3=yes
set demohtq4=yes
set demohtru=no
set demojpeg=yes
set demoscan=yes
set demoshop1=yes
set demostore000=no

set compiledbhtml=no
set compiledsp=yes
set compiledpr=yes
set compilecoderage=yes
set compilefire=yes
set compilehtcl=yes
set compilehtfm=yes
set compilehtfs=yes
set compilehtq1=yes
set compilehtq2=yes
set compilehtq3=yes
set compilehtq4=yes
set compilehtru=no
set compilejpeg=yes
set compilescan=yes
set compileshop1=yes
set compilestore000=no

if "%whipc%"=="old" set demodbhtml=yes
if "%whipc%"=="x"    set demodbhtml=no

call %ZaphodsMap%zmset.bat flagdemosdsp UsingKey2Value "HREFTools/WebHub/cv004 SystemStartup demosdsp"
echo flagdemosdsp is %flagdemosdsp%

set demodsp=no
if "%flagdemosdsp%"=="yes" set demodsp=yes
if "%flagdemosdsp%"=="yes" set demodpr=yes

call %ZaphodsMap%zmset.bat flagdemosdb UsingKey2Value "HREFTools/WebHub/cv004 SystemStartup demosdb"
echo flagdemosdb is %flagdemosdb%

if "%flagdemosdb%"=="no" goto end

set demofire=yes

set demohtcl=yes

set demohtfm=yes

set demohtfs=yes
set demojpeg=yes
set demohtq1=yes

:end
