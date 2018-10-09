unit Test_aws_s3_getobject;

(*
Permission is hereby granted, on 9-Oct-2018, free of charge, to any person
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

uses
  Memo,  // helpful during testing.
  Data.Cloud.CloudAPI, Data.Cloud.AmazonAPI;

procedure Test_GetObject(
                      bucketName: string;
                      const scheme: string;
                      const awsKey, awsSecret: string;
                      const awsRegion: string;
                      out ErrorText: string; AMemo: TMemo = nil);


implementation

uses
  SysUtils,
  Classes,
  Forms,
  uAWS_S3;


procedure Test_GetObject(bucketName: string;
  const scheme: string;
  const awsKey, awsSecret: string;
  const awsRegion: string;
  out ErrorText: string; AMemo: TMemo = nil);
const cFn = 'Test_GetObject';
var
  AmazonConnectionInfo1: TAmazonConnectionInfo;
  i: Integer;
var
  ResponseInfo: TCloudResponseInfo;
  StorageService: TAmazonStorageService;
  BucketContents: TAmazonBucketResult;
  AStream: TStringStream;
const
  cTestFilenames: array[0..4] of string = ('#sample_file.txt',
    'sample#file.txt',
    'sample$file.txt', 'sample_file.txt', 'sample+file.txt');
begin

  AmazonConnectionInfo1 := nil;
  StorageService := nil;
  BucketContents := nil;
  ResponseInfo := nil;
  AStream := nil;
  ErrorText := '';


  try         // finally
    try       // except
      AmazonConnectionInfo1 := TAmazonConnectionInfo.Create(nil);
      AmazonConnectionInfo1.AccountName := awsKey;
      AmazonConnectionInfo1.AccountKey := awsSecret;

      AmazonConnectionInfo1.Protocol := scheme; // 'http' or 'https';

      {For buckets outside us-east-1, configure these 2 extra properties }
      AmazonConnectionInfo1.UseDefaultEndpoints := ('us-east-1' = awsRegion);
      AmazonConnectionInfo1.StorageEndpoint := StrToS3Endpoint(awsRegion);

      StorageService := TAmazonStorageService.Create(AmazonConnectionInfo1);
      ResponseInfo := TCloudResponseInfo.Create;
      AStream := TStringStream.Create;

      for i := 0 to High(cTestFilenames) do
      begin
        AStream.Clear;
        AMemo.Lines.Add(i.ToString + #9 + cTestFilenames[i]);
        if StorageService.GetObject(bucketName, cTestFilenames[i],
          AStream, ResponseInfo) then
        begin
          AMemo.Lines.Add(#9 + 'downloaded as size ' +
            AStream.Size.ToString);
          if AStream.Size > 0 then
          begin
            AMemo.Lines.Add(Copy(AStream.DataString, 1, 80));
            AMemo.Lines.Add(sLineBreak + '--' + sLineBreak);
          end;
        end
        else
        begin
          ErrorText := 'ERROR: Unable to GetObject ' + cTestFilenames[i];
          AMemo.Lines.Add(ErrorText);
          AMemo.Lines.Add(ResponseInfo.Headers.Text);
          AMemo.Lines.Add('');
          //break;
        end;
      end;

    except
      on E: Exception do
      begin
        AMemo.Lines.Add('EXCEPTION: ' + E.Message);
        Application.ProcessMessages;
        ErrorText := E.Message;
      end;
    end;
  finally
    FreeAndNil(ResponseInfo);
    FreeAndNil(BucketContents);
    FreeAndNil(StorageService);
    FreeAndNil(AStream);
    FreeAndNil(AmazonConnectionInfo1);
  end;
  


end;


end.
