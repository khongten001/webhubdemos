:: select-db-demos.bat
:: Copyright (c) 2011 HREF Tools Corp.
:: www.href.com

call %ZaphodsMap%\zmset.bat whipc UsingKey2Value "HREFTools\Install WebHub ipc old"

echo .
echo ***
echo ipc is %whipc%
echo ***
echo .

set demodbhtml=no
set demodsp=no
set democoderage=no
set demofire=no
set demohtcl=no
set demohtfm=no
set demohtfs=no
set demohtq1=no
set demohtq2=no
set demohtq3=no
set demohtq4=no
set demohtru=no
set demojpeg=no
set demoscan=no
set demoshop1=no
set demostore000=no

set compiledbhtml=no
set compiledsp=yes
set compilecoderage=no
set compilefire=yes
set compilehtcl=no
set compilehtfm=yes
set compilehtfs=yes
set compilehtq1=no
set compilehtq2=no
set compilehtq3=no
set compilehtq4=no
set compilehtru=no
set compilejpeg=yes
set compilescan=no
set compileshop1=yes
set compilestore000=no

if "%whipc%"=="old" set demodbhtml=yes
if "%whipc%"=="x"    set demodbhtml=no

call %ZaphodsMap%zmset.bat flagdemosdsp UsingKey2Value "HREFTools/WebHub/cv004 SystemStartup demosdsp"
echo flagdemosdsp is %flagdemosdsp%

set demodsp=no
if "%flagdemosdsp%"=="yes" set demodsp=yes

call %ZaphodsMap%zmset.bat flagdemosdb UsingKey2Value "HREFTools/WebHub/cv004 SystemStartup demosdb"
echo flagdemosdb is %flagdemosdb%

if "%flagdemosdb%"=="no" goto end

if "%whipc%"=="old" set demofire=yes
if "%whipc%"=="x"    set demofire=yes

if "%whipc%"=="old" set demohtcl=yes
if "%whipc%"=="x"    set demohtcl=no

if "%whipc%"=="old" set demohtfm=yes
if "%whipc%"=="x"    set demohtfm=no

if "%whipc%"=="old" set demohtfs=yes
if "%whipc%"=="x"    set demohtfs=yes

if "%whipc%"=="old" set demojpeg=yes
if "%whipc%"=="x"    set demojpeg=yes

if "%whipc%"=="old" set demoshop1=yes
if "%whipc%"=="x"    set demoshop1=no

:end
