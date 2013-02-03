setlocal

cd /d D:\Projects\webhubdemos\Live\WebHub\Apps
set FilespecToSign=D:\Projects\webhubdemos\Live\WebHub\Apps\Paradox2Xml.exe

call P:\AllHREFToolsProducts\Pak\AllSetupProduction\AllSetupScriptSource\InstallationBuilderBat\codesign_best.bat D:\Projects\webhubdemos\Live\WebHub\Apps\Paradox2Xml.exe http://www.href.com "Convert Paradox Table to XML File"
if errorlevel 1 pause

endlocal
