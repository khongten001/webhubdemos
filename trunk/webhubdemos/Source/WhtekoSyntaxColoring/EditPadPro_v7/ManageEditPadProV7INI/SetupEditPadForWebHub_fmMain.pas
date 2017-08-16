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
  ZM_CodeSiteInterface,
  ucVers,
  ucShell,
  uCode,
  ucDlgs,
  SetupEditPadForWebHub_uDownload, SetupEditPadForWebHub_uColors,
  SetupEditPadForWebHub_uPaths;


procedure TForm2.ButtonInstallNowClick(Sender: TObject);
var
  bAllGood: Boolean;
  InfoMsg: string;
begin
  ExitCode := 0;
  Label1.Text := '';
  bAllGood := False;

  Edit1.Text := IncludeTrailingPathDelimiter(Edit1.Text);
  if (NOT DirectoryExists(Edit1.Text)) or (NOT FileExists(Edit1.Text +
    'WHBridge2EditPad.exe')) then
  begin
    InfoMsg := Edit1.Text + ' must point to a directory containing ' +
      'WHBridge2EditPad.exe';
    CSSendError(InfoMsg);
    if NOT FIsSilentInstall then
      MsgInfoOk(InfoMsg);
    Label1.Text := 'Fix path to WHBridge2EditPad';
    ExitCode := 1;
  end
  else
  begin
    if NOT DirectoryExists(EditPadPlusDataRoot) then
    begin
      InfoMsg := 'The EditPad Pro 7 ' +
      'data directory should exist before using this utility.' + sLineBreak +
      sLineBreak + EditPadPlusDataRoot;
      CSSendError(InfoMsg);
      if NOT FIsSilentInstall then
        MsgErrorOk(InfoMsg);
      ExitCode := 3;
    end
    else
    begin
      if StrToIntDef(FileTypeID, 0) <= 0 then
      begin
        InfoMsg := 'The EditPad INI file is not ready for customization yet.' +
        sLineBreak + sLineBreak +
        'Please run EditPad, go to Options > Preferences ' +
        'and change SOMETHING such as ' +
        'Options > Preferences > Tabs, change font size from 9 to 10. ' +
        'Apply the change, exit EditPad, and retry here.' + sLineBreak +
        sLineBreak +
        'This will cause EditPad to save ALL its default settings including ' +
        'information about all the filetypes.  Then we can define a filetype ' +
        'for WebHub *.whteko files.' + sLineBreak + sLineBreak +
        'You may revert the tab size afterwards if you prefer 9pt.';
        CSSendError(InfoMsg);
        if NOT FIsSilentInstall then
          MsgErrorOk(InfoMsg);
        ExitCode := 1;
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
    end;
  end;
  if bAllGood then
  begin
    InfoMsg := FormatDateTime('dddd hh:nn', Now) + ': install complete.';
    CSSend(InfoMsg);
    Label1.Text := InfoMsg;
    if NOT FIsSilentInstall then
      ShowMessage('Done. You may exit this Setup now.');
  end
  else
    Inc(ExitCode);
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

  //whutil_ZaphodsMap, // brings in lots of TPack GUI and WebHub units
  // GetWebHubRuntimeInstallBinFolder;
  WebHubBinPath := 'D:\Apps\HREFTools\WebHub\bin\';

  Edit1.Text := WebHubBinPath;
end;

end.
