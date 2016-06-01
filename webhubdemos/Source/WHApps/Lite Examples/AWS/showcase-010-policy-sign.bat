setlocal

set opensslpath=D:\Apps\OpenSSL\OpenSSL-Win64\bin\

set   inputfilespec=showcase-003-upload.policy.viaopenssl.base64.txt
set outputfilespec1=showcase-020-upload.policy.viaopenssl.signed.txt

set /P secretkey=Enter secret key :

CD /D %~dp0

del %outputfilespec1%

type %inputfilespec% | %opensslpath%openssl.exe dgst -hmac %secretkey% -sha1 -out %outputfilespec1% 

pause
type %outputfilespec1%

copy %outputfilespec1% showcase-021-upload.policy.viaopenssl.signed-cleaned.txt
@echo off
echo Use Notepad to leave just the answer in the cleaned file...
pause

notepad showcase-021-upload.policy.viaopenssl.signed-cleaned.txt

