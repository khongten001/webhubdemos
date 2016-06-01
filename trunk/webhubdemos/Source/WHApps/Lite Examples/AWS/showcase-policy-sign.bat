setlocal

set opensslpath=D:\Apps\OpenSSL\OpenSSL-Win64\bin\

set   inputfilespec=showcase.upload.policy.viaopenssl.base64.txt
set outputfilespec1=showcase.upload.policy.viaopenssl.signed.txt
set outputfilespec2=showcase.upload.policy.viaopenssl.signed.base64.txt

set /P secretkey=Enter secret key :

CD /D %~dp0

type %filespec% | %opensslpath%openssl.exe dgst -hmac %secretkey% -sha1 > %outputfilespec1% 

type %filespec% | %opensslpath%openssl.exe dgst -hmac %secretkey% -sha1 | %opensslpath%openssl.exe base64 > %outputfilespec2% 

dir showcase.upload.policy.viaopenssl.signed*

pause
