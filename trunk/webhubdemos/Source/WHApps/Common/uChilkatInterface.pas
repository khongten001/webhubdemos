unit uChilkatInterface;

{ ---------------------------------------------------------------------------- }
{ *                                                                          * }
{ *  uChilkatInterface                                                       * }
{ *                                                                          * }
{ *  Pascal routines to interface with the Chilkat RSA DLL                   * }
{ *                                                                          * }
{ *  Download: https://www.chilkatsoft.com/delphiDll.asp                     * }
{ *  Purchase: https://www.chilkatsoft.com/purchase2.asp                     * }
{ *  Docs: https://www.chilkatsoft.com/refdoc/dd_CkRsaRef.html               * }
{ *                                                                          * }
{ ---------------------------------------------------------------------------- }

interface

{$I hrefdefines.inc}

function Chilkat_OpenSSL_Sign_SHA1(const StringToSign, PrivateKeyPEM
  : string): string;

implementation

uses
  SysUtils, System.Classes,
  {$IFDEF Delphi21UP}System.NetEncoding,{$ENDIF} // available in XE7
  Rsa, PrivateKey, // REQUIRES ChilkatDelphiXE.dll, otherwise EXE will exit !!
  ucCodeSiteInterface, ucAWS_Security;


function Chilkat_OpenSSL_Sign_SHA1(const StringToSign, PrivateKeyPEM
  : string): string;
const
  cFn = 'Chilkat_OpenSSL_Sign_SHA1';
var
  Rsa: HCkRsa;
  success: Boolean;
  aVersion: string;
  privkey: HCkPrivateKey;
  privateKeyXml: PWideChar;
begin
{$IFDEF LOGAWSSign}
  CSEnterMethod(nil, cFn);

  CSSend('StringToSign', StringToSign);
  CSSend('PrivateKeyPEM', PrivateKeyPEM);
{$ENDIF}

  privkey := nil;
  privateKeyXml := nil;

  Rsa := CkRsa_Create();

  success := CkRsa_UnlockComponent(Rsa, 'Anything for 30-day trial');
  if success then
  begin

    aVersion := CkRsa__version(Rsa);
{$IFDEF LOGAWSSign}
    CSSend('CkRsa version', aVersion);
{$ENDIF}

    CkRsa_putEncodingMode(Rsa, 'base64');
    // Valid EncodingModes are "base64", "hex", "url", or "quoted-printable" (or "qp").
    // Important: If trying to match OpenSSL results, set the LittleEndian property = False.
    CkRsa_putLittleEndian(Rsa, False);

    privkey := CkPrivateKey_Create();

    // If the private key PEM is protected with a password, then
    // call LoadEncryptedPem.  Otherwise call LoadPem.
    success := CkPrivateKey_LoadPem(privkey, PWideChar(PrivateKeyPEM));
    if (success <> True) then
    begin
      CSSendError(cFn + sLineBreak + CkPrivateKey__lastErrorText(privkey));
    end
    else
    begin

      privateKeyXml := CkPrivateKey__getXml(privkey);
{$IFDEF LOGAWSSign}
      CSSend('privateKeyXml', string(privateKeyXml));
{$ENDIF}
      success := CkRsa_ImportPrivateKey(Rsa, privateKeyXml);
      if (success <> True) then
      begin
        CSSendError(cFn + sLineBreak + CkRsa__lastErrorText(Rsa));
      end
      else if NOT CkRsa_VerifyPrivateKey(Rsa, privateKeyXml) then
      begin
        CSSendError(cFn + ' PrivateKey fails the verification test.');
        success := False;
      end
      else
        {$IFDEF LOGAWSSign}CSSend('PEM verified'){$ENDIF};
    end;

    if success then
    begin
      if NOT CkRsa_ImportPrivateKey(Rsa, privateKeyXml) then
        CSSendError(cFn + sLineBreak + CkRsa__lastErrorText(Rsa))
      else
      begin
        Result := CkRsa__signStringENC(Rsa, PChar(StringToSign), 'sha-1');
        {$IFDEF LOGAWSSign}CSSend(cFn + ': Result', Result);{$ENDIF}
      end;
    end;

  end;
  CkPrivateKey_Dispose(privkey);
  CkRsa_Dispose(Rsa);

  {$IFDEF LOGAWSSign}
  CSExitMethod(nil, cFn);
  {$ENDIF}
end;

end.
