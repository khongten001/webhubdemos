unit whBridge2EditPad_fmSelectFilespec;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox, FMX.StdCtrls;

type
  TForm4 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Panel2: TPanel;
    ListBox1: TListBox;
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetFilespecList(AList: TStringBuilder; const ADelim: string);
  end;

var
  Form4: TForm4;

implementation

{$R *.fmx}

uses
  ucString, ucCodeSiteInterface;

procedure TForm4.Button2Click(Sender: TObject);
begin
  ShowMessage(Listbox1.ItemByIndex(ListBox1.ItemIndex).ToString);
end;

procedure TForm4.SetFilespecList(AList: TStringBuilder; const ADelim: string);
const cFn = 'SetFilespecList';
var
  a1, a2: string;
begin
  CSEnterMethod(Self, cFn);
  ListBox1.Clear;

  a2 := AList.ToString;
  while true do
  begin
    SplitString(a2, ADelim, a1, a2);
    if a1 <> '' then
      ListBox1.Items.Add(a1)
    else
      break;
  end;

  CSExitMethod(Self, cFn);
end;

end.
