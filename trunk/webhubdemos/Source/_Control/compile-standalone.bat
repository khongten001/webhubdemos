set CSSend=P:\AllHREFToolsProducts\Pak\AllSetupProduction\PakUtilities\CodeSiteConsole.exe


%CSSend% /note "compile-standalone.bat EMail_with_StartTLS"

cd %~dp0\..\StandaloneDemos\EMail_with_StartTLS

set compilerdigits=18
call %~dp0\compile-1demo_win32_nopackages.bat Test_Indy_Smtp

