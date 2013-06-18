:: dcc_postbuild_dserver_win64_rename.bat
:: called from Delphi XE4 IDE
:: when compiling win64

cd /d %~dp0
cd ..\..\Live\WebHub\Apps
copy DServer.exe DServer_x_d18_win64.exe
if errorlevel 1 P:\AllHREFToolsProducts\Pak\AllSetupProduction\PakUtilities\CodeSiteConsole.exe /error "Could not copy to DServer_x_d18_win64.exe"
