unit ucAWS_CloudFront_PrivateURLs;

interface

uses
  SysUtils;

type TCloudFrontSecurityProvider = class(TObject)
  strict private
    FKeyPairID: string;
    FPrivateKeyPEM: string;
    FPolicy: string;
    FDiskFolder: string;
    function getUrlSafeString(const unsafeURLStr: string): string;
  protected
    procedure SetPolicy(const Value: string);
  public
    function GetCustomUrl(const url: string): string; overload;
    function GetCustomUrl(const url: string; const expirationUTC: TDateTime;
      const allowedCidr: string): string; overload;

/// <param name="policyPlain">Be sure that whitespace has already been stripped.
/// </param>
    function GetCustomUrl(const url, policyPlain: string): string;
      overload;

/// <param name="url">absolute url starting from http and ending with the file
/// to be retrieved.
/// </param>
/// <param name="expirationUTC">Expiration TDateTime for the policy. Required.
/// </param>
/// <param name="allowedCidr">allow access when client matches this Cidr;
/// example '192.168.0.0/24'; leave blank for no condition based on ip.
/// </param>
    function GetPolicyAsStr(const url: string; const expirationUTC: TDateTime;
      const allowedCidr: string): string;

    function Sign(const StringToSign: string): string;

    property DiskFolder: string read FDiskFolder write FDiskFolder;
    property Policy: string read FPolicy write SetPolicy;
    property KeyPairID: string read FKeyPairID write FKeyPairID;
    property PrivateKeyPEM: string read FPrivateKeyPEM write FPrivateKeyPEM;

end;

implementation

uses
  DateUtils, Classes,
  //ucLogFil,
  ucMsTime, ucString, ucAWS_Security, ucCodeSiteInterface,
  uChilkatInterface;

function TCloudFrontSecurityProvider.GetPolicyAsStr(const url: string;
  const expirationUTC: TDateTime; const allowedCidr: string): string;
const cFn = 'GetPolicyAsStr';
var
  sb: TStringBuilder;
  epoch: Int64;
begin
  sb := nil;
  try
    sb := TStringBuilder.Create;  // without any whitespace
    sb.Append('{');
    sb.Append('"Statement":[');
    sb.Append('{');
    sb.Append('"Resource":"');
      sb.Append(url);
      sb.Append('",');
    sb.Append('"Condition":{');
    if allowedCidr <> '' then
    begin
      sb.AppendFormat('"IpAddress":{"AWS:SourceIp":"%s"}',
        [allowedCidr]);
      sb.Append(',');
    end;
    if expirationUTC < NowUTC then
      LogProgrammerErrorToCodeSite(Format('%s: %s utc expires in the PAST', [cFn,
        FormatDateTime('yyyy-mm-dd hh:nn:ss', expirationUTC)]));

    epoch := DateTimeToUnix(IncMinute(NowUTC, -5), True);
    sb.AppendFormat('"DateGreaterThan":{"AWS:EpochTime":%d},',
      [epoch]); // allow for some slow clocks

    epoch := DateTimeToUnix(expirationUTC, True);
    sb.AppendFormat('"DateLessThan":{"AWS:EpochTime":%d}', [ epoch ]);

    sb.Append('}');
    sb.Append('}');
    sb.Append(']');
    sb.Append('}');

    // test in http://jsonlint.com/
    Result := sb.ToString;
  finally
    FreeAndNil(sb);
  end;
end;

function TCloudFrontSecurityProvider.getUrlSafeString(
  const unsafeURLStr: string): string;
//var
//  data8: UTF8String;
begin
  //data8 := UTF8String(unsafeURLStr);
  //Result := BytesToBase64(data8);
  result := unsafeURLStr;
  Result := Result.Replace('+', '-').Replace('=', '_').Replace('/', '~');
end;

{function TCloudFrontSecurityProvider.PEMtoDER(
  const PEM: string): TBytes;
begin
  Result := TNetEncoding.Base64.DecodeStringToBytes(PEM);
end;}


procedure TCloudFrontSecurityProvider.SetPolicy(const Value: string);
begin
  FPolicy := StripWhitespace(Value);
end;

