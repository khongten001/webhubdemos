unit fmMain;

(*
Copyright (c) 2013-2014 HREF Tools Corp.

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
  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IPPeerClient, Vcl.StdCtrls,
  Vcl.FileCtrl, Vcl.ExtCtrls, Data.Cloud.CloudAPI, Data.Cloud.AmazonAPI;

type
  TForm2 = class(TForm)
    AmazonConnectionInfo1: TAmazonConnectionInfo;
    Button1: TButton;
    LabeledEditBucket: TLabeledEdit;
    LabeledEditAccessKey: TLabeledEdit;
    LabeledEditSecret: TLabeledEdit;
    FileListBox1: TFileListBox;
    DirectoryListBox1: TDirectoryListBox;
    Label1: TLabel;
    DriveComboBox1: TDriveComboBox;
    LabeledEditTargetPath: TLabeledEdit;
    EditCustomHeader: TLabeledEdit;
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

uses
  ucLogFil;

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

  AmazonConnectionInfo1.AccountName := LabeledEditAccessKey.Text;
  AmazonConnectionInfo1.AccountKey := LabeledEditSecret.Text;
  AmazonConnectionInfo1.Protocol := 'https';

  Filespec := Filelistbox1.FileName;

  if (LabeledEditTargetPath.Text <> '') and
    (LabeledEditTargetPath.Text[1] = '/') then
  begin
    ShowMessage('ALERT: Do not start with a leading / for the target path.' +
      sLIneBreak + sLineBreak + LabeledEditTargetPath.Text);
  end
  else
  if FileExists(Filespec) then
  begin
    try
      StorageService := TAmazonStorageService.Create(AmazonConnectionInfo1);

      ResponseInfo := TCloudResponseInfo.Create;
      stream := TBytesStream.Create;
      stream.LoadFromFile(Filespec);
      SetLength(Data, stream.Size);
      PSrc := Addr(Stream.Bytes[0]);
      PTrg := Addr(Data[0]);
      Move(pSrc^, pTrg^, Stream.Size);

      //Metadata not required on Amazon S3
      //Metadata := TStringList.Create;
      //Metadata.Values[SMDPath] := ExtractFilePath(Filespec);
      //Metadata.Values[SMDFrom] := GetComputerandUserName;

      if EditCustomHeader.Text <> '' then
      begin
        CustomHeaderList := TStringList.Create;
        CustomHeaderList.Add(EditCustomHeader.Text);
      end;

      StorageService.UploadObject(
        LabeledEditBucket.Text,  // target bucket e.g. screenshots.href.com

        { LabeledEditTargetPath.Text must be blank or end in / example data/ }
        LabeledEditTargetPath.Text + ExtractFileName(Filespec),

        Data,  // must use an array whose length is the size to send!
        False, nil, CustomHeaderList,
        amzbaPublicRead,  // permissions - public
        ResponseInfo);

      {status 200 means that it worked
       if you use a bad Access Key or Secret Access Key, status 403 will be in
       headers}
      InfoMsg := Format('statuscode %d, message %s',
        [ResponseInfo.StatusCode, ResponseInfo.StatusMessage
        ]);
      HREFTestLog('info', InfoMsg, '');
      ShowMessage(InfoMsg);
      
      if Assigned(ResponseInfo.Headers) then
      begin
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
{var
  SampleDirectory: string; }
{$I amazon_secret_info.txt}  // you can comment this out
begin
{  SampleDirectory :=
  'D:\Apps\Embarcadero\RADStudio\11.0\Samples\Delphi\DataSnap\connectors\WindowsPhone7Clients\CompanyTweetClient\CompanyTweetClient\icons';
  if SysUtils.Directoryexists(SampleDirectory) then
    DirectoryListBox1.Directory := SampleDirectory;
}
  LabeledEditAccessKey.Text := cAKey;
  LabeledEditSecret.Text := cSAKey;
  LabeledEditBucket.Text := cBName;

  LabeledEditTargetPath.Text := 'testfolder_' + 
    FormatDateTime('yyyymmdd', Now) + '/';

  ; Custom headers not supported.  See Quality Central.
  ; EditCustomHeader.Text := 'Content-Type=text/html';
end;

end.