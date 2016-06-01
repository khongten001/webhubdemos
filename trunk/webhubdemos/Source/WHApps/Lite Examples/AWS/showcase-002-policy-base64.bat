setlocal

set  inputfilespec=showcase-001-upload.policy.json
set outputfilespec=showcase-003-upload.policy.viaopenssl.base64.txt

CD /D %~dp0

:: Thanks to https://wiki.openssl.org/index.php/Enc for the -A flag !!!!!!!

type %inputfilespec% | D:\Apps\OpenSSL\OpenSSL-Win64\bin\openssl.exe base64 -A > %outputfilespec%

type %outputfilespec%

pause
