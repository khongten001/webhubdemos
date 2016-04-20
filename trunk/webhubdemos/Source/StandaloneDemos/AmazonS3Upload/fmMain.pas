unit fmMain;

(*
  Copyright (c) 2013-2016 HREF Tools Corp.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
*)

interface

{$WARN UNIT_PLATFORM OFF}   // Vcl.FileCtrl is for Windows only.

uses
  Winapi.Windows, Winapi.Messages, SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IPPeerClient,
  Vcl.StdCtrls, Vcl.FileCtrl, Vcl.ExtCtrls, Data.Cloud.CloudAPI,
  Data.Cloud.AmazonAPI, Vcl.ActnList, System.Actions, Vcl.StdActns, Vcl.ToolWin,
  Vcl.ActnMan, Vcl.ActnCtrls, Vcl.ActnMenus, Vcl.Menus;

type
  TForm2 = class(TForm)
    AmazonConnectionInfo1: TAmazonConnectionInfo;
    Panel1: TPanel;
    Button1: TButton;
    GroupBox2: TGroupBox;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    FileListBox1: TFileListBox;
    Panel2: TPanel;
    LabeledEditBucket: TLabeledEdit;
    LabeledEditAccessKey: TLabeledEdit;
    LabeledEditSecret: TLabeledEdit;
    LabeledEditTargetPath: TLabeledEdit;
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    GroupBox4: TGroupBox;
    MemoCustomHeaders: TMemo;
    ComboRegion: TComboBox;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionList1: TActionList;
    FileExit1: TFileExit;
    Exit1: TMenuItem;
    ools1: TMenuItem;
    Action1: TAction;
    ActionCreateBucket: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
  private
    { Private declarations }
    function StrToRegion(const InRegion: string): TAmazonRegion;
    function StrToS3Endpoint(const InRegion: string): string;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses
  StdStyleActnCtrls;

{$R *.dfm}

procedure TForm2.Action1Execute(Sender: TObject);
var
  StorageService: TAmazonStorageService;
  ResponseInfo: TCloudResponseInfo;
  ARegion: TAmazonRegion;
  InfoMsg: string;
  ComboText: string;
begin
  StorageService := nil;
  ResponseInfo := nil;
  InfoMsg := '';

  AmazonConnectionInfo1.AccountName := LabeledEditAccessKey.Text;
  AmazonConnectionInfo1.AccountKey := LabeledEditSecret.Text;
  AmazonConnectionInfo1.Protocol := 'HTTP';  // or 'https'
  ComboText := ComboRegion.Items[ComboRegion.ItemIndex];
  AmazonConnectionInfo1.UseDefaultEndpoints := ('us-east-1' = ComboText);
  // NB: make sure this matches against whichever region is listed below.
  AmazonConnectionInfo1.StorageEndpoint := StrToS3Endpoint(ComboText);
  Memo1.Lines.Add('StorageEndpoint=' + AmazonConnectionInfo1.StorageEndpoint);

  try
    StorageService := TAmazonStorageService.Create(AmazonConnectionInfo1);
    ResponseInfo := TCloudResponseInfo.Create;
    ARegion := StrToRegion(ComboRegion.Items[ComboRegion.ItemIndex]);

    StorageService.CreateBucket(LowerCase(LabeledEditBucket.Text),
      TAmazonACLType.amzbaPublicRead,
      // amzrUSEast1, // The specified location-constraint is not valid (InvalidLocationConstraint)
      //amzrAPSoutheast1, // Singapore works
      //amzrUSWest2, // Oregon works
      ARegion,
      ResponseInfo);
    InfoMsg :=
      Format('ResponseInfo: statuscode %d, message %s',
      [ResponseInfo.StatusCode,
      ResponseInfo.StatusMessage]);
  finally
    FreeAndNil(ResponseInfo);
    FreeAndNil(StorageService);
  end;

  Memo1.Lines.Add(InfoMsg);
end;

