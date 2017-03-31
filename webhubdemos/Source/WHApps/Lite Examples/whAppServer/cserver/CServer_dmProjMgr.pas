unit CServer_dmProjMgr;

interface

{$I hrefdefines.inc}

uses
  SysUtils, Variants, Classes, Forms,
  whdemo_DMProjMgr, tpProj;

type
  TDMForWHDemoC = class(TDMForWHDemo)
    procedure ProjMgrGUICreate(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: string;
      var Continue: Boolean);
    procedure ProjMgrStartupComplete(Sender: TtpProject);
    procedure ProjMgrStop(Sender: TtpProject; var ErrorText: string;
      var Continue: Boolean);
    procedure ProjMgrDataModulesCreate1(Sender: TtpProject;
      var ErrorText: string; var Continue: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMForWHDemoC: TDMForWHDemoC;

implementation

{$R *.dfm}

uses
  MultiTypeApp, {$IFDEF LOG2CSL}whSharedLog, {$ENDIF}
  whBuildInfo,
  {$IF cWebHubVersion <= 3.268} // uses whBuildInfo (DCU not PAS)
  ucCodeSiteInterface, // compiles in v3.268
  {$ELSE}
  ZM_CodeSiteInterface,
  {$IFEND}
  uCode,
  ucShellProcessCntrl,  // GetCurrentProcessID
  whutil_ZaphodsMap, htWebApp, webCall, webApp,
  cfmwhCustom;

procedure TDMForWHDemoC.ProjMgrDataModulesCreate1(Sender: TtpProject;
  var ErrorText: string; var Continue: Boolean);
begin
  inherited;
  {$IFDEF LOG2CSL}UseWebHubSharedLog;{$ENDIF}
end;

procedure TDMForWHDemoC.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: string; var Continue: Boolean);
const cFn = 'ProjMgrGUICreate';
begin
  CSEnterMethod(Self, cFn);
  inherited;
  CSSend(cFn + ': ShouldEnableGUI', S(ShouldEnableGUI));
  if ShouldEnableGUI then
  begin
    // this is normal when starting as an app
    Application.CreateForm(TfmAppCustomPanel, fmAppCustomPanel);
  end
  else
  begin
    // this is normal when starting it as a service
    // e.g. net start webhubsample1
  end;
  CSExitMethod(Self, cFn);
end;

procedure TDMForWHDemoC.ProjMgrStartupComplete(Sender: TtpProject);
const cFn = 'ProjMgrStartupComplete';
var
  inst: string;
begin
  CSEnterMethod(Self, cFn);
  inherited;
  {$IFDEF LOG2CSL}UseWebHubSharedLog;{$ENDIF}
  CSSend('my pid', S(GetCurrentProcessID));
  CSSend('my AppID', pWebApp.AppID);

  if ({M}Application.ApplicationMode = mtamWinService) then // uses MultiTypeApp
  begin
        {When running as-service, the sequence must come from the service
         number.}
        ParamValue('num', inst); // uses ucode
        LogSendInfo('service num', inst, cFn);
  end;

  UncoverAppOnStartup(pWebApp.AppID);
  CSSend('Started instance', S(ProjMgr.InstanceSequence));
  if Assigned(pConnection) then
    pConnection.MarkReadyToWork;
  CSExitMethod(Self, cFn);
end;

procedure TDMForWHDemoC.ProjMgrStop(Sender: TtpProject; var ErrorText: string;
  var Continue: Boolean);
const cFn = 'ProjMgrStop';
begin
  CSEnterMethod(Self, cFn);
  inherited;
  CSSend('Stopping');
  CSExitMethod(Self, cFn);
end;

end.
