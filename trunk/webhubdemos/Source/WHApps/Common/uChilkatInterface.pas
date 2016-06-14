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

function Chilkat_OpenSSL_Sign_SHA1(const StringToSign, PrivateKeyPEM
  : string): string;

//function Indy_OpenSSL_Sign_SHA1(const StringToSign, PrivateKeyPEM
//  : string): string;

implementation

uses
  SysUtils, System.Classes,
  Rsa, PrivateKey, // REQUIRES ChilkatDelphiXE.dll, otherwise EXE will exit !!
  IdCTypes, IdSSLOpenSSLHeaders, // REQUIRES Indy units that ship with Delphi
  ucCodeSiteInterface;


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

function Indy_OpenSSL_Sign_SHA1(const StringToSign, PrivateKeyPEM
  : string): string;
const
  cFn = 'Indy_OpenSSL_Sign_SHA1';
var
  x: TIdC_INT;
  ctx: EVP_MD_CTX;
  BP: pBIO;
  LKey: pEVP_PKEY;
  StringToSign8, PrivateKeyPEM8: UTF8String;
  iFinal: TIdC_INT;
begin
{$IFDEF LOGAWSSign}
  CSEnterMethod(nil, cFn);

  CSSend('StringToSign', StringToSign);
  CSSend('PrivateKeyPEM', PrivateKeyPEM);
{$ENDIF}

 {for the first command, you would initialize a signing ctx with
 EVP_SignInit(EVP_sha1()), then feed the raw .json data to it
 with EVP_SignUpdate(), and then sign it with the PEM key using
 EVP_SignFinal(),
 where the key is loaded with PEM_ASN1_read(d2i_PrivateKey()) or
 PEM_read_bio_PrivateKey().
 Then you can feed the final hash through TIdEncoderMIME to base64 encode it.
 }

  StringToSign8 := UTF8String(StringToSign);
  PrivateKeyPEM8 := UTF8String(PrivateKeyPEM);

  BP := BIO_new_mem_buf(@PrivateKeyPEM8, Length(PrivateKeyPEM8));

  LKey := PEM_read_bio_PrivateKey(BP,
    nil,
    nil,  // no password callback on the PEM itself
    nil);

  x := EVP_SignInit(@ctx, EVP_sha1());
  EVP_SignUpdate(@ctx, @StringToSign8, Length(StringToSign8));

  iFinal := EVP_SignFinal(@ctx, @StringToSign8, @x, LKey);

  ///////???? where is the content to be base64'd ??

  {$IFDEF LOGAWSSign}
  CSSend('iFinal', S(iFinal));
  CSExitMethod(nil, cFn);
  {$ENDIF}
end;

end.
