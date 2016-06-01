setlocal

set  inputfilespec=showcase.upload.policy.json
set outputfilespec=showcase.upload.policy.viaopenssl.base64.txt

CD /D %~dp0

type %inputfilespec% | D:\Apps\OpenSSL\OpenSSL-Win64\bin\openssl.exe base64 > %outputfilespec%

type %outputfilespec%

pause
