unit dserver_dmProjMgr;

{$I hrefdefines.inc}
{$I WebHub_Comms.inc}

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
  strict private
    { Private declarations }
    FSourceSubDir: string;
    FIsRelativePath: Boolean;
    procedure DServerExceptionEvent(Sender: TObject; E: Exception;
      var Handled, ReDoPage: Boolean);
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
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}  // Raize Software
  {$IFDEF EUREKALOG}ExceptionLog7, EExceptionManager,{$ENDIF} // EurekaLabs
  MultiTypeApp,
  ucDlgs, ucLogFil, ucCodeSiteInterface, ucMsTime, ucPos,
  webApp, webBase, webSplat, dmWHApp, htWebApp, webCall, whxpCommTypes,
  whdemo_Extensions, whdemo_Initialize, whdemo_ViewSource, whcfg_App, whConst,
  whutil_ZaphodsMap,
  {$IFNDEF PREVENTGUI}
  Forms,
  whpanel_RemotePages, whpanel_Mail, uAutoPanels, whMain, whgui_Menu,
  {$ENDIF}
  dserver_whdmGeneral, whdemo_ColorScheme;

{ TDMForDServer }

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

procedure TDMForDServer.DServerExceptionEvent(Sender: TObject; E: Exception;
  var Handled, ReDoPage: Boolean);
const cFn = 'DServerExceptionEvent';
begin
  CSEnterMethod(Self, cFn);

  LogSendException(E);
  Handled := True;

  {$IFDEF EUREKALOG}
  // uses ExceptionLog7, EExceptionManager
  LogSendWarning('EurekaLog provides the following CallStack');
  LogSendError(ExceptionManager.LastException.CallStack.ToString);
  {$ENDIF}

  if PosCi('violation', E.Message) > 0 then
  begin
    {$IFDEF WEBHUBACE}
    pConnection.MarkTerminateASAP;
    {$ENDIF}
    pWebApp.Response.SendBounceTo(pWebApp.DynURL.RawToActiveAuthorityM +
      pWebApp.Request.RawVMR + '?' + pWebApp.AppID + pWebApp.DynURL.W +
      pWebApp.Situations.HomePageID);
  end;
  CSExitMethod(Self, cFn);
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
  pWebApp.OnError := DServerExceptionEvent;
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
  end;

  if Continue and ShouldEnableGUI then
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
  LogSendError(ErrorText, 'during startup');
end;

procedure TDMForDServer.ProjMgrStartupComplete(Sender: TtpProject);
begin
  UncoverAppOnStartup(pWebApp.AppID);
{$IFDEF WEBHUBACE}
  pConnection.MarkReadyToWork;  // required final step for app to get to work
{$ENDIF}
  CSSend('Started instance ' + IntToStr(ProjMgr.InstanceSequence) +
    ' ' + FormatDateTime('dddd dd-MMM hh:nn:ss', NowGMT) + ' gmt');
  CSSend('pConnection.AvailableToCalc state',
    WebHubAppState(pConnection.AvailableToCalc));
end;

end.
