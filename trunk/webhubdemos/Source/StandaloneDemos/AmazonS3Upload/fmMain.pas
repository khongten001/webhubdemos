unit fmMain;

(*
Copyright (c) 2013 HREF Tools Corp.

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
  ucDlgs;

//const
//  SMDPath = 'originalfilepath';
//  SMDFrom = 'uploadfrom';

procedure TForm2.Button1Click(Sender: TObject);
var
  ResponseInfo: TCloudResponseInfo;
  Filespec: string;
  stream: TBytesStream;
  StorageService: TAmazonStorageService;
begin
  stream := nil;
  StorageService := nil;
  ResponseInfo := nil;

  AmazonConnectionInfo1.AccountName := LabeledEditAccessKey.Text;
  AmazonConnectionInfo1.AccountKey := LabeledEditSecret.Text;
  AmazonConnectionInfo1.Protocol := 'https';

  Filespec := Filelistbox1.FileName;

  if (LabeledEditTargetPath.Text <> '') and
    (LabeledEditTargetPath.Text[1] = '/') then
  begin
    MsgWarningOk('Do not start with a leading / for the target path.' +
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

      //Metadata not required on Amazon S3
      //Metadata := TStringList.Create;
      //Metadata.Values[SMDPath] := ExtractFilePath(Filespec);
      //Metadata.Values[SMDFrom] := GetComputerandUserName;

      StorageService.UploadObject(
        LabeledEditBucket.Text,  // target bucket e.g. screenshots.href.com

        { LabeledEditTargetPath.Text must be blank or end in / example data/ }
        LabeledEditTargetPath.Text + ExtractFileName(Filespec),

        Stream.Bytes,
        False, nil, nil,
        Data.Cloud.AmazonAPI.amzbaPublicRead,  // permissions - public
        ResponseInfo);

      {status 200 means that it worked
       if you use a bad Access Key or Secret Access Key, status 403 will be in
       headers}
      MsgInfoOk(Format('statuscode %d, message %s, headers %s',
        [ResponseInfo.StatusCode, ResponseInfo.StatusMessage,
        ResponseInfo.Headers.Text]));
    finally
      FreeAndNil(stream);
      FreeAndNil(StorageService);
      FreeAndNil(ResponseInfo);
    end;
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  SampleDirectory: string;
begin
  SampleDirectory :=
  'D:\Apps\Embarcadero\RADStudio\11.0\Samples\Delphi\DataSnap\connectors\WindowsPhone7Clients\CompanyTweetClient\CompanyTweetClient\icons';
  if Directoryexists(SampleDirectory) then
    DirectoryListBox1.Directory := SampleDirectory;
end;

end.