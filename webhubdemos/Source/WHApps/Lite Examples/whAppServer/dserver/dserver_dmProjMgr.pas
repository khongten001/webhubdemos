unit dserver_dmProjMgr;

interface

uses
  SysUtils, Classes, tpProj;

type
  TDMForDServer = class(TDataModule)
    ProjMgr: TtpProject;
    procedure ProjMgrBeforeFirstCreate(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
    procedure ProjMgrDataModulesCreate1(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
    procedure ProjMgrDataModulesCreate2(Sender: TtpProject;
      const SuggestedAppID: String; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrDataModulesCreate3(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
    procedure ProjMgrDataModulesInit(Sender: TtpProject;
      var ErrorText: String; var Continue: Boolean);
    procedure ProjMgrGUICreate(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrGUIInit(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: String;
      var Continue: Boolean);
    procedure ProjMgrStartupError(Sender: TtpProject;
      const ErrorText: String);
    procedure DataModuleCreate(Sender: TObject);
    procedure ProjMgrStartupComplete(Sender: TtpProject);
  private
    { Private declarations }
    FSourceSubDir: string;
    FIsRelativePath: Boolean;
  public
    { Public declarations }
    procedure SetDemoFacts(const DemoAppID, SourceSubdir: string;
      const IsRelativePath: Boolean);
  end;

var
  DMForDServer: TDMForDServer;

implementation

{$R *.dfm}

uses
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  MultiTypeApp,
  ucDlgs, ucLogFil, ucCodeSiteInterface,
  webApp, webBase, webSplat, dmWHApp, htWebApp, webCall, whgui_Menu,
  whdemo_Extensions, whdemo_Initialize, whdemo_ViewSource, whcfg_App, whConst,
  {$IFNDEF PREVENTGUI}
  Forms,
  whpanel_RemotePages, whpanel_Mail, uAutoPanels, whMain,
  {$ENDIF}
  dserver_whdmGeneral, whdemo_ColorScheme;

{ TDMForWHDemo }

procedure TDMForDServer.DataModuleCreate(Sender: TObject);
begin
  ProjMgr.Identifier := '';
  {$IFDEF PREVENTSVCMGR}
  ProjMgr.InstanceMonitoringMode := simmIgnoreInstanceNum;
  {$ELSE}
  ProjMgr.InstanceMonitoringMode := simmAppendInstanceNumToServiceName;
  {$ENDIF}
end;

procedure TDMForDServer.SetDemoFacts(const DemoAppID, SourceSubdir: string;
  const IsRelativePath: Boolean);
begin
  ProjMgr.Identifier := DemoAppID;
  FSourceSubDir := SourceSubDir;
  FIsRelativePath := IsRelativePath;
end;

procedure TDMForDServer.ProjMgrBeforeFirstCreate(
  Sender: TtpProject; var ErrorText: String; var Continue: Boolean);
begin
//
end;

procedure TDMForDServer.ProjMgrDataModulesCreate1(
  Sender: TtpProject; var ErrorText: String; var Continue: Boolean);
begin
  CreateCoreWebHubDataModule;
end;


procedure TDMForDServer.ProjMgrDataModulesCreate2(
  Sender: TtpProject; const SuggestedAppID: String; var ErrorText: String;
  var Continue: Boolean);
var
  UsedAppID: string;
  S: string;
begin
  if SuggestedAppID <> '' then
    UsedAppID := SuggestedAppID
  else
    UsedAppID := ProjMgr.Identifier;
  if UsedAppID = '' then
    UsedAppID := 'appvers';

  whDemoSetAppId(UsedAppID);  // this refreshes the app

  //Cover again after refresh
  htWebApp.CoverApp(UsedAppID, 1, 'Loading WebHub Demo application', False, S);
  ProjMgr.Item := S;

  whDemoCreateSharedDataModules;
end;

procedure TDMForDServer.ProjMgrDataModulesCreate3(
  Sender: TtpProject; var ErrorText: String; var Continue: Boolean);
begin
  Application.CreateForm(TdmwhGeneral, dmwhGeneral);
  Application.CreateForm(TDataModuleColorScheme, DataModuleColorScheme);
end;

procedure TDMForDServer.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  InitCoreWebHubDataModule;
  whDemoInit;
  whDemoSetDelphiSourceLocation(FSourceSubDir, FIsRelativePath);
  dmwhGeneral.Init;  {see also: TdmwhGeneral.WebAppUpdate}
  DemoExtensions.Init;
  DataModuleColorScheme.Init;
  //pConnection.onBadPageID := nil;
end;

procedure TDMForDServer.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
var
  SplashMessage: string;
begin
  if (pWebApp.Startup.StandardModuleStatus(moduleDreamweaver) =
    mstatusDisabled) then
  begin
    ErrorText := 'DServer requires the Dreamweaver module to be enabled ' +
      'in application-level XML file.';
    MsgWarningOk(ErrorText);
    Continue := False;
    Exit;
  end;

  if ShouldEnableGUI then
  begin
    SplashMessage := 'Creating panels';
    WebMessage(SplashMessage);

    Application.CreateForm(TfmWebHubMainForm, fmWebHubMainForm);
    fmWebHubMainForm.Caption := pWebApp.AppID;

    whDemoCreateSharedPanels;

    WebMessage('-' + SplashMessage);
  end;
end;

procedure TDMForDServer.ProjMgrGUIInit(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
begin
  Assert(Assigned(pWebApp));
  Assert(pWebApp.IsUpdated);
  if ShouldEnableGUI then
  begin
    pWebApp.DoUpdateGUI;

    InitCoreWebHubDataModuleGUI;
    InitStandardWHModulesGUI;

    WebMessage('0');         // required to close splash screen
  end;

end;

procedure TDMForDServer.ProjMgrStartupError(Sender: TtpProject;
  const ErrorText: String);
begin
  {$IFDEF CodeSite}CodeSite.SendError(ErrorText);
  {$ELSE}HREFTestLog('error', 'during startup', ErrorText);{$ENDIF}
end;

procedure TDMForDServer.ProjMgrStartupComplete(Sender: TtpProject);
begin
  htWebApp.UncoverApp(ProjMgr.Item);
end;

end.
