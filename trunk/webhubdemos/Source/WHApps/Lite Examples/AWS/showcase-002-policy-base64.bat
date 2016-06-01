setlocal

set  inputfilespec=showcase-001-upload.policy.json
set outputfilespec=showcase-003-upload.policy.viaopenssl.base64.txt

CD /D %~dp0

type %inputfilespec% | D:\Apps\OpenSSL\OpenSSL-Win64\bin\openssl.exe base64 > %outputfilespec%

type %outputfilespec%

pause
