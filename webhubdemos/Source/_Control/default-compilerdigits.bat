:: default-compilerdigits.bat

if "%compilerdigits%"=="" set bits=64
if "%compilerdigits%"=="" call %~dp0set-compilerdigits.bat

