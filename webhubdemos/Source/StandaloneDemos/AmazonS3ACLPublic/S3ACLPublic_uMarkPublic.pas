unit S3ACLPublic_uMarkPublic;

(*
Permission is hereby granted, on 23-Jul-2017, free of charge, to any person
obtaining a copy of this file (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the
Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

Author: Ann Lynnworth at HREF Tools Corp.
*)

interface

function ReportSyntaxAvailable: string;
function ReportSyntaxUsed: string;

/// <summary> Tag files on an AWS S3 bucket public. </summary>
/// <remarks> Can be called from non-gui console application.
/// Compile with -DCodeSite if you have CodeSite logging available.
/// </remarks>
/// <param name="bActionIt">True: make changes.  False: dry run.
/// </param>
/// <param name="scheme">http or https
/// </param>
/// <param name="bucketName">Example: www.embarcadero.com
/// </param>
/// <param name="leadingPath">Optional leading path to select files within
/// </param>
/// <param name="matchThis">Optional: select files containing this within their
/// name and/or their folder name
/// </param>
/// <param name="awsKey">Amazon Web Services Access Key for account with ability
/// to take the action.
/// </param>
/// <param name="awsSecret">Confidential Secret corresponding to the Access Key.
/// </param>
/// <param name="JustRootFolder">True: only take action on files in the root of
/// the bucket.
/// </param>
/// <param name="MaxFilesToTouch">0 for unlimited, else the maximum number of
/// files to take action on.  Use a small number such as 10 for initial testing.
/// </param>
/// <param name="awsRegion">us-east-1 or other region. The official names are
/// documented by Amazon.
/// http://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region
/// </param>
procedure TagPublic(const bActionIt: Boolean;
  const scheme: string;
  const bucketName, leadingPath: string;
  const matchThis: string;
  const awsKey, awsSecret: string;
  const JustRootFolder: Boolean;
  const MaxFilesToTouch: Integer;
  const awsRegion: string);

implementation

uses
  System.SysUtils, System.Types, System.Classes,
  Data.Cloud.CloudAPI, Data.Cloud.AmazonAPI,
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF} // incl with CodeSite Express
  {$IFDEF ZMLog}ZM_CodeSiteInterface,{$ENDIF}  // on sf.net, ZaphodsMap project
  uAWS_S3;

function ReportSyntaxUsed: string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to ParamCount do
  begin
    Result := Result + ParamStr(i);
    if i < ParamCount then
      Result := Result + '  ';
  end;
end;

function ReportSyntaxAvailable: string;
begin
  Result := ExtractFileName(ParamStr(0)) + sLineBreak +
    'https://www.href.com/' + sLineBreak +
    'Source on sf.net in WebHubDemos project' + sLineBreak +
    sLineBreak +
    '[--dryrun] [--quiet]' + sLineBreak +
    '/BucketName=<bucket>' + sLineBreak +
    '[/LeadingPath=<string>]' + sLineBreak +
    '[/MatchThis=<string>]' + sLineBreak +
    '/AccessKey=<awskey>' + sLineBreak +
    '/SecretKey=<ZM FileTransfer S3 KeyToValue>' + sLineBreak +
    '[/MaxFiles=<n>' + sLineBreak +
    '[/JustRoot]' + sLineBreak +
    '[/Region=<awsregion>]' + sLineBreak;
end;

procedure TagPublic(const bActionIt: Boolean;
  const scheme: string;
  const bucketName, leadingPath: string;
  const matchThis: string;
  const awsKey, awsSecret: string;
  const JustRootFolder: Boolean;
  const MaxFilesToTouch: Integer;
  const awsRegion: string);
const cFn = 'TagPublic';
var
  AmazonConnectionInfo1: TAmazonConnectionInfo;
var
  ResponseInfo: TCloudResponseInfo;
  StorageService: TAmazonStorageService;
  {$IF Defined(DEBUG) and Defined(ZMLog)}
  InfoMsg: string;
  {$IFEND}
  {$IF Defined(ZMLog)}
  GeneralCounter: Integer;
  {$IFEND}
  BucketContents: TAmazonBucketResult;
  S3Object: TAmazonObjectResult;
  OptionalParams: TStrings;
  OriginalObjName: string;
  bKeepLooping: Boolean;
  ChangeCounter: Integer;
  BucketMarker: string;
  bOk: Boolean;
