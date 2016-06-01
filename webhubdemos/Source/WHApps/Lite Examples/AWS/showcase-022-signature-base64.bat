setlocal

set opensslpath=D:\Apps\OpenSSL\OpenSSL-Win64\bin\

set  inputfilespec=showcase-021-upload.policy.viaopenssl.signed-cleaned.txt

set outputfilespec=showcase-023-upload.policy.viaopenssl.signed.base64.txt

CD /D %~dp0

del %outputfilespec%

%opensslpath%openssl.exe base64 -A -in %inputfilespec% -out %outputfilespec% 

dir showcase-02?-upload.policy.viaopenssl.signed*

type %outputfilespec%
pause

