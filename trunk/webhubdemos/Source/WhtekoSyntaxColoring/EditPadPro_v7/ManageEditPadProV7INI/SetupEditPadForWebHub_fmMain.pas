unit SetupEditPadForWebHub_fmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    cbSyntax: TCheckBox;
    cbFileNav: TCheckBox;
    cbColor: TCheckBox;
    Button2: TButton;
    cbTools: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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
  ucVers,
  SetupEditPadForWebHub_uDownload, SetupEditPadForWebHub_uColors;


procedure TForm2.Button1Click(Sender: TObject);
var
  bAllGood: Boolean;
begin
  Label1.Text := '';
  bAllGood := False;
  if InstallLatestWebHubFiles(cbSyntax.IsChecked, cbFileNav.IsChecked,
    cbTools.IsChecked, cbColor.IsChecked) then
  begin
    if cbColor.IsChecked then
    begin
      if NOT WriteHREFToolsColorsToEditPadINI then
        Label1.Text := 'WriteHREFToolsColorsToEditPadINI failed'
      else
        bAllGood := True;
    end
    else
      bAllGood := True;

    if bAllGood and cbSyntax.IsChecked then
    begin
      if NOT IsWHTekoFileTypeInstalled then
      begin
        bAllGood := InstallWebHubFileType;
      end;
    end;

    if bAllGood and cbTools.IsChecked then
    begin
      bAllGood := InstallWHBridgeTools;
    end;
  end
  else
    Label1.Text := 'InstallLatestWebHubFiles failed';
  if bAllGood then
    Label1.Text := FormatDateTime('dddd hh:nn', Now) + ': install complete.';

end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  ShowMessage(Self.Caption + sLineBreak +
    'version ' + GetVersionDigits(False) + sLineBreak +
    sLineBreak +
    'Quickly configure EditPad Pro v7 for use with WebHub' + sLineBreak +
    '(c) 2014 HREF Tools Corp.'
  );
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  Label1.Text := '';
  cbSyntax.IsChecked := True;
  cbFileNav.IsChecked := True;
  cbColor.IsChecked := True;
  cbTools.IsChecked := True;
end;

end.
