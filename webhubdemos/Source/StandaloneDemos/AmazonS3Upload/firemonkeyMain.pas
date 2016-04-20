unit firemonkeyMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, IPPeerClient,
  FMX.ScrollBox, FMX.Memo, Data.Cloud.CloudAPI, Data.Cloud.AmazonAPI,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    AmazonConnectionInfo1: TAmazonConnectionInfo;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    function StrToS3Endpoint(const InRegion: string): string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
{$I amazon_secret_info.txt}  // you can comment this INCLUDE out
var
  ResponseInfo: TCloudResponseInfo;
  Filespec: string;
  stream: TBytesStream;
  StorageService: TAmazonStorageService;
  CustomHeaderList: TStringList;
  Data: TArray<Byte>;
  PSrc, PTrg: PByte;
  InfoMsg: string;
  ComboText: string;
begin
  stream := nil;
  StorageService := nil;
  ResponseInfo := nil;
  CustomHeaderList := nil;
  SetLength(Data, 0);
  Memo1.Lines.Clear;

  AmazonConnectionInfo1.AccountName := cAKey;
  AmazonConnectionInfo1.AccountKey := cSAKey;

  { The use of https here always leads to this exception:
    First chance exception at $758A5B68. Exception class ENetHTTPCertificateException with message 'Server Certificate Invalid or not present'. Process DemoUploadToAmazonS3.exe (3584)

    Tested: domain cname, domain on amazonaws.com, domain cname that has https cert.
  }
  AmazonConnectionInfo1.Protocol := 'HTTPS';  // or 'https'

  ComboText := 'us-east-1';

  {For buckets outside us-east-1, configure these 2 extra properties }
  AmazonConnectionInfo1.UseDefaultEndpoints := ('us-east-1' = ComboText);
  AmazonConnectionInfo1.StorageEndpoint := StrToS3Endpoint(ComboText);

  Filespec := 'D:\Projects\webhubdemos\Source\StandaloneDemos\AmazonS3Upload\DemoUploadToAmazonS3.dpr';

  if FileExists(Filespec) then
  begin
    try
      StorageService := TAmazonStorageService.Create(AmazonConnectionInfo1);

      ResponseInfo := TCloudResponseInfo.Create;
      stream := TBytesStream.Create;
      stream.LoadFromFile(Filespec);
      SetLength(Data, stream.Size);
      PSrc := Addr(stream.Bytes[0]);
      PTrg := Addr(Data[0]);
      Move(PSrc^, PTrg^, stream.Size);

      // Metadata not required on Amazon S3
      // Metadata := TStringList.Create;
      // Metadata.Values[SMDPath] := ExtractFilePath(Filespec);
      // Metadata.Values[SMDFrom] := GetComputerandUserName;

      try
        StorageService.UploadObject(cBName,
          // target bucket e.g. screenshots.href.com

          { LabeledEditTargetPath.Text must be blank or end in / example data/ }
          'test_201604/' + ExtractFileName(Filespec),

          Data, // must use an array whose length is the size to send!
          False, nil, CustomHeaderList, amzbaPublicRead, // permissions - public
          ResponseInfo);

        { status 200 means that it worked
          if you use a bad Access Key or Secret Access Key, status 403 will be in
          headers }
        InfoMsg :=
          Format('ResponseInfo: file %s, statuscode %d, message %s',
          [ExtractFileName(Filespec), ResponseInfo.StatusCode,
          ResponseInfo.StatusMessage]);
      except
        on E: Exception do
        begin
          InfoMsg := 'EXCEPTION:' + #9 + E.Message;
        end;
      end;

      Memo1.Lines.Add(InfoMsg);
      ShowMessage('info' + sLIneBreak + InfoMsg);

      if Assigned(ResponseInfo.Headers) then
      begin
        Memo1.Lines.Add('');
        Memo1.Lines.Add(ResponseInfo.Headers.Text);
        ShowMessage('ResponseInfo.Headers' + sLineBreak + sLineBreak +
          ResponseInfo.Headers.Text);
      end;
    finally
      FreeAndNil(stream);
      FreeAndNil(StorageService);
      FreeAndNil(ResponseInfo);
      FreeAndNil(CustomHeaderList);
      SetLength(Data, 0);
    end;
  end;
end;

function TForm1.StrToS3Endpoint(const InRegion: string): string;
begin
  // http://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region
  if InRegion = 'us-east-1' then
    Result := 's3.amazonaws.com' // or 's3-external-1.amazonaws.com'
  else
    Result := Format('s3-%s.amazonaws.com', [InRegion]);
end;
end.
