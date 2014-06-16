unit BackupEditPadProColors_fmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Memo;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  IniFiles, BackupEditPadProColors_uHREFTools_Inhouse;

procedure TForm1.Button1Click(Sender: TObject);
var
  ErrorText: string;
begin
  Label1.Text := '';
  Memo1.Lines.Text := LoadHREFToolsColors(ErrorText);
  if ErrorText = '' then
    Label1.Text := 'Loaded ' + FormatDateTime('dddd hh:nn:ss', Now)
  else
  begin
    Label1.Text := ErrorText;
    Memo1.Lines.Add(ErrorText);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  ErrorText: string;
begin
  PreserveHREFToolsColors(ErrorText);
  if ErrorText = '' then
    Label2.Text := 'Saved ' + FormatDateTime('dddd hh:nn:ss', Now)
  else
  begin
    Label2.Text := ErrorText;
    Memo1.Lines.Add(ErrorText);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Label1.Text := '';
  Label2.Text := '';
end;

end.
