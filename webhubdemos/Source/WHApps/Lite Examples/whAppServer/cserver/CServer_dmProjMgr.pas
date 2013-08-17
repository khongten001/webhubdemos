unit CServer_dmProjMgr;

interface

{$I hrefdefines.inc}
{$I WebHub_Comms.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, whdemo_DMProjMgr, tpProj;

type
  TDMForWHDemoC = class(TDMForWHDemo)
    procedure ProjMgrGUICreate(Sender: TtpProject;
      const ShouldEnableGUI: Boolean; var ErrorText: string;
      var Continue: Boolean);
    procedure ProjMgrStartupComplete(Sender: TtpProject);
    procedure ProjMgrStop(Sender: TtpProject; var ErrorText: string;
      var Continue: Boolean);
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
  {$IFDEF CodeSite}CodeSiteLogging,{$ENDIF}
  MultiTypeApp, whSharedLog, ucCodeSiteInterface, uCode, 
  whutil_ZaphodsMap, htWebApp, webCall, webApp,
  cfmwhCustom;

procedure TDMForWHDemoC.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: string; var Continue: Boolean);
const cFn = 'ProjMgrGUICreate';
begin
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
end;

procedure TDMForWHDemoC.ProjMgrStartupComplete(Sender: TtpProject);
const cFn = 'ProjMgrStartupComplete';
var
  inst: string;
begin
  CSEnterMethod(Self, cFn);
  inherited;
  CSSend('my pid', S(GetCurrentProcessID));
  CSSend('my AppID', pWebApp.AppID);

  if ({M}Application.ApplicationMode = mtamWinService) then // uses MultiTypeApp
  begin
        {When running as-service, the sequence must come from the service
         number.}
        ParamValue('num', inst); // uses ucode
        LogSendInfo('service num', inst, cFn);
  end;
  
  {$IFDEF WEBHUBACE}
  UncoverAppOnStartup(pWebApp.AppID);
  CSSend('Started instance', S(ProjMgr.InstanceSequence));
  pConnection.MarkReadyToWork;
  {$ELSE}
  if NOT pWebApp.ConnectToHub then
    LogSendWarning('ConnectToHub: False', cFn);
  {$ENDIF}
  CSExitMethod(Self, cFn);
end;

procedure TDMForWHDemoC.ProjMgrStop(Sender: TtpProject; var ErrorText: string;
  var Continue: Boolean);
const cFn = 'ProjMgrStop';
begin
  {$IFDEF CodeSite}CodeSite.EnterMethod(Self, cFn);{$ENDIF}
  inherited;
  CSSend('Stopping');
  {$IFDEF CodeSite}CodeSite.ExitMethod(Self, cFn);{$ENDIF}
end;

initialization
  ResetLogFilespec;

end.
