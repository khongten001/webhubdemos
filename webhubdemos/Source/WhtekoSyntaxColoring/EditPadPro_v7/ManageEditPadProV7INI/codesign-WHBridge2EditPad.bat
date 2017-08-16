:: codesign-WHBridge2EditPad.bat
:: Put a code signature on the release binary

setlocal

:: check the output folder
CD /D %~dp0..\..\..\TempBuild\Bin\Win64\Release
if errorlevel 1 pause

set FilespecToSign=%~dp0..\..\..\TempBuild\Bin\Win64\Release\WHBridge2EditPad.exe

call P:\AllHREFToolsProducts\Pak\AllSetupProduction\AllSetupScriptSource\InstallationBuilderBat\codesign_best.bat https://www.href.com/ "WebHub Bridge to EditPad Pro" 
if errorlevel 1 pause

endlocal
