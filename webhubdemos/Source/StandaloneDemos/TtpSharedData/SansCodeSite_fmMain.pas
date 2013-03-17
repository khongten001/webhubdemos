unit SansCodeSite_fmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm5 = class(TForm)
    Button1: TButton;
    ListBox1: TListBox;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

uses
  CodeSiteLogging,
  ucString;

procedure TForm5.Button1Click(Sender: TObject);
const cFn = 'Button1Click';
var
  i: Integer;
  s1, s2: string;
begin
  //CodeSite.EnterMethod(Self, cFn);
  i := StrToInTDef(LeftOfS(' ', ListBox1.Items[ListBox1.ItemIndex]), -1);
  s1 := LabeledEdit1.Text;
  s2 := LabeledEdit2.Text;

  case i of
    1: CodeSite.Send(s1, s2);
    2: CodeSite.SendWarning(s1);
    3: CodeSite.SendError(s1);
    4: CodeSite.SendNote(s1);
    5: ;
    6: CodeSite.EnterMethod(Sender, s1);
    7: CodeSite.ExitMethod(Sender, s1);
    8: ; // CodeSite.LogFile.FilePath := ExtractFilePath(ParamStr(0));
  end;
  //CodeSite.ExitMethod(Self, cFn);
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
  ListBox1.ItemIndex := 0;
  LabeledEdit1.Text := 'a';
  LabeledEdit2.Text := 'b';
  top := 300;
  left := 600;
end;

end.
