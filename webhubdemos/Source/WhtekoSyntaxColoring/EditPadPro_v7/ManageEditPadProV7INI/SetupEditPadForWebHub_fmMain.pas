unit SetupEditPadForWebHub_fmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    cbSyntax: TCheckBox;
    cbFileNav: TCheckBox;
    cbColor: TCheckBox;
    Button2: TButton;
    cbTools: TCheckBox;
    cbClipCollections: TCheckBox;
    Edit1: TEdit;
    Label2: TLabel;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
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
  //ZaphodsMap,
  whutil_ZaphodsMap,
  ucVers, ucShell,
  SetupEditPadForWebHub_uDownload, SetupEditPadForWebHub_uColors;


procedure TForm2.Button1Click(Sender: TObject);
var
  bAllGood: Boolean;
begin
  Label1.Text := '';
  bAllGood := False;

  Edit1.Text := IncludeTrailingPathDelimiter(Edit1.Text);
  if (NOT DirectoryExists(Edit1.Text)) or (NOT FileExists(Edit1.Text +
    'WHBridge2EditPad.exe')) then
  begin
    ShowMessage(Edit1.Text + ' must point to a directory containing ' +
      'WHBridge2EditPad.exe, a utility published on ftp://webhub.com');
    Label1.Text := 'Fix path to WHBridge2EditPad';
  end
  else
  begin
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
        bAllGood := InstallWHBridgeTools(Edit1.Text);
      end;

      if bAllGood and cbClipCollections.IsChecked then
        bAllGood := InstallWebHubClipCollections;
    end
    else
      Label1.Text := 'InstallLatestWebHubFiles failed';
  end;
  if bAllGood then
  begin
    Label1.Text := FormatDateTime('dddd hh:nn', Now) + ': install complete.';
    ShowMessage('Done. You may exit this Setup now.');
  end;

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

procedure TForm2.Button3Click(Sender: TObject);
var
  AFilespec: string;
begin
  AFilespec := ExtractFilePath(ParamStr(0)) + PathDelim +
    'Readme-WebHub-EditPad.rtf';
  if NOT FileExists(AFilespec) then
    GetRTFResource('Resource_README', AFilespec);
  WinShellOpen(AFilespec);
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  WebHubBinPath: string;
begin
  Label1.Text := '';

  cbSyntax.IsChecked := True;
  cbFileNav.IsChecked := True;
  cbColor.IsChecked := True;
  cbTools.IsChecked := True;
  WebHubBinPath := GetWebHubRuntimeInstallBinFolder;
  Edit1.Text := WebHubBinPath;
end;

end.
