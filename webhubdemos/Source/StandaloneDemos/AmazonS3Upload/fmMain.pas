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
    ButtonUploadToS3: TButton;
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
    ActionList1: TActionList;
    FileExit1: TFileExit;
    Exit1: TMenuItem;
    ools1: TMenuItem;
    Action1: TAction;
    ActionCreateBucket: TMenuItem;
    Button2: TButton;
    LabeledEditProtocol: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure ButtonUploadToS3Click(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    function ActiveProtocol: string;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses
  StdStyleActnCtrls, uAWS_S3;

{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
var
  SampleDirectory: string;
  i: Integer;
{$I amazon_secret_info.txt}  // you can comment this INCLUDE if you prefer to paste values at runtime
begin
  // Initialize the controls for easier repeat tests
  Memo1.Clear;

  LabeledEditTargetPath.Text := 'testfolder_' + FormatDateTime('yyyymmdd',
    Now) + '/';

  // you can set the default directory here
  SampleDirectory := 'D:\Apps\Embarcadero\Studio\18.0\Images\Icons';
  SampleDirectory := 'D:\Projects';
  if SysUtils.Directoryexists(SampleDirectory) then
    DirectoryListBox1.Directory := SampleDirectory;

  if cAKey <> 'AK...'  then
  begin
    // seems that a valid INC file is available
    LabeledEditAccessKey.Text := cAKey;  // key
    LabeledEditSecret.Text := cSAKey;    // secret key
    LabeledEditBucket.Text := cBName;    // bucket name

    // set region combobox based on cS3Region
    ComboRegion.ItemIndex := -1;
    for i := 0 to Pred(ComboRegion.Items.Count) do
    begin
      if ComboRegion.Items[I] = cS3Region then
      begin
        ComboRegion.ItemIndex := I;
        break;
      end;
    end;

  end
  else
  begin
    // use example from docwiki
    // http://docwiki.embarcadero.com/RADStudio/XE8/en/Amazon_and_Cloud_Computing_with_DataSnap
    LabeledEditAccessKey.Text := 'AKIAJ32REXDJHV2X4JSQ';
    LabeledEditSecret.Text := 'uW3f0fucxqotP/UXQAv/xhiaGt8UAAhHcYDaqxmW';
    LabeledEditBucket.Text := 'samples3.embarcadero.com';
  end;

  // Custom headers are better left to user data entry
  //EditCustomHeader.Text := 'Cache-Control=max-age=31557600'; //'Content-Type=text/html';
end;

procedure TForm2.Action1Execute(Sender: TObject);
var
  StorageService: TAmazonStorageService;
  ResponseInfo: TCloudResponseInfo;
  InfoMsg: string;
  ComboText: string;
begin
  StorageService := nil;
  ResponseInfo := nil;
  InfoMsg := '';

  AmazonConnectionInfo1.AccountName := LabeledEditAccessKey.Text;
  AmazonConnectionInfo1.AccountKey := LabeledEditSecret.Text;
  AmazonConnectionInfo1.Protocol := ActiveProtocol;
  ComboText := ComboRegion.Items[ComboRegion.ItemIndex];
  AmazonConnectionInfo1.UseDefaultEndpoints := ('us-east-1' = ComboText);
  // NB: make sure this matches against whichever region is listed below.
  AmazonConnectionInfo1.StorageEndpoint := StrToS3Endpoint(ComboText);
  Memo1.Lines.Add('StorageEndpoint=' + AmazonConnectionInfo1.StorageEndpoint);

  try
    StorageService := TAmazonStorageService.Create(AmazonConnectionInfo1);
    ResponseInfo := TCloudResponseInfo.Create;

    StorageService.CreateBucket(LowerCase(LabeledEditBucket.Text),
      TAmazonACLType.amzbaPublicRead,
      // Alert! Unless you pass amzrNotSpecified, this exception occurs:
      // The specified location-constraint is not valid (InvalidLocationConstraint)
      amzrNotSpecified,
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

function TForm2.ActiveProtocol: string;
begin
  Result := LabeledEditProtocol.Text;
end;

procedure TForm2.ButtonUploadToS3Click(Sender: TObject);
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
  AmazonConnectionInfo1.Protocol := ActiveProtocol;

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

procedure TForm2.Button2Click(Sender: TObject);
var
  StorageService: TAmazonStorageService;
  ResponseInfo: TCloudResponseInfo;
  Data: TArray<Byte>;
  msg: String;
begin
  ResponseInfo := nil;
  StorageService := nil;
  SetLength(Data, 0);
  Memo1.Clear;

  ComboRegion.ItemIndex := 0; // force us-east-1

  { The use of https here always leads to this exception:
    First chance exception at $758A5B68. Exception class ENetHTTPCertificateException with message 'Server Certificate Invalid or not present'. Process DemoUploadToAmazonS3.exe (3584)

    Tested: domain cname, domain on amazonaws.com, domain cname that has https cert.
  }
  // configure AmazonConnectionInfo1 object

  AmazonConnectionInfo1.AccountName := LabeledEditAccessKey.Text;
  AmazonConnectionInfo1.AccountKey := LabeledEditSecret.Text;
  AmazonConnectionInfo1.Protocol := ActiveProtocol;
  AmazonConnectionInfo1.StorageEndpoint :=   's3.amazonaws.com';
  AmazonConnectionInfo1.UseDefaultEndpoints := false;

  try
    try
      StorageService := TAmazonStorageService.Create(AmazonConnectionInfo1);
      ResponseInfo := TCloudResponseInfo.Create;

      if StorageService.CreateBucket(LabeledEditBucket.Text,
         amzbaNotSpecified,
         amzrNotSpecified,
         ResponseInfo) then
         ShowMessage('Bucket ' + LabeledEditBucket.Text +
           ' created succesfully over ' + AmazonConnectionInfo1.Protocol)
      else
      begin
        msg := ' Error creating bucket ' + LabeledEditBucket.Text + '.';
        if ResponseInfo.StatusCode = 409 then
          msg := msg + ' Bucket already exists';
      end;
    except
      ShowMessage('Error trying to create bucket ');
    end;
  finally
    FreeAndNil(ResponseInfo);
    FreeAndNil(StorageService);
  end;
end;

end.
