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
  ucCodeSiteInterface,
  webCall, webApp,
  cfmwhCustom;

procedure TDMForWHDemoC.ProjMgrGUICreate(Sender: TtpProject;
  const ShouldEnableGUI: Boolean; var ErrorText: string; var Continue: Boolean);
const cFn = 'ProjMgrGUICreate';
begin
  inherited;
  if ShouldEnableGUI then
  begin
    // this is normal when starting as an app
    LogSendInfo('ShouldEnableGUI', BoolToStr(ShouldEnableGUI, True), cFn);
    Application.CreateForm(TfmAppCustomPanel, fmAppCustomPanel);
  end
  else
  begin
    // this is normal when starting it as a service
    // e.g. net start webhubsample1
    LogSendInfo('ShouldEnableGUI', BoolToStr(ShouldEnableGUI, True), cFn);
  end;
end;

procedure TDMForWHDemoC.ProjMgrStartupComplete(Sender: TtpProject);
begin
  inherited;
  LogSendInfo('ProjMgrStartupComplete', 'my appid is', pWebApp.AppID);
  if NOT pWebApp.IsUpdated then
    LogSendWarning('refreshed: False');
  {$IFDEF WEBHUBACE}
  pConnection.MarkReadyToWork;
  {$ELSE}
  if NOT pWebApp.ConnectToHub then
    LogSendWarning('ConnectToHub: False');
  {$ENDIF}
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

end.
