unit whdemo_DMDBProjMgr;

// for use with demos that use the database layer

interface

uses
  SysUtils, Classes, tpProj;

type
  TDMForWHDBDemo = class(TDataModule)
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
    procedure ProjMgrStop(Sender: TtpProject; var ErrorText: String;
      var Continue: Boolean);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FFixedAppID: string;
    FSourceSubDir: string;
    FIsRelativePath: Boolean;
  public
    { Public declarations }
    procedure SetDemoFacts(const DemoAppID, SourceSubdir: string;
      const IsRelativePath: Boolean);
  end;

var
  DMForWHDBDemo: TDMForWHDBDemo;

implementation

{$R *.dfm}

uses
  Forms,
  MultiTypeApp, ucDlgs, ucLogFil,
  webApp, webBase, webSplat, dmwhBDEApp, htbdeWApp,
  whdemo_Extensions, whdemo_Initialize, whdemo_ViewSource,
  whMain, whsample_EvtHandlers, whpanel_RemotePages,
  whpanel_Mail, uAutoPanels;

{ TDMForWHDemo }

procedure TDMForWHDBDemo.DataModuleCreate(Sender: TObject);
begin
  FFixedAppID := '';
end;

procedure TDMForWHDBDemo.SetDemoFacts(const DemoAppID, SourceSubdir: string;
  const IsRelativePath: Boolean);
begin
  FFixedAppID := DemoAppID;
  FSourceSubDir := SourceSubDir;
  FIsRelativePath := IsRelativePath;
end;

procedure TDMForWHDBDemo.ProjMgrBeforeFirstCreate(
  Sender: TtpProject; var ErrorText: String; var Continue: Boolean);
begin
//
end;

procedure TDMForWHDBDemo.ProjMgrDataModulesCreate1(
  Sender: TtpProject; var ErrorText: String; var Continue: Boolean);
begin
  CreateCoreWebHubDataModule;
end;


var
  ACoverPageFilespec: string = '';

procedure TDMForWHDBDemo.ProjMgrDataModulesCreate2(
  Sender: TtpProject; const SuggestedAppID: String; var ErrorText: String;
  var Continue: Boolean);
var
  UsedAppID: string;
begin
  UsedAppID := FFixedAppID;
  if UsedAppID = '' then
  begin
    UsedAppID := SuggestedAppID;
    if UsedAppID = '' then
      UsedAppID := 'appvers';
  end;

  whDemoSetAppId(UsedAppID);  // this refreshes the app

  //Cover again after refresh
  CoverApp(UsedAppID, 1, 'Loading WebHub Demo application', False,
    ACoverPageFilespec);

  // We want to let a parameter determine the AppID served by whLite.exe
  // See ucString.pas and uCode.pas for DefaultsTo and ParamString functions
  whDemoCreateSharedDataModules;

end;

procedure TDMForWHDBDemo.ProjMgrDataModulesCreate3(
  Sender: TtpProject; var ErrorText: String; var Continue: Boolean);
begin
//
end;

procedure TDMForWHDBDemo.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  InitCoreWebHubDataModule;
  whDemoInit;
  whDemoSetDelphiSourceLocation(FSourceSubDir, FIsRelativePath);
end;

procedure TDMForWHDBDemo.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
var
  SplashMessage: string;
begin
  if ShouldEnableGUI then
  begin
    SplashMessage := 'Creating panels';
    WebMessage(SplashMessage);

    {M}Application.CreateForm(TfmWebHubMainForm, fmWebHubMainForm);
    fmWebHubMainForm.Caption := pWebApp.AppID;

    whDemoCreateSharedPanels;

    WebMessage('-' + SplashMessage);
  end;
end;

procedure TDMForWHDBDemo.ProjMgrGUIInit(Sender: TtpProject;
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

  UncoverApp(ACoverPageFilespec);
end;

procedure TDMForWHDBDemo.ProjMgrStartupError(Sender: TtpProject;
  const ErrorText: String);
begin
  HREFTestLog('error', 'during startup', ErrorText);
{$IFNDEF PREVENTGUI}
  MsgErrorOk(ErrorText);
{$ENDIF}
end;

procedure TDMForWHDBDemo.ProjMgrStop(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  whDemoDestroySharedPanels;
  DestroyCoreWebHubDataModuleGUI;
  whDemoDestroySharedDataModules;
end;

end.
