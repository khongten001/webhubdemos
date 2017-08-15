:: codesign_setupeditpad.bat
:: Put a code signature on the release binary

setlocal

:: check the output folder
CD /D %~dp0..\..\TempBuild\Bin\Win32\Release
if errorlevel 1 pause

set FilespecToSign=%~dp0..\..\TempBuild\Bin\Win32\Release\SetupEditPadForWebHub.exe

call P:\AllHREFToolsProducts\Pak\AllSetupProduction\AllSetupScriptSource\InstallationBuilderBat\codesign_best.bat https://www.href.com/ "Configure EditPad Pro for use with WebHub"
if errorlevel 1 pause

endlocal
