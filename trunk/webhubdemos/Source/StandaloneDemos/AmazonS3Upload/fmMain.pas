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

uses
  Winapi.Windows, Winapi.Messages, SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IPPeerClient,
  Vcl.StdCtrls, Vcl.FileCtrl, Vcl.ExtCtrls, Data.Cloud.CloudAPI,
  Data.Cloud.AmazonAPI;

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
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

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
  AmazonConnectionInfo1.Protocol := 'HTTPS';  // or 'https'

  {For buckets outside US-East, configure these 2 extra properties }
  AmazonConnectionInfo1.UseDefaultEndpoints := false;
  AmazonConnectionInfo1.StorageEndpoint :=
    Format('s3-%s.amazonaws.com', [ComboRegion.Items[ComboRegion.ItemIndex]]);

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

end.
