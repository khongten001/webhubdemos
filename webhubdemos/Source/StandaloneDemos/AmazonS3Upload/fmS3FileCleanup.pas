unit fmS3FileCleanup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  IPPeerClient, Vcl.StdCtrls, Vcl.ExtCtrls, Data.Cloud.CloudAPI,
  Data.Cloud.AmazonAPI,
  tpCompPanel;  // TtpComponentPanel is in TPack and available to public.

type
  TForm3 = class(TForm)
    AmazonConnectionInfo1: TAmazonConnectionInfo;
    tpComponentPanel1: TtpComponentPanel;
    Panel1: TPanel;
    Memo1: TMemo;
    GroupBox1: TGroupBox;
    MemoDeleteFiles: TMemo;
    Panel2: TPanel;
    Button1: TButton;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

uses
  ucString, ucDlgs, ZM_CodeSiteInterface,  // in TPack
  uAWS_S3;                                // in this demo

{$I amazon_secret_info.txt}  // copy amazon_secret_info.sample.txt, then adjust

procedure TForm3.Button1Click(Sender: TObject);
const cFn = 'Button1Click';
var
  ResponseInfo: TCloudResponseInfo;
  StorageService: TAmazonStorageService;
  InfoMsg: string;
  BucketContents: TAmazonBucketResult;
  S3Object: TAmazonObjectResult;
  OptionalParams: TStrings;
  OriginalObjName: string;
  LowerObjName: string;
  bOK: Boolean;
  bActionIt: Boolean;
  bCopyIt, bDeleteIt: Boolean;
  BucketMarker: string;

  function ShouldDeleteThisName(Value: string): Boolean;
  var
    i: Integer;
    DeleteThis: string;
  begin
    Result := False;
    Value := LowerCase(Value);
    Value := RightOfLastDelimiter('/', Value);
    if Value <> '' then
    begin

      for i := 0 to Pred(MemoDeleteFiles.Lines.Count) do
      begin
        DeleteThis := Trim(LowerCase(MemoDeleteFiles.Lines[i]));
        if MemoDeleteFiles.Lines[i] = '' then Continue;

        if (Value = DeleteThis) then
        begin
          Result := True;
          break;
        end;

      end;
    end;
  end;

begin
  StorageService := nil;
  ResponseInfo := nil;
  Memo1.Text := cS3Region + sLineBreak + cBName;
  bActionIt := NOT Checkbox1.Checked;
  bOK := False;

  InfoMsg := 'Proceed to lowercase files on ' + cBName + '?' + sLineBreak +
    sLineBreak;
  if bActionIt then
    InfoMsg := InfoMsg + 'ALERT - LIVE'
  else
    InfoMsg := InfoMsg + '(simulation - reporting only)';

  if ucDlgs.AskQuestionYesNo(InfoMsg) then
  begin
    AmazonConnectionInfo1.AccountName := cAKey;
    AmazonConnectionInfo1.AccountKey := cSAKey;

    { The use of https here always leads to this exception:
      First chance exception at $758A5B68. Exception class ENetHTTPCertificateException with message 'Server Certificate Invalid or not present'. Process DemoUploadToAmazonS3.exe (3584)
    }
    AmazonConnectionInfo1.Protocol := 'http';

    CSSend('cBName', cBName); // AWS S3 source bucket name

    {For buckets outside us-east-1, configure these 2 extra properties }
    AmazonConnectionInfo1.UseDefaultEndpoints := ('us-east-1' = cS3Region);
    AmazonConnectionInfo1.StorageEndpoint := StrToS3Endpoint(cS3Region);

    try
      StorageService := TAmazonStorageService.Create(AmazonConnectionInfo1);
      ResponseInfo := TCloudResponseInfo.Create;
      OptionalParams := TStringList.Create;
      BucketMarker := '';

      while true do
      begin
        OptionalParams.Clear;
        if BucketMarker <> '' then
          OptionalParams.Add('marker=' + BucketMarker);
        OptionalParams.Add('max-keys=500');
        BucketContents := StorageService.GetBucket(LowerCase(cBName),
          OptionalParams, ResponseInfo,
          StrToRegion(cS3Region));
        InfoMsg :=
          Format('Marker: %s, ResponseInfo: statuscode %d, message %s',
          [BucketMarker, ResponseInfo.StatusCode,
          ResponseInfo.StatusMessage]);
        CSSend(InfoMsg);
        if Assigned(BucketContents) then
        begin
          if BucketContents.Objects.Count <= 0 then
            break;
          for S3Object in BucketContents.Objects do
          begin
            OriginalObjName := S3Object.Name;
            BucketMarker := OriginalObjName; // use when response Truncated
            LowerObjName := LowerCase(OriginalObjName);

            bDeleteIt := ShouldDeleteThisName(OriginalObjName);
            bCopyIt := (NOT bDeleteIt) and (OriginalObjName <> LowerObjName);
            if bCopyIt then
              bDeleteIt := True;

            Memo1.Lines.Add(Format('%s: copy %s, delete %s', [OriginalObjName,
              S(bCopyIt), S(bDeleteIt)]));

            if bCopyIt then
            begin
              try
                if bActionIt then
                begin
                  StorageService.CopyObject(cBName, LowerObjName, cBName,
                    OriginalObjName,
                    nil,  // OptionalParams e.g. ACL and meta data
                    nil);
                  InfoMsg := '..Copy ok';
                  Memo1.Lines.Add(InfoMsg);
                  CSSend(InfoMsg);
                end;
                bOK := True;
              except
                on E: Exception do
                begin
                  CSSendException(Self, cFn, E);
                  bOK := False;
                end;

              end;
            end;
            if bOK then
            begin
              if bDeleteIt then
              begin
                try
                  if bActionIt then
                  begin
                    StorageService.DeleteObject(cBName, OriginalObjName);
                    InfoMsg := '..Delete ok';
                    Memo1.Lines.Add(InfoMsg);
                  end;
                except
                  on E: Exception do
                  begin
                    CSSendException(Self, cFn, E);
                    bOK := False;
                  end;
                end;
              end;
              if NOT bOK then break;

            end;
          end;
        end
        else
          break;
        if NOT BucketContents.IsTruncated then
          break;
      end;
    finally
      FreeAndNil(ResponseInfo);
      FreeAndNil(StorageService);
      FreeAndNil(OptionalParams);
      FreeAndNil(BucketContents);
    end;
  end;

end;

end.
