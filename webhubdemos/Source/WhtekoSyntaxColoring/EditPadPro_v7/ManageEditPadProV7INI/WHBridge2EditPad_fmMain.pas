unit WHBridge2EditPad_fmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Memo;

type
  TForm3 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
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
  ucShell, uCode;

procedure TForm3.Button1Click(Sender: TObject);
var
  EppFile: string;
  ErrorText: string;
begin
  EppFile := ParamString('-eppfile');
  if FileExists(EppFile) then
  begin
    Launch(ExtractFileName(EppFile),
      'D:\Projects\webhubdemos\Live\WebHub\WHTML\Lite Examples\whAdRotation\whAdRotation.whteko' +
      '  /s100-125', // StartSel-EndSel',
      ExtractFilepath(EppFile), True, 0,
      ErrorText);
    if ErrorText <> '' then
      Memo1.Lines.Add(ErrorText)
    else
      Self.Close;
  end;
end;

procedure TForm3.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  Memo1.Lines.Clear;
  for i := 1 to ParamCount do
  begin
    Memo1.Lines.Add(ParamStr(i));
  end;
end;

end.
