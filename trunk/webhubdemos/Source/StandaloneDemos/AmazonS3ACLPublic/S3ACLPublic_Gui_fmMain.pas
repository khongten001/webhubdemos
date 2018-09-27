unit S3ACLPublic_Gui_fmMain;

interface

(*
Permission is hereby granted, on 26-Jul-2017, free of charge, to any person
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

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ScrollBox, FMX.Memo;

type
  TForm3 = class(TForm)
    GridPanelLayout1: TGridPanelLayout;
    Label1: TLabel;
    EditBucketName: TEdit;
    Label2: TLabel;
    EditRegion: TEdit;
    Label3: TLabel;
    EditLeadingPath: TEdit;
    Label4: TLabel;
    EditMatchThis: TEdit;
    Label5: TLabel;
    EditAWSAccessKey: TEdit;
    Label6: TLabel;
    EditAWSSecretKey: TEdit;
    Label7: TLabel;
    cbJustRootFolder: TCheckBox;
    Label8: TLabel;
    EditMaxFilesToTouch: TEdit;
    LabelScheme: TLabel;
    GroupBox1: TGroupBox;
    cbSchemeHttp: TRadioButton;
    cbSchemeHttps: TRadioButton;
    Label9: TLabel;
    cbActionIt: TCheckBox;
    Button1: TButton;
    ButtonGo: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure ButtonGoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

uses
  S3ACLPublic_uMarkPublic;

procedure TForm3.Button1Click(Sender: TObject);
begin
  Self.Close;  // close the form
end;

procedure TForm3.ButtonGoClick(Sender: TObject);
var
  bActionIt: Boolean;
  bJustRootFolder: Boolean;
  Scheme: string;
  ErrorText: string;
begin
  bActionIt := cbActionIt.IsChecked;
  bJustRootFolder := cbJustRootFolder.IsChecked;

  if cbSchemeHttp.IsChecked then
    scheme := 'http'
  else
    scheme := 'https';

  TagPublic(bActionit, scheme, EditBucketName.Text, EditLeadingPath.Text,
    EditMatchThis.Text, EditAWSAccessKey.Text, EditAWSSecretKey.Text,
    bJustRootFolder, StrToIntDef(EditMaxFilesToTouch.Text, 1), EditRegion.Text,
    ErrorText{$IFNDEF CodeSite}, Memo1{$ENDIF});

  if ErrorText = '' then
    ShowMessage('Done.')
  else
    ShowMessage(ErrorText);
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  cbJustRootFolder.IsChecked := True;
  cbActionIt.IsChecked := True;
  EditAWSSecretKey.Text := '';
  EditMaxFilesToTouch.Text := '10';
  //EditAWSAccessKey.Text := 'AKIAI';
  //EditAWSSecretKey.Text := 'XD';
end;

end.
