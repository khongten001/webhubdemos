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

function Indy_OpenSSL_Sign_SHA1(const StringToSign, PrivateKeyPEM
  : string): string;

implementation

uses
  SysUtils, System.Classes,
  {$IFDEF Delphi21UP}System.NetEncoding,{$ENDIF} // available in XE7
  Rsa, PrivateKey, // REQUIRES ChilkatDelphiXE.dll, otherwise EXE will exit !!
  IdCTypes, IdSSLOpenSSLHeaders, // REQUIRES Indy units that ship with Delphi
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

function Indy_OpenSSL_Sign_SHA1(const StringToSign, PrivateKeyPEM
  : string): string;
const
  cFn = 'Indy_OpenSSL_Sign_SHA1';
var
  ctx: EVP_MD_CTX;
  BP: pBIO;
  LKey: pEVP_PKEY;
  StringToSign8, PrivateKeyPEM8: UTF8String;
  lenPKey, lenOutput: Integer;
  arrayOfBytes: TBytes;
begin
{$IFDEF LOGAWSSign}
  CSEnterMethod(nil, cFn);
  CSSend('StringToSign', StringToSign);
{$ENDIF}
  Result := '';

  try
    // we start with having both the StringToSign and the key in PEM format.
    IdSSLOpenSSLHeaders.Load;

    StringToSign8 := UTF8String(StringToSign);
    PrivateKeyPEM8 := UTF8String(PrivateKeyPEM);

    BP := BIO_new_mem_buf(PAnsiChar(PrivateKeyPEM8), Length(PrivateKeyPEM8));
    if BP = nil then
      raise Exception.Create('out of memory!');

    try
      CSSend('about to call PEM_read_bio_PrivateKey');
      LKey := PEM_read_bio_PrivateKey(BP, nil, nil,
        // no password callback on the PEM itself
        nil);
      if LKey = nil then
        raise Exception.Create('cannot load private key!');
    finally
      CSSend('PEM_read_bio_PrivateKey ok');
      BIO_free(BP);
    end;

    try
      lenPKey := EVP_PKEY_size(LKey);
      CSSend('lenPKey', S(lenPKey));

      if lenPKey > 0 then
      begin
        SetLength(arrayOfBytes, lenPKey);

        CSSend('about to call EVP_SignInit');
        if EVP_SignInit(@ctx, EVP_sha1) <> 1 then
          raise Exception.Create('cannot initialize signing context');
        CSSend('EVP_SignInit ok');

        try
          CSSend('about to call EVP_SignUpdate');
          if EVP_SignUpdate(@ctx, PAnsiChar(StringToSign8),
            Length(StringToSign8)) <> 1 then
            raise Exception.Create('signing failed');

          CSSend('about to call EVP_SignFinal');
          if EVP_SignFinal(@ctx, @arrayOfBytes[1], @lenOutput, LKey) <> 1 then
            raise Exception.Create('signing failed');
          CSSend('lenOutput', S(lenOutput));

        finally
          CSSend('about to call EVP_MD_CTX_cleanup');
          EVP_MD_CTX_cleanup(@ctx);
        end;


        if lenOutput > 0 then
        begin
          CSSend('about to base64 encode');
          Result := TNetEncoding.Base64.EncodeBytesToString(@arrayOfBytes[0],
            lenOutput)
        end;

      end
      else
        CSSendError('no data');
    finally
      CSSend('about to call EVP_PKEY_free');
      EVP_PKEY_free(LKey);
    end;

  except
    on E: Exception do
    begin
      CSSendException(E);
    end;
  end;

  CSSend('Result', Result);
  IdSSLOpenSSLHeaders.Unload;

  SetLength(arrayOfbytes, 0);

{$IFDEF LOGAWSSign}
  CSExitMethod(nil, cFn);
{$ENDIF}
end;

end.
