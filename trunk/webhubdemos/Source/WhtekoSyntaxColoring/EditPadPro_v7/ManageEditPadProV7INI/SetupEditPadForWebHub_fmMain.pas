unit SetupEditPadForWebHub_fmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

uses
  SetupEditPadForWebHub_uDownload, SetupEditPadForWebHub_uColors;


procedure TForm2.Button1Click(Sender: TObject);
begin
  Label1.Text := '';
  if InstallLatestWebHubFiles then
  begin
    if WriteHREFToolsColorsToEditPadINI then
      Label1.Text := FormatDateTime('dddd hh:nn', Now) + ': install complete.'
    else
      Label1.Text := 'WriteHREFToolsColorsToEditPadINI failed';
  end
  else
    Label1.Text := 'InstallLatestWebHubFiles failed';
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  Label1.Text := '';
end;

end.
