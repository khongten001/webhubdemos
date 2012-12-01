unit IbObj_Bootstrap_fmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.FileCtrl;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    FileListBox1: TFileListBox;
    EditFilespec: TEdit;
    DirectoryListBox1: TDirectoryListBox;
    Label1: TLabel;
    CheckBox1: TCheckBox;
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
  ucDlgs,
  ucIBObjCodeGen_Bootstrap;

procedure TForm2.Button1Click(Sender: TObject);
var
  FullFilespec: string;
begin
  FullFilespec := IncludeTrailingPathDelimiter(Label1.Caption) +
    EditFilespec.Text;
  if AskQuestionYesNo('Project abbreviation = ' + Edit1.Text +
    sLineBreak + sLineBreak + 'Output unit: ' + sLineBreak +
    FullFilespec) then
  begin
    if Checkbox1.Checked then
      IbAndFb_GenPAS_Connect(False, Edit1.Text, FullFilespec)
    else
      IbAndFb_GenPAS_Connect(False, Edit1.Text, FullFilespec, '', '');
    if FileExists(FullFilespec) then
      MsgInfoOk('look for ' + FullFilespec + ' now');
  end;
end;

end.