procedure TForm2.Button1Click(Sender: TObject);
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
  Memo1.Clear;

  AmazonConnectionInfo1.AccountName := LabeledEditAccessKey.Text;
  AmazonConnectionInfo1.AccountKey := LabeledEditSecret.Text;

  { The use of https here always leads to this exception:
    First chance exception at $758A5B68. Exception class ENetHTTPCertificateException with message 'Server Certificate Invalid or not present'. Process DemoUploadToAmazonS3.exe (3584)

    Tested: domain cname, domain on amazonaws.com, domain cname that has https cert.
  }
  AmazonConnectionInfo1.Protocol := 'HTTP';  // or 'https'

  ComboText := ComboRegion.Items[ComboRegion.ItemIndex];

  {For buckets outside us-east-1, configure these 2 extra properties }
  AmazonConnectionInfo1.UseDefaultEndpoints := ('us-east-1' = ComboText);
  AmazonConnectionInfo1.StorageEndpoint := StrToS3Endpoint(ComboText);

  Filespec := FileListBox1.FileName;

  if (LabeledEditTargetPath.Text <> '') and (LabeledEditTargetPath.Text[1] = '/')
  then
  begin
    ShowMessage('ALERT: Do not start with a leading / for the target path.' +
      sLIneBreak + sLIneBreak + LabeledEditTargetPath.Text);
  end
  else if FileExists(Filespec) then
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

      if MemoCustomHeaders.Text <> '' then
      begin
        CustomHeaderList := TStringList.Create;
        // NB: XE7 does not support custom headers.
        CustomHeaderList.Text := Trim(MemoCustomHeaders.Lines.Text);
        Memo1.Lines.Add('HEADERS:');
        Memo1.Lines.Add(MemoCustomHeaders.Text);
        Memo1.Lines.Add('');
      end;

      try
        StorageService.UploadObject(LabeledEditBucket.Text,
          // target bucket e.g. screenshots.href.com

          { LabeledEditTargetPath.Text must be blank or end in / example data/ }
          LabeledEditTargetPath.Text + ExtractFileName(Filespec),

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

procedure TForm2.FormCreate(Sender: TObject);
var
  SampleDirectory: string;
{$I amazon_secret_info.txt}  // you can comment this INCLUDE out
begin
  Memo1.Clear;
  // you can set the default directory here
  SampleDirectory := 'D:\Apps\Embarcadero\Studio\18.0\Images\Icons';
  SampleDirectory := 'D:\Projects';
  if SysUtils.Directoryexists(SampleDirectory) then
    DirectoryListBox1.Directory := SampleDirectory;

  LabeledEditAccessKey.Text := cAKey;
  if LabeledEditAccessKey.Text = '' then
  begin
    // use example from docwiki
    // http://docwiki.embarcadero.com/RADStudio/XE8/en/Amazon_and_Cloud_Computing_with_DataSnap
    LabeledEditAccessKey.Text := 'AKIAJ32REXDJHV2X4JSQ';
  end;
  LabeledEditSecret.Text := cSAKey;
  if LabeledEditSecret.Text = '' then
    LabeledEditSecret.Text := 'uW3f0fucxqotP/UXQAv/xhiaGt8UAAhHcYDaqxmW';
  LabeledEditBucket.Text := cBName;
  if LabeledEditBucket.Text = '' then
    LabeledEditBucket.Text := 'samples3.embarcadero.com';

  LabeledEditTargetPath.Text := 'testfolder_' + FormatDateTime('yyyymmdd',
    Now) + '/';

  // Custom headers are better left to user data entry
  //EditCustomHeader.Text := 'Cache-Control=max-age=31557600'; //'Content-Type=text/html';
end;

function TForm2.StrToRegion(const InRegion: string): TAmazonRegion;
begin
  if InRegion = 'us-east-1' then Result := amzrUSEast1
  else
  if InRegion = 'us-west-1' then Result := amzrUSWest1
  else
  if InRegion =  'us-west-2' then Result := amzrUSWest2
  else
  if InRegion =  'eu-west-1' then Result := amzrEUWest1
  else
  if InRegion =  'eu-central-1' then Result := amzrEUCentral1
  else
  if InRegion =  'ap-northeast-1' then Result := amzrAPNortheast1
  //else
  //if InRegion =  'ap-northeast-2' then Result := // unsupported
  else
  if InRegion =  'ap-southeast-1' then Result := amzrAPSoutheast1
  else
  if InRegion =  'ap-southeast-2' then Result := amzrAPSoutheast2
  else
  if InRegion =  'sa-east-1' then Result := amzrSAEast1
  else
    Result := amzrNotSpecified;
end;

function TForm2.StrToS3Endpoint(const InRegion: string): string;
begin
  // http://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region
  if InRegion = 'us-east-1' then
    Result := 's3.amazonaws.com' // or 's3-external-1.amazonaws.com'
  else
    Result := Format('s3-%s.amazonaws.com', [InRegion]);
end;

end.