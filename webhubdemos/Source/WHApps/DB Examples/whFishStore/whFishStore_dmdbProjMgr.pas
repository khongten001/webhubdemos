unit whFishStore_dmdbProjMgr;

// for the Fish Store

interface

uses
  SysUtils, Classes, tpProj;

type
  TDMForWHFishStore = class(TDataModule)
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
    procedure ProjMgrStartupComplete(Sender: TtpProject);
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
  DMForWHFishStore: TDMForWHFishStore;

implementation

{$R *.dfm}

uses
  Forms,
  MultiTypeApp, ucDlgs, ucLogFil, ucCodeSiteInterface,
  webApp, webBase, webSplat, whSharedLog, webCall,
  dmFishAp, tfish, htWebApp, 
  whdemo_Extensions, whdemo_Initialize, whdemo_ViewSource, whMain,
  whpanel_RemotePages, whpanel_Mail, AdminDM, whFishStore_fmWhPanel,
  whFishStore_dmwhBiolife;

{ TDMForWHDemo }

procedure TDMForWHFishStore.DataModuleCreate(Sender: TObject);
begin
  FFixedAppID := '';
end;

procedure TDMForWHFishStore.SetDemoFacts(const DemoAppID, SourceSubdir: string;
  const IsRelativePath: Boolean);
begin
  FFixedAppID := DemoAppID;
  FSourceSubDir := SourceSubDir;
  FIsRelativePath := IsRelativePath;
end;

procedure TDMForWHFishStore.ProjMgrBeforeFirstCreate(
  Sender: TtpProject; var ErrorText: String; var Continue: Boolean);
begin
//
end;

procedure TDMForWHFishStore.ProjMgrDataModulesCreate1(
  Sender: TtpProject; var ErrorText: String; var Continue: Boolean);
begin
  SetCodeSiteLoggingState([]); // no logging during initial startup
  CreateCoreWebHubDataModule;
end;

procedure TDMForWHFishStore.ProjMgrDataModulesCreate2(
  Sender: TtpProject; const SuggestedAppID: String; var ErrorText: String;
  var Continue: Boolean);
begin
  whDemoSetAppId('htfs');  // HREF Tools Fish Store
  {$IFDEF Log2CSL}UseWebHubSharedLog;{$ENDIF} // this resets to using the shared log

  whDemoCreateSharedDataModules;
end;

procedure TDMForWHFishStore.ProjMgrDataModulesCreate3(
  Sender: TtpProject; var ErrorText: String; var Continue: Boolean);
begin
  Application.CreateForm(TDMFishStoreBiolife, DMFishStoreBiolife);
  {M}Application.CreateForm(TDataModuleAdmin, DataModuleAdmin);
end;

procedure TDMForWHFishStore.ProjMgrDataModulesInit(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  InitCoreWebHubDataModule;
  whDemoInit;
  whDemoSetDelphiSourceLocation(FSourceSubDir, FIsRelativePath);
  Continue := DMFishStoreBiolife.Init(ErrorText);
  if Continue then
    Continue := DataModuleAdmin.Init(ErrorText);  // do this after ALL the modules in the project have been created.
end;

procedure TDMForWHFishStore.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
var
  SplashMessage: string;
begin
  if ShouldEnableGUI then
  begin
    SplashMessage := 'Creating Fish Store panels';
    WebMessage(SplashMessage);

    {M}Application.CreateForm(TfmWebHubMainForm, fmWebHubMainForm);

      if Assigned(fmWebHubMainForm.Restorer) then
      begin
        { avoid Restorer feature on production server
          with multiple instances -- too much conflict on the
          WHAppRestorer.xml file during shutdown }
        CSSend(csmLevel5, 'Restorer.Forget on ZMContext',
          pWebApp.ZMDefaultMapContext);
        fmWebHubMainForm.Restorer.Forget;  // cleanup pointers on nested panels
        FreeAndNil(fmWebHubMainForm.Restorer);
      end
      else
        CSSend('fmWebHubMainForm.Restorer already nil');

    whDemoCreateSharedPanels;
    {M}Application.CreateForm(TfmHTFSPanel, fmHTFSPanel);

    WebMessage('-' + SplashMessage);
  end;
end;

procedure TDMForWHFishStore.ProjMgrGUIInit(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: String;
  var Continue: Boolean);
begin
  Assert(Assigned(pWebApp));
  Assert(pWebApp.IsUpdated);
  if ShouldEnableGUI then
  begin
//    fmWebHubMainForm.Restorer.Flags := [];  // else fish store gives A/V on exit !!!

    pWebApp.DoUpdateGUI;

    InitCoreWebHubDataModuleGUI;

    WebMessage('0');         // required to close splash screen
  end;
end;

procedure TDMForWHFishStore.ProjMgrStartupComplete(Sender: TtpProject);
begin
  UncoverAppOnStartup(pWebApp.AppID);
  pConnection.MarkReadyToWork;  // required in v3.190+
end;

procedure TDMForWHFishStore.ProjMgrStartupError(Sender: TtpProject;
  const ErrorText: String);
begin
  HREFTestLog('error', 'during startup', ErrorText);
{$IFNDEF PREVENTGUI}
  MsgErrorOk(ErrorText);
{$ENDIF}
end;

procedure TDMForWHFishStore.ProjMgrStop(Sender: TtpProject;
  var ErrorText: String; var Continue: Boolean);
begin
  whDemoDestroySharedPanels;
  DestroyCoreWebHubDataModuleGUI;
  whDemoDestroySharedDataModules;
end;

end.