begin
  {$IFDEF ZMLog}CSEnterMethod(nil, cFn);{$ENDIF}

  AmazonConnectionInfo1 := nil;
  StorageService := nil;
  ResponseInfo := nil;
  //DesiredHeaders := nil;
  ChangeCounter := 0;
  {$IF Defined(ZMLog)}
  GeneralCounter := 0;
  {$ENDIF}

  bOk := True;

  {$IFDEF ZMLog}
  CSSend('bActionIt', S(bActionIt));
  CSSend(awsRegion, bucketName);
  CSSend('leadingPath', leadingPath);
  CSSend('JustRootFolder', S(JustRootFolder));
  CSSend('MaxFilesToTouch', S(MaxFilesToTouch));
  {$ENDIF}

  if (bucketName = '') then
  begin
    bOk := False;
    {$IFDEF CodeSite}CodeSite.SendError('bucket name required');{$ENDIF}
    ExitCode := 14;
  end;

  if (awsKey = '') or (Copy(awsKey, 1, 2) <> 'AK') then
  begin
    bOk := False;
    {$IFDEF CodeSite}CodeSite.SendError('AWS access key required');{$ENDIF}
    ExitCode := 13;
  end;

  if (Length(awsSecret) < 10) then
  begin
    bOk := False;
    {$IFDEF CodeSite}CodeSite.SendError('valid AWS secret key required');{$ENDIF}
    ExitCode := 15;
  end;

  if bOk then
  begin

    try
      AmazonConnectionInfo1 := TAmazonConnectionInfo.Create(nil);
      AmazonConnectionInfo1.AccountName := awsKey;
      AmazonConnectionInfo1.AccountKey := awsSecret;

      { The use of https here always leads to this exception:
        First chance exception at $758A5B68.
        Exception class ENetHTTPCertificateException with message
        'Server Certificate Invalid or not present'.
      }
      AmazonConnectionInfo1.Protocol := scheme; // 'http';

      {For buckets outside us-east-1, configure these 2 extra properties }
      AmazonConnectionInfo1.UseDefaultEndpoints := ('us-east-1' = awsRegion);
      AmazonConnectionInfo1.StorageEndpoint := StrToS3Endpoint(awsRegion);
      {$IFDEF ZMLog}CSSend('AmazonConnectionInfo1.StorageEndpoint',
        AmazonConnectionInfo1.StorageEndpoint);{$ENDIF}

      try
        StorageService := TAmazonStorageService.Create(AmazonConnectionInfo1);
        ResponseInfo := TCloudResponseInfo.Create;
        OptionalParams := TStringList.Create;
        BucketMarker := '';
        bKeepLooping := True;

        while bKeepLooping do
        begin

          OptionalParams.Clear;
          if BucketMarker <> '' then
            OptionalParams.Add('marker=' + BucketMarker);
          OptionalParams.Add('max-keys=3000');  // default is 1000
          try
            { in DEBUG mode, if the Forms unit has not been included,
            TMSXMLDOMDocumentFactory.CreateDOMDocument can
            raise a DOMException about MSXML not being installed. This exception
            is never surfaced; it is only visible in DEBUG mode.
            Adding Vcl.Forms or FMX.Forms to the DPR solves this exception. }
            BucketContents := StorageService.GetBucket(LowerCase(bucketName),
              OptionalParams, ResponseInfo,
              StrToRegion(awsRegion));
          except
            on E: Exception do
            begin
              {$IFDEF CodeSite}CodeSite.SendException(E);{$ENDIF}
              bKeepLooping := False;
            end;
          end;
          {$IF Defined(DEBUG) and Defined(ZMLog)}
          InfoMsg :=
            Format('Marker: %s, ResponseInfo: statuscode %d, message %s',
            [BucketMarker, ResponseInfo.StatusCode,
            ResponseInfo.StatusMessage]);
          CSSend(InfoMsg);
          {$IFEND}

          if NOT Assigned(BucketContents) then
          begin
            ExitCode := 45;
            {$IFDEF CodeSite}CodeSite.SendError('BucketContents nil');{$ENDIF}
            bKeepLooping := False;
            Continue;
          end;

          if BucketContents.Objects.Count <= 0 then
          begin
            bKeepLooping := False;
            Continue;
          end;

          for S3Object in BucketContents.Objects do
          begin
            {$IFDEF ZMLog}
            Inc(GeneralCounter);
            {$ENDIF}

            OriginalObjName := S3Object.Name;
            BucketMarker := OriginalObjName; // use when response Truncated

            if JustRootFolder then
            begin
              if (Pos('/', OriginalObjName) > 0) then
                Continue;
            end
            else
            begin
              if (leadingPath <> '') and (Pos(leadingPath, OriginalObjName) <> 1)
              then
              begin
                {$IF Defined(DEBUG) and Defined(ZMLog)}
                CSSend(csmLevel3, OriginalObjName, 'no start with ' + leadingPath);
                {$IFEND}
                Continue;
              end;

              if (MatchThis <> '') and (Pos(MatchThis, OriginalObjName) = 0) then
              begin
                {$IF Defined(DEBUG) and Defined(ZMLog)}
                CSSend(csmLevel3, OriginalObjName, 'no match with ' + MatchThis);
                {$IFEND}
                Continue;
              end;
            end;

            if (Copy(OriginalObjName, Length(OriginalObjName), 1) = '/') then
            begin
              {$IF Defined(DEBUG) and Defined(ZMLog)}
              CSSend('directory .');
              {$IFEND}
              Continue;
            end;

            {$IFDEF ZMLog}
            if Pos(ExtractFileExt(OriginalObjName).ToLower, ',.jpg,.png,.css,')
            >= 2 then
            begin
              // log the other files, which are more rare overall.
              CSSend(OriginalObjName);
            end;
            {$ENDIF}

            if bActionIt then
            begin
              {
              Unfortunately as of Delphi 10.2 Tokyo it is still NOT possible to
              set any of the headers such as X-Robots-Tag except during the
              initial upload to the bucket.

              bMadeList := False;
              try
                MetaDataOptionalParams := Default(TAmazonGetObjectOptionals);
                MetaDataOptionalParams.ResponseCacheControl := 'max-age=1800004';
                MetaDataList := StorageService.GetObjectMetadata(BucketName,
                  OriginalObjName, MetaDataOptionalParams, ResponseInfo);
                if NOT Assigned(MetaDataList) then
                begin
                  MetaDataList := TStringList.Create;
                  bMadeList := True;
                end
                else
                begin
                  CSSend('MetaDataList', MetaDataList.Text);
                  CSSend('Headers', ResponseInfo.Headers.Text);
                end;
              except
                on E: Exception do
                begin
                  ExitCode := 78;
                  CSSendError('StorageService.GetObjectMetadata failure');
                  CSSendException(nil, cFn, E);
                  bKeepLooping := False;
                  if bMadeList then
                    FreeAndNil(MetaDataList);
                  break;
                end;
              end;}

              {
              if DesiredHeaders = nil then
                DesiredHeaders := TStringList.Create;
              DesiredHeaders.Clear;

              DesiredHeaders.Add('X-Robots-Tag: index');
              //bKeepLooping := SetObjectMetadataAndHeaders(StorageService, BucketName,
              //  OriginalObjName, MetaDataList, DesiredHeaders, amzbaPublicRead,
              //  ResponseInfo);
              //CSSend('SetObjectMetadata response',
              //  S(ResponseInfo.StatusCode) + sLineBreak + ResponseInfo.Headers.Text);
              }

              if NOT StorageService.SetObjectACL(bucketName, OriginalObjName,
                amzbaPublicRead, ResponseInfo) then
              begin
                if (Copy(OriginalObjName, Length(OriginalObjName) - 9, 9) <>
                  '_$folder$') then
                begin
                  // Failed to set amzbaPublicRead for
                  // assets.http:--test.domain.info-2013-.plist
                  {$IF Defined(CodeSite)}
                  CodeSite.SendWarning('Failed to set amzbaPublicRead for ' +
                    OriginalObjName);  // DELPHI error, not AWS error.
                  {$IFEND}
                  //Inc(ExitCode);
                end;
              end
              else
                Inc(ChangeCounter);
            end;

            if NOT bKeepLooping then
              break; // out of For-Loop

            if MaxFilesToTouch > 0 then
            begin
              if ChangeCounter >= MaxFilesToTouch then
              begin
                {$IF Defined(ZMLog)}
                CSSend('Quit due to ChangeCounter', S(ChangeCounter));
                {$IFEND}
                bKeepLooping := False;
                break; // out of For-Loop
              end;
            end;

            {$IF Defined(DEBUG) and Defined(ZMLog)}
            if GeneralCounter > 9 then
            begin
                CSSend('Quit due to GeneralCounter', S(GeneralCounter));
                bKeepLooping := False;
                break; // out of For-Loop
            end;
            {$IFEND}
          end;

          if NOT BucketContents.IsTruncated then
            break;
        end;
      finally
        FreeAndNil(ResponseInfo);
        FreeAndNil(BucketContents);
        FreeAndNil(StorageService);
      end;
    finally
      FreeAndNil(AmazonConnectionInfo1);
    end;
  end;

  {$IFDEF ZMLog}
  CSSend('ChangeCounter', S(ChangeCounter));
  CSSend('GeneralCounter', S(GeneralCounter));
  CSExitMethod(nil, cFn);
  {$ENDIF}
end;

end.