function TCloudFrontSecurityProvider.Sign(const StringToSign: string): string;
const cFn = 'Sign';
begin
  {$IFDEF LOGAWSSign}CSEnterMethod(Self, cFn);{$ENDIF}

  Result := Chilkat_OpenSSL_Sign_SHA1(StringToSign, PrivateKeyPEM);

  {$IFDEF LOGAWSSign}CSExitMethod(Self, cFn);{$ENDIF}
end;

function TCloudFrontSecurityProvider.GetCustomUrl(
  const url, policyPlain: string): string;
const cFn = 'GetCustomUrl';
var
  PolicyBase64: string;
  signatureFromOpenSSL: string;
begin
  {$IFDEF LOGAWSSign}CSEnterMethod(Self, cFn);{$ENDIF}
  { Excellent guide to building the url string:
  http://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-creating-signed-url-custom-policy.html#private-content-custom-policy-statement-examples
  }

  { Your policy statement in JSON format, with white space removed, then base64
    encoded. }
  policyBase64 := StringToBase64NoCRLF(UTF8String(policyPlain));

  {$IFDEF LOGAWSSign}
  CSSend('policyPlain', policyPlain);
  LogToCodeSiteKeepCRLF(cFn + ': should have NoCRLF: policyBase64', policyBase64);
  {$ENDIF}

  { A hashed, signed, and base64-encoded version of the JSON policy statement.
    For more information, see Creating a Signature for a Signed URL That Uses a
    Custom Policy.
  }
  signatureFromOpenSSL := sign(policyPlain);
  {$IFDEF LOGAWSSign}
  LogToCodeSiteKeepCRLF('signatureFromOpenSSL', signatureFromOpenSSL);
  CSSend('Length of signatureFromOpenSSL', S(Length(signatureFromOpenSSL)));
  {$ENDIF}

  signatureFromOpenSSL := signatureFromOpenSSL
       //.Replace(#13, '',  [rfReplaceAll])
       .Replace('+', '-', [rfReplaceAll])
       .Replace('=', '_', [rfReplaceAll])
       .Replace('/', '~', [rfReplaceAll]);
  LogToCodeSiteKeepCRLF('After replacements, signatureFromOpenSSL', signatureFromOpenSSL);

  {$IFDEF LOGAWSSign}CSSend('FPrivateKeyID', FKeyPairID);{$ENDIF}
(*
  signatureAttempt := BytesToBase64(sigAttemptBytes);
  CSSend('signatureAttempt as Base64', signatureAttempt);
  signatureAttempt := signatureAttempt.Replace('+', '-').Replace('=', '_')
    .Replace('/', '~');

  signatureFromOpenSSL := stringLoadFromFile(DiskFolder +
    'demos.url.signed64.txt')
     .Replace(sLineBreak, '').Replace('+', '-').Replace('=', '_').Replace('/', '~');

  UTF8StringwriteToFile(DiskFolder + 'demos.url.signed64.replaced.txt',
    UTF8String(signatureFromOpenSSL), False);
*)

  // return url + string.Format("?Policy={0}&Signature={1}&Key-Pair-Id={2}", getUrlSafeString(Encoding.ASCII.GetBytes(policy)), signature, privateKeyId);
  Result := url + '?' + Format(
    'Policy=%s&Signature=%s&Key-Pair-Id=%s',
    //getUrlSafeString
    [getUrlSafeString(policyBase64), signatureFromOpenSSL, FKeyPairID]);

  {$IFDEF LOGAWSSign}
  LogToCodeSiteKeepCRLF(cFn + ': Result', Result);
  //UTF8StringwriteToFile(DiskFolder + 'demos.url.signed64.attempt.allhoops.txt',
  //  UTF8String(Result), False);

  CSExitMethod(Self, cFn);
  {$ENDIF}
end;

function TCloudFrontSecurityProvider.GetCustomUrl(const url: string;
  const expirationUTC: TDateTime;
  const allowedCidr: string): string;
var
  policyPlain: string;
begin
  policyPlain := GetPolicyAsStr(url, expirationUTC, allowedCidr);
  Result := GetCustomUrl(url, policyPlain);
end;

function TCloudFrontSecurityProvider.GetCustomUrl(const url: string): string;
begin
  Result := GetCustomUrl(url, Self.FPolicy);
end;

end.
