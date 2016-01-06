:: select-db-demos.bat
:: Copyright (c) 2011-2014 HREF Tools Corp.
:: www.href.com

:: init all to NO
set demodbhtml=no
set demodpr=no
set democoderage=yes
set demofire=no
set demohtcl=no
set demohtfm=no
set demohtfs=yes
set demohtq1=no
set demohtq2=no
set demohtq3=no
set demohtq4=no
set demohtru=no
set demojpeg=yes
set demoscan=yes
set demoshop1=no
set demostore000=no

set compiledbhtml=yes
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

set demodbhtml=yes

call %ZaphodsMap%zmset.bat flagdemosdpr UsingKey2Value "HREFTools/WebHub/cv004 SystemStartup demosdpr"
echo flagdemosdpr is %flagdemosdpr%

if "%flagdemosdpr%"=="yes" set demodpr=yes

call %ZaphodsMap%zmset.bat flagdemosdb UsingKey2Value "HREFTools/WebHub/cv004 SystemStartup demosdb"
echo flagdemosdb is %flagdemosdb%

if "%flagdemosdb%"=="no" goto end

set demofire=yes

set demohtfm=yes

set demohtfs=yes
set demojpeg=yes
set demohtq1=yes

:end
