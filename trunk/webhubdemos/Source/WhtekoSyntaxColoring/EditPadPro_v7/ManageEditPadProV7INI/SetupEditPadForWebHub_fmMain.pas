unit SetupEditPadForWebHub_fmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation;

type
  TForm2 = class(TForm)
    ButtonInstallNow: TButton;
    Label1: TLabel;
    cbSyntax: TCheckBox;
    cbFileNav: TCheckBox;
    cbColor: TCheckBox;
    ButtonHelp: TButton;
    cbTools: TCheckBox;
    cbClipCollections: TCheckBox;
    Edit1: TEdit;
    Label2: TLabel;
    ButtonReadme: TButton;
    procedure ButtonInstallNowClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonHelpClick(Sender: TObject);
    procedure ButtonReadmeClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    FIsSilentInstall: Boolean;
  public
    { Public declarations }

  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

uses
  //ZaphodsMap,
  //whutil_ZaphodsMap, // brings in lots of TPack GUI and WebHub units
  ucVers,
  ucShell,
  uCode,
  SetupEditPadForWebHub_uDownload, SetupEditPadForWebHub_uColors;


procedure TForm2.ButtonInstallNowClick(Sender: TObject);
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
    if NOT FIsSilentInstall then
      ShowMessage('Done. You may exit this Setup now.');
  end;

end;

procedure TForm2.ButtonHelpClick(Sender: TObject);
begin
  ShowMessage(Self.Caption + sLineBreak +
    'version ' + GetVersionDigits(False) + sLineBreak +
    sLineBreak +
    'Quickly configure EditPad Pro v7 for use with WebHub' + sLineBreak +
    sLineBreak +
    Format('(c) 2014-%s HREF Tools Corp.', [FormatDateTime('yyyy', Now)]) +
    sLineBreak +
    'www.href.com' + sLineBreak +
    'webhub.com'
  );
end;

procedure TForm2.ButtonReadmeClick(Sender: TObject);
var
  AURL: string;
begin
  AURL := 'http://webhub.com/dynhelp:alias::whbridge2editpad';
  WinShellOpen(AURL);
end;

var
  FlagInit: Boolean = False;

procedure TForm2.FormActivate(Sender: TObject);
begin
  if NOT FlagInit then
  begin
    FIsSilentInstall := HaveParam('/Silent');
    if FIsSilentInstall then
    begin
      ButtonInstallNowClick(Sender);
      Self.Close;
    end;
    FlagInit := True;
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  WebHubBinPath: string;
begin
  Label1.Text := '';
  FIsSilentInstall := False;

  cbSyntax.IsChecked := True;
  cbFileNav.IsChecked := True;
  cbColor.IsChecked := True;
  cbTools.IsChecked := True;
  WebHubBinPath := 'D:\Apps\HREFTools\WebHub\bin\'; // GetWebHubRuntimeInstallBinFolder;
  Edit1.Text := WebHubBinPath;
end;

end.
