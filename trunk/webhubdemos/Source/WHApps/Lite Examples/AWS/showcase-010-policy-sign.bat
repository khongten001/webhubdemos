setlocal

set opensslpath=D:\Apps\OpenSSL\OpenSSL-Win64\bin\

set  inputfilespec=showcase-003-upload.policy.viaopenssl.base64.txt
set outputfilespec=showcase-011-upload.policy.viaopenssl.signed.base64.txt

set /P secretkey=Enter secret key :

CD /D %~dp0

@del %outputfilespec%

%opensslpath%openssl.exe dgst -sha1 -hmac "%secretkey%" -binary %inputfilespec% | %opensslpath%openssl.exe base64 -A > %outputfilespec% 

if errorlevel 1 pause
type %outputfilespec%

pause

