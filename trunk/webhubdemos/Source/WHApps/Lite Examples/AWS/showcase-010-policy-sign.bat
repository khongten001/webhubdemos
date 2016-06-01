setlocal

set opensslpath=D:\Apps\OpenSSL\OpenSSL-Win64\bin\

set   inputfilespec=showcase-003-upload.policy.viaopenssl.base64.txt

set outputfilespec2=showcase-023-upload.policy.viaopenssl.signed.base64.txt

set /P secretkey=Enter secret key :

CD /D %~dp0

@del %outputfilespec2%

%opensslpath%openssl.exe dgst -sha1 -hmac "%secretkey%" -binary %inputfilespec% | %opensslpath%openssl.exe base64 -A > %outputfilespec2% 

if errorlevel 1 pause
type %outputfilespec2%

pause


