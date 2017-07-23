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

procedure TagPublic(const bActionIt: Boolean;
  const bucketName, leadingPath: string;
  const matchThis: string;
  const awsKey, awsSecret: string;
  const JustRootFolder: Boolean;
  const MaxFilesToTouch: Integer = 0;
  const awsRegion: string = 'us-east-1');

implementation

uses
  System.SysUtils, System.Types, System.Classes,
  Data.Cloud.CloudAPI, Data.Cloud.AmazonAPI,
  uAWS_S3,
  ZM_CodeSiteInterface,
  ucString;

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
  const bucketName, leadingPath: string;
  const matchThis: string;
  const awsKey, awsSecret: string;
  const JustRootFolder: Boolean;
  const MaxFilesToTouch: Integer = 0;
  const awsRegion: string = 'us-east-1');
const cFn = 'TagPublic';
var
  AmazonConnectionInfo1: TAmazonConnectionInfo;
var
  ResponseInfo: TCloudResponseInfo;
  StorageService: TAmazonStorageService;
  {$IFDEF DEBUG}
  InfoMsg: string;
  {$ENDIF}
  BucketContents: TAmazonBucketResult;
  S3Object: TAmazonObjectResult;
  //MetaDataOptionalParams: TAmazonGetObjectOptionals;
  //MetaDataList: TStrings;
  OptionalParams: TStrings;
  OriginalObjName: string;
  bKeepLooping: Boolean;
  ChangeCounter, GeneralCounter: Integer;
  BucketMarker: string;
  //DesiredHeaders: TStrings;
  bOk: Boolean;
begin
  CSEnterMethod(nil, cFn);

  AmazonConnectionInfo1 := nil;
  StorageService := nil;
  ResponseInfo := nil;
  //DesiredHeaders := nil;
  ChangeCounter := 0;
  GeneralCounter := 0;
  bOk := True;

  CSSend('bActionIt', S(bActionIt));
  CSSend(awsRegion, bucketName);
  CSSend('leadingPath', leadingPath);
  CSSend('JustRootFolder', S(JustRootFolder));
  CSSend('MaxFilesToTouch', S(MaxFilesToTouch));

  if (bucketName = '') then
  begin
    bOk := False;
    CSSendError('bucket name required');
    ExitCode := 14;
  end;

  if (awsKey = '') or (Copy(awsKey, 1, 2) <> 'AK') then
  begin
    bOk := False;
    CSSendError('AWS access key required');
    ExitCode := 13;
  end;

  if (Length(awsSecret) < 10) then
  begin
    bOk := False;
    CSSendError('valid AWS secret key required');
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
      AmazonConnectionInfo1.Protocol := 'http';

      {For buckets outside us-east-1, configure these 2 extra properties }
      AmazonConnectionInfo1.UseDefaultEndpoints := ('us-east-1' = awsRegion);
      AmazonConnectionInfo1.StorageEndpoint := StrToS3Endpoint(awsRegion);
      CSSend('AmazonConnectionInfo1.StorageEndpoint', AmazonConnectionInfo1.StorageEndpoint);

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
          OptionalParams.Add('max-keys=500');
          try
            { in DEBUG mode, if the Forms unit has not been included,
            TMSXMLDOMDocumentFactory.CreateDOMDocument can
            raise a DOMException about MSXML not being installed. This exception
            is never surfaced; it is only visible in DEBUG mode.
            Adding Vcl.Forms to the DPR solves this exception. }
            BucketContents := StorageService.GetBucket(LowerCase(bucketName),
              OptionalParams, ResponseInfo,
              StrToRegion(awsRegion));
          except
            on E: Exception do
            begin
              CSSendException(nil, cFn, E);
              bKeepLooping := False;
            end;
          end;
          {$IFDEF DEBUG}
          InfoMsg :=
            Format('Marker: %s, ResponseInfo: statuscode %d, message %s',
            [BucketMarker, ResponseInfo.StatusCode,
            ResponseInfo.StatusMessage]);
          CSSend(InfoMsg);
          {$ENDIF}

          if NOT Assigned(BucketContents) then
          begin
            ExitCode := 45;
            CSSendError('BucketContents nil');
            bKeepLooping := False;
            Continue;
          end;


          CSSend('BucketContents.Objects.Count=' +
            S(BucketContents.Objects.Count));

          if BucketContents.Objects.Count <= 0 then
          begin
            bKeepLooping := False;
            Continue;
          end;

          for S3Object in BucketContents.Objects do
          begin
            Inc(GeneralCounter);
            if GeneralCounter mod 25 = 0 then
              CSSend('   ' + S(GeneralCounter));

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
                {$IFDEF DEBUG}
                CSSend(csmLevel3, OriginalObjName, 'no start with ' + leadingPath);
                {$ENDIF}
                Continue;
              end;

              if (MatchThis <> '') and (Pos(MatchThis, OriginalObjName) = 0) then
              begin
                {$IFDEF DEBUG}
                CSSend(csmLevel3, OriginalObjName, 'no match with ' + MatchThis);
                {$ENDIF}
                Continue;
              end;
            end;

            if (Copy(OriginalObjName, Length(OriginalObjName), 1) = '/') then
            begin
              {$IFDEF DEBUG}
              CSSend('directory .');
              {$ENDIF}
              Continue;
            end;

            CSSend(csmLevel7, 'OriginalObjName', OriginalObjName);

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

              DesiredHeaders.Add('X-Robots-Tag: noindex');
              //bKeepLooping := SetObjectMetadataAndHeaders(StorageService, BucketName,
              //  OriginalObjName, MetaDataList, DesiredHeaders, amzbaPublicRead,
              //  ResponseInfo);
              //CSSend('SetObjectMetadata response',
              //  S(ResponseInfo.StatusCode) + sLineBreak + ResponseInfo.Headers.Text);
              }

              if NOT StorageService.SetObjectACL(bucketName, OriginalObjName,
                amzbaPublicRead, ResponseInfo) then
              begin
                CSSendError('Failed to set amzbaPublicRead for ' + OriginalObjName);
                Inc(ExitCode);
              end;
              Inc(ChangeCounter);
            end;

            if NOT bKeepLooping then
              break; // out of For-Loop

            if MaxFilesToTouch > 0 then
            begin
              if ChangeCounter >= MaxFilesToTouch then
              begin
                CSSend('Quit due to ChangeCounter', S(ChangeCounter));
                bKeepLooping := False;
                break; // out of For-Loop
              end;
            end;

            {$IFDEF DEBUG}
            if GeneralCounter > 9 then
            begin
                CSSend('Quit due to GeneralCounter', S(GeneralCounter));
                bKeepLooping := False;
                break; // out of For-Loop
            end;
            {$ENDIF}
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

  CSExitMethod(nil, cFn);
end;

end.
