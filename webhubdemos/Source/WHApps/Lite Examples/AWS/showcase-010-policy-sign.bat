setlocal

set opensslpath=D:\Apps\OpenSSL\OpenSSL-Win64\bin\

set   inputfilespec=showcase-003-upload.policy.viaopenssl.base64.txt
set outputfilespec1=showcase-020-upload.policy.viaopenssl.signed.txt
set outputfilespec2=showcase-021-upload.policy.viaopenssl.signed.base64.txt

set /P secretkey=Enter secret key :

CD /D %~dp0

type %filespec% | %opensslpath%openssl.exe dgst -hmac %secretkey% -sha1 > %outputfilespec1% 

type %filespec% | %opensslpath%openssl.exe dgst -hmac %secretkey% -sha1 | %opensslpath%openssl.exe base64 -A > %outputfilespec2% 

dir showcase-02?-upload.policy.viaopenssl.signed*

type %outputfilespec2%
pause

