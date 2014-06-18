unit WHBridge2EditPad_fmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Memo, FMX.Edit;

type
  TForm3 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
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
  ucShell, uCode, ucCodeSiteInterface,
  WHBridge2EditPad_uIni, WHBridge2EditPad_uRegex;

procedure TForm3.Button1Click(Sender: TObject);
const cFn = 'Button1Click';
var
  ErrorText: string;
begin
  CSEnterMethod(Self, cFn);
  WrapFindInFiles(ErrorText);

  if ErrorText <> '' then
    Self.Close;

  CSExitMethod(Self, cFn);
end;

procedure TForm3.FormCreate(Sender: TObject);
const cFn = 'FormCreate';
var
  SearchType: TwhsType;
  I: Integer;
begin
  CSEnterMethod(Self, cFn);

  Label1.Text := ParamString('-verb');

  Memo1.Lines.Clear;
  Memo1.Font.Size := 11;
  for i := 1 to ParamCount do
  begin
    Memo1.Lines.Add(ParamStr(i));
  end;

  SearchType := Word2SearchType(ParamString('-word'), ParamString('-linetext'));
  Edit1.Text := Word2SearchPattern(ParamString('-word'), SearchType);

  CSExitMethod(Self, cFn);
end;

end.
