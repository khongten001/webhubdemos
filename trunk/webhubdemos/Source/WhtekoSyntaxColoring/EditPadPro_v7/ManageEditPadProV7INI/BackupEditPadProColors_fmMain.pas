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
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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
begin
  Memo1.Lines.Text := LoadHREFToolsColors;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  PreserveHREFToolsColors;
end;

end.
